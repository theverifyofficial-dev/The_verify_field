# Future Property / Upcoming Flats — Feature Inventory

Scope: everything matching *future / upcoming / vacancy / vacate / expected vacant*. Two related-but-separate subsystems exist:

- **A. Future Property** — the building/plot/commercial catalogue (`lib/Future_Property_OwnerDetails_section/`, `lib/Administrator/Admin_future _property/`)
- **B. Upcoming Flats** — the "expected vacant / available from date" pipeline (`lib/Upcoming/`, `lib/Administrator/Admin_upcoming*.dart`)

~66,000 lines across ~62 Dart files. No PHP source is in this repo — all endpoints are remote on `verifyrealestateandservices.in` (`Second PHP FILE/`, `PHP_Files/`, `WebService4.asmx`). Endpoint names below are the live URLs the client calls.

This document is a read-only survey — no application code was changed while compiling it.

---

## 1. Screens / pages / dialogs

### Entry points

| Role | Home tile | Opens |
|---|---|---|
| FieldWorker | "Future Property" (`Home_Screen.dart:1368`) | `FuturePropertyTabPage` |
| FieldWorker | "Upcoming Flats" (`Home_Screen.dart:1407`) | `ParentUpcoming` |
| Administrator | "Upcoming Property" (`Administrator_HomeScreen.dart:483`) | `AdminUpcoming` |
| Sub Administrator | "Upcoming Property" (`SubAdminAccountant_Home.dart:357`) | `AdminUpcoming` |
| Sub Administrator | "Future Property (Field)" / "Upcoming Flats (Field)" (`SubAdminAccountant_Home.dart:466,473`) | the **fieldworker** screens (sub-admin gets the full write-capable FW UI) |
| Social-media module | `video_home.dart:106` | `AdministaterPropertyTabPage` |

Named routes (only the admin side is routed; everything else is raw `Navigator.push`) — `lib/Notification_demo/routes.dart`:

| Route constant | Value | Widget |
|---|---|---|
| `administaterShowFutureProperty` | `/administaterShowFutureProperty` | `AdministaterPropertyTabPage(tabIndex:0)` |
| `AdminFieldPlot` | `/FieldPlot` | `AdministaterPropertyTabPage(tabIndex:1)` |
| `AdminFieldCommercial` | `/FieldCommercial` | `AdministaterPropertyTabPage(tabIndex:2)` |
| `administaterFuturePropertyDetails` | `/administaterFuturePropertyDetails` | `Administater_Future_Property_details` |

### A. Future Property — FieldWorker tree

| Screen | File | Opened by |
|---|---|---|
| `FuturePropertyTabPage` — 4 tabs: Buildings / Plots / Commercial / History | `Future_Property_Tabbar.dart` | Home tile; also `pushAndRemoveUntil` after a building is created |
| `FrontPage_FutureProperty` — building list (tab 0) | `Future_Property.dart` | tab |
| `PlotListPage` (tab 1) | `PlotShow.dart` | tab |
| `CommercialListPage` (tab 2) | `commercialShow.dart` | tab |
| `HistoryPage` (tab 3) | `Administrator/Admin_future _property/BuildingHistoryPage.dart` (shared with admin) | tab |
| **Bottom sheet** "Form options" → Add Building / Add Plot / Add Commercial + Cancel | `Future_Property_Tabbar.dart:_showAddOptionsDialog` | FAB "Add Forms" |
| `Add_FutureProperty` — 6-step building wizard | `Add_futureProperty.dart` (2,512 ln) | bottom sheet |
| `PropertyListingPage` — plot form | `Add_plot_property.dart` (1,900 ln) | bottom sheet |
| `CommercialPropertyForm` — commercial form | `Add_commercial_property.dart` (1,956 ln) | bottom sheet |
| `Future_Property_details` — building detail | `Future_property_details.dart` (1,443 ln) | building card tap; search-result tap; `Upcoming_details` "Go to Building"; task feed (`buildingFollowUp`) |
| **Popup menu** on building detail: `Edit Building`, `Add Building Images` | same file, `_handleMenuItemClick` | ⋮ |
| `UpdateRealEstateProperty` — edit building | `Update_future_building.dart` (1,446 ln) | popup |
| `FuturePropertyFileUploadPage` — building gallery add/delete | `Add_FutureProperty_Images.dart` | popup |
| `AllContact` — "Calling section" | `Owner_Call/All_contact.dart` (1,245 ln) | green button on building detail |
| `Add_Flatunder_futureproperty` — 6-step flat wizard | `add_flat_form.dart` (2,481 ln) | blue "Add New Flat" button |
| `underflat_futureproperty` — flat detail | `New_Update/under_flats_infutureproperty.dart` (2,878 ln) | flat card tap; task feed (`addFlat`) |
| **Popup menu** on flat detail: `Edit Flat`, `Add Flat Images` | same file:1869 | ⋮ |
| `EditFlat` | `New_Update/Edit_flat.dart` (2,543 ln) | popup |
| `Futureproipoerty_FileUploadPage` — flat gallery | `New_Update/add_image_under_futureproperty.dart` | popup |
| `AddTenantUnderFutureProperty` | `New_Update/add_tenant_infutureproperty.dart` | FAB "Add Tenant" on flat detail |
| `DuplicateFutureProperty` — clone a flat | `Duplicate_Property.dart` (2,895 ln) | "Duplicate" badge on flat card |
| `PlotPropertyDisplayPage` + popup `Edit Plot` / `Add Plot Images` | `Plot_detail.dart`, `New_Update/Edit_Plot.dart`, `New_Update/Edit_plot_image.dart` | plot card |
| `CommercialUnderProperty` + popup edit/images | `Commercial_detail.dart`, `New_Update/Edit_commercial.dart`, `New_Update/Edit_commercial_images.dart` | commercial card |
| **Confirm dialogs**: "Call {Owner/Caretaker}" Yes/No; "Confirm Action — Do you want to move this property?" | detail pages / `Reverse_in_Futureproperty.dart` | |

