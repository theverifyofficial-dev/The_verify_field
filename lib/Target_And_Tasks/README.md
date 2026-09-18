# Target_And_Tasks — merged "Targets & Tasks" section

## What this is

The single screen (`target_and_tasks_home.dart`) that replaces the two
things a field worker used to open separately:

- **Target Section** — `Target_details/Monthly_target.dart` and
  `Target_details/Yearly_Target.dart` (quota progress).
- **To-Do Section** — the field-worker calendar screen that used to live in
  `Calender/CalenderForFieldWorker.dart` (the day's tasks).

**Both original screens are now deleted.** `Home_Screen.dart`'s "Tasks &
Targets" card has exactly one tappable element — the whole card — which
opens this merged screen. There is no other way to reach the old screens
because they no longer exist.

## What was actually removed, and what had to be kept

| File | Status | Why |
|---|---|---|
| `Target_details/Monthly_target.dart` | **Deleted** | Zero other references anywhere in the codebase (verified by repo-wide grep before deleting). |
| `Target_details/Yearly_Target.dart` | **Deleted** | Same. |
| `Calender/CalenderForFieldWorker.dart` | **Deleted** | See below — this one wasn't a simple delete. |
| `Calender/shared_calendar_models.dart` | **New** | 7 model classes extracted out of the file above before deleting it. |

`CalenderForFieldWorker.dart` could not simply be deleted: **`Calender/CalenderForAdmin.dart`
had a real compile-time dependency on 7 of its classes** —
`NextCallingItem`, `CallingBuildingData`, `TenantDemand`/`TenantDemandResponse`,
`UpcomingFlat`/`UpcomingFlatResponse`, and `LiveFlat` — used directly in the
Admin calendar's own fetch/render code (verified with `grep` for each symbol
against `CalenderForAdmin.dart` before touching anything). Deleting the file
outright would have broken the Admin calendar screen's build.

Instead: those 7 classes were extracted byte-for-byte (same field names,
same JSON parsing) into the new `Calender/shared_calendar_models.dart`,
`CalenderForAdmin.dart`'s one import line was repointed at that new file,
and only then was the original 5,316-line `CalenderForFieldWorker.dart`
deleted. The Admin calendar screen is unaffected — same data, same
behavior, just importing from a small shared file instead of a huge one
that no longer needs to exist.

## Navigation — fully wired, one destination per task type

Every task card routes to the **exact same detail screen** its old
per-feed card in `CalenderForFieldWorker.dart` used to open — confirmed by
reading that file's original `Navigator.push` call for each card type
before it was deleted, then checking each destination screen's constructor.
See the `switch` in `_openTask()` in `target_and_tasks_home.dart` — one
method, one case per task type, each with a one-line comment naming the
original card it replaces:

| Task type | Opens | Source of truth |
|---|---|---|
| Agreement follow-up | `AllDetailpage(agreementId: ...)` | was `_buildAgreementCard` |
| Building follow-up | `Future_Property_details(idd: ...)` | was `_buildFuturePropertyCard` |
| Owner-call reminder | `Future_Property_details(idd: ...)` (keyed by `building_id`) | was `_buildCallingReminderCard` |
| Tenant demand | `DemandDetail(demandId: ...)` | was `_buildTenantDemandCard` |
| Live property | `View_Details(id: ...)` | was `_buildLivePropertyCard` |
| Upcoming flat | `UpcomingDetailsPage(id: ...)` | was `_buildUpcomingFlatCard` |
| Website visit | opens `theverify.in/details.html?id=` in the browser (not an in-app screen — matches original behavior exactly) | was `_buildWebsiteVisitCard` |

Target quota cards route to the same per-category screens the original
`Target_details` screens used (`MonthlyBookRentScreen`,
`BuildingMonthlyListScreen`, etc.) — unchanged from the previous pass on
this merge.

## Card design — one navigation element per card

- **Home screen**: the "Tasks & Targets" card used to have three separate
  tap targets (Monthly Target button, Yearly Target button, calendar
  preview). It now has exactly one — the whole card opens
  `TargetAndTasksHome`.
