# Verify Field — Task Management: Business & Architecture Analysis

**Prepared for:** Verify Real Estate
**Subject app:** Verify Field (`The_verify_field`, package `com.verifyrealestate.fieldworker`, v1.0.8+1)
**Method:** Direct source review of the live repository (`lib/Calender/`, `lib/Tenant_Details_Demand/`, `lib/Demand_2/`, `lib/Administrator/`, `lib/Home_Screen.dart`, and the checked-in architecture audit `CLAUDE.md`), cross-checked against prior project memory.
**Date:** 2026-09-17

---

## 0. Key Finding Up Front

**There is no dedicated "Task" or "To-Do" module, model, or database table in this app.** Grepping the entire `lib/` tree turns up zero `Task` model class, zero `ToDo` folder, and zero generic task CRUD API. What both roles experience *as* a to-do list is actually an aggregation layer — the **Calendar** screen — that fans out to roughly ten unrelated feature APIs (agreements, tenant demand, property visits, building follow-ups, website visits) and renders their results as if they were one unified task feed. Each underlying "task type" has its own data model, its own status vocabulary, and its own PHP/ASMX endpoint family, hand-duplicated once for the field-worker view and once for the admin view.

This is stated explicitly because it changes what "how are tasks created/assigned/tracked" means in this app: there is no single answer — there are seven or eight different answers, one per feature, that happen to converge visually on one calendar screen. The rest of this report documents that reality rather than an idealized task system, and flags in each section where I'm describing the general pattern versus where I traced one concrete, representative flow (Tenant Demand) end-to-end in the code.

---

## 1. Application Structure

### 1.1 Overall architecture
- Flutter client (`lib/`, ~415 files) talking to a legacy PHP/ASMX backend at `verifyrealestateandservices.in` (older endpoints) and `theverify.in` (newer). No centralized API client — individual screens make raw `http.get`/`http.post` calls inline.
- Organized by **feature + role**, not by architectural layer: a screen file typically owns its own networking, JSON parsing, and UI together. There is no data/domain/presentation split.
- Four roles share one codebase via client-side branching: **FieldWorker, Sub Administrator, Administrator, Editor.** Role is decided entirely from a cached string on the device (no server-issued session token — see `CLAUDE.md` Auth section for the full detail); this matters for task management because **role-based task visibility is enforced only by which query parameters a screen happens to send, not by any server-side authorization check.**

### 1.2 Modules relevant to task management
| Module | Role | What it actually is |
|---|---|---|
| `lib/Calender/CalenderForFieldWorker.dart` (5,316 lines) | Field Worker | The field worker's day view / task feed. Fans out ~10 API calls per selected date. |
| `lib/Calender/CalenderForAdmin.dart` (3,814 lines) | Admin | Near-duplicate of the above, same endpoint family, org-wide instead of per-worker. |
| `lib/Tenant_Details_Demand/` | Both | The clearest example of a full task lifecycle (assign → view → act → feedback). Used as the worked example below. |
| `lib/Demand_2/` | Both | A second, largely parallel tenant-demand/lead pipeline (see project memory: "two parallel status systems" for demand tracking — not fully reconciled with `Tenant_Details_Demand/`). |
| `lib/Administrator/Add_Assign_Tenant_Demand/` | Admin | Admin-side task/lead creation and assignment screens. |
| `lib/Home_Screen.dart` / `lib/Administrator/Administrator_HomeScreen.dart` | Both | Dashboard entry points; surface counts and shortcuts into the individual feature screens (agreements, verification, targets) rather than a task list themselves. |
| `lib/Target_details/` vs `lib/Adminisstrator_Target_details/` | Both | Not tasks per se, but the quota/performance layer tasks are measured against (see §3.4). |
| `lib/Notification_demo/routes.dart`, `lib/main.dart` (`_openNotificationPage`) | Both | Push-notification deep-linking; the closest thing to a "you have a new task" alert (see §5). |

### 1.3 Absence of a real backend task model
There is no `tasks` concept server-side either, as far as the client code reveals: every "task type" hits its own endpoint family (`task_for_agreement_on_date.php`, `task_for_building.php`, `pending_agreement_task.php`, `tenant_demand_for_field_task.php`, `live_property_task_for_fieldworkar.php`, `book_visit_in_tenant_demand_for_fields.php`, `upcoming_flat_for_fieldworkar.php`, `building_calling_reminder.php`, plus the older `WebService4.asmx` tenant-demand assignment endpoints). These are confirmed by direct code read of `_fetchData()` in `CalenderForFieldWorker.dart` (lines ~2601–2650). Each returns a different JSON shape, parsed by a different hand-written model class in the same file.

