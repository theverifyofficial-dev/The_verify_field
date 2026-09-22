# The Verify Field — Safe Cleanup Audit (Phase 1–3)

Date: 2026-09-22
Scope: full-repo static audit (no Flutter/Dart SDK available in this session — nothing below was compiled; every finding is grep/graph evidence, not a build result).
Builds on the prior full-repo audit in `CLAUDE.md` (2026-09-01); every item below was re-verified against the current tree, since ~3 weeks of new work has landed since that document was written.

**No files have been changed. This is the audit only — nothing is deleted until you approve.**

## Method

- Built a real import/export dependency graph for all 429 `lib/**/*.dart` files (resolving both relative imports and `package:verify_feild_worker/...` imports), then did a BFS from `lib/main.dart` to find every file genuinely unreachable from the app's entry point.
- Cross-checked every deletion candidate with `grep -r` across the *entire* repo (not just `lib/`) for its filename, class names, and any string-based reference, per the project's standing rule to prove non-usage before removing anything.
- Cross-checked `pubspec.yaml` dependencies against actual `package:<name>/` imports in `lib/`.
- Cross-checked `assets/images/*` filenames against every `.dart`, `.yaml`, `.xml`, and `.plist` file in the repo (so an image only used from Android/iOS config, not Dart, still counts as used).

---

## SAFE TO REMOVE

| Item | Why unused | Evidence |
|---|---|---|
| `lib/services/agreement_service.dart` | Empty stub — only content is `// TODO Implement this library.` | Zero files reference `agreement_service` anywhere in the repo. Already flagged dead in the 09-01 audit; still true. |
| `lib/Future_Property_OwnerDetails_section/old_future_detailpage.dart` (4,970 lines) | Explicitly legacy screen, superseded by `Future_property_details.dart` | Zero files import it. Not reachable from `main.dart` in the full import graph. |
| `lib/Add_Rented_Flat_New/FieldWorker_Complete_Page 2.dart` | Editor "keep both" duplicate of `FieldWorker_Complete_Page.dart` (same class `FieldWorkerCompleteFlats`) | Zero files import the " 2" filename; the real file is imported from 6 other screens. |
| `lib/Add_Rented_Flat_New/FieldWorker_Booking_Page_Details 2.dart` | Duplicate of `FieldWorker_Booking_Page_Details.dart` (same class `PropertyDetailPage`) | Zero references to the " 2" filename anywhere. |
| `lib/Add_Rented_Flat_New/Book_Flat_For_FieldWorker 2.dart` | Byte-identical duplicate of `Book_Flat_For_FieldWorker.dart` (same class `RentedPropertyPage`) | Zero references; `diff` shows 0 lines difference from the original. |
| `lib/Add_Rented_Flat_New/FieldWorker_Complete_Detail_Page 2.dart` | Duplicate of `FieldWorker_Complete_Detail_Page.dart` (same class `PropertyCompleteDetailPage`) | Zero references to the " 2" filename anywhere. |
| `lib/Yearly_Target 2.dart` | Orphaned duplicate — there is no `Yearly_Target.dart` original at all anymore | Its class `Target_Yearly`/`TargetYearlyResult` is not referenced by any other file. Not reachable from `main.dart`. |
| `git` (0-byte file at repo root) | Stray empty file, not a real git artifact, not referenced by any build config | `file` reports it empty; nothing reads it. |
| `__MACOSX/` (8,485 tracked files, ~34MB, includes a stray resource-fork copy of `google-services.json`) | Pure zip-extraction junk (macOS "keep both" resource-fork folder), unrelated to app code, bloats `.git` by tens of MB | Confirmed still fully present and tracked; nothing in `lib/`, Android, or iOS config reads from `__MACOSX/`. |
| `equatable: ^2.0.7` (pubspec dependency) | Zero files `extends Equatable` or import `package:equatable` | Confirmed via repo-wide grep — conclusively unused, matches special-rule carve-out for removing a dependency only when conclusively unused. |
| `google_maps_flutter: ^2.2.3` (pubspec dependency) | No `GoogleMap(` widget, no `GoogleMapController`, no import anywhere in `lib/`; not referenced in Android/iOS manifest either | Re-confirmed (09-01 audit already flagged this as unused). |
| `flutter_dotenv: ^6.0.0` (pubspec dependency) | Zero `dotenv.` calls or `package:flutter_dotenv` imports anywhere in `lib/` — the `.env` file it would read is never actually loaded by code | Confirmed via grep; the Maps API key sitting in `.env` is not consumed by this package or by native config. |