### A. Future Property — Admin tree (all read-only)

| Screen | File | Opened by |
|---|---|---|
| `AdministaterPropertyTabPage` — 3 tabs Building / Plot / Commercial | `Administater_Future_Tabbar.dart` | route + FCM deep link |
| `ADministaterShow_FutureProperty` — buildings grouped by fieldworker | `Administater_Future_Property.dart` | tab 0 |
| `Show_Administater_Plot` → `Administater_show_Plot` → `Administater_Under_Plot` | `Administater_Plot.dart`, `Administater_Show_Plot.dart`, `Administater_Under_Plot.dart` | tab 1 / "See All →" / card |
| `Show_Aministater_Commercial` → `Administater_Commercial` → `Administater_CommercialUnderProperty` | `Administater_Commercial.dart`, `Administater_show_commercial.dart`, `Administater_under_commercial.dart` | tab 2 / "See All →" / card |
| `TabBarPage` — 2 tabs Building / History, with a fieldworker info strip | `Admin_SeeAll_Tabbar.dart` | "See All →" on a fieldworker row |
| `SeeAll_FutureProperty` — paginated per-fieldworker building list | `See_All_Futureproperty.dart` (1,153 ln) | tab |
| `Administater_Future_Property_details` — building detail | `Future_Property_Details.dart` (1,539 ln) | card tap, route, `Administater_Realestate_Details.dart:1076`, `Edit_Building.dart:151` |
| `Admin_underflat_futureproperty` — flat detail | `Admin_under_flats.dart` (1,761 ln) | flat card |

### B. Upcoming Flats — FieldWorker

| Screen | File | Opened by |
|---|---|---|
| `ParentUpcoming` — 3 tabs All Property / Your Property / Add Property | `Parent_Upcoming.dart` | Home tile |
| `AllFlats` — all upcoming flats (location-scoped) | `All_flats.dart` | tab 0 → `AdminUpcomingDetails` |
| `UserFlat` — this fieldworker's upcoming flats | `user_flat.dart` | tab 1 → `UpcomingDetailsPage` |
| `AddFlats` — urgent-flat list + FAB | `add_flats.dart` | tab 2 → `AddedDetails` |
| `AddComingFlats` — urgent-flat creation form | `add_coming_flats.dart` (3,255 ln) | FAB on tab 2 |
| `UpcomingDetailsPage` — upcoming-flat detail | `Upcoming_details.dart` | card; task feed (`upcomingFlat`) |
| `AddedDetails` — urgent-flat detail | `added_details.dart` | card |
| `UpdateForm` — urgent-flat edit | `update_form.dart` (3,230 ln) | "Update" on `AddedDetails` |
| `MultiImg` — urgent-flat gallery | `multi_img.dart` | "Multi Image" on `AddedDetails` |
| `ReverseInFutureProperty` — push an upcoming record back under a building | `Home_Screen_click/Reverse_in_Futureproperty.dart` | popup "Reverse In Future Property" on `AddedDetails` |

