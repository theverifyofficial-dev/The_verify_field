# Legacy Calendar/Target/Task Audit

Date: 2026-09-22
Scope: the OLD per-role Calendar, Target, and Task-history implementations that were superseded this session by the unified `lib/Target_And_Tasks/` (field worker) and `lib/Admin_Target_And_Tasks/` (admin/sub-admin) system.

**Nothing has been deleted. This is the audit only — no files touched, waiting for approval.**

## Method

Same evidence bar as the general cleanup audit: a real import graph across all 429 `lib/**/*.dart` files, BFS from `lib/main.dart`, PLUS one extra step this specific audit needed — for every import edge into the old trees, I checked whether the importing file actually *uses* any symbol from it (an import statement that resolves to a real file still counts as a graph edge even if nothing in it is ever called, so graph reachability alone isn't proof of real use). That extra check mattered once, and it's the finding that unlocks most of this report: `SubAdminAccountant_Home.dart` imports `Adminisstrator_Target_details/Targets.dart` but the word `Target` never appears anywhere else in that file's body — it's a dead import left over from the screen's 2026-09-22 rebuild earlier this session. With that edge removed, I recomputed reachability for the whole Calendar/Target/Task cluster and also checked `routes.dart`, `main.dart`'s notification dispatch table, the three home screens' navigation, native Android/iOS code, and asset usage directly.

## What's actually going on (read this before the tables)

There isn't one old system and one new system living side by side — it's a hybrid: the new `Target_And_Tasks`/`Admin_Target_And_Tasks` screens are the entry points, but they reuse a *subset* of the old detail screens as drill-down pages when you tap into a specific target category (e.g. tapping "Rent bookings" still opens the old `Target_details/Monthly_Tab/Book_Rent.dart`). Specifically:

- The old **Calendar** screens are already half-gone: `Calender/CalenderForFieldWorker.dart` was deleted in an earlier pass (its 7 still-needed model classes were extracted into `Calender/shared_calendar_models.dart` first — this is exactly the pattern this report recommends repeating for the admin side). `Calender/CalenderForAdmin.dart` is still on disk, but only ~380 of its 3,814 lines are alive; the rest is the dead screen.
- The old **Target** system's *Monthly* tab is genuinely still load-bearing (7 detail files + their own sub-details, on both the field-worker and admin sides except one asymmetry noted below) — reused directly by `Target_And_Tasks/services/target_service.dart`.
- The old **Target** system's *Yearly* tab is **entirely dead** on both sides — nothing in the new system links to it at all.
- The old admin Target **hub screen** (`Adminisstrator_Target_details/Targets.dart`, 2,012 lines) and the field-worker equivalent (`Statistics/Target_MainPage.dart`, 1,301 lines) are both dead — replaced outright by the new hub screens.
- There's no separate old "Task" system to find — task tracking was always part of the Target/Calendar screens, not a standalone feature, so there's nothing extra in this category beyond what's listed below.
- `routes.dart` and `main.dart`'s FCM notification-routing table have **zero** references to any of the old screens — no route or push-notification cleanup is needed.
- No assets, fonts, or localization strings are used *exclusively* by the old screens (the 3 image constants they do reference — `AppImages.transparent/loader/verify` — are each used in 20–130 other files) — no asset cleanup needed here.
- No Android/iOS native code references any of this — it's pure Dart/UI.

---

## OLD & SAFE TO DELETE

| Path | Reason | References checked | Evidence |
|---|---|---|---|
| `lib/Adminisstrator_Target_details/Targets.dart` (2,012 lines) — old admin Target hub screen | Replaced by `Admin_Target_And_Tasks/admin_target_and_tasks_home.dart` | Its only importer (`SubAdminAccountant_Home.dart`) never actually references the `Target` class or any of its exported widgets (`TargetCard`, `TargetsCard`, `TargetMetricCard`, `UserCounts`) — confirmed by grepping for each name in that file's body: zero hits | Full-repo grep for `Targets.dart` imports: exactly one hit, and it's dead |
| `lib/Adminisstrator_Target_details/OwnerCallsHistoryScreen.dart` (523 lines) | Only ever navigated to from inside the now-dead `Targets.dart` | Zero other importers anywhere in the repo | Superseded by `Target_And_Tasks/owner_calls_detail.dart`, which is what the new system actually uses |
| `lib/Statistics/Target_MainPage.dart` (1,301 lines) + `lib/Statistics/Progressbar.dart` (259 lines) — old field-worker Target hub | Replaced by `Target_And_Tasks/target_and_tasks_home.dart` | Zero importers anywhere in the repo (confirmed independently in the earlier general cleanup audit too) | Not reachable from `main.dart` at all |
| `lib/Target_details/Target_Widget.dart` (125 lines), `history_target.dart` (465 lines), `history_detailpage.dart` (345 lines) | Old field-worker target-history widgets | `Target_Widget.dart`/`history_target.dart` were only ever imported by the now-dead `Targets.dart`; `history_detailpage.dart` has zero importers at all | Confirmed via repo-wide grep for each filename |
| **Entire `Target_details/Yearly_Tab/` tree** (10 files, `Agreement_External.dart`, `Book_Buy.dart`, `Book_Rent.dart`, `Building.dart`, `Police_verification.dart`, and the 5 files under `Target_Under_Details_/`) | The new system's `target_service.dart` only reuses the *Monthly* tab, never Yearly | Zero importers for any of the 10 files | Consistent with `Yearly_Target 2.dart` already being confirmed fully dead in the general cleanup audit — the whole Yearly feature is gone |
| **Entire `Adminisstrator_Target_details/Yearly_Tab/` tree** (10 files, same names, admin side) | Same as above, admin mirror | Zero importers for any of the 10 files (all reachable only via the now-dead `Targets.dart`) | Same pattern, both role-trees confirmed dead in tandem |
| `Target_details/Monthly_Tab/Monthly_police_verification.dart` + its own `Monthly_under_detail/Police_Monthly_Detail.dart` | Field-worker-side police-verification detail — **not** the one `target_service.dart` actually links to (see asymmetry note below) | Zero importers besides each other | `target_service.dart` imports only the **admin-side** `Adminisstrator_Target_details/Monthly_Tab/Monthly_police_verification.dart`, for both roles |
| `Adminisstrator_Target_details/Monthly_Tab/{Book_Rent,Live_Commercial,Monthly_LiveBuy,Monthly_LiveRent,Monthly_agreement_external}.dart` (5 files) + their own `Monthly_under_detail/{Agreement_Monthly_Detail,Monthlu_Livebuy_details,Monthly_LiveRent_detail,Monthly_Livecommercial_details,Monthly_bookrent_detail}.dart` (5 files) | The admin-side copies of these specific Monthly detail screens — `target_service.dart` links to the **field-worker-side** copies for these five categories instead (see asymmetry note) | Zero importers besides the now-dead `Targets.dart` | Confirmed: `target_service.dart`'s imports for these 5 categories all point at `Target_details/...` (field-worker folder), never `Adminisstrator_Target_details/...` |
| `CalendarTaskPageForAdmin` + `_CalendarTaskPageForAdminState` inside `lib/Calender/CalenderForAdmin.dart` (lines 908–3814, ~2,900 of the file's 3,814 lines) — the old admin calendar screen itself | Replaced by `Admin_Target_And_Tasks/admin_target_and_tasks_home.dart`'s new calendar strip | Zero navigation to `CalendarTaskPageForAdmin(` anywhere in the repo — only two doc-comments mentioning it as "replaced" | **This is a partial-file deletion, not a whole-file one** — see the note right below |
| 13 model classes inside the same file, used only by that dead screen: `OverviewStat`, `AddFlatResponse`, `AdminAddFlat`, `AdminAcceptedAgreementResponse`, `AdminAcceptedAgreement`, `AdminPendingAgreementResponse`, `AdminPendingAgreement`, `BookedTenantVisit`, `BookedTenantVisitResponse`, `BuildingCallingResponse`, `BuildingCalling`, `FieldWorkerStat` | Same reasoning — dead once the screen that used them is gone | None of these 13 names appear anywhere in `Home_Screen.dart` (the file's only external importer) | Checked each class name individually against `Home_Screen.dart`'s body: zero hits for all 13 |

### Important note on `CalenderForAdmin.dart`

This file is **not** a clean delete — it can't be, because `Home_Screen.dart` (the *field worker's own* home screen, oddly enough) imports it just to reach 5 of its model classes for its "Tasks & Targets" counts: `AgreementTaskResponse`, `AgreementTask`, `FuturePropertyResponse`, `FutureProperty` (needed as `FuturePropertyResponse`'s field type even though it's not named directly), and `WebsiteVisitResponse`/`WebsiteVisit`. That's roughly lines 30–192 and 286–516 of the file (~380 lines) — everything else, including the screen widget itself, is dead.

The right fix here is the exact same move a previous pass already made for the field-worker side: extract those ~380 live lines into `Calender/shared_calendar_models.dart` (which already exists and already holds the field-worker equivalent extraction), point `Home_Screen.dart`'s import at that file instead, and then delete the rest of `CalenderForAdmin.dart` outright. I'm flagging this precisely rather than doing it now, since it's a refactor-then-delete, not a plain `rm` — I want your explicit go-ahead on that approach before touching it.

---

## CURRENT & MUST KEEP

| Path | Current usage | Where it's used |
|---|---|---|
| `Target_And_Tasks/*` (all 13 files) and `Admin_Target_And_Tasks/admin_target_and_tasks_home.dart` | The new unified Target/Task/Calendar hub for both roles | Entry points from `Home_Screen.dart` and `Administrator_HomeScreen.dart`/`SubAdminAccountant_Home.dart` |
| `Calender/shared_calendar_models.dart` | Holds the 7 model classes rescued from the already-deleted `CalenderForFieldWorker.dart` | Imported by `Calender/CalenderForAdmin.dart` |
| `Calender/CalenderForAdmin.dart` — **only** the model classes `AgreementTaskResponse`/`AgreementTask`/`FuturePropertyResponse`/`FutureProperty`/`WebsiteVisitResponse`/`WebsiteVisit` (~lines 30–516) | Field worker's own home-screen "Tasks & Targets" counts | `Home_Screen.dart` |
| `Target_details/Monthly_Tab/{Book_Rent,Live_Commercial,Monthly_LiveBuy,Monthly_LiveRent,Monthly_agreement_external}.dart` (field-worker side) + their `Monthly_under_detail/` counterparts | Drill-down detail screens for 5 of the Monthly target categories | Imported directly by `target_service.dart`, reached from both `target_and_tasks_home.dart` and `admin_target_and_tasks_home.dart` |
| `Adminisstrator_Target_details/Monthly_Tab/Monthly_police_verification.dart` (admin side) + its `Monthly_under_detail/Police_Monthly_Detail.dart` | Drill-down detail screen for the police-verification target category, used for **both** roles | Imported directly by `target_service.dart` |

### The Monthly-tab role asymmetry, explained

`target_service.dart` doesn't consistently pick "the field-worker copy" or "the admin copy" — it picks whichever one file happened to get wired up when the new system was built: the police-verification detail comes from the **admin** folder for everyone, while the other five categories (rent, commercial, buy, live-rent, agreement-external) come from the **field-worker** folder for everyone. That's a pre-existing quirk in how the new system was assembled (not something I introduced or need to fix), and it's the reason the "keep" list above splits unevenly between the two role-trees rather than keeping one whole tree and deleting the other.

---

## UNCERTAIN

Nothing landed here. Every file in the Calendar/Target/Task cluster resolved cleanly to either a confirmed-dead or confirmed-alive classification once the dead `SubAdminAccountant_Home.dart → Targets.dart` import edge was accounted for — there was no case where I couldn't trace a file's usage to a definite answer. The one partial-file case (`CalenderForAdmin.dart`) is called out above under SAFE TO DELETE with its own caveat rather than parked here, since I'm confident about *which* lines are dead, just not confident that a plain file delete is the correct mechanical action.

---

## What Phase 4 would look like, pending your approval

1. Delete the 2 old hub screens (`Targets.dart`, `Target_MainPage.dart`) and their exclusively-owned dependents (`OwnerCallsHistoryScreen.dart`, `Progressbar.dart`, `Target_Widget.dart`, `history_target.dart`, `history_detailpage.dart`).
2. Delete both `Yearly_Tab/` trees in full (20 files).
3. Delete the 12 now-orphaned Monthly-tab files (the field-worker police-verification pair + the 5 admin-side category duplicates and their 5 sub-details).
4. Extract `CalenderForAdmin.dart`'s 6 still-needed model classes into `shared_calendar_models.dart`, repoint `Home_Screen.dart`'s import, then delete the rest of `CalenderForAdmin.dart` (the dead screen + its 13 model classes).
5. Remove now-empty directories (`Target_details/Yearly_Tab/`, `Adminisstrator_Target_details/Yearly_Tab/`, and `Target_details/Yearly_Tab/Target_Under_Details_/`/`Adminisstrator_Target_details/Yearly_Tab/Target_Under_Details_/` if nothing else lands in them).
6. Re-run a full repo-wide grep for every deleted filename/class name afterward to confirm nothing was missed, and give you a `git diff --stat`.

No routes, no navigation entries, no menu/tab/drawer entries, no notification code, and no assets need touching — confirmed clean on all of those in this audit. I can't run `flutter analyze`/`pub get`/a real build here (no Dart SDK in this environment, same limitation as the general cleanup audit) — steps 12–15 in your instructions (analyze/pub get/build/fix) will need to happen on your machine after I apply the deletions; I'll get you as far as a clean, evidence-backed diff and then hand off for that verification.

Waiting for your go-ahead before touching anything.