- **Target quota cards** (`TargetProgressCard`): one `GestureDetector`,
  tapping anywhere opens that category's detail screen. No secondary
  buttons or icons trigger a different action.
- **Task cards** (`TaskTile`): one `InkWell`, tapping anywhere opens that
  task's detail screen. The small colored dot is a status indicator, not a
  control — it doesn't respond to taps.

This was a deliberate simplification from the original calendar cards,
several of which had a tap-to-open-details zone *plus* separate
tap-to-call / tap-to-WhatsApp icons in the same card. Those quick actions
were dropped in favor of one predictable interaction per card — see
"What changed vs. the originals" below if that quick-call behavior needs
to come back.

## What changed vs. the originals (so nothing is a surprise)

- **Quick-call / WhatsApp shortcuts are gone.** Several original task
  cards (e.g. building follow-up) had inline call/WhatsApp icon buttons
  alongside the tap-to-open-details zone. The merged `TaskTile` has one tap
  target only, per the "one navigation element" simplification requested
  for this pass. If quick-call access is still wanted, it belongs on the
  *destination* screen (`Future_Property_details`, etc.), not back on the
  list card — adding it back to the card would reintroduce the multi-button
  problem this pass removed.
- **The "two different owner-call features" conflict from an earlier pass
  is now resolved** — see "Fixed: missing task feeds, and owner-calling
  replaced" above. The old `building_calling_reminder.php` feed is no
  longer used by this screen at all; owner calling is the new
  `due_calls.php`/`submit_call.php` pair exclusively.

## Calendar date-switching (restored)

The first pass of this merge silently dropped the original screen's date
navigation: `target_and_tasks_home.dart` only ever showed **today's** tasks
via a `_selectedDate` field that was set once and never changed. This was
caught by direct user review of the running app ("where is the calendar
data switch logic?") — it was a real functional loss, not an intentional
simplification, and it was not flagged clearly enough when that pass was
reported as done.

It's now restored, faithfully reproducing the deleted
`CalenderForFieldWorker.dart` screen's own date-switching UI (recovered via
`git show HEAD:lib/Calender/CalenderForFieldWorker.dart`, since the file no
longer exists on disk — the deletion itself was not reverted, only its
last-committed content was read for reference):

- A **`Calendar` section** sits between "Your targets" and the task list,
  containing a `TableCalendar` (`table_calendar: ^3.0.6`, already a
  pubspec dependency — no new package added).
- **Month View / Week View** toggle (`_calendarFormatToggle()`, a
  `PopupMenuButton`) — same two options and the same interaction the
  original app-bar action used. `table_calendar` itself has no "Day"
  format, so the original screen didn't offer one either; none was
  invented here.
- **Tapping the "Month Year" title** opens the same month/year jump
  picker the original screen had (`_showMonthYearPicker()`), built from
  two `CupertinoPicker`s (month, year) in a bottom sheet with an "Apply"
  button — same widget, same layout, same "Apply moves the calendar and
  reloads that date's tasks" behavior.
- **Tapping a day** (`onDaySelected`) sets `_selectedDay` and immediately
  reloads the task feed for that date via `_activeDate` (a getter:
  `_selectedDay ?? _focusedDay`, replacing the old dead `_selectedDate`
  field). **Swiping/paging between months** (`onPageChanged`) just tracks
  which month is on screen for the title and the picker's defaults — it
  does not by itself change which date's tasks are loaded, exactly like
  the original.
- The tasks section heading now reflects the active date ("Today's tasks"
  vs. "Tasks for 12 Oct 2026"), via `_tasksHeadingFor()`.

This is the one piece of this merge that was reported "done" before it
actually matched the originals' functionality. Treat that as a reminder
that "verified" in the section below means the specific checks listed —
not a guarantee that every interaction was carried over; the user's own
review of the running app is what caught this gap.

## Fixed: missing task feeds, and owner-calling replaced (this pass)

