# Future Property Module — Architecture & UX Analysis

**App:** The Verify Field (field-worker Flutter app) + its admin counterpart
**Module analyzed:** `lib/Future_Property_OwnerDetails_section/` (field worker) and `lib/Administrator/Admin_future _property/` (admin — note the literal stray space in that folder name)
**Prepared for:** developers / product managers implementing or reviewing this feature
**Date:** 2026-09-23
**Method:** static code review only (no compiler/emulator available in this environment) — every claim below is traced to a specific file, class, endpoint, or grep result; a handful of items are flagged as "unverified in code" where the trail runs cold.

---

## 1. Structure — data model and hierarchy

The module's actual data hierarchy is **flatter than the requested "Property → Building → Flat" framing** — there is no dedicated `Building` class. The model layer is:

- **`Property1`** (`lib/Future_Property_OwnerDetails_section/New_Update/flat_edit_model.dart`) — the one substantial model in the module. It is really a **flat/unit record**, not a building record, even though many of its fields (owner, caretaker, address, road size, metro distance, facilities, lift, parking, age of property) describe the *building* the unit sits in. Full field list: `pId, propertyPhoto, locations, flatNumber, buyRent, residenceCommercial, apartmentName, apartmentAddress, typeOfProperty, bhk, showPrice, lastPrice, askingPrice, floor, totalFloor, balcony, squareFit, maintenance, parking, ageOfProperty, fieldWorkerAddress, roadSize, metroDistance, highwayDistance, mainMarketDistance, meter, ownerName, ownerNumber, currentDates, availableDate, kitchen, bathroom, lift, facility, furnishedUnfurnished, fieldWorkerName, liveUnlive, fieldWorkerNumber, registryAndGpa, loan, longitude, latitude, videoLink, fieldWorkerCurrentLocation, careTakerName, careTakerNumber, subid, multipleImages`.
- **The "building" level is implicit**, not a separate table/model in this app's client code. A building is identified by an id (`subid` on the flat record, `P_id`/`id` on the building's own create/list/detail calls) plus shared fields — `apartmentName` (`Apartment_name`), `apartmentAddress`, `locations` — that every flat under it repeats. There's a second, near-duplicate model, `FutureProperty`/`FuturePropertyResponse` (in the newly created `lib/model/FutureBuilding_model.dart`, rescued from a deleted legacy file), used mainly by the Home screen's building-level widgets.
- **`model_flatfutureproperty`** (`New_Update/model_flatunderfutureproperty.dart`) is a tiny throwaway model with one field (`dimage` → JSON `images`) — used only for the multi-image gallery, not a hierarchy node.
- Three **parallel property types** exist side by side, each with its own screens, models and endpoints, rather than one generic "Property" type with a type flag: **Residential Building** (`Add_futureProperty.dart` → `Property1`/building fields), **Plot** (`Add_plot_property.dart`), and **Commercial** (`Add_commercial_property.dart`, its own field set — office/retail/showroom/warehouse, area, rent-meter, amenities). This repo-wide 3-way split is consistent all the way through admin, list, detail, and edit screens.

Effective hierarchy, in practice:

```
Field Worker
  └─ Building (Residential)  ── identified by building id (P_id/id), grouped by Apartment_name/address
  │     └─ Flat / Unit (Property1)  ── identified by P_id, linked to building via subid
  │           └─ Tenant(s)            ── separate record, added via "Add Tenant"
  │
  ├─ Plot        (separate model/screens, no flats under it)
  └─ Commercial Property (separate model/screens, no flats under it — has its own single-unit detail page)
```

Only the **Residential Building** branch has a real building→flat parent/child relationship. Plot and Commercial are single-level records (no sub-units).

---

## 2. UI/UX — screens, navigation, interactions

**Entry point:** `FuturePropertyTabPage` (`Future_Property_Tabbar.dart`) — a 4-tab page: **Buildings | Plots | Commercial | History**.

