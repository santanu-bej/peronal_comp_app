> **Provider change:** the app now calls the Google Gemini API (free tier) instead of Claude. Same prompts, JSON schemas, token budgets, caching and local-first rules; the request/response shape is in `lib/core/ai/ai_client.dart` (`responseSchema` structured output, `x-goog-api-key`). Default models: `gemini-2.5-flash` (plan, replan) and `gemini-2.5-flash-lite` (the rest). Where this file says Claude/tool_use, read Gemini/JSON response.

# AI — Claude API usage with minimum tokens

The app calls the Claude Messages API directly from the phone with the user's own API key.
Goal: **high value per token**. Most of the app's intelligence is local; Claude is used for the few
things only a language model does well (planning, judging fit, classifying odd titles, weekly insight).

## 1. Where AI is used (and nowhere else)

| # | Feature | Trigger | Default model | Max input (approx) | `max_tokens` | Calls / month (typical) |
|---|---|---|---|---|---|---|
| A1 | Goal plan | User taps *Plan with AI* | `claude-sonnet-5-5` | 600 | 1,400 | 2–5 |
| A2 | Goal digest refresh | Digest stale, ≤ 1/day/goal | `claude-haiku-5-5` | 500 | 220 | 5–10 |
| A3 | Alignment score (1–10 items batched) | New todo/stage when local scorer isn't sure | `claude-haiku-5-5` | 250 + 40/item | 60 + 70/item | 60–120 |
| A4 | Replan proposal | User taps *Ask AI* on a behind goal | `claude-sonnet-5-5` | 700 | 900 | 1–3 |
| A5 | Content classification batch | Daily job, pending titles ≥ 5 | `claude-haiku-5-5` | 120 + 15/title (≤ 50) | 10/title | 30 |
| A6 | Weekly review | Sunday job or user tap | `claude-haiku-5-5` (setting: Sonnet) | 900 | 450 | 4–5 |

Typical month: ~150k–250k tokens total. Default budget cap: **400k tokens/month** (setting).
Models are settings (per feature) so they can be changed without code edits. Model ids in this table are
the defaults at time of writing; keep them in `settings` and show a *Test* button that lists errors clearly
if a model id is rejected.

Nudges, reminders, scoring of obvious items, pace, categories, money maths, Shorts blocking and the dashboard
use **zero** tokens.

## 2. Token-saving rules (enforced in code)

1. **Local first.** Every feature checks `ai_cache`, then local logic. AI only on a miss.
2. **Goal digest, not goal plan.** A3/A5/A6 send each active goal's ≤ 120-token digest, never stages or todos.
3. **Batch.** Multiple new todos → one A3 call. Content titles → one A5 call per day.
4. **Structured output with a forced tool.** Every call uses one tool with a JSON schema and
   `tool_choice: {"type":"tool","name":...}`. No prose, no markdown, no "explain your reasoning".
   Reasons are capped by `maxLength` in the schema.
5. **Tight `max_tokens`** per the table. If a response hits `stop_reason: "max_tokens"`, don't retry with more;
   save what parsed and mark the rest pending.
