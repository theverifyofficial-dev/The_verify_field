# Rent Agreement Module — Flow & Structure Analysis

*The_verify_field · `lib/Rent Agreement/` · analyzed 2026-09-26*

## Summary of current state

The Rent Agreement module is the largest in the app — 8 field-worker-facing wizard screens (~29,900 lines combined) plus a separate admin-side approval/PDF tree. Seven of the eight wizards (everything except Police Verification) follow the same 4-step shape: Owner → Tenant(s) → Property → Preview/Submit. That shared shape is good news structurally, but it was built by copying one file into the next seven times rather than factoring out shared code, so the module now carries the same logic (pricing tables, API URLs, validation helpers, UI widgets) duplicated 6-8 times over. That copy-paste history has already produced real, user-facing bugs — not just theoretical tech debt — including a wizard whose Submit button is one tap harder to reach than it should be, a whole agreement type that cannot be edited after rejection, and a status/rejection screen that silently hides itself for one agreement type depending on which tab the field worker came from. Renewal is also not one flow but three independently-coded ones, two of which can quote a stale price. None of this is visible from the UI — it only surfaces as confusing dead ends for field workers and admins.

## 1. Overall organization and logical flow

- **8 entry points, 1:1 with 8 files.** `Dashboard_screen.dart`'s `AgreementDashboard` groups them into "Rental Agreements" (Rental, External Rental, Renewal), "Commercial Agreements" (Commercial, External Commercial), and "Other Services" (Furnished Company, Furnished Owner, Police Verification).
- **Shared 4-step wizard** (Owner details incl. Aadhaar photos → Tenant/Director block(s) → Property details incl. rent/deposit/maintenance/parking/meter → Preview → Submit) is used by Rental, External Rental, Commercial, External Commercial, Furnished Company, Furnished Owner, and Renewal.
- **Police Verification is correctly a 3-step exception** (Owner → Tenant → Preview, no Property step) since it collects no rent/deposit data — a deliberate, well-executed difference, not an inconsistency.
- **Renewal is not one flow.** It's three separately-coded submission paths that all end up posting to the same `agreement.php` endpoint with no ID linking the new record back to the original:
  1. A blank full wizard opened from the Dashboard (`Renewal_form.dart`).
  2. A quick-renew bottom sheet off the "renewing in 30 days" feed, which copies the entire original agreement's fields forward with only rent/date overridden.
  3. A near-identical quick-renew bottom sheet off the "already expired" feed — essentially the same ~130-line field map duplicated a second time.
- **Two parallel "view agreement detail" screens exist for the same job**: one reached from the Pending tab and push-notification links, one reached from the Final tab and the Target/Tasks screen. They don't share an implementation and — as detailed below — don't behave identically.

## 2. Structural elements

- **Pricing and notary-fee tables are copy-pasted into all 8 form files**, not centralized: the same tiered notary table (10/20/50/100 agreements → ₹150/170/200/250 non-discounted or ₹100/120/150/200 discounted) and the same `convertToWords()` helper appear identically in every file. A change to one tier requires editing all 8, with no safeguard against them drifting apart.
- **API endpoint URLs are hardcoded per file** — the create/update endpoints appear as literal strings 24+ times across the module rather than as a shared constant.
- **Shared-looking widgets are actually redefined per file**: `BuildingSuggestion`, `FlatSuggestion`, and the gradient submit button are each their own class inside every one of the 8 files, not a shared component.
- **The "tenant" data class is named differently in each file for the same shape** (`TenantBlock`, `ExtraTenant`, `DirectorBlock`) — cosmetic, but it makes the duplication harder to spot and to eventually consolidate.
- **`Renewal_form.dart` has a fragile hidden dependency**: rather than defining its own data classes, it imports pieces from two sibling 4,000+-line files (one with a name collision it works around via `hide`). A refactor inside either sibling can silently break Renewal with no compiler warning.
- **No state-management library is used anywhere in this module** (no Provider/GetX) — it's `StatefulWidget` + `setState` throughout, consistent with the rest of the app.

## 3. Layout and formatting consistency

- All 8 Dashboard entry buttons share the same purple circular icon background, differentiated only by icon glyph and label text. **"Furnished Company" and "Furnished Owner" use the identical icon**, so those two of the eight buttons are visually indistinguishable except by reading the text — a real risk for field workers with lower literacy, the same usability concern this session already addressed elsewhere in the app (Add/Edit Building & Flat forms).
- The label " External Commercial" has a stray leading space in the Dashboard — minor but visible.
- No Hinglish or vernacular text exists anywhere in this module; it's English-only throughout, unlike the recent redesign work done on the Future Property forms.
- Field validation (mobile number pattern, Aadhaar/VID pattern, required-field checks) is substantively consistent across all 8 forms in outcome, but inconsistent in mechanism — some forms use Flutter's built-in `Form`/validator plumbing, others run the same regex checks manually outside of it. Functionally harmless today, but it means a future validation-rule change has to be applied twice, in two different styles.

## 4. Clarity and coherence of language

- Field labels and step names are plain and consistent with each other across the 7 shared-shape wizards — no naming confusion between screens once you're inside a form.
- The confusion is at the *entry point*, not inside the forms: nothing on the Dashboard explains the real-world difference between "Rental" vs "External Rental" or "Furnished Company" vs "Furnished Owner" to a field worker deciding which of 8 buttons to tap.
- Internal code comments in a couple of the renewal/list files are in Hinglish (developer comments, not user-facing) — harmless, just worth knowing it's developer shorthand rather than a deliberate localization choice.