- **Buildings tab** (`FrontPage_FutureProperty`, in `Future_Property.dart`) — the only tab with a search bar ("Search building, owner, place…"), backed by `FuturePropertyController`. Lists building cards grouped/searchable; each card shows a "Live: N / Unlive: 0" badge and a "⚠ Missing: <fields>" completeness banner. Tapping a card opens `Future_Property_details(idd: buildingId)`.
- **Plots tab** (`PlotListPage`) → list → `Plot_detail.dart`.
- **Commercial tab** (`CommercialListPage`) → list → `Commercial_detail.dart`.
- **History tab** (`HistoryPage`, from `BuildingHistoryPage.dart`) — a shared widget physically filed under the *Administrator* folder but wired into **both** the field-worker tab page (scoped to that worker's own number) and the admin flow (scoped to whichever worker the admin selected). It shows a notification/action feed (Live vs Booked events) with stat tiles and date grouping — not a full field-level change log.
- **Global "Add" action:** a floating button opens a bottom sheet ("Form options") with three choices — **Add Building / Add Plot / Add Commercial** — routing to `Add_futureProperty.dart`, `Add_plot_property.dart` (`PropertyListingPage`), or `Add_commercial_property.dart` (`CommercialPropertyForm`) respectively.
- **Building detail** (`Future_Property_details` widget, `Future_property_details.dart`) — image carousel, building info, a **⋮ menu with "Edit Building" and "Add Building Images"**, a flats grid/list (each flat card shows a green "live" status badge and a 🔥 **Duplicate** button → `DuplicateFutureProperty`), and a bottom bar with **"Calling section"** (owner/caretaker/contacts) and **"Add Flat"** buttons.
  - "Edit Building" navigates to **`UpdateRealEstateProperty`** (`Update_future_building.dart`) — confirmed by direct code trace, not the older `Edit_Building_futureproperty` class in `Edit_futureproperty/Edit_Building.dart`, which is defined but **never referenced anywhere else in the codebase** (grep-confirmed dead code — do not treat it as the live "Edit Building" screen).
  - "Add Flat" is **gated**: it checks that the building's `roadSize`, `metroName`, `metroDistance`, `mainMarketDistance`, `ageOfProperty`, `lift`, and `parking` are all non-empty first; if any is missing it blocks with a red SnackBar ("⚠ Please update property details first") instead of navigating — i.e. a building must be "complete" before flats can be added under it.
- **Flat detail** (`underflat_futureproperty`, in the confusingly-named `New_Update/under_flats_infutureproperty.dart` — despite the filename this is a single-flat detail page, not a list) — photo carousel, info rows, contact cards, tenant list, a ⋮ menu ("Edit Flat" → `Edit_flat.dart`, "Add Flat Images"), a floating "Add Tenant" button, and — critically — **the Live/Unlive toggle buttons live here** (see §6).
- **Duplicate flow** (`Duplicate_Property.dart`, triggered by the 🔥 button on a flat card) — clones a flat's data into a new add-flat-style form, prefilled from the source flat, for the case where a field worker is adding a near-identical unit.
- A separate, apparently **orphaned** screen, `MoveTO_Add_propertyverification` (`Move_To_PropertyVerification.dart`), posts to a different backend entirely (`insert.php`, the main Verify Real Estate "Property Verification" module) — grep-confirmed it is defined but never navigated to from anywhere in the current codebase. Treat it as legacy/unreachable, not part of the live flow, unless you find a caller we missed.
- A legacy duplicate of the building detail screen, `old_future_detailpage.dart`, re-declares a class also named `Future_Property_details` and is not imported anywhere — dead code left over from a prior refactor.

Text flow diagram:

```
FuturePropertyTabPage (4 tabs: Buildings / Plots / Commercial / History)
  │
  ├─ [+] FAB → "Add Building" / "Add Plot" / "Add Commercial"
  │
  ├─ Buildings tab ─▶ Future_Property_details (building detail)
  │                     ├─ ⋮ "Edit Building"       ─▶ UpdateRealEstateProperty (pre-filled, validated)
  │                     ├─ ⋮ "Add Building Images"  ─▶ image uploader
  │                     ├─ flat card ⋮ "Duplicate"  ─▶ Duplicate_Property (prefilled Add-Flat clone)
  │                     ├─ flat card tap            ─▶ underflat_futureproperty (flat detail)
  │                     │      ├─ ⋮ "Edit Flat"        ─▶ Edit_flat.dart
  │                     │      ├─ ⋮ "Add Flat Images"  ─▶ image uploader
  │                     │      ├─ FAB "Add Tenant"      ─▶ AddTenantUnderFutureProperty
  │                     │      └─ bottom bar: 2 LIVE/UNLIVE TOGGLE BUTTONS  (see §6)
  │                     ├─ "Calling section" button   ─▶ AllContact (owner/caretaker call/WhatsApp)
  │                     └─ "Add Flat" button (gated on building completeness) ─▶ add_flat_form.dart
  │
  ├─ Plots tab      ─▶ PlotShow list ─▶ Plot_detail.dart
  ├─ Commercial tab ─▶ commercialShow list ─▶ Commercial_detail.dart
  └─ History tab    ─▶ HistoryPage (notification/status-change feed for this worker)
```

---

## 3. Adding a Building — steps, fields, validation

Screen: **`Add_FutureProperty`** (`Add_futureProperty.dart`), reached via the global "Add" bottom sheet → "Add Building". This screen is specifically for **residential** buildings (Plot and Commercial each have their own separate add-screens — see §5).

Structure: single scrollable `Form`, no wizard/stepper — sections: image upload, basic info, contact info, property details, location, nearby facilities, submit.

**Required fields** (form-validated, "Please select/enter …" errors): Place (dropdown, fixed locality list), Buy/Rent, Total Floor, Property Type (Residential/Commercial), Property Name & Address, Facilities (multi-select dialog), Road Width, Age of Property, Metro Distance, Market Distance, Lift Availability (Yes/No), Parking (Yes/No), Address for Field Worker, Google Location (free text, filled manually or via a GPS button). A cover photo is also effectively required — enforced by an explicit code check, not a form validator (submission is blocked with a SnackBar if none is picked).

**Optional fields:** Owner Name, Owner Number (max 10 digits), Caretaker Name, Caretaker Number (max 10 digits), Owner Vehicle Number, Metro Station + Localities (via a metro/locality picker, feeding a "Nearby Facilities" panel that only appears once a metro is chosen), additional gallery images (multi-picker, no fixed cap).

**Location capture:** a "Get Current Location" button uses device GPS (`Geolocator`) plus reverse-geocoding (`geocoding` package) to fill the Google Location field automatically, with a manual-typing fallback; raw latitude/longitude are captured and shown in a small removable "Detected" chip.

**Submit behavior:** validate → 3-second "Submitting in 3…2…1…" countdown → multipart POST to `new_future_property_api_with_multile_images_store/new_future_property_api_with_images.php`, sending every field above plus the field worker's own name/number (read from `SharedPreferences`, not user-entered) and a server timestamp. On success: SnackBar + navigate back to the tab page (`pushAndRemoveUntil`, clearing the stack back to root). On failure: an error SnackBar and the failure is separately logged via `BugLogger`.

---

## 4. Adding Flats within a Building — steps, fields, validation

Screen: **`Add_Flatunder_futureproperty`** (`add_flat_form.dart`), reached via the "Add Flat" button on the building detail page — **only if the building's own details are complete** (see §2's gating check). The building's id and most of its shared attributes (owner/caretaker info, road size, metro/market distance, age of property, lift, address, place, facilities, locality list, current location) are passed in as constructor parameters from the parent screen and re-sent unedited with every new flat — the field worker never re-types them.