Two real bugs were reported directly by the user testing the app
("fix the to do tasks... why APIs data is not showing", "implement the
building owner calling inside tasks. and target"), on top of the
calendar-restoration fix above:

**1. Three of the ten original Calendar feeds were never fetched at all.**
`pending_agreement_task.php`, `accept_agreement_task.php`, and
`book_visit_in_tenant_demand_for_fields.php` had no call site anywhere in
`task_feed_service.dart` — their corresponding `AgentTaskType` values
(`pendingAgreement` — new; `agreementAccept`; `bookVisit`) either didn't
exist or existed with a real `_openTask` case that could never run because
nothing ever produced a task of that type. Worse, the `agreementAccept`
case was a bare `throw UnimplementedError()` — a landmine that would have
crashed the app the moment this pass actually started producing that task
type. All three feeds are now fetched and parsed (field names confirmed
against `PendingAgreement`, `AcceptedAgreement`, and `BookedTenantVisit` in
the recovered original file), and every navigation destination was
re-verified against that file's own `_build*Card` widgets rather than
guessed:

| Task type | Feed | Opens |
|---|---|---|
| Pending agreement | `pending_agreement_task.php` | `AgreementDetailPage(agreementId: ...)` |
| Accepted agreement | `accept_agreement_task.php` | `HistoryTab(defaultTabIndex: 1)` |
| Booked tenant visit | `book_visit_in_tenant_demand_for_fields.php` | `DemandDetail(demandId: ...)` |

**2. Owner calling now uses the NEW `Building_Calling/due_calls.php` +
`submit_call.php` API pair, replacing the old read-only reminder feed.**
This was flagged as an unresolved conflict in an earlier pass of this
merge (two different owner-call features coexisting) — per explicit user
decision, it's resolved now by fully switching this screen to the new
pair:

- `TaskFeedService` no longer calls `building_calling_reminder.php` at
  all for this screen. Owner-call tasks come from
  `OwnerCallService.fetchDueCalls()` (`GET
  Building_Calling/due_calls.php?fieldworkarnumber=...`).
- Tapping an owner-call task opens a bottom sheet (in
  `target_and_tasks_home.dart`, `_openOwnerCallSheet`) with a status
  dropdown (`Answered` / `Not Answered` — the exact two values the spec
  requires) and a notes field. Submitting calls
  `OwnerCallService.submitCall()` (`POST Building_Calling/submit_call.php`
  with `property_id`, `fieldworkarname`, `fieldworkarnumber`, `status`,
  `notes` — the exact five fields the spec gave), and only reloads the
  task list / records the call as done once the backend confirms success.
- **Admin's calendar is untouched** — it still uses
  `building_calling_reminder.php` via `shared_calendar_models.dart`
  (`NextCallingItem`/`CallingBuildingData`). This replacement is scoped to
  the field-worker Tasks screen only, per the user's decision.

**3. New "Owner Calls" quota card added to the Target section.** Tapping
it opens `owner_calls_detail.dart`, a small new screen (no original
equivalent existed) that lists due calls and lets the field worker log
one, mirroring the Tasks screen's own call sheet.

**Assumptions flagged for verification — could not be checked live:**
this environment has no network egress to
`verifyrealestateandservices.in`, so none of `due_calls.php`'s actual
response JSON, `submit_call.php`'s actual success response, or whether
`Building_Calling/` is even the right path segment could be confirmed
against the live backend.

- `OwnerCallDue.fromJson` (in `models/owner_call_due.dart`) is
  deliberately defensive: it tries several plausible key spellings for
  building id / address / owner name / owner number (borrowed from other
  feeds' known field names) rather than assuming one. **The first time
  this runs against the real endpoint, log the raw response body and
  narrow this to the real keys.**
- `OwnerCallService.fetchDueCalls` accepts either a bare JSON list or a
  `{"data": [...]}` envelope for the same reason.
- `OwnerCallService.submitCall` treats `status: true`, `"success"`, or
  `"ok"` as success — narrow this once the real response shape is known.
- **The "Owner Calls" quota target (20/month) is a placeholder.** There
  is no existing quota for this metric anywhere in the codebase (it's a
  brand-new metric, unlike every other Target card which copied a real
  number from `Target_details/Monthly_target.dart`) — replace it with a
  real number once one exists.
- **The "done" count for that quota is a local, per-device
  `SharedPreferences` counter** (`owner_calls_done_<year>_<month>`), not a
  server-side count — because the spec's API pair has no "count of calls
  logged this month" endpoint. This means the count does NOT sync across
  a field worker's devices and is invisible to Admin. If that matters,
  the real fix is a new backend count endpoint, not a client-side
  workaround — flagging this rather than hiding it.

## Owner-calling redesign: dedicated section, one-tap call, first-in-line target

A further explicit design request refined the owner-calling flow added in
the previous pass, so it reads as its own feature rather than one more
task type sharing the generic list:

- **Own section, visually distinct.** Owner-call tasks no longer appear
  inside the "Due now / Today / Upcoming" urgency groups at all — they're
  pulled out (`_ownerCallTasks` getter; `_grouped` now explicitly skips
  `AgentTaskType.ownerCall`) into their own "Building Owner Calls" section
  between the targets row and the calendar, rendered with a dedicated
  `OwnerCallCard` widget (blue-tinted gradient card, building icon, a
  filled circular call button) instead of the shared `TaskTile` every
  other task type still uses. This also fixes a display quirk: owner
  calls were never date-scoped to begin with (see `TaskFeedService`'s
  comment on `due_calls.php`), so grouping them under whichever date
  happens to be selected was never accurate — they now show up regardless
  of the calendar's selected date, which matches what the data actually
  is.
- **One-tap calling.** `OwnerCallCard`'s call button (not the rest of the
  card) calls `_callOwner()`, which reads the owner's phone number from a
  synthetic `_owner_number` key `TaskFeedService` now stamps onto every
  owner-call `AgentTask.raw` (see that file — added specifically so the UI
  never has to guess which of `OwnerCallDue.fromJson`'s several tried key
  spellings the live backend actually used), then opens the phone dialer
  via `tel:`. Tapping the rest of the card instead opens the outcome sheet
  directly with no call placed — for logging a call a field worker already
  made through another channel.
- **Automatic return-to-app handoff.** `_TargetAndTasksHomeState` now
  mixes in `WidgetsBindingObserver`. `_callOwner()` sets `_pendingCallTask`
  right before opening the dialer; `didChangeAppLifecycleState` opens the
  call-outcome sheet the moment the app resumes, for whatever task is
  pending, then clears the flag so an unrelated return to the app doesn't
  re-trigger it. This is the "make a call, come back, the form is already
  waiting" flow from the redesign request — there's no OS callback for
  "the call ended", so app-resume is the practical signal used instead
  (the same technique this kind of "call then log" flow uses across
  mobile apps generally, since call-duration/outcome isn't exposed to
  ordinary apps on either platform).
- **"Owner Calls" quota card now leads the Target row.** Moved to the
  front of `_fetchMonthly`'s returned list in `target_service.dart`, per
  explicit request — it's the one quota tied to an in-screen action, not
  just a read-only progress ring, so it leads instead of trailing.

`_openTask()`'s `AgentTaskType.ownerCall` case is kept (still correctly
opens the same sheet) for exhaustiveness, but is effectively unreachable
through the normal task list now that owner-call tasks never enter
`_grouped` — the only real entry points are `OwnerCallCard`'s two tap
zones and the automatic post-call resume.

