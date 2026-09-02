# CLAUDE.md — The Verify Field Worker

Architectural knowledge base for Claude Code sessions. Compiled from a full-repo
audit on 2026-09-01. Re-verify specifics before relying on them for anything
security-sensitive — this file describes the state found at that time.

## Project purpose

Flutter app (`com.verifyrealestate.fieldworker`, pubspec name `verify_feild_worker`,
v1.0.8+1) for a real-estate field-verification / property-management business.
Backed by a legacy PHP/ASMX server at `verifyrealestateandservices.in` (some
endpoints also hit `theverify.in`). Four roles share one codebase via
client-side branching: **FieldWorker, Sub Administrator, Administrator, Editor**
(role value literally comes from a field named `FAadharCard` in the API
response — a naming artifact, not an Aadhar card).

Major functional areas: rent agreements (new/renewal/commercial/external),
tenant demand tracking, property verification & document upload, insurance
quotations, targets (monthly/yearly, per role), accountant expense tracking,
calendar/visit scheduling, police verification, AI chat (Gemini), push
notifications with deep-linking.

## Folder / module architecture

`lib/` has **415 files** in ~40 feature folders, organized by *feature+role*
rather than by layer (no data/domain/presentation split — a screen owns its
own networking, parsing, and UI in one file). Notable folders:

- `lib/Administrator/`, `lib/Accountant/` — role-specific screens.
- `lib/Target_details/` vs `lib/Adminisstrator_Target_details/` (note the typo)
  — **near-duplicate trees**, same subfolders/filenames, ~587 of ~560 diff
  lines when compared — a bug fix here must currently be applied twice by hand.
  `CalenderForFieldWorker.dart`/`CalenderForAdmin.dart` follow the same
  duplicate-per-role pattern.
- `lib/Rent Agreement/Forms/` — the biggest files in the repo (`Agreement_Form.dart`
  4,568 lines, `External_Form.dart` 4,492, `Commercial_Form.dart` 4,294,
  `Renewal_form.dart` 4,054, `External_Commercial.dart` 3,992).
- `lib/Web_query/web_query.dart` (878 lines) — a screen+data mashup, **not**
  a real service layer despite the name.
- `lib/services/agreement_service.dart` — **empty stub (0 lines)**, dead file.
- `lib/model/` — 26 hand-written model classes, inconsistent conventions
  (see Models section).
- `lib/provider/` — a handful of `ChangeNotifier` classes (Theme, Property,
  PropertyId, MultiImageUpload, RealEstateShowData).
- `lib/Controller/` — a couple of GetX `GetxController` classes (e.g.
  `Show_demand_control.dart`); mostly vestigial, see State management.
- `lib/Custom_Widget/`, `lib/ui_decoration_tools/` — ~15 shared-widget files
  vs 300+ screens; reuse is thin. Confirmed byte-identical duplicate files
  from editor "keep both" copies still committed: `FieldWorker_Complete_Page.dart`
  / `FieldWorker_Complete_Page 2.dart`, `Yearly_Target 2.dart`,
  `FieldWorker_Booking_Page_Details 2.dart`, `Book_Flat_For_FieldWorker 2.dart`,
  `FieldWorker_Complete_Detail_Page 2.dart`. `old_future_detailpage.dart`
  (4,970 lines) is explicitly legacy/dead code still shipping in the tree.
- Five directories contain **spaces in their names** — fragile for imports/
  tooling: `lib/Rent Agreement`, `lib/Paid Visit`,
  `lib/Accountant/Company expense`, `lib/Accountant/Salaray expense`
  (also misspelled), `lib/Administrator/Admin_future _property` (stray
  mid-word space).
- Repo also has **8,485 committed `__MACOSX/` files** (a zip-extraction
  artifact, including a stray resource-fork copy of `google-services.json`)
  bloating `.git` to ~90MB. Pure junk, unrelated to app code.

## Authentication & authorization flow

**There is no real session/token system.**