## 5. Redundancies, gaps, and ambiguities (verified against the live code)

1. **Furnished Company form is one tap harder to submit than it should be.** Its step list only has 3 pages (Tenant → Property → Preview), but the Submit/Update button — and the "next step" boundary — is wired to trigger on step index 3, which doesn't exist on this screen. A field worker on the Preview page has to tap "Next" once first (which does nothing visible) before the button turns into "Submit". The sibling "Furnished Owner" form doesn't have this problem because it genuinely has 4 pages.
2. **A rejected "Furnished Owner" agreement can't be edited and resubmitted.** The shared edit-routing logic matches agreement types by checking for the text "furnished agreement" — which matches "Furnished Company" but not the literal type string this form actually submits, "Furnished by Owner". A field worker trying to fix and resubmit a rejected Furnished-Owner agreement hits an "Unknown agreement type" message and a dead end.
3. **Furnished forms have no Police Verification option at all.** Both Furnished wizards support only a single tenant with no "include police verification" flag or charge line, unlike all 6 other wizards. If that's intentional, it isn't documented anywhere as a deliberate limitation.
4. **Police Verification's status and rejection reason disappear depending on which screen you view it from.** One of the two "agreement detail" screens hides the entire status/rejection card for Police Verification submissions (and has a "police residential address" section commented out entirely); the other detail screen shows status normally for the same agreement type. The same real submission looks different — or invisible — depending only on navigation path (Pending tab/notification vs. Final tab).
5. **The two "hide already-renewed agreements" filters silently disagree.** The "renewing in 30 days" list computes a proper date comparison and then ignores it, falling back to "hide if any renewal date exists at all" (even a stale/invalid one) — dead code sitting next to the real logic. The "already expired" list's equivalent filter does the date comparison correctly. Same intent, two different real-world behaviors.
6. **Two of the three renewal paths can quote a stale price.** The blank Renewal wizard recalculates the current discount/price fresh. The two quick-renew bottom sheets instead copy the *original* agreement's stored price forward unchanged. Two field workers renewing on the same day, at the same current discount tier, could see different prices purely based on which of the three entry points they used.
7. **Aadhaar masking protects the printed number but not the photo.** The admin PDF's privacy toggle masks the Aadhaar number when it's printed as text, but the scanned Aadhaar card photos (which show the full number, name, and photo anyway) are embedded on their own PDF page completely unmasked regardless of that same toggle — so the privacy control gives materially less protection than its name implies. (The module's two other PDF generators, for Commercial and Furnished agreements, weren't checked for the same gap and are worth a quick look.)
8. **Pricing isn't uniform across agreement types** in the way the Dashboard's single discount rule might suggest: Police Verification uses its own, much lower base price (₹40/₹50) than every other agreement type (₹100/₹150) — correct as designed, but easy to forget when reasoning about "the" agreement price.

## Recommendations

Ranked roughly by user-facing impact vs. effort to fix:

1. **Fix the Furnished Company step-index bug** (item 1) — a one-line boundary-condition fix (align the "last step" check with the real 3-page count, the way Furnish_owner.dart already does it correctly). Small, safe, immediately removes a confusing extra tap for every field worker submitting this form type.
2. **Add the missing "Furnished by Owner" branch to the edit-routing logic** (item 2) — a one-condition addition so rejected Furnished-Owner agreements can actually be corrected and resubmitted instead of dead-ending.
3. **Make the two "already renewed" filters agree** (item 5) — replace the dead-code branch in the 30-day feed with the same date comparison already used correctly in the expired feed.
4. **Decide, deliberately, whether Police Verification should show status/rejection consistently** across both detail screens (item 4) — today it's an accident of which screen was built later, not a deliberate design choice. Whichever behavior is correct should be the same in both places.
5. **Decide whether Furnished agreements should support Police Verification** (item 3) and either add it for consistency with the other 6 wizards, or document that it's intentionally excluded.
6. **Reconcile renewal pricing so it doesn't depend on entry point** (item 6) — either have the quick-renew paths recompute the current discount like the blank wizard does, or make it an explicit, documented choice that renewals always keep the original price.
7. **Extend Aadhaar masking to the embedded card photos, not just the printed number** (item 7) — likely the single highest-impact privacy fix in the module; worth checking the Commercial and Furnished PDF generators for the same gap while in there.
8. **Centralize the notary/pricing table and the API endpoint strings** into one shared file that all 8 forms import, rather than 8 copies of each. This doesn't change behavior today, but every one of items 1-6 above lives inside code that's currently duplicated 6-8 times — centralizing first would make future fixes single-edit instead of eight-edit, and prevent the next accidental divergence.
9. **Differentiate the "Furnished Company" and "Furnished Owner" Dashboard icons**, and consider adding short Hinglish subcaptions to all 8 Dashboard entries (matching the pattern already applied this session to the Future Property forms) — a field worker choosing between 8 similarly-styled buttons is exactly the low-literacy usability gap this session has been addressing elsewhere in the app.
10. **Longer-term**, consider consolidating the two parallel "agreement detail" screens and the near-duplicate renewal quick-renew screens into one implementation each — this is the same "copy instead of share" pattern already flagged for the forms themselves, and it's why bugs like #4 and #5 can exist in the first place: two implementations of "the same screen" inevitably drift.

*No code was changed as part of this analysis — this is a read-only report, per your request. Flutter's own compiler/analyzer isn't available in this environment, so file/line references above should be re-confirmed by opening the cited files before any fix is scheduled.*
