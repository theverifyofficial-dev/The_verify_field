import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Administrator/Admin_profile.dart';
import '../Administrator/Administrator_HomeScreen.dart';
import '../Administrator/SubAdmin/SubAdminAccountant_Home.dart';
import '../Home_Screen.dart';
import '../Network_Map/Admin_Network_Map_Page.dart';
import '../Network_Map/Network_Map_Page.dart';
import '../Z-Screen/Login_page.dart';
import '../Z-Screen/profile.dart';
import '../ui_decoration_tools/app_images.dart';

/// The three roles this shell knows how to build tabs for. Deliberately
/// does NOT cover "Editor" -- that role keeps its own separate
/// `VideoHomepage` flow untouched, exactly as it worked before this
/// bottom-nav feature existed (see `Login_page.dart` / `splash.dart`,
/// whose Editor branches were left alone).
enum AppRole { administrator, subAdministrator, fieldWorker }

/// Persistent bottom-navigation shell shared by all three roles:
/// Home / Map / Profile, with each tab's actual screen chosen by [role].
/// Every existing per-role Home/Map/Profile screen is reused completely
/// unchanged (just relocated into a tab) -- this file adds navigation,
/// it does not re-implement any screen.
///
/// There used to be a 4th "Leads" tab here too. It was removed by
/// explicit request -- Leads/Demand functionality moved back to living
/// on each role's Home screen exactly as it did before this feature
/// existed (see the Leads tiles restored in `Home_Screen.dart`,
/// `Administrator_HomeScreen.dart`, and `SubAdminAccountant_Home.dart`).
/// Don't re-add a Leads tab without also removing those tiles again.
///
/// The bar itself is a custom "premium" design (floating rounded card,
/// animated purple highlight pill behind the selected icon) rather than
/// the stock `BottomNavigationBar`, using the app's own full-color
/// illustration assets (`AppImages.home` / `.mapPin` / `.man`) in place
/// of Material icons. Those images are full-color flat illustrations,
/// not monochrome glyphs, so they are drawn untinted -- the "selected"
/// state is communicated by the pill background, the label color/weight,
/// and a small scale animation, not by recoloring the artwork itself.
///
/// Reached today only via the three named routes in
/// `Notification_demo/routes.dart` (`Home_Screen.route`,
/// `AdministratorHome_Screen.route`, `SubAdminHomeScreen.route`), each of
/// which hardcodes the matching, already-validated [role] -- so in
/// practice this widget is never built with a role that doesn't match an
/// already-approved login. The defensive checks below exist for the
/// future/edge case (corrupted local storage, a role string that no
/// longer matches any case below) rather than for the normal happy path.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.role});

  final AppRole role;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const int _tabCount = 3; // Home, Map, Profile

  int _selectedIndex = 0;

  /// Lazily-built tab widgets. `null` until a tab has been visited once,
  /// then kept alive for the rest of this shell's lifetime (so switching
  /// tabs preserves scroll position / in-progress state the same way the
  /// old "push a new screen" navigation effectively did while that screen
  /// stayed on the stack) -- but NOT built eagerly on first frame, so a
  /// tab's screen doesn't fire its network calls until the user actually
  /// opens it, matching the old lazy on-tap-navigate behavior.
  late final List<Widget?> _tabs = List<Widget?>.filled(_tabCount, null);

  @override
  void initState() {
    super.initState();
    _validateSession();
  }

  /// Minimal sanity check: a logged-in user always has a saved
  /// `number` (see `Login_page.dart`). If that's missing here, local
  /// storage is in a state this shell doesn't know how to render --
  /// fall back to logging out rather than showing a broken screen.
  Future<void> _validateSession() async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getString('number');
    if ((number == null || number.isEmpty) && mounted) {
      _logoutToLogin();
    }
  }

  void _logoutToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.reset();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Login_page()),
      (route) => false,
    );
  }

  /// Builds (and from then on caches) the real screen for [index] only
  /// once that tab has actually been selected at least once -- so an
  /// unvisited tab stays a cheap placeholder and never fires its screen's
  /// network calls, matching the old "nothing loads until you tap into
  /// it" behavior. Once built, a tab's widget is kept alive for the rest
  /// of this shell's lifetime via `IndexedStack`, so switching away and
  /// back preserves its state.
  Widget _childFor(int index) {
    if (_tabs[index] == null && index == _selectedIndex) {
      _tabs[index] = _tabForRoleAndIndex(widget.role, index);
    }
    return _tabs[index] ?? const SizedBox.shrink();
  }

  Widget _tabForRoleAndIndex(AppRole role, int index) {
    switch (role) {
      case AppRole.administrator:
        switch (index) {
          case 0:
            return const AdministratorHome_Screen();
          case 1:
            return const AdminNetworkMapPage();
          case 2:
            return AdminProfile();
        }
        break;
      case AppRole.subAdministrator:
        switch (index) {
          case 0:
            return const SubAdminHomeScreen();
          // Sub-Admin's home screen has no Network Map entry today --
          // reusing the full Admin map (rather than the field worker's
          // own-buildings-only map) since Sub-Admin is an admin-tier
          // role with the same need to see every field worker's
          // buildings. See the assumptions note shipped with this
          // feature for why.
          case 1:
            return const AdminNetworkMapPage();
          case 2:
            return ProfilePage();
        }
        break;
      case AppRole.fieldWorker:
        switch (index) {
          case 0:
            return const Home_Screen();
          case 1:
            return const NetworkMapPage();
          case 2:
            return ProfilePage();
        }
        break;
    }
    // Unreachable for the known tab indices, but keeps the analyzer
    // happy and gives a safe fallback instead of a crash if this ever
    // gets called with something unexpected.
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(_tabCount, (i) => _childFor(i)),
      ),
      bottomNavigationBar: _PremiumNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

/// Full-width "premium" bottom navigation bar: spans the entire bottom
/// edge of the screen (no floating side margins), with its background
/// following the app's current light/dark theme instead of a hardcoded
/// color, so it reads as part of the screen rather than an opaque card
/// pinned on top of it. Holds the three tab items in a row. Pure Flutter
/// widgets + implicit animations -- no new package dependency.
class _PremiumNavBar extends StatelessWidget {
  const _PremiumNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const List<_NavItemData> _items = [
    _NavItemData(asset: AppImages.home, label: 'Home'),
    _NavItemData(asset: AppImages.mapPin, label: 'Map'),
    _NavItemData(asset: AppImages.man, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Matches this screen's own AppBar/card surface for that theme (see
    // the lightTheme/darkTheme definitions in main.dart) rather than a
    // bar-specific color, so the nav bar blends with whatever's above it
    // instead of standing out as its own floating card.
    final barColor = theme.cardColor;
    final topBorderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.06);

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: barColor,
          border: Border(top: BorderSide(color: topBorderColor, width: 1)),
        ),
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (index) {
              final selected = index == selectedIndex;
              return Expanded(
                child: _NavItem(
                  data: _items[index],
                  selected: selected,
                  isDark: isDark,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.asset, required this.label});
  final String asset;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final _NavItemData data;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Purple selected-pill works on both themes; only its opacity and the
    // unselected label color need to adapt so the bar reads correctly in
    // dark mode too.
    final selectedPillColor = isDark
        ? Colors.purple.withOpacity(0.22)
        : Colors.purple.withOpacity(0.12);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: selected ? 18 : 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selected ? selectedPillColor : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                scale: selected ? 1.12 : 1.0,
                child: Image.asset(
                  data.asset,
                  height: 26,
                  width: 26,
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: selected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          data.label,
                          style: const TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