## Bug-fix pass: 10 issues from a code review, plus the "can't call the owner" bug

A direct code review flagged ten specific defects in the owner-calling
redesign and the surrounding screen, and the field worker reported the
call button's snackbar always saying "No phone number on file for this
owner" no matter what. Both are fixed in this pass, file by file:

**The phone number bug (root cause).** `OwnerCallDue.fromJson`'s guessed
key list for the owner's phone number never included `ownernumber` (all
lowercase, no underscore) — which, after auditing every "owner phone
number" JSON key actually used anywhere in this codebase, turned out to
be the real spelling `show_api_for_details_page.php` uses (the same
building-details endpoint `Future_Property_details.dart` already calls
successfully). Since `due_calls.php`'s exact response still can't be
confirmed live (no network egress to the backend from this environment),
the fix is two-layered rather than a single guess: `OwnerCallDue.fromJson`
now tries `ownernumber` first, and — new — `OwnerCallService` has a
`fetchOwnerNumberFallback()` that looks the number up directly from that
known-working `show_api_for_details_page.php?id=<property_id>` endpoint
whenever a due call's own record comes up empty. `fetchDueCallsResolved()`
wraps both together in one call, used by both `TaskFeedService` and
`OwnerCallsDetailScreen` so the fallback logic lives in exactly one place.

