# Design — Claymorphism system

Soft, puffy, toy-like surfaces: pastel fills, big rounded corners, a light highlight on the top-left,
a soft coloured shadow on the bottom-right, and an inner glow so things look pressed out of clay.
Calm enough to look at 50 times a day; the only loud colours are status (behind/at risk) and the
wake alarm.

## 1. Tokens (`lib/core/theme/clay_tokens.dart`)

### Colours — light
| Token | Hex | Use |
|---|---|---|
| `bg` | `#EFEAF8` | App background (lavender clay) |
| `surface` | `#F8F5FE` | Cards |
| `surfaceAlt` | `#E6E0F5` | Pressed/inset areas, inputs |
| `ink` | `#2D2943` | Main text |
| `inkMuted` | `#77728F` | Secondary text |
| `primary` | `#7B6CF6` | Main actions, selected tab |
| `onPrimary` | `#FFFFFF` | Text on primary |
| `peach` | `#FFB48F` | Money, energy |
| `mint` | `#7ED9B4` | Done, on track, physical |
| `sky` | `#8CC8FF` | Learning, info |
| `butter` | `#FFD97A` | Warnings, streaks |
| `rose` | `#FF8A8A` | Behind, at risk, wasted time, alarm |
| `shadowDark` | `#7B6CF6` at 22% | Outer shadow (tinted, not grey) |
| `shadowLight` | `#FFFFFF` at 90% | Highlight top-left |

### Colours — dark
`bg #1C1A2B` · `surface #262338` · `surfaceAlt #1F1D30` · `ink #ECE9F8` · `inkMuted #A29DBD` ·
`primary #9A8CFF` · same pastels at 90% brightness · `shadowDark #000000` at 55% · `shadowLight #FFFFFF` at 6%.
Follow the system theme; a setting can force light/dark.

### Category colours (charts, chips)
work `primary` · learning `sky` · entertainment `rose` · social `peach` · communication `butter` ·
physical `mint` · utility `#B9B4CC` · other `#D4D0E2` · sleep/idle `#A9A3C9`.

### Shape and depth
- Radius: `xl 32` (big cards, sheets) · `lg 24` (cards) · `md 18` (buttons, inputs) · `pill 999` (chips).
- Spacing scale: 4 · 8 · 12 · 16 · 20 · 24 · 32. Screen side padding 20.
- **Clay depth** (three layers, all on one container):
  1. Outer shadow bottom-right: offset (8, 10), blur 24, `shadowDark`.
  2. Outer highlight top-left: offset (−6, −6), blur 16, `shadowLight`.
  3. Inner shadows: top-left white 60% offset (4,4) blur 8; bottom-right `#000` 8% offset (−4,−4) blur 10.
  Flutter has no inset `BoxShadow`; draw layer 3 with a `CustomPainter` (gradient-masked rounded rect) or a
  small inset-shadow package. Keep it in **one** widget, `ClayContainer`.
- Elevation levels: `flat` (inputs, list rows: layer 3 only, inverted = pressed), `raised` (cards),
  `floating` (FAB, banners: stronger layer 1, blur 32).
- Pressed state: animate to `flat` + scale 0.97 in 120 ms.

### Type (bundled fonts, no runtime fetch)
- Display/numbers: **Fredoka** 600 — screen titles 28, big numbers 36–44, card titles 18.
- Body/UI: **Nunito** 500/700 — body 15, labels 13, captions 12.
- `tabularFigures` for all numbers. Sentence case everywhere.

### Motion
Durations 120 / 200 / 320 ms, curve `easeOutBack` for pops (chips, check marks), `easeOutCubic` otherwise.
Progress rings animate from 0 on first show only. Respect *reduce motion* (no scale/bounce).

## 2. Widgets (`lib/core/widgets/`)