- Login screen: `lib/Z-Screen/Login_page.dart`. Sends an **HTTP GET** to
  `Login_Api_Field_application.php` with phone number, password, and FCM
  token as **URL query parameters** — password travels in the query string
  (server/proxy access-log exposure risk even over HTTPS).
- On success, only plain identity fields are cached in `SharedPreferences`
  (unencrypted): `id`, `name`, `number`, `post` (role — reused from the
  `FAadharCard` field), `location`, `fcmToken`. **No auth token or session id
  is ever issued by the backend.**
- App relaunch / "session restore": `lib/Z-Screen/splash.dart` re-fetches the
  user by re-sending the cached phone `number` to an **unauthenticated GET**
  (`home_screen.php?FNumber=...`). Password is never re-checked. Anyone who
  can write that one SharedPreferences key (rooted/jailbroken device, backup
  extraction) can impersonate any account.
- Role-based navigation is decided purely client-side from the cached role
  string (`Login_page.dart`, `splash.dart`) — since there's no verifiable
  server session, **role gating is UI-only**; nothing stops a modified client
  from calling "admin" endpoints directly.
- No logout/token invalidation mechanism exists. Account status
  (Pending/Approved/Rejected) is the only server-side gate, also checked
  client-side.
- No `Authorization`/`Bearer` header pattern anywhere in the codebase (grep
  confirmed zero matches) — every later API call re-identifies the user via
  plain `FNumber`/id query params, not a validated token.

## API / WebService architecture

**No centralized API client exists.** ~270-310 files make raw `http.get`/
`http.post` or ad-hoc `Dio()` calls directly inline in screen/state classes.
Two networking stacks coexist: `http` package (majority, ~289 files) and
`dio` (minority, ~27 files) — no shared instance, no interceptors.

- Base URLs are hardcoded string literals scattered through screens, e.g.
  `https://verifyrealestateandservices.in/...` and `https://theverify.in/...`
  — despite `flutter_dotenv` being a dependency, it is **not** used for API
  base URLs (only currently holds an unused Maps key, see Security section).
- Backend is a mix of legacy `.asmx` (SOAP-ish) and `.php` endpoints.
- Error handling is inconsistent file-to-file and even within the same file:
  some calls use `.timeout(10s)` + `TimeoutException` handling +
  network-error string sniffing (`web_query.dart`'s `fetchQueries()` is the
  best example — maps failures to a `"NO_INTERNET"` sentinel); others
  (`metro_api.dart`, several calls inside `Home_Screen.dart`) have no timeout
  at all and only a generic `catch (e)`.
- At least two files (`Add_plot_property.dart:473`, `Edit_Plot.dart:480`)
  call a **literal placeholder URL** `https://your-api.com/plots` — dead/
  unfinished code shipping in the tree.
- Notification-triggered navigation (`lib/main.dart`, `_openNotificationPage`,
  ~550 lines) maps ~25 FCM `type` strings to route pushes via a long if/else
  chain with no shared enum/constants — already shows key-casing drift
  (`P_id`/`p_id` mismatches).

## Models & data flow

`lib/model/` (26 files): all hand-written `fromJson`, **no `toJson`**
(no round-trip serialization), **no use of `equatable`** despite it being a
pubspec dependency (dead dependency — zero files `extends Equatable`).
Null-safety discipline is inconsistent between files — e.g. `user_model.dart`
reads fields with no null-check/cast (throws on unexpected null/non-string),
while `demand_model.dart` defensively uses `?.toString() ?? ''` and
`int.tryParse(...) ?? 0` throughout. Treat every model as a potential runtime
crash source when the API shape drifts; check the specific model's parsing
style before assuming it's safe.

## State management

**Three paradigms coexist**, unevenly:
- `StatefulWidget` + `setState` — dominant, ~240-314 files, ~2,100 `setState`
  calls.
- `provider` (`ChangeNotifier`) — small set of app-wide concerns (theme,
  property/image upload state) wired via `MultiProvider` in `main.dart`.