### B. Upcoming Flats — Admin / Sub-admin

| Screen | File | Notes |
|---|---|---|
| `AdminUpcoming` | `Administrator/Admin_upcoming.dart` | list, read-only |
| `AdminUpcomingDetails` | `Administrator/Admin_upcoming_details.dart` | detail, **read-only** (no date-update, no move) |

### Dead / unreachable (no inbound navigation — verified by grep)

`old_future_detailpage.dart` (4,970 ln, duplicate `Future_Property_details`), `Move_To_PropertyVerification.dart` (1,769 ln), `Edit_futureproperty/Edit_Building.dart` (993 ln), `New_Update/New_File_Future_property.dart` (`Available_property`), `Upcoming/Upcoming_update.dart` (1,396 ln — entirely commented out), `metro_api.dart`, `metro_search.dart` (`MetroField`, `MetroAPI`), `model/Design_model_class/future_porperty_model.dart` (0 bytes). `Add_plot_property.dart:473` and `New_Update/Edit_Plot.dart:480` call the placeholder `https://your-api.com/plots`.

---

## 2. Fields

### Add Building — `Add_futureProperty.dart` → `new_future_property_api_with_images.php` (Dio multipart)

6 steps: Cover Photo · Basic Info · Address & Location · Facilities & Access · Metro & Distance · Owner & Caretaker. Step titles exist in English and Hinglish.

| Field (payload key) | Type | Required | Validation |
|---|---|---|---|
| `images` (cover) | single image, compressed q=85 | ✅ | step 0: "Please select a cover photo" |
| `img[]` | multi image | ❌ | — |
| `place` | dropdown — SultanPur, ChhattarPur, Aya Nagar, Rajpur Khurd, Manglapuri, Dwarka Mor, Uttam Nagar, Nawada, Vasant Kunj, Ghitorni | ✅ | step 1 |
| `Residence_commercial` | dropdown — Residential / Commercial | ✅ | step 1 |
| `buy_rent` | dropdown — Buy / Rent | ✅ | step 1 |
| `total_floor` | dropdown — G Floor…10 Floor | ✅ | step 1 |
| `age_of_property` | dropdown — Under Construction, New Construction, 1–10 years, 10+ years | ✅ | step 1 |
| `propertyname_address` | text | ✅ | step 2 + `TextFormField` validator |
| `property_address_for_fieldworkar` | text | ✅ | step 2 + validator |
| `your_address` | text (Google location) | ✅ | step 2 + validator |
| `facility` | multi-select → comma-joined — CCTV Camera, Parking, Security, Terrace Garden, Gas Pipeline | ✅ ≥1 | step 3 |
| `road_size` | dropdown — 15/20/25/30/35 Feet, 40 Above | ✅ | step 3 |
| `lift` | Yes / No | ✅ | step 3 |
| `parking` | Yes / No | ✅ | step 3 |
| `metro_distance` | dropdown — 200 m…2.5+ km | ✅ | step 4 |
| `main_market_distance` | dropdown — 200 m…2.5+ km | ✅ | step 4 |
| `metro_name` | chips — Hauz Khas, Malviya Nagar, Saket, Qutub Minar, Chhattarpur, Sultanpur, Ghitorni, Arjan Garh | ❌ | — |
| `ownername`, `ownernumber`, `caretakername`, `caretakernumber`, `owner_vehical_number` | text — labels say **"(Optional)"** | ❌ | — |
| `longitude`, `latitude` | auto from Geolocator | ❌ | — |
| `fieldworkarname`, `fieldworkarnumber` | auto from `SharedPreferences` | — | — |
| `current_date`, `current_date_` | auto | — | — |
| `locality_list` | **hardcoded literal `"Sultanpur"`** | — | ⚠ ignores selected place |

Edit Building (`Update_future_building.dart` → `update_allfeilds_with_single_image.php`) posts the same set plus `id`, with `facility` as free text instead of multi-select; also hardcodes `locality_list: "Sultanpur"`. Omitting the image makes the backend keep the old one.