| Widget | Spec |
|---|---|
| `ClayContainer` | color, radius, depth (`flat`/`raised`/`floating`), padding, onTap (pressed animation) |
| `ClayButton` | primary (filled primary, white text), soft (surface), danger (rose). Height 52, radius 18, icon optional |
| `ClayIconButton` | 48×48 circle, raised |
| `ClayChip` | pill, pastel fill at 35% + ink text; `selected` = full pastel + white text |
| `ClayProgressRing` | thick (12) round-cap ring, track `surfaceAlt`, value colour by status; centre big number |
| `ClayProgressBar` | 14 high pill bar with inset track; optional expected-pace tick |
| `ClayTextField` | inset (`flat` inverted) field, radius 18, label above |
| `ClaySwitch` | puffy thumb, mint when on |
| `ScoreBadge` | rounded square 40×32, number in Fredoka; colour: ≥75 mint, 50–74 butter, 25–49 grey, <25 rose |
| `StatusChip` | Ahead (mint) · On track (sky) · Behind (butter) · At risk (rose) |
| `ClaySheet` | bottom sheet radius 32 top, handle, used for add/edit forms |
| `EmptyState` | a small clay illustration (shapes only, drawn in code) + one line + one button |

Overlay banners in Kotlin copy the same look: surface fill, 24dp radius, 1dp primary-tint border,
8dp elevation, Fredoka-like bold title (use the bundled font from assets via `Typeface.createFromAsset`).

## 3. Navigation

Bottom bar (floating clay pill, 5 items): **Home · Goals · Todo · Time · More**.
More → Money, Routines, Focus guard, Settings, Backup.
FAB on Home/Goals/Todo: quick add (todo by default; long-press for goal or money entry).

## 4. Screens

1. **Onboarding** (3 steps): name + "about me" line → Claude API key (*Test key*) or *Skip, use without AI* →
   first goal (title, deadline, why) with *Plan with AI*. Then the setup checklist.
2. **Home / Dashboard** — see PRD F6. Layout: status sentence; "Do this now" raised card with Start/Done;
   horizontal goal cards (ring + days left + status chip); Today card (donut + 3 stat pills: work+learn h,
   wasted min (rose), steps); money bar; streak chips; weekly review card.
3. **Goals list** — big cards with ring, title, deadline, status chip, next stage.
4. **Goal detail** — header ring + pace line ("42% · expected 47% · 312 days left"); stage timeline
   (vertical, clay dots, today marker, overdue in rose); todos per stage; buttons: *Plan with AI*, *Replan*,
   *Edit*, *Pause*. Money goals also show the monthly-needed line and money bar.
5. **AI review screen** (plan/replan) — every proposed stage/todo is a card with a checkbox and inline edit;
   sticky bottom: *Add selected (n)*; shows tokens used in small caption.
6. **Todo** — segmented: Today · Upcoming · All · Done. Rows: checkbox, title, goal chip, estimate, remind
   time, ScoreBadge. Swipe right = done, left = snooze/edit. Add sheet shows the score live after a short pause
   ("quick score" or "AI score" label + reason).
7. **Time** — Today/Week switch; donut by category; timeline strip (24h, coloured blocks); top apps list
   (tap → set category); top content list (tap → set category or mark channel); steps card; focus session
   button.
8. **Money** — month header (income/expense/saved), add sheet, category bars, money-goal cards, recurring list.
9. **Routines** — wake task card (time big in Fredoka, days chips, proof type, contacts, grace); history list
   (on time / late by N min / escalated).
10. **Wake screen** (`/wake`, over lock screen) — full rose-to-peach gradient clay, time huge, top task,
    proof widget (step counter ring / text field / sums), small *Snooze (1 left)*; no other way out.
11. **Morning screen** (`/morning`) — "Good morning" + today's focus stage + top 3 todos + Start.
12. **Focus guard** — toggles (nudges, Shorts blocker per app), focus hours editor, nudge after N min,
    quiet hours, deny-list, *Test nudge*, today's nudges shown/obeyed.
13. **Settings** — setup checklist, AI (key, models, budget meter by feature, AI off), WhatsApp, about me,
    theme, backup.

## 5. Copy rules
- Plain, short, second person. Numbers first: "47 min wasted", not "You wasted 47 minutes today".
- Status words are fixed: Ahead, On track, Behind, At risk.
- Errors say what to do: "Claude key rejected. Check it in Settings → AI."
- Nudges may use light Hinglish (templates in `docs/AI.md`); everything else English.