## SAFE TO CLEAN

| Item | What can be cleaned | Why it's safe |
|---|---|---|
| Bare `print()` / `debugPrint()` calls not routed through `AppLogger` — **1,167 occurrences**, heavily concentrated in a subset of files (e.g. `Duplicate_Property.dart` alone has 15 emoji-tagged ad-hoc debug prints like `print("🚀 duplicateFlatSubmit() CALLED")`) | Delete the print statements (or route through the existing `AppLogger` wrapper if you want to keep some for real diagnostics) | These are plain console output with no return value and no other code depends on their side effects; removing them changes nothing but log noise. **Given the volume (1,167 lines across many files), I'd recommend doing this as its own separate, scoped pass rather than folding it into this cleanup** — a diff that size deserves its own review, and it's easy to accidentally delete a line that's actually doing something (a few of these prints sit next to, not instead of, real logic). |
| `Claude outputs/*.md` (2 tracked analysis docs from a previous session) | Not code — could be moved out of the git-tracked repo into a local notes folder if you don't want them versioned with the app | Not a functional risk either way; flagging as a judgment call, not a defect. |

## NEEDS REVIEW

| Item | Why uncertain | What could break if removed |
|---|---|---|
| 45 files under `assets/images/` that never appear as a literal filename anywhere in `.dart`, `.yaml`, `.xml`, or `.plist` (full list in Appendix A) — e.g. `bg.png`, `about.png`, `logo_again.png`, `your_background_image.jpg`, `V.png`, and 40 others | Flutter apps often build asset paths dynamically (string interpolation, a constants class computed at runtime) which a text search can miss; the special rule explicitly calls out "assets referenced indirectly" as something to prove, not assume | Deleting an image that's actually built from a dynamic path would produce a broken image icon in production with no compile-time warning |
| ~28 other pubspec dependencies with no direct `package:<name>/` import found (full list in Appendix B) | Some packages (e.g. `cupertino_icons`) are legitimately used without ever appearing as a literal import string, and I have not individually verified all 28 the way I verified `equatable`/`google_maps_flutter`/`flutter_dotenv` | Removing a dependency that's actually wired in (even indirectly) breaks the build immediately — this bucket needs a one-by-one check, not a batch removal |
| `get: ^4.6.5` (GetX) — actively used in exactly 6 files (`Show_TenantDemands.dart`, `Feild_Accpte_TenantDemand2.dart`, `pending_tenant_control.dart`, `Show_demand_binding.dart`, `Show_demand_control.dart`, `Admin_profile.dart`) | Not unused — it's a real, working (if narrow and "vestigial" per the architecture notes) pattern. This is a technical-debt observation, not a cleanup item. | Removing it breaks those 6 files' state management |
| Two literal placeholder API calls: `Add_plot_property.dart:473` and `Edit_Plot.dart:480` both call `https://your-api.com/plots` | This is a functional bug (unfinished/broken feature), not dead code — fixing it means changing API behavior, which is explicitly out of scope for a cleanup pass | Not a deletion candidate at all; flagging only so you're aware it exists |
| Orphaned Google Maps API key committed in `.env` (tracked, not gitignored) | This is a live-credential/security matter (rotate + purge from git history), not a code-cleanup action — the 09-01 audit already proposed a remediation plan that hasn't been executed | Out of scope for this pass; needs its own explicit go-ahead since it involves git history rewriting and key rotation |
| 102 files (of 429) came back "unreached" from the `main.dart` import graph (full list in Appendix C) — most are legitimate role-duplicate screens reached only through a sibling entry point my BFS didn't seed rather than truly dead | A single-entry-point BFS undercounts reachability in an app with several named-route/tab entry points; only the ones independently confirmed above (via full-repo grep for the class name too) are trustworthy dead-code calls | Treat the rest of this list as "worth a second look," not a deletion list |

### Side finding — not part of this cleanup, but worth flagging

