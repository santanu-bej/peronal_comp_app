# PRD — Goal Compass

One user, one Android phone. The app answers three questions every day:
**What am I working toward? Is what I'm doing right now helping? Am I on pace?**

Features (F1–F8) below. Each has user stories and acceptance criteria (AC). "AI" always means a Claude API
call made through `AiClient` under the budgets in `docs/AI.md`.

---

## F1. Goals and AI planning

A goal is something with a deadline: "Earn ₹10 lakh profit by 31 Oct 2027", "Ship chat agent MVP by Dec",
"Run 5 km under 30 min by March". There can be several goals at once (active limit: 5).

### Goal fields
Title · why it matters (one line) · deadline · type (`general` or `money`) · target amount (money goals) ·
colour · status (`active`, `paused`, `done`, `dropped`) · priority (1–5).

### Stories
1. **Create a goal.** I type the title, deadline and why. I can save it with no AI at all.
2. **Ask AI for a plan.** I tap *Plan with AI*. AI returns:
   - 3–7 **stages** (short-term goals) with a title, due date, weight (% of the goal) and a one-line "done when".
   - 3–8 **setup todos** (first actions), each linked to a stage, with a time estimate.
   - a **goal digest** (≤ 120 tokens) used for every later alignment check. Stored, never shown raw.
3. **Pick what I keep.** The plan opens as a review screen with a checkbox on every stage and todo
   (all checked by default). I can edit a title or date inline, uncheck items, then tap *Add selected*.
   Nothing is saved until I confirm.
4. **Add my own stages and todos later.** When I add one, the app shows an **alignment score** (0–100),
   which goal it serves, and a reason in ≤ 20 words. I can still save a low-scoring item.
5. **Track over time.** Each goal shows: % complete, days left, expected % by today (pace), and a
   status: *Ahead*, *On track*, *Behind*, *At risk*. Stages show on a timeline with today's marker.
6. **Replan when behind.** When a goal is *Behind* or a stage is overdue, a *Replan* button appears.
   First a local replan (shift overdue stages by their slip, keep the deadline). If I tap *Ask AI*, AI
   proposes changes, which I review the same way as story 3.

### Progress maths (local, no AI)
- Stage progress = done ? 1 : (done todos in stage / todos in stage), capped at 0.9 until marked done.
- General goal % = Σ(stage weight × stage progress). Weights are normalised to 100.
- Money goal % = net saved toward the goal (F5) / target amount.
- Expected % = (today − start) / (deadline − start).
- Status: % − expected ≥ +5 → Ahead · within ±5 → On track · −5 to −15 → Behind · below −15 → At risk.

### AC
- A goal can be created, edited, paused and completed with AI turned off.
- *Plan with AI* makes **one** AI call, returns in under 20 s on 4G, and a failed call shows a retry button
  without losing anything I typed.
- Editing the goal title, why, or stages marks the digest stale; it is regenerated at most once per day
  (or when I tap *Refresh digest*), never on every edit.
- Pace and status are correct for the cases in `test/logic/pace_test.dart`.

---

## F2. Todos and alignment scoring

### Todo fields
Title · goal (optional) · stage (optional) · estimate (15 min / 30 min / 1–2 h / half day / day+) ·
due date (optional) · remind at (optional) · alignment score · reason · status · recurrence
(none / daily / weekdays / weekly) · created/done timestamps.

### Stories
1. **Quick add** from anywhere in the app (floating button) and from a home-screen notification action
   ("Add todo").
2. **Score on add.** Order of checks: (a) cache hit for the same normalised text → reuse;
   (b) local rules (see `docs/AI.md` → Local scorer) give a confident answer → use it, label "quick score";
   (c) otherwise one AI call with the goal digests → label "AI score".
   Adding 5 todos at once (paste a list, one per line) makes **one** AI call for all of them.
3. **Today list** sorted by: overdue first, then score × urgency (due today/tomorrow), then estimate (shortest first).
4. **Do the highest score first.** The top item shows as "Do this now" on the dashboard and in nudges.
5. **Low-score warning.** If I start a focus session on a todo scoring < 40 while a todo ≥ 75 is open,
   show: "You have higher-value work: <title> (85). Continue anyway?"
6. **Reminders** fire at *remind at* as a notification and an on-screen banner over any app (F7).