### Add Flat under building — `add_flat_form.dart` → `add_flat_in_future_property.php`

6 steps. Required per `_validateStep`:

| Step | Required fields |
|---|---|
| 0 | Primary Photo |
| 1 | `Typeofproperty` (Flat/Office/Shop/Farms/Godown/Plots), `Flat_number`, `Bhk` (1/2/3/4 BHK, 1 RK, Commercial), `Floor_` (G…10 Floor) |
| 2 | `Buy_Rent`; if **Buy** → `registry_and_gpa` (Registry/GPA) **and** `loan` (Yes/No) |
| 3 | `furnished_unfurnished`, `Balcony` (Front/Back/Two Side/Side/Window/Park Facing/Road Facing/Corner/No Balcony), `bathroom` (Western/Indian/No), `kitchen` (Western/Indian/No), `parking` (Car/Bike/Both/No Parking), `squarefit` |
| 4 | `show_Price`, `Last_Price`, `asking_price`, `maintance` (+ custom amount if "Custom"), house-meter type |
| 5 | nothing |

A second gate in `_handleUpload` re-checks Balcony, Kitchen, Bathroom, Buy/Rent. Optional: `owner_name/number`, `care_taker_name/number`, `video_link`, `meter`, **`available_date`** (date picker — this is the expected-vacancy date). Inherited read-only from the parent building: `locations`, `Residence_Commercial`, `Total_floor`, `Apartment_Address`, `fieldworkar_address`, `age_of_property`, `lift`, `Facility`, `Road_Size`, `locality_list`, `metro_distance`, `highway_distance`, `main_market_distance`. Server-side constant: **`live_unlive = "Book"`**.

⚠ `Apartment_name` is overloaded: when furnishing is Semi/Fully Furnished it carries the furniture list (`"Bed(2), Sofa(1)"`), not a name. ⚠ `metro_distance` is sent `widget.metro_name` and `highway_distance` is sent `widget.metro_dis` — swapped.

### Add Plot — `Add_plot_property.dart` → `plot_add_api.php`

All validated via `TextFormField`/dropdown validators, ≥1 image required. `plot_size` (50–500 gaj slider), `plot_front_size` (20–80 ft + Custom), `plot_side_size`, `road_size` (10–100 ft + Custom), `plot_open` (1–4 Side), `age_of_property` (1–5 years), `water_connection` (Yes/No), `electric_price` (Yes/No), `plot_price`, `plot_status` (Register / GPA / Lal Dara / Power of Attorney / Loan), `property_chain` (Yes/No), `property_rent` (Available for Rent / Not for Rent), `field_address`, `main_address`, `current_location`, `Description`, `longitude`, `latitude`, `fieldworkar_name/number` (auto). Images: `single_image`, `images[]`.

### Add Commercial — `Add_commercial_property.dart` → `add_commercial_property.php`

Required: main image, `listing_type` (Rent/Sell), `property_type` (Office / Retail Shop / Showroom / Warehouse), `avaible_date`, `location_`. Others: `current_location`, `build_up_area`, `carpet_area`, `dimmensions_`, `height_`, `width_`, `total_floor` (Ground,1–5,6+), `parking_faciltiy` (Public/Private/Both/None), `amenites_` (comma-joined from Water Storage, Power Backup, Security, Parking, Lift, Air Conditioning, Fire Safety, Internet Ready), `price`, `Description`, `longitude`, `latitude`, `field_workar_name/number`.

### Add Tenant — `add_tenant_infutureproperty.dart` → `add_tanant_in_future_property/insert.php`

**All required.** `tenant_name`, `tenant_phone_number` (digits only, `maxLength:10`, "Phone must be 10 digits"), `flat_rent`, `shifting_date` (date picker, `dd/MM/yyyy`), `members`, `email`, `tenant_vichal_details`, `work_profile`, `bhk`, `type_of_property` (Residential/Commercial), `payment_mode` (Cash/UPI/Bank Transfer/Cheque), `sub_id` (flat id).

### Add urgent flat — `add_coming_flats.dart` → `add_flat_urgent_flat.php`