**The 10 reviewed issues:**

1. **Year range mismatch** — the month/year picker allowed 2022–2031 while
   `TableCalendar`'s own `firstDay`/`lastDay` only allowed 2023–2030;
   picking either end year in the picker produced a date `TableCalendar`
   itself considered invalid. Fixed with one source of truth
   (`_firstPickerYear`/`_lastPickerYear` constants) feeding both the
   picker's year list and `TableCalendar`'s range.
2. **Infinite loading with no credentials** — if `SharedPreferences` has
   no `number`, `_loadTargets()`/`_loadTasks()` used to return before ever
   setting `_loadingTargets`/`_loadingTasks` to `false`, leaving both
   spinners spinning forever. `_bootstrap()` now detects this up front and
   clears both flags with an explanatory snackbar; `_loadTargets()`/
   `_loadTasks()` also clear their own flag if called directly (e.g. from
   pull-to-refresh) with credentials still missing.
3. **Stale API responses** — tapping several calendar dates quickly (or
   toggling Monthly/Yearly quickly) could let an older response land after
   a newer one and silently overwrite the correct data. Fixed with a
   request-generation counter (`_targetsRequestId`/`_tasksRequestId`):
   each load captures its own id, and only applies its result if that id
   is still current when the await resolves.
4. **Month/year picker controller lifecycle** — both
   `FixedExtentScrollController`s were created inline inside
   `StatefulBuilder`'s `builder` callback, which re-runs on every wheel
   scroll (`setModalState`), so a new controller replaced the old one on
   every single item change — the "picker jumping/resetting" bug. Fixed:
   both controllers are created once, before the sheet opens, and disposed
   once it closes.
5. **`notesController` never disposed** — in both the Tasks screen's call
   sheet and `OwnerCallsDetailScreen`'s call-log dialog. Fixed in both
   places.
6. **Unchecked `launchUrl()`** — the website-visit task's external link
   launch, and both owner-calling `tel:` launches, now check the returned
   `bool` and tell the field worker when it fails instead of doing nothing
   silently.
7. **Same as #2** — covered together since they were the same fix.
8. **Async UI updates after disposal** — audited every `await` followed by
   a `setState`/`ScaffoldMessenger` call across this pass's files; every
   one now has a `mounted` (or `sheetContext.mounted`/`dialogContext.mounted`
   for sheet/dialog-local state) guard immediately after the `await`.
9. **`"null"` strings reaching detail pages** — `_openTask()`'s cases used
   to write `task.raw['id'].toString()` directly into a constructor
   argument; if the API ever omitted `id`, Dart's `null.toString()` is the
   literal string `"null"`, silently passed to a detail screen as if it
   were a real id. Every case now reads the raw value first, checks it for
   `null`, and falls through to the "couldn't open this task" snackbar
   instead of handing a fake id downstream.
10. **Duplicate/incorrect results from rapid calendar changes** — the same
    fix as #3.