- `get` (GetX) — a pubspec dependency but only touched in ~6 files; **no
  `GetMaterialApp`, no app-wide bindings** — effectively vestigial/leftover
  from a partial, abandoned migration. One orphaned `Bindings` subclass
  (`lib/Controller/Show_demand_binding.dart`) has nothing to bind to.
- **7 files mix `setState` with GetX/Provider/ChangeNotifier in the same
  file**: `main.dart`, `Future_Property_OwnerDetails_section/Update_future_building.dart`,
  `Home_Screen_click/Add_New_Property.dart`, `Home_Screen_click/Update_realEstate_form.dart`,
  `Upcoming/add_coming_flats.dart`, `Upcoming/Upcoming_update.dart`,
  `Upcoming/update_form.dart`. Any change in these needs extra care about
  which mechanism actually triggers the rebuild you're editing.

When adding new state, prefer `provider` (already the app-root DI mechanism)
over introducing more GetX or raw `setState` — don't add a 4th paradigm.

## Local storage / session behavior

`SharedPreferences.getInstance()` is called directly in **~164 files** — no
wrapper/service class exists; every screen manages its own ad hoc key
read/write. No `flutter_secure_storage` anywhere in the app. All cached
identity/session data (see Auth section) is plaintext. Before adding a new
persisted value, check whether an existing screen already uses the same key
name (no central registry of keys — collisions are possible and unaudited).

## Navigation structure

Plain Flutter `Navigator`, **not** GetX, despite `get` being a dependency.
Named routes are registered in `lib/Notification_demo/routes.dart` and used
via `MaterialApp(routes: Routes.routes, initialRoute: Splash.route)` in
`main.dart`. ~289 files also use raw `Navigator.push`/`MaterialPageRoute`
directly instead of named routes — inconsistent, but Navigator-based
throughout (only 2 files use `Get.to`/`Get.off`, an outlier, not a second
real pattern).

Deep-linking uses **Firebase Dynamic Links** (`_initDynamicLinks`/
`_handleDeepLink` in `main.dart`) — this Firebase product was deprecated/
shut down by Google (Aug 2025); treat this as a ticking breakage risk that
needs a replacement (e.g. Firebase App Links / a custom domain scheme) before
it stops working, if it hasn't already.

No top-level `FlutterError.onError` handler; only `runZonedGuarded` catches
async-zone errors, and its debug print is gated behind `kDebugMode` — release
crashes are currently silent with no crash reporting (no Crashlytics/Sentry
wiring found).

## Android / iOS configuration

- Android `applicationId=com.verifyrealestate.fieldworker`,
  `compileSdk`/`targetSdk` = 36.
- Manifest permissions (INTERNET, LOCATION, CALL_PHONE, POST_NOTIFICATIONS,
  VIBRATE, BOOT_COMPLETED) are reasonably matched to the app's stated purpose
  — not flagged as over-broad.
- Release signing is correctly configured via `android/key.properties` →
  a `.jks` keystore, and both are properly `.gitignore`d — this part is done
  right, unlike the `.env` handling (see Security).