**Assumption stated explicitly:** I inferred there is no shared backend "tasks" table from the fact that the client never calls one generic endpoint for task data — it always calls a feature-specific one. I did not have direct access to the PHP server code, so this is an inference from client behavior, not a server-side confirmation.

---

## 2. Task Management Logic

Since there's no unified system, this section describes the **common pattern** shared by the per-feature task types, then the **one exception that matters** (Tenant Demand, which does have an explicit multi-state lifecycle and is the closest thing to a "real" task object in the codebase).

### 2.1 The common pattern (Agreements, Buildings, Website Visits, Live Property, Upcoming Flats)
- **Creation:** implicit. A "task" of this kind isn't created as a task — it's created as a side effect of the underlying business record. E.g., a rent agreement task exists on the calendar because an `Agreement` row has a relevant date field (renewal date, next-calling date); a "building" task exists because a property record has a follow-up/calling date attached. There is no admin screen titled "Create Task" for these.
- **Assignment:** implicit via a stored field-worker identifier on the underlying record (e.g., the agreement or property row already has a `field_workar_number`/`field_warkar_name` attached from whenever that record was originally created or last touched). Reassignment, where possible, happens by editing the underlying business record, not through a task-reassignment UI.
- **Tracking / visibility:** query-parameter scoping only. The field worker's calendar appends `&Fieldwarkarnumber=<their number>` to each of the ~10 calls; the admin calendar omits it and gets everyone's tasks for that date, org-wide (confirmed directly in code — `CalenderForAdmin.dart` calls the identical endpoints without the field-worker parameter). This is a client-side filter, not a server-enforced one.
- **Update / completion:** varies by feature, and in several cases there is **no explicit "mark complete" action on the calendar card itself** — tapping a card navigates (`Navigator.push`) into that feature's own detail screen (agreement detail, property verification detail, etc.), and whatever status change happens there is what "completes" the task. The calendar itself is read-mostly; one card type infers completion purely from whether a text field is non-empty (`isCompleted = reason.isNotEmpty`, confirmed at two locations in `CalenderForFieldWorker.dart`), which is a heuristic, not a status flag.
- **Status vocabulary observed in UI code:** `Pending`, `Active`, `Completed`, `Cancelled` (from `_getStatusColor()`), but this switch statement is generic UI coloring — not every task type actually flows through all four states; some (like the reason-based one above) never reach a real "Completed" status field at all.

### 2.2 The one fully-traceable lifecycle: Tenant Demand assignment
This is the clearest, most literal "task" object in the app, and it's worth walking through because it's the pattern most likely to generalize if this system is ever consolidated:

1. **Creation + Assignment (Admin):** `lib/Tenant_Details_Demand/Assigned_Tenant_Demand.dart` calls `WebService4.asmx/add_assign_tenant_demand_` with the field worker's name/number, the demand's name/number, BHK, date/time, and `looking_type=Pending`. This single call both creates the assignment record and assigns it — there's no separate "assign later" step in this flow.
2. **Retrieval (Field Worker):** the worker's screen (`Feild_Accpte_TenantDemand.dart`) fetches their queue via `WebService4.asmx/display_assign_tenant_demand_by_feild_num_looking_location_?fieldworkar_number=...&looking_type=Pending` (and a second bucket, `looking_type=Re_Demand`, for demands re-opened after feedback).
3. **Retrieval (Admin, monitoring):** `Administater_TenanDemand.dart` calls the *same* endpoint family but by `looking_type` + `location_` only (`display_assign_tenant_demand_by_looking_type_location_`) — org-wide for that location, not scoped to one worker. Same backend concept, filtered differently per role — the same duplicate-tree pattern flagged architecturally elsewhere in this codebase.
4. **Action (Field Worker):** the worker can call or WhatsApp the demand's contact number directly from the card (`tel:`/`wa.me` deep links), then opens a feedback bottom sheet.
5. **Update (Field Worker):** submitting feedback calls `WebService4.asmx/update_assign_tenant_demand_by_id_looking_feedback_?id=...&looking_type=Pending&feedback=<text>` — confirmed directly in code that the field worker's own feedback submission re-flags the record as `Pending` (not `Completed`), attaching only free-text feedback. There is no field-worker-facing "mark as done" action in this file; closing the loop appears to depend on an admin or a separate downstream process reading that feedback, not a status the field worker sets themselves.
6. **Deletion:** a `Delete_assign_tenant_demand_` endpoint exists but is commented out in the active code path — dead/unreachable, not part of the live workflow.

**Assumption stated explicitly:** I could not find, in the field-worker-facing files reviewed, any call that sets `looking_type` to something like `Completed` or `Accepted` for this flow. It's possible that transition exists in a file I didn't open (the demand pipeline has a second largely-parallel implementation in `lib/Demand_2/`, per prior project-memory notes, which I did not fully re-trace here), or that "completion" for this record type is actually a manual admin action taken outside the app. Treat "field workers can't self-close a tenant-demand task" as a finding to verify with the team, not a certainty.

