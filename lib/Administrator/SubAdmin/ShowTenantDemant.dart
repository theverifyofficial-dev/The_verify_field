import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowTenantDemandPage extends StatefulWidget {

  const ShowTenantDemandPage({super.key});

  @override
  State<ShowTenantDemandPage> createState() => _ShowTenantDemandPageState();
}

class _ShowTenantDemandPageState extends State<ShowTenantDemandPage> {
  bool isLoading = true;
  bool isError = false;
  String errorMessage = '';
  List<ShowTenantDemand> demands = [];
  String _searchQuery = '';
  DemandStatus? _selectedStatus;

  // Color scheme for light/dark mode
  final ColorScheme _colorScheme = ColorScheme(
    primary: Color(0xFF2563EB),    // Professional blue
    primaryContainer: Color(0xFFDBEAFE),
    secondary: Color(0xFF64748B),   // Slate gray
    secondaryContainer: Color(0xFFF1F5F9),
    surface: Colors.white,
    background: Color(0xFFF8FAFC),  // Light gray background
    error: Color(0xFFDC2626),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF0F172A),   // Dark text
    onBackground: Color(0xFF0F172A),
    onError: Colors.white,
    brightness: Brightness.light,
  );

  final ColorScheme _darkColorScheme = ColorScheme(
    primary: Color(0xFF3B82F6),     // Brighter blue for dark mode
    primaryContainer: Color(0xFF1E3A8A),
    secondary: Color(0xFF94A3B8),
    secondaryContainer: Color(0xFF1E293B),
    surface: Color(0xFF1E293B),
    background: Color(0xFF0F172A),  // Dark background
    error: Color(0xFFEF4444),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  );

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;
  ColorScheme get _colors => _isDarkMode ? _darkColorScheme : _colorScheme;

  @override
  void initState() {
    super.initState();
    fetchDemands();
  }

  // ---------------- API CALL ----------------
  Future<void> fetchDemands() async {
    setState(() {
      isLoading = true;
      isError = false;
      errorMessage = '';
    });

    try {
      final url = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_tenant_demand.php");

      final response = await http.get(url).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          demands = decoded.map<ShowTenantDemand>((e) => ShowTenantDemand.fromJson(e)).toList();
        } else if (decoded is Map && decoded['data'] is List) {
          demands = (decoded['data'] as List).map<ShowTenantDemand>((e) => ShowTenantDemand.fromJson(e)).toList();
        } else {
          final maybeList = json.decode(response.body);
          if (maybeList is List) {
            demands = maybeList.map<ShowTenantDemand>((e) => ShowTenantDemand.fromJson(e)).toList();
          } else {
            demands = [];
          }
        }
      } else {
        isError = true;
        errorMessage = "Server returned ${response.statusCode}";
      }
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  List<ShowTenantDemand> get _filteredDemands {
    return demands.where((demand) {
      final matchesSearch = _searchQuery.isEmpty ||
          demand.tname.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          demand.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          demand.reference.displayName.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _selectedStatus == null || demand.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          _buildHeader(),
          // Search and Filters
          _buildSearchAndFilters(),
          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchDemands,
              backgroundColor: _colors.surface,
              color: _colors.primary,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, bottom: 24, left: 24, right: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isDarkMode
              ? [Colors.black26,Colors.black38]  // Dark blue gradient
              : [Color(0xFF2563EB), Color(0xFF3B82F6)], // Light blue gradient
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isDarkMode ? 0.3 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(CupertinoIcons.left_chevron,color: Colors.white,))),
                Text(
                  'Tenant Demands',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: fetchDemands,
                  icon: Icon(Icons.refresh, color: Colors.white, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    final newCount = demands.where((d) => d.status == DemandStatus.newStatus).length;
    final assignedCount = demands.where((d) => d.status == DemandStatus.assigned).length;
    final totalCount = demands.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(totalCount.toString(), 'Total', Colors.white),
        _buildStatItem(newCount.toString(), 'New', Colors.white),
        _buildStatItem(assignedCount.toString(), 'Assigned', Colors.white),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Box
          Container(
            decoration: BoxDecoration(
              color:_isDarkMode?Colors.white10:
              _colors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isDarkMode ? 0.2 : 0.30),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(color: _colors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search demands...',
                hintStyle: TextStyle(color: _colors.onSurface.withOpacity(0.6)),
                prefixIcon: Icon(Icons.search, color: _colors.onSurface.withOpacity(0.6)),
                border: InputBorder.none,

                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Status Filters
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatusFilter('All', null),
                _buildStatusFilter('New', DemandStatus.newStatus),
                _buildStatusFilter('Assigned', DemandStatus.assigned),
                _buildStatusFilter('In Progress', DemandStatus.inProgress),
                _buildStatusFilter('Completed', DemandStatus.completed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(String label, DemandStatus? status) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _colors.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (bool value) {
          setState(() {
            _selectedStatus = value ? status : null;
          });
        },
        backgroundColor: _colors.surface,
        selectedColor: _colors.primary,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? _colors.primary : _colors.secondary.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_colors.primary),
        ),
      );
    }

    if (isError) {
      return _buildErrorState();
    }

    if (_filteredDemands.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredDemands.length,
      itemBuilder: (context, index) {
        return _buildDemandCard(_filteredDemands[index]);
      },
    );
  }

  Widget _buildErrorState() {
    return ListView(
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.error_outline,
          size: 64,
          color: _colors.error,
        ),
        const SizedBox(height: 16),
        Text(
          'Something went wrong',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: _colors.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _colors.onBackground.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ElevatedButton.icon(
            onPressed: fetchDemands,
            style: ElevatedButton.styleFrom(
              backgroundColor: _colors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.search_off,
          size: 64,
          color: _colors.onBackground.withOpacity(0.3),
        ),
        const SizedBox(height: 16),
        Text(
          _searchQuery.isNotEmpty || _selectedStatus != null
              ? "No matching demands found"
              : "No demands available",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: _colors.onBackground.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _searchQuery.isNotEmpty || _selectedStatus != null
              ? "Try adjusting your filters"
              : "Pull down to refresh",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: _colors.onBackground.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildDemandCard(ShowTenantDemand demand) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: _isDarkMode ? 2 : 4,
      color:_isDarkMode?Colors.white10:
      _colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     _colors.surface,
          //     _isDarkMode
          //         ? _colors.secondaryContainer
          //         : demand.status.color.withOpacity(0.1),
          //   ],
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DEMAND #${demand.id}',
                    style: TextStyle(
                      color: _colors.onSurface.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  _buildStatusBadge(demand.status),
                ],
              ),
              const SizedBox(height: 16),
              // Tenant Info
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isDarkMode
                            ? [Color(0xFF3B82F6), Color(0xFF1E40AF)]
                            : [Color(0xFF2563EB), Color(0xFF3B82F6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        demand.tname.isNotEmpty
                            ? demand.tname.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demand.tname,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          demand.tnumber,
                          style: TextStyle(
                            color: _colors.onSurface.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    demand.demandType.icon,
                    color: _colors.primary,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Demand Details Grid
              _buildDetailsGrid(demand),
              const SizedBox(height: 16),
              // Message
              if (demand.message.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isDarkMode
                        ? _colors.secondaryContainer
                        : _colors.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _colors.secondary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    demand.message,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: _colors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Footer
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: _colors.onSurface.withOpacity(0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          demand.formattedDate,
                          style: TextStyle(
                            color: _colors.onSurface.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          demand.reference.icon,
                          size: 16,
                          color: _colors.onSurface.withOpacity(0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          demand.reference.displayName,
                          style: TextStyle(
                            color: _colors.onSurface.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(DemandStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(_isDarkMode ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: status.color),
          const SizedBox(width: 6),
          Text(
            status.displayName,
            style: TextStyle(
              color: status.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(ShowTenantDemand demand) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDarkMode ? _colors.secondaryContainer : _colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _colors.secondary.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow('Type', demand.demandType.displayName, Icons.category),
          _buildDetailRow('Location', demand.location, Icons.location_on),
          _buildDetailRow('BHK', demand.bhk.displayText, Icons.apartment),
          _buildDetailRow('Price', demand.price.formattedRange, Icons.attach_money),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: _colors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: _colors.onSurface.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _colors.onSurface,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// Keep your existing model classes (ShowTenantDemand, enums, PriceRange, BhkRange) exactly as before
// ... [Your existing model classes remain unchanged] ...

// ------------------------------------------------------
// MODEL (Keep your existing model classes)
// ------------------------------------------------------

class ShowTenantDemand {
  final String id;
  final String tname;
  final String tnumber;
  final String buyRentRaw;
  final String referenceRaw;
  final PriceRange price;
  final String message;
  final BhkRange bhk;
  final String location;
  final String statusRaw;
  final bool mark;
  final DateTime? createdDate;

  ShowTenantDemand({
    required this.id,
    required this.tname,
    required this.tnumber,
    required this.buyRentRaw,
    required this.referenceRaw,
    required this.price,
    required this.message,
    required this.bhk,
    required this.location,
    required this.statusRaw,
    required this.mark,
    required this.createdDate,
  });

  factory ShowTenantDemand.fromJson(Map<String, dynamic> j) {
    return ShowTenantDemand(
      id: j['id']?.toString() ?? '',
      tname: j['Tname']?.toString() ?? '',
      tnumber: j['Tnumber']?.toString() ?? '',
      buyRentRaw: j['Buy_rent']?.toString() ?? '',
      referenceRaw: j['Reference']?.toString() ?? '',
      price: PriceRange.fromString(j['Price']?.toString() ?? ''),
      message: j['Message']?.toString() ?? '',
      bhk: BhkRange.fromString(j['Bhk']?.toString() ?? ''),
      location: j['Location']?.toString() ?? '',
      statusRaw: j['Status']?.toString() ?? '',
      mark: (j['mark']?.toString() == "1"),
      createdDate: DateTime.tryParse(j['created_date']?.toString() ?? ''),
    );
  }

  DemandStatus get status => DemandStatus.fromString(statusRaw);
  DemandType get demandType => DemandType.fromString(buyRentRaw);
  ReferenceSource get reference => ReferenceSource.fromString(referenceRaw);

  String get formattedDate {
    final d = createdDate ?? DateTime.now();
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }
}

enum DemandType { buy, rent, unknown
  ;
  static DemandType fromString(String s) {
    final lower = s.toLowerCase();
    if (lower.contains('buy')) return DemandType.buy;
    if (lower.contains('rent')) return DemandType.rent;
    return DemandType.unknown;
  }

  String get displayName {
    switch (this) {
      case DemandType.buy:
        return 'Buy';
      case DemandType.rent:
        return 'Rent';
      default:
        return 'Unknown';
    }
  }

  IconData get icon {
    switch (this) {
      case DemandType.buy:
        return Icons.shopping_bag_outlined;
      case DemandType.rent:
        return Icons.house_outlined;
      default:
        return Icons.help_outline;
    }
  }
}

enum DemandStatus { newStatus, assigned, inProgress, completed, cancelled, unknown
  ;
  static DemandStatus fromString(String s) {
    final lower = s.toLowerCase();
    if (lower.contains('new')) return DemandStatus.newStatus;
    if (lower.contains('assigned')) return DemandStatus.assigned;
    if (lower.contains('progress')) return DemandStatus.inProgress;
    if (lower.contains('completed')) return DemandStatus.completed;
    if (lower.contains('cancel')) return DemandStatus.cancelled;
    return DemandStatus.unknown;
  }

  String get displayName {
    switch (this) {
      case DemandStatus.newStatus:
        return 'New';
      case DemandStatus.assigned:
        return 'Assigned';
      case DemandStatus.inProgress:
        return 'In Progress';
      case DemandStatus.completed:
        return 'Completed';
      case DemandStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Color get color {
    switch (this) {
      case DemandStatus.newStatus:
        return Colors.blue;
      case DemandStatus.assigned:
        return Colors.orange;
      case DemandStatus.inProgress:
        return Colors.purple;
      case DemandStatus.completed:
        return Colors.green;
      case DemandStatus.cancelled:
        return Colors.red;
      default:
        return
          Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case DemandStatus.newStatus:
        return Icons.fiber_new;
      case DemandStatus.assigned:
        return Icons.assignment_turned_in;
      case DemandStatus.inProgress:
        return Icons.timelapse;
      case DemandStatus.completed:
        return Icons.check_circle;
      case DemandStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}

enum ReferenceSource { website, instagram, housing, other
  ;
  static ReferenceSource fromString(String s) {
    final lower = s.toLowerCase();
    if (lower.contains('website')) return ReferenceSource.website;
    if (lower.contains('insta')) return ReferenceSource.instagram;
    if (lower.contains('housing')) return ReferenceSource.housing;
    return ReferenceSource.other;
  }

  String get displayName {
    switch (this) {
      case ReferenceSource.website:
        return 'Website';
      case ReferenceSource.instagram:
        return 'Instagram';
      case ReferenceSource.housing:
        return 'Housing';
      default:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ReferenceSource.website:
        return Icons.language;
      case ReferenceSource.instagram:
        return Icons.camera_alt;
      case ReferenceSource.housing:
        return Icons.apartment;
      default:
        return Icons.more_horiz;
    }
  }
}

class PriceRange {
  final double min;
  final double max;

  PriceRange(this.min, this.max);

  factory PriceRange.fromString(String s) {
    try {
      if (s.trim().isEmpty) return PriceRange(0, 0);
      final parts = s.split("-");
      final a = double.tryParse(parts[0].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      final b = parts.length > 1 ? double.tryParse(parts[1].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0 : a;
      return PriceRange(a, b);
    } catch (_) {
      return PriceRange(0, 0);
    }
  }

  String get formattedRange {
    if (min == 0 && max == 0) return 'Not specified';
    if (min == max) return '₹${min.toInt()}';
    return '₹${min.toInt()} - ₹${max.toInt()}';
  }
}

class BhkRange {
  final int min;
  final int max;

  BhkRange(this.min, this.max);

  factory BhkRange.fromString(String s) {
    try {
      if (s.trim().isEmpty) return BhkRange(1, 1);
      final parts = s.split("-");
      final a = int.tryParse(parts[0]) ?? 1;
      final b = parts.length > 1 ? int.tryParse(parts[1]) ?? a : a;
      return BhkRange(a, b);
    } catch (_) {
      return BhkRange(1, 1);
    }
  }

  String get displayText {
    if (min == max) return '$min BHK';
    return '$min-$max BHK';
  }
}