Same ~45-key shape as the building flat form, but standalone (no parent building) so the location/metro/road fields are entered by hand: `locations`, `Flat_number`, `Buy_Rent`, `Residence_Commercial`, `Apartment_Address`, `Typeofproperty`, `Bhk` (+Custom), `show_Price` / `Last_Price` / `asking_price`, `Floor_`, `Total_floor`, `Balcony`, `squarefit`, `maintance` (+Custom), `parking`, `age_of_property`, `fieldworkar_address`, `Road_Size`, `metro_distance`, `highway_distance`, `main_market_distance`, `meter` (+Custom), `owner_name/number`, `care_taker_name/number`, `video_link`, `current_dates`, **`available_date`**, `kitchen`, `bathroom`, `lift`, `Facility`, `furnished_unfurnished`, `Apartment_name` (same furniture overload), `registry_and_gpa`, `loan`, `field_worker_current_location`, `Latitude`, `Longitude`, `field_warkar_name/number`, `live_unlive = 'Book'`.

### Displayed-only fields

- **Building detail (FW)** — carousel; Property Address, Field Worker Address, Current Location (tappable → Google Maps); Specifications: Total Floors, Road Size, Metro Station, Metro Distance, Market Distance, Age, Lift, Parking, Locality; Contact Information: Owner, Caretaker (each with Call); Date & Time; flats grouped by floor with an "N flats" count.
- **Flat detail (FW)** — Property Details (Flat Number, BHK, Floor, Sq. Ft., Type of Property, Resi/Comm, Furnished Status, Parking, Balcony, Kitchen, Bathroom, Lift, Registry & GPA, Loan, Meter Type), Pricing (Asking / Last Price), Flat Facility, Building Facility, Road Size, Metro Station / Distance, Market Distance, Age, Video Link, Fieldworker Address/Location, Current Date; OWNER / CARETAKER / FIELD WORKER / TENANT cards (Tenant: Phone, Email, Members, Shifting Date, Vehicle, Work Profile, Payment Mode, or "No tenant added yet"). Furnishing is rendered as `Move-in Ready` / `Partially Ready` / `Bare Shell`.
- **Upcoming detail** — `Bhk • Typeofproperty`, `locations`, then sections Pricing (Show / Asking / Last Price), Property Information (Flat Number, Total Floor, Balcony, Square Feet, Maintenance, Parking, Age of Property, Metro Distance, Highway Distance, Main Market Distance, Facility, **Updated Available Date** = `dates_for_right_avaiable`), Nearby Localities chips, Owner Details, Field Worker. Missing values render `N/A`.

---

## 3. Actions / buttons / APIs / who can do them

### FieldWorker (and Sub Administrator, who reuses the FW screens)

| Action | Where | API | Method |
|---|---|---|---|
| Create building | Add wizard | `new_future_property_api_with_images.php` | Dio multipart |
| Edit building | ⋮ Edit Building | `update_allfeilds_with_single_image.php` | multipart |
| Building images add/delete | ⋮ Add Building Images | `update_multiple_image_future_property.php` with `action=show` / `insert` / `delete_selected` + `delete_images[i]` | multipart / POST |
| Create flat | Add New Flat (gated — see below) | `add_flat_in_future_property.php` | multipart |
| Edit flat | ⋮ Edit Flat | `update_flat_in_future_property.php` | Dio multipart |
| Flat images | ⋮ Add Flat Images | `update_multiple_image_in_future_property.php` (same action verbs) | multipart |
| Duplicate flat | "Duplicate" badge | read `fecth_data_dublicate_flat.php?id=`, write `add_flat_in_future_property.php` | GET + multipart |
| Add tenant | FAB | `add_tanant_in_future_property/insert.php` | multipart |
| **Move to Live / Rent out–Book** | flat detail, left bottom button | `move_to_main_realestae.php` | POST ×3 |
| **Move to Upcoming / Remove** | flat detail, right bottom button | `upcoming_flat_move_to_realestate.php` | POST ×3 |
| Calling section | building detail | log `new_future_property_calling_option.php`; status `calling_update_building.php`; read `show_api_for_calling_api_in_buidling.php`, `show_data_calling_both_of_flat.php` | POST / GET |
| Call / WhatsApp | contact rows | `tel:` via `flutter_phone_direct_caller`, `https://wa.me/` | — |
| Create/edit plot, plot images | plot screens | `plot_add_api.php`, `update_plot_api.php`, `edit_plot_multiple_image.php` | multipart |
| Create/edit commercial, images | commercial screens | `add_commercial_property.php`, `update_api_commercial.php`, `edit_commerical_multiple_images.php` | multipart |
| Create/edit urgent flat, images | Upcoming tab 2 | `add_flat_urgent_flat.php`, `urgent_flat_update_api.php`, `urgent_flat_multiple_image.php` | multipart |
| **Move urgent flat to Live** | `AddedDetails` bottom button | `urgent_flat_move_to_realestate.php` | POST ×2 |
| Update available date | `UpcomingDetailsPage` | `upcomin_update_api.php` (`P_id`, `date`) | POST |
| Reverse into Future Property | `AddedDetails` ⋮ | `reverised.php?pid=&subid=` | GET |
| Go to Building | `UpcomingDetailsPage` | navigation only (`subid` → building) | — |