### 2.3 Targets as a proxy for "task" completion tracking
There's no task-completion dashboard as such, but there is a quota/target system (`Target_details/` for field workers, `Adminisstrator_Target_details/` for admins) that counts completed agreements, police verifications, and buildings per period against hardcoded monthly/yearly numbers (e.g., monthly Agreement target = 20, Police Verification = 20). This is the closest thing to "did the field worker do their work," but per prior project-memory findings it is a **hardcoded Dart constant, not an admin-configurable setting**, and the admin target screen loops over a **hardcoded 4-person roster** rather than the live worker list — so it will silently omit anyone added to the team after that list was written.

---

## 3. Workflow for Field Workers (step-by-step)

1. **Log in.** Phone number + password via `Login_page.dart` (note: this app has no real session/token system — every subsequent screen re-identifies the worker by their cached phone number, not a validated session; not itself a task-management concern, but it's why every task query below is scoped by a plain, client-supplied phone number rather than a verified identity).
2. **Land on the Home Screen** (`Home_Screen.dart`). This surfaces feature shortcuts and counts (agreements, verifications, targets) — it is a launcher into the feature areas, not a task inbox itself.
3. **Get notified of new work**, in one of two ways:
   - A **push notification** (Firebase Cloud Messaging) for certain event types — routed by `main.dart`'s `_openNotificationPage`, which maps the notification's `type` string to a specific screen. (Not every task type has a corresponding push type; this is confirmed only for the ~25 `type` strings that exist in that routing table.)
   - Simply **opening the Calendar** (`CalenderForFieldWorker.dart`) and picking a date — this is the primary discovery mechanism, since it actively re-pulls all ~10 task-type feeds for whatever date is selected, scoped to the logged-in worker's phone number.
4. **Review the day's items.** Each card type (agreement follow-up, building call-back, tenant-demand visit, live-property task, website visit, upcoming-flat availability) renders with its own layout, since each comes from a different endpoint/model, not a shared "Task" widget.
5. **Act on an item**, typically one of:
   - Tap-to-call or tap-to-WhatsApp the contact directly from the card (deep links, no in-app call logging beyond whatever the destination screen records).
   - Tap into the card to navigate to that feature's own detail/action screen (e.g., agreement details, property verification form) — this is where the substantive work (uploading documents, recording a visit outcome, editing a record) actually happens; the calendar card itself is a launcher.
6. **Submit an outcome**, where the feature supports it. In the traced Tenant Demand flow, this means opening a feedback bottom sheet and submitting free text, which re-flags the item (observed as staying in `Pending`, not moving to a worker-set `Completed` state — see §2.2, item 5).
7. **Get measured**, separately, against the hardcoded monthly/yearly targets screen — this is a self-service progress view, not something the day's task list feeds into automatically in an obvious way from the code reviewed.

**Assumption:** step 3's "how a worker actually learns about a brand-new tenant-demand assignment" is not fully confirmed — I found no push-notification `type` in `main.dart` that obviously corresponds to "new tenant demand assigned to you." It's plausible workers simply check the calendar/queue screens periodically rather than being proactively alerted for every task type. Flagging this as worth confirming with the team, since it affects how reliable "assignment" actually is in practice.

---

## 4. Workflow for Admins (step-by-step)

1. **Log in** as Administrator or Sub Administrator (same login screen, role read from the cached `post`/`FAadharCard` field).
2. **Land on the Admin Home Screen** (`Administrator_HomeScreen.dart`) — again a launcher/dashboard, with its own task-related endpoints for the day's agreement and building tasks org-wide (`task_agreement_for_admin.php`, `task_building_for_admin.php`), plus a link into `CalendarTaskPageForAdmin`.
3. **Create/assign work**, using feature-specific screens rather than a general "assign task" tool:
   - For tenant demand specifically, `Assigned_Tenant_Demand.dart` lets the admin pick a field worker and submit the demand details in one call — creation and assignment are the same action here (§2.2, step 1).
   - For other task types (agreement follow-ups, building call-backs), assignment is implicit in whichever record the admin edits — there's no dedicated "assign this to a worker" screen found for those; the field-worker identifier appears to be set when the underlying property/agreement record itself is created or edited.
4. **Monitor org-wide**, via the Admin Calendar (`CalenderForAdmin.dart`) — same ~10 endpoint calls as the field-worker view, but without the per-worker filter, so it returns everyone's items for the selected date. This is the primary oversight mechanism for "what's happening today across the team."
5. **Review a specific pipeline's queue**, e.g. `Administater_TenanDemand.dart` for tenant demand, filtered by `looking_type` (Pending / Re_Demand) and location rather than by individual worker — so an admin sees "all pending demands in Sultanpur," not "all of Ravi's open tasks," from this particular screen.
6. **Check performance against targets**, via `Adminisstrator_Target_details/`, which mirrors the field-worker target screen but for the org (or for the admin's own location, filtered against that hardcoded 4-person roster noted in §2.3).
7. **Handle exceptions**, e.g. `Show_Unexpected_Demand.dart` under `Add_Assign_Tenant_Demand/` — a screen specifically for demand records that don't fit the normal assignment flow (naming suggests an escape hatch for anomalous/unassigned leads, not fully traced in this pass).

**Assumption:** I did not find a single "admin dashboard" screen that lists every open task across every task type in one place — admins appear to monitor per-feature (agreements here, tenant demand there, buildings elsewhere), the same way field workers do, just with the org-wide filter instead of the self filter. If a unified admin oversight view exists, it wasn't located in the files reviewed for this analysis.

---

## 5. Interactions and Dependencies Between the Two Roles

- **Shared endpoints, different filters.** Every task-type pairing found (Calendar, Tenant Demand, Targets) uses the *identical* backend endpoint family for both roles, distinguished only by which query parameter the client happens to send (a worker's own number vs. nothing/location). This means the two roles' views are tightly coupled at the API level — a backend change to one of these ~10+ endpoints affects both role trees simultaneously, and because the Dart code for each role lives in a separately duplicated file, a bug fix or feature change on one side does not automatically apply to the other (this duplicate-tree risk is already flagged architecturally in `CLAUDE.md` for Calendar and Targets specifically).
- **One-directional assignment, two-directional visibility.** Assignment (who is responsible for a task) flows from Admin → Field Worker in the one fully-traced example (Tenant Demand). Visibility into task state flows both ways: the field worker sees their own scoped queue, the admin sees everyone's.
- **Feedback loop is asymmetric.** In the traced example, the field worker can attach feedback text but the code found doesn't show them setting a terminal "Completed" status themselves — closing the loop looks like it depends on an admin-side action or a downstream process not covered in the files reviewed. This is a meaningful dependency: if that's accurate, admins are a required step in completing at least this task type, not just an optional overseer.
- **No server-enforced boundary between the two roles' task data.** Because there's no auth token and role gating is client-side only (per `CLAUDE.md`'s Authentication section), the separation between "my tasks" and "everyone's tasks" is only as strong as which URL parameters a given screen sends — worth knowing if this is ever extended to more sensitive task data.
- **Targets create an indirect dependency.** Field workers are measured against quotas that are hardcoded per role tree; if an admin's copy of a target constant drifts from the field worker's copy (per the duplicate-tree pattern), the two roles could literally see different quota numbers for the same job without any code change being deliberately made to cause that.

---

## 6. Summary of Assumptions and Open Questions

Stated together here for visibility:

1. No server-side generic "tasks" table was directly observed — inferred from client behavior (always feature-specific endpoints), not confirmed against backend code.
2. Field-worker self-completion for the Tenant Demand flow was not found in the files reviewed — it's possible it exists in `lib/Demand_2/`'s parallel implementation or elsewhere, which was not fully re-traced in this pass.
3. No push-notification type was identified that clearly corresponds to "new task assigned to you" for every task category — confirmed only for the ~25 types already documented in `main.dart`'s routing table.
4. No single unified admin "all open tasks" dashboard was found — admin oversight appears to be per-feature, same as the field-worker experience, just org-wide instead of self-scoped.
5. `Show_Unexpected_Demand.dart`'s exact role in the assignment workflow was not traced in depth.

---

## 7. Notable Improvement Opportunities (bonus, not requested but relevant to "improvement" framing)

- **Consolidate the ~10 per-day task-type endpoints behind one real task feed**, even if the underlying business tables stay separate — would remove the current per-feature duplication of fetch/parse/render logic across two role trees.
- **Make target quotas backend-configurable** and drive the admin roster from a live worker list instead of a hardcoded 4-person array — flagged previously as a silent-failure risk for onboarding.
- **Give field workers an explicit terminal status action** (e.g., a real "Completed" button) for task types where completion currently has to be inferred (empty/non-empty text fields) or appears to depend on an admin closing the loop.
- **Server-side role enforcement** for task visibility, since the admin/worker split for task data is currently a client-side filter only.

---

*This report reflects a source-code-level review completed 2026-09-17. It is a snapshot, not a live monitor — re-verify specific file/line claims against the current repository before relying on them for implementation work, consistent with the standing note in `CLAUDE.md`.*