6. **Short field names** in inputs (`t` title, `e` estimate min, `d` due) and no whitespace in JSON input.
7. **Prompt caching only where it pays.** Mark the system prompt + digests block with
   `cache_control: {"type":"ephemeral"}` only when that prefix is above the model's minimum cacheable length
   (check current docs; small prompts don't qualify). Most of our prompts are deliberately smaller than that,
   so the main savings come from rules 1–6.
8. **Budget guard.** `TokenBudget.canSpend(feature, estimate)` before every call. At 80% of the monthly cap,
   non-user-initiated calls (A2, A5, A6) stop; at 100% everything stops except A1 with a confirmation dialog.
9. **Record usage** from the response `usage` block (`input_tokens`, `output_tokens`,
   `cache_read_input_tokens`, `cache_creation_input_tokens`) into `ai_usage`. Settings shows month total by feature.
10. **AI off switch.** When off or no key: A1/A4 buttons hide, A3 uses the local scorer only, A5 leaves titles
    as `other` until the user classifies, A6 shows the numbers-only review.

## 3. AiClient (Dart)

```dart
class AiClient {
  Future<AiResult<T>> callTool<T>({
    required String feature,          // 'plan' | 'digest' | 'align' | 'replan' | 'classify' | 'review'
    required String model,
    required String system,
    required String userContent,      // compact JSON string
    required Map<String, dynamic> tool, // {name, description, input_schema}
    required int maxTokens,
    required T Function(Map<String, dynamic>) parse,
    bool cacheSystem = false,
    Duration timeout = const Duration(seconds: 30),
  });
}
```

Request:
```
POST https://api.anthropic.com/v1/messages
x-api-key: <key from secure storage>
anthropic-version: 2023-06-01
content-type: application/json

{ "model": "...", "max_tokens": N, "temperature": 0.2,
  "system": [ { "type": "text", "text": "<system>" } ],
  "tools": [ <tool> ], "tool_choice": { "type": "tool", "name": "<tool name>" },
  "messages": [ { "role": "user", "content": "<userContent>" } ] }
```
Parse the first content block with `type == "tool_use"` → `input`. Validate required fields; drop
invalid items instead of failing the whole result.

Errors: 401 → "API key rejected" (open settings); 400 → log body to `event_log`, show "AI request invalid";
429/529/5xx → one retry after 2–4 s jitter, then fail with retry button; timeout → same. Never loop.

Cache key: `sha256(feature + model + system + userContent)`. A1/A4 results are not cached (user wants fresh),
A3/A5 cached 180 days, A2 cached until the goal changes, A6 cached for the ISO week.

## 4. Calls in detail

### A1. Goal plan

System:
```
You plan personal goals for one person in India. Be concrete and realistic.
Today is {today}. Stages are short-term goals with dates between today and the deadline, in order.
Weights add to 100. Setup todos are the first small actions (15–120 min each) to start stage 1–2.
Digest: <=120 tokens, plain text: the goal, what matters most, the stages in one line each, and what does
NOT help this goal (distractions). Write for a machine reader, no filler.
```
User content (compact JSON):
```json
{"goal":"Earn ₹10 lakh profit","why":"Keep Teqsonic alive and fund robotics","deadline":"2027-10-31","type":"money","target":1000000,"ctx":"IT services company, 6 staff, cost ₹1.55L/month, sales weak since co-founder left","other_goals":["Chat agent MVP by Dec"]}
```
`ctx` is an optional one-line context the user types once in Settings ("About me", ≤ 200 chars).

Tool `save_plan` input_schema:
```json
{"type":"object","required":["stages","todos","digest"],"properties":{
 "stages":{"type":"array","minItems":3,"maxItems":7,"items":{"type":"object","required":["t","due","w","done_when"],"properties":{
   "t":{"type":"string","maxLength":80},"due":{"type":"string","description":"YYYY-MM-DD"},
   "w":{"type":"integer","minimum":5,"maximum":60},"done_when":{"type":"string","maxLength":90}}}},
 "todos":{"type":"array","minItems":3,"maxItems":8,"items":{"type":"object","required":["t","stage","e"],"properties":{
   "t":{"type":"string","maxLength":80},"stage":{"type":"integer","description":"0-based stage index"},
   "e":{"type":"integer","description":"estimate minutes"}}}},
 "digest":{"type":"string","maxLength":700}}}
```
Post-process locally: clamp dates into [today, deadline], sort stages by date, normalise weights to 100,
round estimates to the nearest option, then show the review screen.

### A2. Goal digest refresh
System: `Rewrite this goal as a digest for a machine reader, <=120 tokens: goal, priorities, current stage, what does NOT help. No filler.`
User: `{"goal":…,"why":…,"deadline":…,"stages":[{"t":…,"due":…,"s":"open|done"}],"pct":42}`
Tool `save_digest`: `{"digest": string maxLength 700}`.

### A3. Alignment score (batched)
System:
```
Score how much each item moves the person's goals, 0-100.
90-100: directly produces the goal's result (money in, key deliverable, must-do deadline).
70-89: clearly needed soon. 40-69: useful, not urgent. 15-39: weak link. 0-14: distraction or listed as NOT helping.
Penalise long efforts with unclear payoff. Pick the goal it serves best, or null. Reason <=20 words, plain.
Goals: {digests as "G1: …\nG2: …"}
```
User: `{"today":"2026-10-26","items":[{"i":0,"t":"Send invoice to Astroremedys","e":30},{"i":1,"t":"Build horse game level 2","e":2400}]}`
Tool `save_scores`:
```json
{"type":"object","required":["r"],"properties":{"r":{"type":"array","items":{"type":"object","required":["i","s","g","why"],"properties":{
 "i":{"type":"integer"},"s":{"type":"integer","minimum":0,"maximum":100},
 "g":{"type":["string","null"],"description":"G1..Gn or null"},"why":{"type":"string","maxLength":120}}}}}}
```

### A4. Replan
System: `The person is behind on this goal. Propose the smallest set of changes that still reaches the deadline, or say plainly the deadline must move. Keep finished stages. Dates YYYY-MM-DD.`
User: digest + stages with status/due/slip days + pct + expected pct + today.
Tool `save_replan`: `{"summary": str<=300, "changes":[{"stage":int,"due":str?,"t":str?,"drop":bool?}], "add":[{"t":str,"due":str,"w":int}] (max 2), "new_todos":[{"t":str,"stage":int,"e":int}] (max 4), "move_deadline": str?}`.
Shown as a review screen (same as A1). Nothing changes until confirmed.

### A5. Content classification (daily batch)
System: `Classify each title into one category: work, learning, entertainment, social, other. The person is a software founder learning AI/robotics. Answer only via the tool.`
User: `{"items":[{"i":0,"p":"yt","t":"Flutter Riverpod 3 full course","c":"Code With Andrea"},{"i":1,"p":"yt","t":"Funniest cricket moments 2026","c":"…"}]}`
Tool `save_classes`: `{"r":[{"i":int,"c":"work|learning|entertainment|social|other"}]}`.
Cache per `title_hash`; if a channel gets the same class 3 times, add a `content_rules` channel rule
so it never goes to AI again.

### A6. Weekly review
System: `Weekly coach. Use only the numbers given. 3 insights (what changed, what it costs the goals) and 3 actions for next week, each <=25 words, specific, no praise padding.`
User: digests + compact numbers: per goal pct & expected & status; minutes by category this week vs last;
wasted min; top 5 apps; wake on-time days/7; nudges shown/obeyed; steps avg; money saved vs target; todos done (count, avg score).
Tool `save_review`: `{"insights":[str<=160]x3, "actions":[str<=160]x3}`.
Numbers-only fallback (no AI): the same metrics with arrows ↑↓ and the 3 biggest changes.

## 5. Local scorer (A3 runs only when this is unsure)

`lib/core/logic/local_scorer.dart` → `LocalScore {score, confidence, reason, goalId?}`.
- Start at 40. Keyword groups with points (configurable list in Settings):
  money-in (+35: invoice, payment, collect, balance, retainer), sales (+30: client, proposal, quote, lead,
  outreach, follow up, demo, pitch), deliver (+20: deliver, publish, deploy, launch, finish),
  must-do (+25: CA, GST, ROC, filing, tax, bank, lease, legal), learning-for-goal (+10 when the word appears in a digest),
  parked (−35: words from the digests' "does NOT help" part), polish (−10: logo, redesign, refactor, cleanup).
- Estimate penalty: ≥ 1 day and score < 70 → −10. ≤ 30 min and score ≥ 50 → +5.
- Word overlap with a goal digest (after stop-word removal) ≥ 2 words → +10 and that goal.
- **Confidence high** when |score − 50| ≥ 30 and at least one keyword group matched → use it, label "quick score".
  Otherwise → A3 (if AI on and budget allows), else use the local score with "rough" label.
Unit-test with 20 sample tasks.

## 6. Nudge templates (local, no AI)

Variables: `{app}`, `{min}`, `{task}`, `{score}`, `{goal}`, `{pct}`, `{days}`.
Rotate; never the same template twice in a row. Escalated set used on the 3rd nudge.

Normal:
- "{min} min on {app}. Urgent: {task} ({score}). Start now?"
- "{goal} is {pct}% done with {days} days left. {task} moves it. Go?"
- "Bas, {min} min ho gaya on {app}. {task} is waiting."
- "Every 15 min here = 15 min less for {goal}. Next: {task}."

Escalated:
- "Third reminder. You've spent {min} min on {app}. Close it and do {task} now."
- "Santanu, this is the time you said you'd work. {task} ({score}) is still open."

Reminder banner: "{task} · score {score}" with sub-line "Due {due}" or the goal name.