### AC
- Score shows within 1 s for cached/local scores, under 6 s for AI scores.
- Same text added twice never triggers a second AI call.
- Recurring todos create the next instance when the current one is completed or its day passes.
- Reminder fires within 1 minute of the set time with the phone locked and the app killed.

---

## F3. Routines: predefined tasks (wake-up first)

Built-in routine templates; the first and most important is **Wake up**. Others (later, same engine):
*Workout*, *Sleep on time*, *Deep work block*.

### Wake-up task
Settings per wake task: time · days of week · alarm sound · vibration · **proof to stop** ·
snooze (0–2 times, 5 min) · **grace minutes** before escalation (default 10) · **escalation contacts**
(1–3: name + phone) · **message template** · channel (WhatsApp, SMS, or WhatsApp then SMS).

Proof options to stop the alarm (so I can't stop it half-asleep):
- **Walk**: 30 steps counted by the step detector (default).
- **Type**: type the title of today's top todo exactly.
- **Maths**: 3 two-digit sums.

### Flow
1. At wake time the alarm rings full-screen, over the lock screen, loud, until proof is done.
2. Snooze (if allowed) silences it for 5 minutes. Snoozes count against grace time.
3. If proof isn't done by **wake time + grace minutes**, escalation runs **natively** (app may be killed):
   - Send the WhatsApp template to each contact via WhatsApp Cloud API.
   - If WhatsApp fails or there is no internet within 60 s, send the same text as SMS from the phone's SIM.
   - Keep ringing. Repeat escalation once more after another grace period, then stop escalating.
4. When proof is done: alarm stops, pending escalations are cancelled, the morning screen opens:
   today's top 3 todos + today's focus stage.
5. Every step is written to `event_log` (rang, snoozed, proof done at, escalation sent/failed + channel).

Default message (editable, variables in braces):
> Hey {contact}, {user} is still sleeping ({minutes} min after his alarm). He has "{top_task}" pending today. Please call him and wake him up!

### AC
- Rings at the exact minute with the phone locked, in Doze, app swiped away, after a reboot.
- Escalation sends at grace time even if the app process is dead (verify with `adb shell am kill`).
- Without internet, SMS goes out within 2 minutes of the escalation time.
- A *Test escalation* button sends the message to the first contact now (with confirmation).
- Turning the task off cancels every pending alarm and escalation for it.

---

## F4. Time tracking (automatic)

Track where the day goes, without me logging anything.

### Categories
`work` · `learning` · `entertainment` · `social` · `communication` · `physical` · `utility` · `other` ·
plus `sleep/idle` (screen off for > 30 min during night hours).

### Sources
1. **App usage** — Android UsageStatsManager events → app sessions (package, start, end).
2. **Content** — the accessibility service records what is on screen in a few apps, only when it changes:
   YouTube video title + channel, Chrome/Brave page title + domain, Instagram/Facebook "reels vs feed vs DMs".
   This lets "YouTube" count as *learning* for a Flutter tutorial and *entertainment* for a comedy clip.
3. **Physical** — steps, distance and exercise sessions from Health Connect (Google Fit / Samsung Health /
   phone step counter). Fallback: phone step counter sensor.
4. **Manual focus sessions** — a timer for work away from the phone (laptop work, reading a book, gym).
   Start/stop from the app, a notification action, or the quick-settings tile.

### Categorising (local first)
- Built-in package map (≈150 common apps) + my overrides (long-press any app → set category; applies to the past too).
- Content rules: keyword lists per category (e.g. "tutorial", "course", "how to", "flutter", "laravel",
  "interview" → learning). Channel overrides (mark a channel as learning once → always learning).
- Unknown content titles are queued; **one** AI batch per day classifies up to 50 of them (`docs/AI.md` → F4).
  Result cached per title hash and per channel.

### Stories
1. Today view: time per category (donut), timeline of the day, top apps, top content, steps vs target.
2. Week view: stacked bars per day; *wasted time* = entertainment + social during focus hours.
3. Tap an app or content item to re-categorise it.
4. Focus hours (default 10:00–13:00 and 15:00–19:00 weekdays) drive the nudges in F7.

### AC
- Numbers within ±5% of Android's own Digital Wellbeing for the same day.
- Tracking runs with the app closed; aggregation catches up when the app opens.
- No content is captured from apps outside the allow-list (YouTube, Chrome, Brave, Instagram, Facebook).
- Data older than 90 days is rolled up into daily totals and raw rows deleted.

---

## F5. Money tracking

Plain tracking; optionally tied to a money goal.

### Stories
1. Quick add: amount, income / expense / saving, category, note, date (default today), linked goal (optional).
2. Month view: income, expense, saved, vs monthly target. Category bars.
3. Money goal card: amount saved toward the goal vs target, monthly pace needed to finish on time
   ("Need ₹83,334/month; this month ₹41,000 so far").
4. Recurring entries (salary, rent, staff pay) added automatically on their day.

### AC
- All amounts stored as integer paise; shown as ₹ with Indian grouping (₹1,23,456).
- Totals match a manual sum in tests. CSV export of entries.

---

## F6. Dashboard

The home screen. Summary first, detail on tap.

Top to bottom:
1. **Greeting line + one-sentence status**: "2 of 3 goals on track. 47 min wasted today."
2. **Do this now**: the highest-priority open todo, with Start focus and Done buttons.
3. **Goals strip**: one clay card per active goal — % done, days left, pace status chip.
4. **Today**: time split donut, work + learning hours vs target, wasted minutes, steps vs target.
5. **Money this month**: saved vs target bar.
6. **Streaks**: wake-up on time, deep-work days, steps target.
7. **Weekly review** (Sundays, or on tap): 3 insights + 3 actions from AI, cached for the week.

### AC
- Dashboard renders from local data in under 300 ms; no AI call on open.
- Weekly review makes at most one AI call per week unless I tap *Regenerate*.

---

## F7. Over-any-screen reminders and nudges

The app interrupts me on top of whatever app I'm using.

### Banner types
| Type | When | Look |
|---|---|---|
| Reminder | A todo's remind time, a stage due today | Clay banner at top, task + score, *Open* / *Snooze 15m* / *Done* |
| Wasting-time nudge | Entertainment/social app continuously for ≥ N min (default 15) **during focus hours**, while a todo with score ≥ 70 is open | Banner: "25 min on Instagram. Urgent: Send invoice to Astroremedys (95). Go?" *Start now* / *5 more min* |
| Escalated nudge | 3rd nudge in the same session | Full-width card, stays until tapped, stronger copy |
| Shorts/Reels block | YouTube Shorts / Instagram Reels / shorts URLs in browsers (toggle per app) | Presses Back, small toast "Shorts blocked. Back to your goal." |
| Daily focus | Every morning at a set time | Today's focus stage + top 3 todos |

### Rules (all local, no AI)
- Nudge text comes from local templates filled with real task names and minutes (examples in `docs/AI.md`
  → Nudge templates). Templates rotate so they don't repeat back-to-back.
- *5 more min* snoozes nudges for that app for 5 min, max 2 times per session, then the escalated nudge.
- Quiet hours (default 23:00–07:00) and *Do not disturb* mode: no nudges, reminders become silent notifications.
- Nudges never show over phone calls, the camera, maps navigation, or payment apps (deny-list).

### AC
- Banner appears within 2 s of the trigger, over any app, with the app killed.
- No more than 1 nudge per 10 min per session; quiet hours respected.
- Every banner is logged (`nudge_log`) with the action I took; the dashboard shows "nudges obeyed %".

---

## F8. Settings and setup

1. **Setup checklist** (first run and Settings): Claude API key · notifications · exact alarms ·
   full-screen alerts · accessibility service · usage access · Health Connect · activity recognition ·
   SMS · battery unrestricted · autostart tip for Xiaomi/Realme/Oppo/Vivo/OnePlus. Each row: status chip + *Fix* button.
2. **AI**: API key (masked, *Test key* button), model per feature (defaults in `docs/AI.md`),
   monthly token budget (default 400k tokens), usage meter this month by feature, *AI off* switch.
3. **WhatsApp escalation**: phone number ID, access token, template name, language code, *Send test*.
4. **Focus hours, quiet hours, nudge minutes, blocker toggles, deny-list**.
5. **Backup**: export everything (except secrets) to one encrypted `.gcbak` file via the share sheet
   (Drive/WhatsApp); import from file; automatic daily local snapshot (keep 14).