**Required fields:** primary photo (checked manually, "Images are required"), Type of Property (Flat/Office/Shop/Farms/Godown/Plots), Buy/Rent, Furnishing (Fully/Semi/Unfurnished), Parking (Car/Bike/Both/No Parking), Bathroom & Kitchen style, Flat Number, Square Footage, Balcony type, BHK, Floor Number, Show Price / Last Price / Asking Price (₹, each with live "1.20L"/"2.50Cr" formatting), Maintenance (Included, or a Custom amount), House Meter type (Commercial/Govt, or a Custom per-unit rate). If Buy/Rent = Buy, Registry (Registry/GPA) and Loan (Yes/No) also appear as required dropdowns — though a legacy manual double-check for those two was found commented out in the code, so in practice only the form-level validator still guards them.

**Optional fields:** additional gallery images (multi-picker, no cap seen), Furniture Items checklist (only shown when Furnishing ≠ Unfurnished; no required validation), Available Date (date picker, no validator), Video Link, Caretaker Name/Mobile, Owner Name/Mobile (all free text, no validators).

**Not present at all on this form:** a Live/Unlive control. Every new flat is silently created with `live_unlive = "Book"` — a hard-coded value in the submit payload, not a user choice.

**Submit behavior:** validate → 3-second countdown ("Verified!") → multipart POST to `main_realestate/add_flat_in_future_property.php` with the flat fields, the building's carried-over fields, `live_unlive="Book"`, and `subid` = the building id. On success, two success messages fire in quick succession and the screen pops back to the building detail page, which should reflect the new flat once it refetches.