166 files import `AppLogger.dart` via a relative path (`import '../../AppLogger.dart';` or similar), and for every file that sits exactly one folder below `lib/` (e.g. `lib/Upcoming/*.dart`, `lib/provider/*.dart`, `lib/Web_query/web_query.dart`, `lib/Home_Screen.dart`'s siblings), that path resolves one level too far up — to a nonexistent `AppLogger.dart` at the repo root instead of the real `lib/AppLogger.dart`. This pattern dates to an April 2026 commit and is extremely widespread. I can't compile here to confirm actual build impact (no Dart SDK in this environment), and some of the affected files are unambiguously live (e.g. `Administrator_HomeScreen.dart`, which I edited successfully earlier this session), so there may be something about Dart's resolution I'm not accounting for, or this may be a real latent break. **Worth running `flutter analyze` yourself to confirm one way or the other** — this is a correctness question, not something I'm proposing to touch as part of a "remove unused code" pass.

## DO NOT TOUCH

- `lib/Target_details/` vs `lib/Adminisstrator_Target_details/`, and `CalenderForFieldWorker.dart`/`CalenderForAdmin.dart` — near-duplicate trees, but both halves are actively used by different roles. This is a real architecture problem (drift risk) but not dead code.
- `android/`, `ios/`, `google-services.json`, `GoogleService-Info.plist`, `key.properties`, signing config — untouched, as instructed.
- `check_elf_alignment.sh` — a real Android 16KB-page-alignment build script, not junk.
- `build/` directory — gitignored, not committed, regenerable; no action needed.
- Package name, bundle identifier, API URLs, database/API field names — untouched.
- `get`/GetX, despite being "vestigial" architecture — it's live code in 6 files (see NEEDS REVIEW).

---

## What I'd suggest for Phase 4, pending your approval

1. Delete the 7 confirmed-dead files (`agreement_service.dart`, `old_future_detailpage.dart`, the four " 2" duplicates, `Yearly_Target 2.dart`) plus the stray `git` file.
2. Remove `__MACOSX/` from the tree (and ideally from git history later, since it's bloating `.git` by ~34MB+ — that's a separate `git filter-repo` conversation if you want it).
3. Remove `equatable`, `google_maps_flutter`, and `flutter_dotenv` from `pubspec.yaml` (all three conclusively zero-reference).
4. Leave the print/debugPrint cleanup, the 45-image review, the 28-dependency review, and the `AppLogger` import question for a follow-up pass, since each needs either your judgment call or a real `flutter analyze` run to close out safely.

Let me know which of the above you want me to actually apply — I'll only touch what you greenlight, and I'll give you a `git diff --stat` (and full diff on request) after, per your instructions.

---

## Appendix A — full list of the 45 asset images with no literal-text reference found

Homeaddress.png, V.png, about.png, bg.png, bike.png, cer_insu_img.webp, country.jpg, crowne.jpg, customer-service.png, deleteaccount.png, east.jpg, "enquiry support.png", help.png, ic_notification.png, in_arrow.png, internet.png, lavanya.jpg, lawyer.png, leela.jpg, life.jpg, loadingHand.json, logistics.png, logo_again.png, north.jpg, photo.png, pin.png, profile.png, property.webp, "qr img.png", rent_pro.webp, rentji.webp, servant.webp, seven.jpeg, tick.png, tivoli.jpg, truckkkkk.png, tuk.png, umrao.jpg, verified.png, verify.jpg, verify2.jpeg, web-link.png, website.png, west.jpg, your_background_image.jpg

(`loadingHand.json` is a Lottie file, not an image — same "no text reference found" caveat applies; do not delete without checking the Lottie widget usages by variable, not filename.)

## Appendix B — full list of the ~28 pubspec dependencies with no direct `package:<name>/` import found

sdk *(parsing artifact from the YAML structure — not a real dependency, ignore)*, cupertino_icons *(near-certainly a false positive — Flutter's own `CupertinoIcons` class is what's actually used, this package just ships the font)*, loading_overlay, timezone, dotted_border, convert, easy_image_viewer, vibration, flutter_staggered_grid_view, transparent_image, flutter_pdfview, expandable, loader_overlay, url_launcher_ios, flutter_pw_validator, top_snackbar_flutter, pinput, app_settings, smooth_page_indicator, printing, palette_generator, gallery_saver_plus, async *(pubspec comment says "for debounce" — likely used, just not via a literal import string my grep catches)*, google_fonts, flutter_animate, webview_flutter, image_cropper, package_info_plus

None of these are recommended for removal without an individual check — this list is here so you (or a future pass) can go through them one at a time rather than re-deriving it.

## Appendix C — the 102 files that came back unreached from `lib/main.dart` in the import graph

Most of these are legitimate screens reached through a route/tab entry point other than a direct `main.dart` import (Accountant sub-tabs, Gemini AI chat entry, some Rent Agreement forms reached via a differently-cased folder path `Rent%20Agreement` vs `Rent Agreement` that my resolver treated as two different paths). Treat this list as "worth a second look with a smarter multi-entry-point graph," not as deletion candidates — only the 7 files independently confirmed in SAFE TO REMOVE above (via a *second*, filename/classname-based repo-wide grep, not just this graph) should actually be treated as dead.

Accountant/Company expense/{Add_expenses,Annually,Company_screen,Tabbar_control,expenses_details}.dart; Accountant/Salaray expense/{Add_salary,Annually,Salary_home,Tabbar_control}.dart; Add_Rented_Flat_New/{All_finacial_New,Book_Flat_For_FieldWorker_New,FieldWorker_CompletePage_transaction_details_page,FieldWorker_Complete_Detail_Page_New,Field_Worker_Target_New}.dart; Administrator/Add_Assign_Tenant_Demand/{Administater_AssignTenant_Add,check_number_availablity_assigndemand}.dart; Administrator/Admin_future _property/{Administater_Plot,Administater_Show_Plot,Administater_Under_Plot,Administater_under_commercial}.dart; Administrator/{Administater_payment_document,Administater_propertyverification,AdministatorFieldWorkerBookingPage,agreement_details}.dart; Administrator/Administator_Agreement/{Admin_All_agreement_model,Admin_Expire_aggrement_details,Admin_Expire_agreement,Admin_Renewal_Agreement,Admin_Renewal_agreement_details}.dart; Administrator/Administator_Agreement/PDFs/pdf_preview.dart; Administrator/All_Rented_Flat/{"Pending_Add _Property_Form",Pending_Property_Update_Form}.dart; Administrator/Calling_socket/{Call_Screen,Incoming_call,socket_service}.dart; Controller/{Show_demand_binding,demand_pin_utitlites}.dart; Custom_Widget/Snack_bar.dart; Future_Property_OwnerDetails_section/Edit_futureproperty/Edit_Building.dart; Future_Property_OwnerDetails_section/Move_To_PropertyVerification.dart; Future_Property_OwnerDetails_section/New_Update/{Add_Floors,New_File_Future_property,model_flatunderfutureproperty}.dart; Future_Property_OwnerDetails_section/{metro_search,old_future_detailpage}.dart; Gemini_AI/{AI_sheet,Demo_chat,Gemini_theme}.dart; Home_Screen_click/{Add_images_in_Realestate,Add_multi_image_in_Realestate,Edit_Page_Realestate,Edit_Property_SecondPage,Image_Update,Preview_Image,Update_realEstate_form}.dart; Internet_Connectivity/Network_Service.dart; Police_Verification/Police_Verification.dart; Propert_verigication_Document/{Add_Property_Veerification,Property_Verification}.dart; Rent Agreement/{Expire_aggrement_details,Expire_agreement,Renewal_Agreement,Renewal_agreement_details}.dart; Rent Agreement/history_agreement/{All_agreement,request_agreement}.dart; SocialMediaHandler/Social_Insurance/Insurance Form Screen.dart; Statistics/{Progressbar,Target_MainPage}.dart; Target_details/Monthly_Tab/Monthly_police_verification.dart; Target_details/Monthly_Tab/Monthly_under_detail/Police_Monthly_Detail.dart; Target_details/Target_Widget.dart; Target_details/Yearly_Tab/{Agreement_External,Building,Police_verification}.dart; Target_details/Yearly_Tab/Target_Under_Details_/{Building_Details,Yearly_police_verification,agreementDetailScreen}.dart; Tenant_Details_Demand/{All_demand_by_feildnumber,Feild_Accpte_TenantDemand2,Filter_by_Number,Filter_by_facility,pending_tenant_control}.dart; Upcoming/Upcoming_update.dart; Yearly_Target 2.dart; model/{Design_model_class/future_porperty_model,Expire_Agreement,Model_Renewal_agreement,New_demand_mode,add_flat_model,agrement_model,doctenantSlider,futureProperty_Slideer,main_RealEstate_Model}.dart; provider/{expire_agrement_,property_provider}.dart; services/agreement_service.dart; ui_decoration_tools/{App_card_theme,constant}.dart