**Gate on "Add New Flat"**: blocked with `⚠ Please update property details first` unless the parent building has all of `roadSize`, `metroName`, `metroDistance`, `mainMarketDistance`, `ageOfProperty`, `lift`, `parking`.

**Safety affordances**: a forced 3-second countdown on the Move-to-Live button; Yes/No confirm dialogs on calls and on "Do you want to move this property?"; a countdown + "Reverse Successful" screen on reverse.

### Administrator

**No write actions anywhere in the Future Property feature.** `grep -r "http.post\|MultipartRequest\|dio.post"` over `lib/Administrator/Admin_future _property/` returns nothing, and `Admin_upcoming*.dart` are GET-only. Admin can: browse, search, filter, paginate, open details, view galleries (`PropertyPreview`), call the owner via a Yes/No dialog, drill fieldworker → "See All →" → building → flat, and read the notification History tab.

---

## 4. Statuses and stages

Two independent flags per flat record.

**`live_unlive` — publication state**

```
Book ──["Move to Live"]──> Live ──["Rent out / Book"]──> Book
```

`move_to_main_realestae.php`, sequenced client-side:
- **Book → Live**: `action=update` + `action=copy` (copies the record into main realestate), then `action=edit_date` with `source_id` + `date_for_target` = today. Toast "Property moved to Live successfully!"
- **Live → Book**: `action=reupdate` + `action=delete` with `source_id`. Toast "Property UnLived successfully!"

Button colour: Book = red, Live = grey. Empty/unknown status renders "Loading..." and disables the button. `added_details.dart` runs the identical verbs against `urgent_flat_move_to_realestate.php` (delete keyed by `source_id`).

**`demo_live_unlive` — upcoming / expected-vacancy state**

```
Book ──[pick date → "Move to Upcoming"]──> Live ──["Remove"]──> Book
```

`upcoming_flat_move_to_realestate.php`:
- **Book → Live**: `showDatePicker(firstDate: now)` — cancelling aborts with "No date selected!". Then `action=update_available_date` (`P_id`, `date`), then `action=update` + `action=copy`. Toast "Moved to Upcoming successfully!" (orange).
- **Live → Book**: `action=reupdate` + `action=delete` keyed by **`subid`** (not `source_id` — differs from the live flow).

Both flags default to `'Book'` when the API returns empty (`under_flats_infutureproperty.dart:249,333,344`). All transitions are optimistic `setState` — no re-fetch, and the move is 2–3 separate un-transacted POSTs, so a partial failure leaves the UI and server disagreeing.

**Derived / reported states**: `Live` / `Unlive` / `Book` counts per building (`live_unlive_flat_under_building`, `count_api_for_avability_for_building`, `GetTotalFlats_under_building`, `GetTotalFlats_Live_under_building`); "Rent Out" chip = `Book` count. History records an `action_type` of `update` (rendered **Live**) vs anything else (**Booked**). "Empty Building" = no flats. "Missing Field" = a client-side scan over ~18–24 keys that renders `⚠ Missing: …` on the card.

Call-log outcome values (`All_contact.dart`): Completed Successfully, Wrong Contact Number, Not Reachable, No Respond, Property Not Found, Customer Cancelled, Mismatch Requirements.

**Availability dates**: `available_date` (entered at creation) vs `dates_for_right_avaiable` (the updated/authoritative one shown as "Updated Available Date" and used by the task feed).

---

## 5. Filters, sorting, search, notifications

### Filters

