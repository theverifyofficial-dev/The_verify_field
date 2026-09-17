# Verify Field — Task & Dashboard Redesign Spec
**Agent Task View + Admin Performance Dashboard**

Grounded in the current app's real theme tokens (pulled from `main.dart` and `App_card_theme.dart`): font `PoppinsMedium`, light background `#F7F7F7` / white cards, dark background `#121212` / `#1E1E1E` cards, 24px-radius soft-shadow gradient cards with a subtle blue radial glow in the corner, and an existing "vivid gradient tile" language already used on the Home Screen (blue `#3B82F6→#1D4ED8`, green `#10B981→#047857`, amber `#F59E0B→#DC2626`, purple `#8B5CF6→#7C3AED`, cyan `#06B6D4→#0891B2`, red `#EF4444→#DC2626`). This spec extends that existing visual language rather than replacing it — nothing below asks for a new design system, just a more disciplined use of the one already shipping.

---

## 0. Design Principles (the "why" behind every choice below)

- **Calendar-first, not list-first.** The current calendar screen makes the agent choose a date and then re-fetches; the redesign flips this so *today* is the default landing state and the calendar becomes a navigation strip, not a picker you must operate first. Fewer decisions before the agent sees actionable content = lower cognitive load.
- **Time is the primary axis, task type is secondary.** Right now each task type (agreement, building, tenant demand, visit) is visually and structurally separate because they come from different endpoints. Agents don't think "I need to check my agreement tasks" — they think "what do I do today." The UI must merge all task types into one time-ordered feed; type becomes a badge/icon, not a separate screen.
- **The system should never require the agent to remember something exists.** Recurring obligations (like the monthly owner call) are currently invisible until someone manually triggers the underlying record's date logic. The fix is to generate these automatically from a rule ("every building, every 30 days") rather than relying on a human to have set a reminder.
- **Status should be a single, explicit, agent-set action — never inferred.** The current app infers "done" from whether a text field is non-empty in at least one flow. That's fragile and invisible to the agent. Every task needs one unambiguous Complete action that the agent presses themselves.
- **Admin dashboards should answer "who needs my attention today" before "here are all the numbers."** Dense analytics is easy to build and hard to act on. Lead with exceptions (overdue, at-risk agents), then let admins descend into detail.

---

## 1. Agent Task View (Mobile-First)

### 1.1 Information architecture
Three temporal buckets replace the current date-by-date recall model:

- **Overdue** — anything past its due date/time, not completed. Always shown first, always visually urgent (not because it's shameful, but because it's genuinely time-sensitive — a follow-up call two weeks late is worse than one due tomorrow).
- **Today** — the default, largest section. This is what opens when the agent opens the app.
- **Upcoming** — next 7 days, collapsed by default into day groupings ("Tomorrow," "Thu, 21 Sep," etc.) so it doesn't compete visually with Today.

This replaces "pick a date, see what's on it" with "here's your day, ranked by urgency" — the agent never has to initiate a search for their own work.

### 1.2 Screen layout (top to bottom)