- `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) *are*
  committed to git (normal for Firebase, not a secret leak in the same sense
  as an API key, but worth knowing they're there).
- No CI configuration found. No real test suite — only the default
  `test/widget_test.dart` stub.

## Build / deployment

- `pubspec.yaml` version `1.0.8+1`; bump both version and build number per
  the usual Flutter convention when releasing.
- `flutter_launcher_icons` is configured (both platforms) off
  `assets/images/Verify Field Logo.png`.
- No automated release pipeline observed — assume manual builds until told
  otherwise.

## Known security issues (as of 2026-09-01 audit — verify current status before assuming still open)

1. **No real auth/session token model** — see Authentication section. The
   entire "session" is a cached phone number, re-validated with no password
   check and no server-side session/JWT. This is the most serious issue in
   the app.
2. **Login sends the password as a URL query parameter** over `http.get`
   (`Login_page.dart`).
3. **Hardcoded, live API keys committed to git**:
   - A Google Generative Language (Gemini) key hardcoded in
     `lib/main.dart` and twice in `lib/Gemini_AI/Demo_chat.dart` (plus a
     third, commented-out occurrence). Runs unconditionally on every app
     launch via `main.dart`.
   - A Google Maps API key committed in a tracked `.env` file at repo root
     (`.env` has no `.gitignore` entry). This key appears to be **orphaned**
     — no code path in `lib/`, the Android manifest, or iOS config actually
     consumes it (`google_maps_flutter` is a pubspec dependency but unused
     in source).
   - `git log --all -S "AIzaSy"` found **4 distinct key values** across 8
     commits in history — more than the 2 currently visible at HEAD. Any
     rotation/cleanup effort must treat the full history as compromised, not
     just current files.
   - A remediation plan (rotate both, move to build-time injection or a
     backend proxy for Gemini, purge `.env` + these lines from git history
     with `git filter-repo`, fix `.gitignore`) was proposed to the user on
     2026-09-01 but **not yet executed** — check current repo state before
     assuming this is still true.
4. Plaintext, unencrypted session/identity data in SharedPreferences (see
   Local storage section).

## Known technical debt / risky areas

- **No centralized API client** — a base-URL, auth-header, or cert-pinning
  change requires touching hundreds of files individually.
- **Duplicate feature trees** (Target_details/Adminisstrator_Target_details,
  Calendar Field Worker/Admin) — changes must be hand-mirrored across
  copies; a prime source of role-specific bugs from drift.
- **Monolithic "god files"** — several 3,000-5,300 line single-file screens
  mixing UI, validation, and networking (see Folder architecture section);
  high regression risk, effectively unreviewable/untestable as-is.
- Deprecated API usage at scale: `.withOpacity(` used **2,172 times**
  (should migrate to `.withValues()`); `WillPopScope` (should be `PopScope`)
  used 5 times.
- ~932 force-unwrap (`!.`) occurrences and ~778 unsafe `as` casts, combined
  with near-zero test coverage — each is a latent crash site if an API
  response or object shape doesn't match expectations.
- 1,290 `print`/`debugPrint` calls, mostly routed through a custom
  `lib/AppLogger.dart` wrapper (a reasonable pattern) — but the volume
  warrants a pass for accidentally-logged sensitive data (raw HTTP bodies,
  phone numbers) before any release, since `Login_page.dart` was found
  logging a full raw response including the password-echoing request when
  `AppLogger.enableDebugLogs` is true.
- `Image.network(` used raw in ~190 places vs `CachedNetworkImage` in only
  ~109, despite `cached_network_image` being a dependency — most network
  images bypass caching.
- Zero test coverage across a 415-file, 4-role production app.

## Conventions & dependencies worth knowing

- Multi-developer history: commits attributed to pawan, Gurdeep, lokesh —
  expect inconsistent per-file conventions since there's no enforced style
  guide/lint discipline beyond default `flutter_lints`.
- `equatable` and most of `get` (GetX) are effectively dead/unused
  dependencies — don't assume their presence in `pubspec.yaml` means they're
  the app's actual pattern; check the specific file.
- `flutter_dotenv` is a dependency but currently underused — only backs the
  orphaned Maps key, not API base URLs or the Gemini key (which are
  hardcoded instead).
- Firebase is used for: Cloud Messaging (push notifications, with a
  ~550-line manual routing table in `main.dart`), Dynamic Links (deprecated,
  see Navigation section), and Core/app config.
- When editing any screen, check whether it has a same-named counterpart in
  a parallel role-specific folder (Administrator/ vs plain, Adminisstrator_*
  vs Target_details, etc.) before assuming a fix in one place is complete.

## Session notes for future Claude Code work here

- Full 6-part subsystem audit (navigation, auth, API layer, models/state/
  storage, Android/iOS config, duplicate/risky-code scan) was completed
  2026-09-01; this file is the synthesis. If asked to "re-analyze the whole
  project," check this file is current before re-doing the full sweep.
- Do not assume any of the "known issues" above are fixed without checking
  current file contents/git status — this document reflects a point-in-time
  audit, not a live monitor.