| Screen | Chips | Mechanism |
|---|---|---|
| Buildings (FW) & `SeeAll_FutureProperty` (admin) | All, Rent, Buy, Commercial, Missing Field, Live, Unlive, Empty Building | **server-side** `&filter=all\|rent\|buy\|commercial\|missing\|live\|unlive\|empty` on `future_property_pagination.php` |
| Commercial (FW) | All, Rent, Sell, Office, Retail shop, Warehouse, Missing Fields | server-side `commercial_pagination.php?filter=` |
| Plots (FW) | All, Sale, Rent, Open | **client-side** substring match on `plotStatus` / `propertyRent` / `plotOpen` |
| History | All, Live, Booked | client-side on `action_type` |
| Upcoming lists | none | — |

**Role/location scoping** (all client-side, no server enforcement):
- `Administater_Future_Property.dart`, `Administater_Plot.dart`, `Administater_Commercial.dart` ship a **hardcoded fieldworker roster** — Ravi Kumar 9711275300, Faizan Khan 9971172204, Yash 9211335993, Shivam 9711775300, Aakash 9211335994 — and show all of them when `post == "administrator"`, else only the ones matching the cached `location` (sultanpur → ravi/faizan/yash; rajpur/chhattarpur → the rest).
- `AdminUpcoming` queries `upcoming_show_api_for_subadmin.php` with no `locations` param for Administrator, else `locations=SultanPur` or `Rajpur Khurd,ChhattarPur`, **then re-filters client-side**.
- `All_flats.dart` carries a second hardcoded map (`sultanpur: ravi kumar, faizan khan, yash, shivam, aakash` / `chhattarpur_group: abhay, manish`) and filters by worker name substring — a roster that disagrees with the admin one.

### Sorting

Always descending by id, always client-side: buildings by `id`, upcoming by `P_id`, floors `.reversed`, History by `createdAt` desc then grouped into Today / Yesterday / `dd MMM yyyy`. No user-facing sort control anywhere.

### Search

| Screen | Behaviour |
|---|---|
| Buildings tab (FW) | server-side `search_in_future_builing.php?fieldworkarnumber=&search=`, fires on **every keystroke** (no debounce), hint "Search building, owner, place...". Clearing the tab resets it. |
| Commercial (FW) | `search_commercial_property.php`, 500 ms debounce |
| Plots (FW) | client-side, debounced |
| `SeeAll_FutureProperty` (admin) | server-side search; suspends infinite scroll while active |
| Upcoming lists (`AllFlats`, `UserFlat`, `AddFlats`, `AdminUpcoming`) | client-side `.contains()` across **~35 fields** per row, no debounce; shows "N properties found" with a clear-X |

Pagination: `limit=10`, infinite scroll at `maxScrollExtent - 200`, `total_records` from `body["pagination"]`. `RefreshIndicator` pull-to-refresh on most lists.

### Notifications

FCM types routed in `main.dart:_openNotificationPage` (data keys `building_id`, `flat_id`, `plot_id`, `commercial_id`, `P_id`/`p_id`):

| Type | Destination |
|---|---|
| `NEW_BUILDING`, `BUILDING_UPDATE` | `administaterShowFutureProperty`, tab 0 (`pushNamedAndRemoveUntil`). Falls back to scraping the building id out of the notification **body text** if the data key is missing. |
| `NEW_PLOT`, `PLOT_UPDATED` | `AdminFieldPlot`, tab 1, after a 350 ms delay |
| `NEW_COMMERCIAL`, `COMMERCIAL_UPDATED` | `AdminFieldCommercial`, tab 2, 350 ms delay |
| `NEW_FLAT`, `FLAT_UPDATE` | `administaterFuturePropertyDetails` with `buildingId` + `flatId`; the flat card is outlined red and scrolled to (`highlightFlatId`, 450 px assumed row height, cleared after 3 s) |
| `SECOND_PAYMENT_ACCEPTED` | `administaterShowFutureProperty` |

In-app **History** tab (`dispay_notification_history_for_fields.php?fw_number=`) is the per-fieldworker notification log with Live/Booked counts.