1. **Sticky header band**
   - Agent's name + a single-line greeting ("Good morning, Ravi") — friendly, low-effort personalization using data already cached locally (no new backend call).
   - A horizontally-scrollable **7-day mini calendar strip** (today centered, small dot under any day that has tasks, red dot if that day has overdue items carried into it). Tapping a day scrolls the feed to that day's section instead of triggering a full re-fetch — this is the one change from the current architecture that most directly reduces perceived latency and cognitive effort, since agents don't wait on a network call just to look one day ahead.
   - A compact progress ring or bar: "4 of 7 done today" — immediate glanceable feedback, reusing the existing circular-progress visual style already present in the Targets screens (don't invent a new component here).

2. **Overdue banner** (only renders when count > 0)
   - Warm-red gradient card (reuse the app's existing red/orange gradient tile style, e.g. `#EF4444→#DC2626`), collapsed to a single row by default: "3 overdue tasks" with a chevron to expand. Collapsed-by-default avoids the banner dominating the screen every single day once an agent has a backlog — expand-on-demand keeps the default view calm.

3. **Today's task feed** — a vertical list of **Task Cards** (see 1.3), grouped by nothing else — no sub-headers by type, because mixing an owner call, a new-flat entry, and a tenant-demand follow-up in one honest time-ordered list is the actual point of the redesign.

4. **Upcoming (collapsed groups by day)** — same Task Card component, lower visual weight (slightly reduced opacity/elevation) since it's not actionable *yet*.

5. **Floating "+ Add Task" action** (bottom-right, existing FAB pattern) — lets an agent manually log something ad hoc (e.g., "call this owner Friday") without waiting for the system to generate it. This preserves/extends existing functionality rather than only relying on automation.

### 1.3 The Task Card component (the single most important reusable piece)

A single card design used for every task type — agreement follow-up, building call, tenant demand, new-flat entry, everything. Structure:

- **Left accent strip or icon chip**, color/icon coded by task type (reuse existing gradient tile colors as a legend — e.g. calls = amber, agreements = blue, tenant demand = purple, new listings = green). This gives type-recognition at a glance without needing a text label.
- **Title line**: plain-language, not a database field name — "Call Mr. Sharma — Sunrise Apartments" not "Building Task #4021."
- **Subtitle**: context needed to act (phone number preview, address, or "Recurs monthly" tag for automated tasks).
- **Time or due-state chip**: "Today, 3:00 PM" / "Overdue by 2 days" / "Due tomorrow" — always human-relative, never a raw date, to reduce the mental math agents currently have to do.
- **Quick-action row** (inline on the card, no navigation required for common actions):
  - ✅ **Complete** — one tap, immediate optimistic UI update, undo toast for 5 seconds (forgiving of mis-taps, standard modern pattern).
  - 📞 / 💬 **Call / WhatsApp** — keep the existing tel:/wa.me deep-link behavior, just surfaced consistently on every card instead of only some.
  - 🕒 **Reschedule** — opens a lightweight bottom sheet (date/time picker + optional reason), not a full-screen form.
  - 📝 **Add note** — same bottom-sheet pattern, replaces the current "feedback" text field but makes it visibly attached to *this* task instead of buried in a separate flow.
- **Tap-anywhere-else** on the card still opens the full underlying record (agreement detail, property page, tenant demand detail) exactly as today — this preserves all existing deep functionality; the card is a smart summary layer on top, not a replacement for the detail screens.

### 1.4 Recurring tasks — how they surface automatically
Rather than an agent or admin manually creating "call this owner again," recurrence should be a rule attached once to the underlying record type:

- Each **building/owner record** gets a `next_contact_due` computed field (owner call cadence, default 30 days, editable by admin per building if some owners need a different rhythm).
- A lightweight scheduled job (daily) generates that day's occurrence into the same task feed the agent already sees — the agent never "sets up" a recurring task; it simply appears on the right day, indistinguishable in the UI from a one-off task except for a small "Recurs monthly" tag for transparency.
- When completed, the system stamps `last_contacted_at` and the next occurrence auto-calculates — no new task-creation step for anyone.
- This same rule engine generalizes to any future recurring obligation (e.g., quarterly document re-verification) without new UI — only a new rule definition.

### 1.5 Micro-interactions
- Completing a task: card animates to a muted/checked state, brief green pulse, then either fades out after 2s or slides to a collapsed "Completed today" strip at the bottom of the Today section (keeping a visible sense of progress rather than tasks just vanishing).
- Pull-to-refresh on the feed, with the existing app's loading treatment (skeleton shimmer cards, not a blocking spinner) — matches modern mobile expectations and avoids the "did anything happen" ambiguity of a full-screen loader.
- Haptic tick on Complete (subtle, standard iOS/Android pattern) — reinforces "done" without needing to look.
- Empty state for Today ("You're all caught up 🎉" + a small illustration) — important for morale; a day with zero tasks should read as a win, not a blank/broken screen.

---

## 2. Admin Dashboard (Desktop-First)

### 2.1 Layout shell
Standard desktop dashboard shell: fixed left sidebar (existing app nav), top filter bar, main content in a responsive card grid. Reuse the existing card language (white/`#1E1E1E` cards, 24px radius, soft shadow) so this doesn't feel like a bolted-on third product inside the app.

### 2.2 Global filter bar (top, always visible, sticky on scroll)
- **Date range** — quick-select chips (Today / This Week / This Month / This Year) plus a custom range picker. Defaults to "This Month."
- **Agent** — multi-select dropdown with avatars; defaults to "All Agents." Must be a live, backend-driven list — not the hardcoded roster the current Targets screens use, since this dashboard is explicitly meant to scale with team size.
- **Task type** — multi-select (Owner Calls, New Buildings, New Flats, Agreements, Tenant Demand, Other).
- **Status** — multi-select (Completed, Pending, Overdue).
- A **"Reset filters"** link and a persistent chip row showing active filters, so an admin never loses track of what view they're looking at.

### 2.3 Top row — KPI stat tiles (glanceable summary, 4–5 tiles)
Reuse the existing gradient-tile visual style from the Home Screen for consistency:
- **Total tasks** (in selected range)
- **Completion rate** (%, with a small trend arrow vs. previous equivalent period)
- **Overdue tasks** (this tile should visually stand out — red/amber — since it's the number that demands action)
- **Active agents** (how many agents had ≥1 task in range — surfaces inactivity at a glance)
- **Avg. time-to-complete** (optional 5th tile, if the data supports it — shows responsiveness, not just volume)

### 2.4 Main visualization area
Following data-visualization best practice (clarity over decoration, one clear idea per chart):

1. **Trend line/area chart** — tasks completed vs. tasks assigned over the selected date range, granularity auto-adjusting to the range (daily bars within a month, monthly within a year). This answers "are we keeping pace" at a glance.
2. **Agent leaderboard / breakdown table** — one row per agent: avatar + name, tasks assigned, completed, overdue, completion %, small inline sparkline of their last 7/30 days. Sortable by any column. This is the "showcase performance" ask made concrete — a sortable table beats a wall of individual bar charts when comparing many agents.
3. **Task-type breakdown** — horizontal bar or donut showing volume by type (Owner Calls / New Buildings / New Flats / Agreements / Tenant Demand) so admins can see where the team's time is actually going, not just how much got done.
4. **Overdue watchlist panel** — a focused list, not a chart: every currently-overdue task, sorted by how overdue it is, with agent name and a one-click "Reassign" or "Nudge" action. This is the single most actionable widget on the page and should sit prominently (top-right or directly under the KPI row), not buried at the bottom — per the "exceptions before analytics" principle in §0.

### 2.5 Drill-down: individual agent view
Clicking an agent (from the leaderboard or the filter) opens a focused view — either a side panel (fast, keeps context) or a dedicated route (better for deep review):
- Same KPI tiles, scoped to that agent.
- Their personal task feed, in the same Task Card component used on mobile (component reuse across platforms keeps the codebase and the mental model consistent) — read-only from the admin side, with a "Reassign" action available per task.
- A calendar heatmap (like a GitHub contribution graph) of daily activity across the selected year — a compact way to spot patterns (e.g., consistently quiet weekends, a two-week gap) that a table of numbers would hide.
- Recurring-task compliance indicator — e.g., "27 of 30 monthly owner calls made this quarter" — directly measures the automated-recurrence feature from §1.4 and gives admins a concrete performance signal tied to it.

### 2.6 Export / showcase
- "Export view" (CSV/PDF of the current filtered table) for reporting to ownership/investors — a lightweight but frequently-requested feature for CRM dashboards, and easy to add on top of the same filtered dataset already powering the screen.
- A **"Share snapshot"** option that generates a clean, read-only summary card (top agents, completion rate, trend) suitable for a WhatsApp/email update — leans into the "showcase" language in the requirements without requiring a separate reporting tool.

---

## 3. Component & Style Guidance

### 3.1 Typography
- Keep `PoppinsMedium` as the base family (already the app's identity) — do not introduce a second typeface. Establish a clearer **scale** than currently exists, since the audit found no consistent type-scale usage across screens:
  - Screen title: 22–24px / semibold
  - Card title: 16px / semibold
  - Card subtitle/meta: 13px / regular, muted color
  - Stat tile number: 28–32px / bold
  - Stat tile label: 12px / medium, uppercase, muted

### 3.2 Color
- Keep the existing light (`#F7F7F7` background / white cards) and dark (`#121212` background / `#1E1E1E` cards) themes exactly as-is — no new base palette needed.
- Formalize the **already-present gradient tile colors** into a named semantic system instead of ad hoc hex values scattered per screen (the current codebase reuses similar but not identical hex pairs in different files — worth consolidating into shared constants during implementation):
  - Success / Completed → green (`#10B981 → #047857`)
  - Warning / Due soon → amber (`#F59E0B → #DC2626` softened, or a pure amber `#F59E0B → #FBBF24`)
  - Danger / Overdue → red (`#EF4444 → #DC2626`)
  - Info / Upcoming → blue (`#3B82F6 → #1D4ED8`)
  - Category accents (task types) → purple, cyan, green, amber as already used on the Home Screen tiles.
- Never rely on color alone for status (per accessibility best practice) — every status also gets a short text label and/or icon, since several existing screens currently use color as the only signal.

### 3.3 Components to build/standardize
- `TaskCard` (agent + admin drill-down, shared)
- `StatTile` (gradient KPI tile — formalize the pattern already used inline on the Home Screen into a real reusable widget)
- `DateFilterBar` (chips + range picker, admin)
- `AgentMultiSelect` (avatar dropdown, admin — must query a live roster, not a hardcoded list)
- `MiniCalendarStrip` (agent, horizontal 7-day scroller)
- `OverdueBanner` (agent, collapsible)
- `AgentLeaderboardTable` (admin, sortable)
- `ActivityHeatmap` (admin, per-agent drill-down)
- `EmptyState` (shared, illustration + message — used for "no tasks today," "no results for this filter," etc.)

### 3.4 Micro-interaction summary
| Interaction | Behavior |
|---|---|
| Complete a task | Optimistic check animation → undo toast (5s) → collapse to "done" strip |
| Reschedule | Bottom sheet, no full navigation |
| Overdue banner | Collapsed by default, expands with a smooth height animation |
| Admin filter change | Debounced re-fetch (~300ms) with skeleton shimmer, not a blocking spinner |
| Leaderboard sort | Instant client-side re-sort if data is already loaded, no re-fetch |
| Agent drill-down | Slide-in panel (desktop) rather than full page reload, to preserve dashboard filter context |

---

## 4. Suggested Component Hierarchy

**Agent Task View**
```
TaskViewScreen
├── GreetingHeader
├── MiniCalendarStrip
├── DailyProgressIndicator
├── OverdueBanner (collapsible)
│   └── TaskCard[] 
├── TodaySection
│   └── TaskCard[]
├── UpcomingSection (grouped by day, collapsed)
│   └── DayGroup[]
│       └── TaskCard[]
├── CompletedTodayStrip (collapsed)
└── AddTaskFAB
```

**Admin Dashboard**
```
AdminDashboardScreen
├── FilterBar (date range, agent, task type, status)
├── KpiTileRow
│   └── StatTile[]
├── MainGrid
│   ├── TrendChartCard
│   ├── OverdueWatchlistCard
│   ├── AgentLeaderboardTable
│   └── TaskTypeBreakdownCard
└── AgentDrillDownPanel (on demand)
    ├── AgentKpiTileRow
    ├── ActivityHeatmap
    ├── RecurringComplianceIndicator
    └── AgentTaskFeed
        └── TaskCard[] (read-only + Reassign)
```

---

## 5. What This Preserves vs. Adds

- **Preserved:** every existing detail screen (agreement forms, property verification, tenant demand detail), all existing call/WhatsApp deep links, the existing light/dark theme system, existing per-role data scoping.
- **Added:** a unified time-ordered task feed, one-tap completion as a real status action (replacing the inferred/text-based completion pattern found in the current tenant-demand flow), a recurrence rule engine for automatic monthly-call generation, and a genuinely drill-down-capable admin dashboard driven by a live agent roster instead of a hardcoded list.
- **Implementation note:** this spec assumes a backend task-aggregation layer (even a thin one) sits behind both views, since the current architecture's ~10 separate per-feature endpoints would otherwise have to be fanned out and merged client-side twice (once for the agent feed, once for the admin dashboard) — flagged here as the main technical dependency to scope before UI work starts.