**A bonus bug the #9 rewrite surfaced**: `_openTask()`'s `liveProperty` and
`upcomingFlat` cases each declared `final id = ...` WITHOUT wrapping their
case body in `{ }` — and a Dart `switch` shares one scope across every
un-braced `case`, so two cases each declaring a same-named local variable
is a genuine compile error ("id is already defined in this scope"). This
had been sitting in the file, uncaught, through every previous pass's
verification, because none of those passes could actually compile this
project (no Flutter/Dart SDK on the connected machine, unchanged). Every
case in `_openTask()` is now wrapped in its own `{ }` block, which both
fixes this and makes the null-safety fix in #9 possible per-case.

## OwnerCallsDetailScreen UI upgrade

Redesigned to match the Tasks screen's own owner-calling section rather
than the plainer list-with-a-button it started as:

- A gradient summary card (same blue family as `OwnerCallCard`) showing
  calls logged this month against the monthly quota
  (`TargetService.monthlyTargets['Owner Calls']`) with a progress bar,
  replacing the old plain "Logged this month: N" row.
- Each due call is its own card, styled to match `OwnerCallCard`: building
  icon, owner name/address, and a filled circular call button.
- The call button now actually calls (`tel:`) instead of only offering
  "Log call" — tapping it opens the dialer, and (new) this screen also
  mixes in `WidgetsBindingObserver` so returning to the app after the call
  automatically opens the same log-call dialog, exactly like the Tasks
  screen's redesigned flow. Tapping the rest of the card still opens that
  dialog directly, for logging a call made another way.

## Owner-calls list: collapsed by default, count badge, direct-number calling

Three follow-up changes to the owner-calling feature, all requested together:

- **Collapsed by default, arrow to expand.** `target_and_tasks_home.dart`'s
  `_ownerCallsSection` now has a `bool _ownerCallsExpanded = false` state
  field. The section's header (title + a trailing arrow) is always shown;
  the list of due calls (loading spinner / empty state / `OwnerCallCard`s)
  is only built when `_ownerCallsExpanded` is `true`. Tapping the arrow
  toggles it via `setState`, and the arrow itself is wrapped in
  `AnimatedRotation` so it spins to point up when the list is open, giving
  a visible open/closed state instead of a static icon.
- **Due count as a red badge in the header.** The old header text
  (`'Building Owner Calls  ·  N'`) is replaced with the plain title plus a
  small red rounded-pill `Container` (via `_sectionHeader`'s existing
  `trailing` parameter) showing just the number, styled like a
  notification badge. It only renders when `calls.isNotEmpty`, so an empty
  queue shows a plain header with no stray "0".
- **Owner number passed directly into `_callOwner`, in both screens.**
  Previously `_callOwner` (in both `target_and_tasks_home.dart` and
  `owner_calls_detail.dart`) re-derived the phone number itself by reading
  `task.raw['_owner_number']` / `call.ownerNumber` inside the function
  body. Both now take the number as an explicit second parameter —
  `_callOwner(AgentTask task, String ownerNumber)` and
  `_callOwner(OwnerCallDue call, String ownerNumber)` — and the caller
  (the `OwnerCallCard`'s `onCallTap` in the Tasks screen, the call-button
  `onTap` in the detail screen) supplies it directly from the same data it
  already has (`task.raw['_owner_number']`, `call.ownerNumber`). The
  function body still does the digit-stripping and the "no usable number"
  check — only where the number comes from changed, not the validation.
  This also removed a stray leftover `print(number);` debug line from
  `owner_calls_detail.dart`'s `_callOwner`.

`OwnerCallsDetailScreen` is a dedicated list screen — showing the list
*is* the screen's purpose — so the collapse/arrow/badge changes were not
applied there; only the direct-number-passing change was, since the user
asked for that specifically "in both screen task + detail screen".

## Fixed: crash on returning to the app after a call, plus a bottom-sheet UI/loader pass

A field worker reported that returning to the app after placing a call
(the "come back and the outcome sheet is already open" flow from the
owner-calling redesign) crashed with a Flutter **framework-level**
assertion, not an app-logic exception:

```
'_dependents.isEmpty': is not true
```