**Reminders** — `Home_Screen.fetchTomorrowData()` fetches `show_futureproperty_by_fieldworkarnumber?current_date_={tomorrow}` and emits "Future" events for tomorrow alongside agreements and website visits. The task feed (`Target_And_Tasks/services/task_feed_service.dart`) adds three future-property feeds:
- `task_for_building.php?current_date_=` → `buildingFollowUp` → `Future_Property_details`
- `upcoming_flat_for_fieldworkar.php?dates_for_right_avaiable=` → `upcomingFlat` → "Flat available — {Flat_number}" → `UpcomingDetailsPage`
- `task_for_add_flat_in_future_property.php?current_dates=` → `addFlat` → `underflat_futureproperty`
- plus `OwnerCallService.fetchDueCallsResolved` → `ownerCall` (not date-scoped — every due call shows on every date)

**Polling**: `AllFlats`, `UserFlat`, `AddFlats` each wrap every row in `StreamBuilder(Stream.periodic(5s))` hitting `Count_api_flat_under_future_property_by_cctv?CCTV={P_id}` to drive a red dot — one request per visible row every 5 seconds.

No local/scheduled notifications, no snooze, no server-side reminder scheduling.

---

## 6. Admin vs FieldWorker differences

| | FieldWorker | Administrator |
|---|---|---|
| **Write access** | full CRUD | **none** — no POST/multipart in the whole admin future tree |
| **Tabs** | 4 (Buildings, Plots, Commercial, History) | 3 (Building, Plot, Commercial); History lives behind "See All →" instead |
| **FAB / add forms** | "Add Forms" bottom sheet | none |
| **List shape** | flat list of own buildings | buildings **grouped by fieldworker** from a hardcoded 5-person roster, horizontally scrolled, with "See All →" per worker |
| **Scoping** | own `number` from prefs | hardcoded roster ∩ cached `location`, bypassed when `post == "administrator"` |
| **Pagination** | infinite scroll | grouped view loads per-worker in full; `SeeAll_FutureProperty` paginates |
| **Search** | server-side, every keystroke | server-side on See-All only; the grouped landing view has no search |
| **Filters** | 8 chips | same 8 on See-All; none on the grouped view |
| **Flat fetch on building detail** | `show_api_building_flat.php?subid=` — one call, grouped by floor, **any number of floors** | 8 separate ASMX calls (`frist_/second_/third_floor_base_show_mainrealestae`), **G through 7th Floor only** — floors 8–10 are invisible to admin even though the add form offers them. Floors 3–7 all reuse `third_floor_base_show_mainrealestae` with a different `Floor_` param. |
| **Images on building detail** | `show_multiple_image_in_future_property.php` (JSON `{success, data[].dimage}`) | `display_future_property_addimages_by_subid_` (ASMX, `item['img']`) |
| **Flat detail** | status buttons, Add Tenant FAB, Edit Flat / Add Flat Images menu | view-only; only a Yes/No call dialog |
| **Upcoming detail** | `UpcomingDetailsPage` — "Update Available Date" + "Go to Building" | `AdminUpcomingDetails` — neither button; also missing Kitchen/Bathroom rows and the Nearby-Localities chips the FW version shows; duplicates the label "Metro Distance" for both `metro_distance` and `highway_distance` |
| **Deep links** | none routed | all four FCM families route here, with flat highlighting |
| **Sub Administrator** | — | gets the admin Upcoming screen **plus** the fieldworker Future Property / Upcoming screens, i.e. full write access through the "(Field)" tiles |

### Divergences worth a ticket

1. Admin building detail is capped at 8 floors and on the legacy per-floor API; field side is on the newer grouped one.
2. Three separate hardcoded fieldworker rosters (`Administater_Future_Property.dart`, `Administater_Plot.dart`/`Administater_Commercial.dart`, `All_flats.dart`) that don't agree — `All_flats` knows `abhay`/`manish`, the admin screens don't.
3. The upcoming "Remove" delete keys on `subid` while the live "Rent out" delete keys on `source_id`.
4. `metro_distance` / `highway_distance` are populated from swapped sources in `add_flat_form.dart`.
5. `locality_list` is hardcoded `"Sultanpur"` on both building create and update.
6. `Apartment_name` doubles as the furniture-list field; `task_feed_service.dart` already carries a comment about this breaking task cards.
7. ~17,000 lines of unreachable code in this feature (`old_future_detailpage.dart`, `Move_To_PropertyVerification.dart`, `Edit_Building.dart`, `Upcoming_update.dart`, plus the `your-api.com` stubs).
8. Admin's read-only posture is UI-only — consistent with the repo-wide absence of server-side auth, so nothing stops a modified client from calling the write endpoints.