A near-duplicate creation path exists at `Duplicate_Property.dart` (the 🔥 button on a flat card), which clones an existing flat's fields into the same kind of form and also hard-codes `live_unlive = "Book"` on the clone.

---

## 5. Forms — field & behavior specification

### Add a Building (`Add_futureProperty.dart` / `Add_FutureProperty`)
- Blank form, `Form`+validators on every dropdown/required text field.
- Cover photo required (code-enforced) + optional multi-image gallery.
- POST → `new_future_property_api_with_images.php`. Navigates back to the tab root on success.

### Update a Building — **two competing implementations; know which one is live**
- **`UpdateRealEstateProperty`** (`Update_future_building.dart`) — **this is the one actually wired into the UI** (via the building detail page's "Edit Building" menu item). Pre-fills every field from a GET (`show_api_for_details_page.php?id=`), reuses the *same* validators as Add, shows the existing cover photo, and lets the field worker either replace it or leave it (backend keeps the old image if none is sent). POST (multipart) → `update_allfeilds_with_single_image.php`. On success: SnackBar + simple `pop()` (no stack reset).
- **`Edit_Building_futureproperty`** (`Edit_futureproperty/Edit_Building.dart`) — **not reachable from any current navigation path** (grep-confirmed zero callers). If you were told this is "the" edit-building screen, it isn't in the current build: it has no pre-fill (every field starts blank even though it's meant to be an "edit"), no form validators at all, a narrower Place list, a different endpoint (`futureproperty_update.php`), and two hard-coded placeholder values (`floor_number: 'floor number'`, `sqyare_feet: 'Sqft'`) that look unfinished. Treat this file as legacy/dead unless further investigation finds a caller.

### Add a Flat (`add_flat_form.dart` / `Add_Flatunder_futureproperty`)
- Blank form; building-level fields arrive pre-filled via constructor params (not editable here — they belong to the parent building).
- `live_unlive` is not a form field — hard-coded to `"Book"` on submit.
- POST (multipart, `http.MultipartRequest`) → `add_flat_in_future_property.php`.

### Update a Flat (`New_Update/Edit_flat.dart` / `EditFlat`)
- Pre-fills from a GET (`display_flat_in_future_property_details_page.php?id=`) into the `Property1` model, then into the same field set as Add Flat (property type, buy/rent [+ registry/loan], furnishing [+ furniture sheet], parking, bathroom/kitchen, flat number/sqft, balcony/BHK, available date/floor, 3 price fields, maintenance [+custom], house meter [+custom], video link, caretaker/owner name+mobile).
- Manual required-field check differs slightly from Add: Edit additionally enforces Lift and Residence/Commercial, which Add does not check manually (both still carry form-level validators either way).
- Only a single replacement photo control; the multi-image gallery picker exists in the code but is **not wired to any button** on this screen (dead code) — additional images can only be managed from the flat-detail page's "Add Flat Images" menu item.
- `live_unlive` is **not read, shown, or written** anywhere in this screen — status management is fully separated from editing a flat's details.
- POST (via `Dio` `FormData`) → `update_flat_in_future_property.php`. On success: SnackBar + `pop()`.

---

## 6. Live/Unlive Flow

**Where it lives:** entirely on the flat-detail page, `underflat_futureproperty` (`New_Update/under_flats_infutureproperty.dart`) — two buttons pinned to the bottom bar. There is no separate dedicated "toggle" screen, no switch/checkbox, and no confirmation dialog before either API call fires.

**The two real states used in the data are `"Book"` and `"Live"`** — the literal string `"Unlive"` is never actually written by the app; "un-live" is achieved by sending a flat back to `"Book"`. ("Unlive" as a UI/reporting label — e.g. the building-card badge "Live: N / Unlive: 0" — is really just "not currently Live," computed as a count, not a third status value.)

There are, in fact, **two parallel status tracks** on every flat, both stored on the same `Property1`-style record:

1. **Main status** (`liveUnlive` / JSON `live_unlive`) — controlled by the button labeled **"Move to Live"** (shown red, when currently `Book`) / **"Rent out / Book"** (shown grey, when currently `Live`).
   - *Trigger:* tap the button → a 3-second in-place countdown on the button itself (no modal dialog) → `handleMainButtonAction()`.
   - *Book → Live:* three sequential POSTs to `main_realestate/move_to_main_realestae.php`: `{action:"update", P_id}`, then `{action:"copy", P_id}`, then `{action:"edit_date", source_id:P_id, date_for_target:<today>}`. On success: green SnackBar "Property moved to Live successfully!" and the button flips state immediately (`setState`).
   - *Live → Book:* `{action:"reupdate", P_id}` then `{action:"delete", source_id:P_id}`. On success: blue SnackBar "Property UnLived successfully!".
   - *UI change:* only the button's own color/label flips; no visible change elsewhere on the page and no explicit list-refresh call was found — a caller returning to the building's flat list should re-fetch to see the updated badge.
2. **"Upcoming" status** (`demoLiveUnlive` / JSON `demo_live_unlive`) — a second, independent status controlled by a second button: **"Move to Upcoming"** (orange, when `Book`) / **"Remove"** (grey, when `Live`).
   - *Book → Live:* first forces the field worker to pick a future **available date** via a date picker (cancelling aborts with a red SnackBar "No date selected!"); then POSTs `{action:"update_available_date", P_id, date}` to `main_realestate/upcoming_flat_move_to_realestate.php`, followed by `{action:"update"}` and `{action:"copy"}`. Success → orange SnackBar "Moved to Upcoming successfully!".
   - *Live → Book:* `{action:"reupdate", P_id}` then `{action:"delete", subid: <building id>}` — note this delete call keys off the **building's** subid, not the flat's own id, unlike the main-status delete which keys off `P_id`. Success → blue SnackBar "Removed from Upcoming successfully!".

**Backend implications:** each "move to Live" (either track) is not a single field update — it's a 2–3 call sequence (`update` + `copy`, sometimes + `edit_date`/`update_available_date`) against the same endpoint with different `action` parameters, and reverting uses `reupdate` + `delete`. This suggests the backend maintains the flat's row plus a **separate "copy" record** (likely in a different table feeding the main Verify Real Estate marketplace) that gets created on "Live" and removed on "Book" — i.e. going Live doesn't just flip a flag, it appears to publish a duplicate record elsewhere, and un-living deletes that published copy. Any client-side change to this logic should preserve the multi-call sequence and its ordering, since a partial failure (e.g. `update` succeeds but `copy` fails) would leave the two statuses out of sync — the current code does not appear to roll back on partial failure.

**Not part of this flow:**
- **Adding a flat** never sets Live — it hard-codes `Book`.
- **Editing a flat** never touches `live_unlive` at all.
- **Admin side is read-only** for status: `Admin_under_flats.dart` (the admin flat-detail twin) declares a `liveUnliveStatus` variable but never reads or writes it — dead code, confirmed by grep; no button, switch, or POST/PUT/DELETE call exists anywhere in the 13-file admin module (`lib/Administrator/Admin_future _property/`, confirmed by an exhaustive grep for `http.post|http.put|http.delete|MultipartRequest`, which returned zero hits — every network call there is a `GET`). Admins can only *view* the current Live/Book counts (building-card badges, `See_All_Futureproperty.dart`'s filter chips "Live/Unlive", and stat tiles fed by `GetTotalFlats_Live_under_building`) and browse a per-worker notification/status-change history feed (`BuildingHistoryPage.dart`, the same "History" tab component shared with the field-worker app, scoped by field-worker number). There is no delete capability anywhere in the admin module either (grep for "delete" across all 13 admin files returned zero matches).
- **`Move_To_PropertyVerification.dart`** is a separate, apparently-orphaned pipeline that posts into the unrelated main "Property Verification" module (`insert.php`) — not part of the Live/Unlive state machine, and not currently reachable from any navigation path we could find.

---

## Open items / things worth confirming with the team before relying on this document

- `Edit_futureproperty/Edit_Building.dart` and `Move_To_PropertyVerification.dart` both look dead (no callers found by grep across the whole `lib/` tree). Recommend confirming with the team before removing — this document does not authorize any deletion, it only reports reachability as found.
- The "copy"/"delete" backend actions behind the Live/Unlive buttons imply a second data store (the main real-estate marketplace) is touched on every toggle; the actual server-side behavior of `move_to_main_realestae.php` and `upcoming_flat_move_to_realestate.php` was not inspected (no backend/PHP source was available to this review) — the description above is inferred from the client's request sequence only.
- `Update_future_building.dart` takes an `int propertyId` while `Edit_Building.dart` takes a `String id` — if the dead file is ever revived, this type mismatch would need reconciling with whatever calls it.