thrown from `InheritedElement.debugDeactivated`, with the offending
widget reported as `ThemeSwitcher` (the app's own theme `InheritedWidget`,
declared in `main.dart` above the app's single `Navigator`), plus a
`RenderFlex ... OVERFLOWING` in the same report.

**Root cause (best explanation given what's actually knowable here):** the
owner-call sheet was opened from `didChangeAppLifecycleState` via a
*single* `addPostFrameCallback`, using *this screen's own* `context`, the
instant the app reports `resumed`. But `main.dart` wraps the whole app in
a theme switcher and a `NetworkListener` (connectivity), and coming back
from a phone call is exactly when connectivity/theme state tends to
change — so a resume-triggered rebuild higher up the tree could still be
in flight in the very same frame `showModalBottomSheet` tried to insert a
new route into the `Overlay`. Two concurrent mutations of the tree's
`Overlay`/`InheritedElement` bookkeeping in one frame is a known class of
Flutter framework race, not something an app-level `try`/`catch` can
intercept (it's a debug-mode `assert`, so it wouldn't even throw in a
release build — but the underlying race is real either way and was very
likely also the source of the reported overflow, since the sheet could be
laid out against a half-updated `MediaQuery`).

**Fix — stop racing it, and make the sheet itself unbreakable regardless:**

- `didChangeAppLifecycleState` now waits a frame **and then a further
  300ms** before opening the sheet, giving any resume-triggered rebuild
  time to fully settle first.
- It now opens the sheet using `navigatorKey.currentContext` (the app's
  single root `Navigator`, exported from `main.dart` — the same stable
  anchor every notification-triggered navigation in this app already
  uses, e.g. `navigatorKey.currentState?.pushNamed(...)`) instead of this
  screen's own `context`, which may not even belong to the current route
  by the time the field worker actually returns.
- A new `_ownerCallSheetOpen` guard flag stops `_openOwnerCallSheet` from
  ever being entered twice at once — the resume path and a direct "Log
  call" tap both funnel through the same method, and two modal routes
  landing in the `Overlay` back-to-back is exactly the kind of thing that
  can trigger this class of crash. Wrapped in `try`/`finally` so the flag
  (and `notesController`) always reset even if something inside the
  builder throws.
- The sheet's content is now wrapped in a `SingleChildScrollView` inside a
  height-capped `ConstrainedBox` (`maxHeight: 90%` of the screen), so it
  can scroll instead of overflowing regardless of keyboard state or
  screen size — this directly addresses the reported `RenderFlex
  OVERFLOWING`, independent of whatever exact circumstance produced it.

**UI pass on the same sheet** (`_openOwnerCallSheet` in
`target_and_tasks_home.dart`), per the same request:

- The plain `DropdownButtonFormField` status picker is replaced with two
  big, color-coded "Answered" / "Not Answered" choice tiles (new
  `_OutcomeChip` widget) — faster to tap and readable at a glance instead
  of needing to open a dropdown.
- The header icon is now a filled gradient avatar instead of a flat
  circle, and gained a close (✕) button so the sheet can be dismissed
  without a swipe.
- The notes field now has a filled background instead of a bare outline,
  matching the rest of the app's input styling.
- While submitting: the outcome tiles, notes field, and close button are
  all disabled (not just the Submit button, which already disabled
  itself), and the sheet can no longer be swiped/backed away from
  (`WillPopScope`, blocked only while `submitting` is true) — so a slow
  network call can't lose what the field worker just typed.
- The submit button's loader (already present before this pass) is now
  paired with a "Submitting…" label next to the spinner, instead of the
  spinner alone, so it's unambiguous the tap registered.

## Same crash fix + UI pass applied to `OwnerCallsDetailScreen`'s dialog

The previous pass fixed the app-resume crash and redesigned the loader/UI
only in `target_and_tasks_home.dart`'s bottom sheet. This pass brings
`owner_calls_detail.dart`'s `_logCall` dialog — the Target section's own
"log this call" UI, opened by `showDialog` rather than a bottom sheet —
up to the same standard, since it has the exact same
`didChangeAppLifecycleState` → `addPostFrameCallback` → open-something
pattern and was equally exposed to the same framework-level race:

- `didChangeAppLifecycleState` now waits a frame **and** a further 300ms,
  then opens the dialog on `navigatorKey.currentContext` (imported
  `show navigatorKey` from `main.dart`) instead of this screen's own
  `context` — identical fix, same reasoning, as the Tasks screen.
- New `_logCall(BuildContext context, OwnerCallDue call)` — the method
  now takes its context as an explicit parameter (it used to close over
  the State's own `context` implicitly) so the resume path can hand it
  the root-navigator context while the manual "tap a due call" path keeps
  passing its own local `context`, exactly mirroring
  `_openOwnerCallSheet(BuildContext context, AgentTask task)`'s shape.
- New `bool _logCallDialogOpen` guard, wrapped in `try`/`finally`, stops
  the dialog from ever being opened twice at once — same fix as
  `_ownerCallSheetOpen`, same reasoning.
- The dialog's `content` is now `ConstrainedBox(maxHeight: 70% of screen)`
  + `SingleChildScrollView`, so it can scroll instead of overflow
  regardless of screen size or keyboard state (dialogs are less prone to
  this than a `showModalBottomSheet(isScrollControlled: true)`, but the
  fix is cheap and keeps both screens' owner-calling UIs held to the same
  standard rather than one being hardened and the other not).

**UI pass, same language as the Tasks screen's sheet:**

- The plain `DropdownButtonFormField` status picker is replaced with the
  same two color-coded outcome tiles the Tasks screen uses.
- The title's plain icon is now the same small gradient avatar.
- The notes field gained the same filled background.
- Every input (outcome tiles, notes field, Cancel button) disables while
  submitting, and the dialog blocks the back gesture while submitting
  (`WillPopScope`), matching the sheet.
- The submit button's existing loader now shows "Submitting…" next to
  the spinner instead of the spinner alone.

**Deduplication**: rather than write a second private copy of the outcome
tile widget in this file, it was pulled out of `target_and_tasks_home.dart`
into a new shared `widgets/owner_call_outcome_chip.dart`
(`OwnerCallOutcomeChip`, public) that both screens now import and use.
This is a real reduction in the "each screen has its own separate
implementation" duplication flagged as a standing risk in every earlier
pass — it doesn't eliminate the duplication (the sheet and the dialog are
still two separate pieces of layout code, `_callOwner`/`_logCall`
included), but it's one fewer thing that can drift out of sync between
them.

## Verification performed (and its limits)

**No Flutter/Dart SDK is available on the connected machine** (`which
flutter` returns nothing), so `flutter analyze` / `flutter test` /
`flutter build` could **not** be run. What was checked instead, for every
file touched in this pass:

- Every deleted file was `grep`'d across the entire `lib/` tree first, to
  confirm nothing else referenced it (the one exception —
  `CalenderForAdmin.dart` — is exactly why the extraction step above
  exists instead of a straight delete).
- Every navigation destination's constructor was read directly from its
  source file and matched against the arguments passed to it.
- Every new/edited file's brace and parenthesis counts were checked for
  balance.
- Every JSON field name used in `target_service.dart` and
  `task_feed_service.dart` was cross-checked against the original
  `fromJson` factory that used to parse that exact field.

**This is real, targeted verification — it is not the same as a successful
compile.** Please run `flutter analyze` (and ideally `flutter test`) on a
machine with the Flutter SDK before treating this as done; a typo or a
mismatched named parameter would not be caught by any of the checks above.

## Rollback

Both original screens are gone, so rollback means restoring from git history
rather than deleting a new addition:
`git checkout <commit-before-this-change> -- lib/Target_details/Monthly_target.dart lib/Target_details/Yearly_Target.dart lib/Calender/CalenderForFieldWorker.dart lib/Home_Screen.dart`,
then delete `lib/Target_And_Tasks/` and `lib/Calender/shared_calendar_models.dart`.
