import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../Custom_Widget/constant.dart';
/// ---------------------------------------------------------------
/// Dark theme palette — same accent colors used on the Login /
/// Create Account screens.
/// ---------------------------------------------------------------
class _AppColors {
  static const primary = Color.fromRGBO(143, 148, 251, 1);
  static const bg = Colors.black;
  static const cardBg = Colors.white12;
  static const cardBorder = Colors.white24;
  static const textGrey = Color(0xFF9A9AA5);
  static const approved = Color(0xFF3DDC84);
  static const pending = Color(0xFFFFA726);
  static const rejected = Color(0xFFFF5C5C);
}

class FieldAgentAccount {
  final String id;
  final String fName;
  final String fEmail;
  final String fNumber;
  final String fAadharCard;
  final String fLocation;
  String status; // mutable so the UI can update instantly after action

  FieldAgentAccount({
    required this.id,
    required this.fName,
    required this.fEmail,
    required this.fNumber,
    required this.fAadharCard,
    required this.fLocation,
    required this.status,
  });

  factory FieldAgentAccount.fromJson(Map<String, dynamic> json) {
    return FieldAgentAccount(
      id: json["id"]?.toString() ?? "",
      fName: json["FName"]?.toString() ?? "",
      fEmail: json["FEmail"]?.toString() ?? "",
      fNumber: json["FNumber"]?.toString() ?? "",
      fAadharCard: json["FAadharCard"]?.toString() ?? "",
      fLocation: json["F_Location"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
    );
  }

  String get normalizedStatus => status.trim().toLowerCase();
}

class AdminAccountsScreen extends StatefulWidget {
  const AdminAccountsScreen({super.key});

  @override
  State<AdminAccountsScreen> createState() => _AdminAccountsScreenState();
}

class _AdminAccountsScreenState extends State<AdminAccountsScreen> {
  static const String _listApi =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Field%20Application/show_app_register_account_for_admin.php";

  static const String _updateApi =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/register_status_update_api.php";

  List<FieldAgentAccount> _accounts = [];
  bool _isLoading = true;
  bool _hasError = false;

  // id currently being accepted/rejected -> disables its buttons only
  String? _updatingId;

  @override
  void initState() {
    super.initState();
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http
          .get(Uri.parse(_listApi))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception("Server error (${response.statusCode})");
      }

      final List decoded = jsonDecode(response.body);
      final accounts =
      decoded.map((e) => FieldAgentAccount.fromJson(e)).toList();

      // Newest to oldest — by numeric id, falling back to string compare.
      accounts.sort((a, b) {
        final idA = int.tryParse(a.id);
        final idB = int.tryParse(b.id);
        if (idA != null && idB != null) return idB.compareTo(idA);
        return b.id.compareTo(a.id);
      });

      if (!mounted) return;
      setState(() {
        _accounts = accounts;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _updateStatus(FieldAgentAccount account, String newStatus) async {
    setState(() => _updatingId = account.id);

    try {
      final response = await http.post(
        Uri.parse(_updateApi),
        body: {
          "id": account.id,
          "status": newStatus,
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          account.status = newStatus;
        });
        Fluttertoast.showToast(
          msg: newStatus == "Approved"
              ? "${account.fName} approved"
              : "${account.fName} rejected",
          backgroundColor:
          newStatus == "Approved" ? Colors.green : Colors.red,
          textColor: Colors.white,
        );
      } else {
        throw Exception("Server error (${response.statusCode})");
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't update status: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    if (mounted) {
      setState(() => _updatingId = null);
    }
  }

  Color _statusColor(String normalized) {
    if (normalized == "approved") return _AppColors.approved;
    if (normalized == "rejected" || normalized == "reject") {
      return _AppColors.rejected;
    }
    return _AppColors.pending; // pending / inreview / anything else
  }

  String _statusLabel(String normalized) {
    if (normalized == "approved") return "Approved";
    if (normalized == "rejected" || normalized == "reject") return "Rejected";
    return "Pending";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.bg,
        appBar: AppBar(
          surfaceTintColor: Colors.black,
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 5,
          title: Image.asset(
              AppImages.verify, height: 75),
          leading: InkWell(
            onTap: () => Navigator.pop(context, true),
            child: const Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
              ],
            ),
          ),
        ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: _AppColors.primary),
      );
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              const Text(
                "Couldn't load applications",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: fetchAccounts,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (_accounts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, color: Colors.grey[600], size: 44),
            const SizedBox(height: 12),
            Text(
              "No applications yet",
              style: TextStyle(color: Colors.grey[400], fontSize: 15),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _AppColors.primary,
      backgroundColor: Colors.grey[900],
      onRefresh: fetchAccounts,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        itemCount: _accounts.length,
        itemBuilder: (context, index) {
          return _AccountCard(
            account: _accounts[index],
            isUpdating: _updatingId == _accounts[index].id,
            statusColor: _statusColor(_accounts[index].normalizedStatus),
            statusLabel: _statusLabel(_accounts[index].normalizedStatus),
            onAccept: () => _updateStatus(_accounts[index], "Approved"),
            onReject: () => _updateStatus(_accounts[index], "Rejected"),
          );
        },
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final FieldAgentAccount account;
  final bool isUpdating;
  final Color statusColor;
  final String statusLabel;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _AccountCard({
    required this.account,
    required this.isUpdating,
    required this.statusColor,
    required this.statusLabel,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = account.normalizedStatus != "approved" &&
        account.normalizedStatus != "rejected" &&
        account.normalizedStatus != "reject";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _AppColors.primary.withOpacity(0.18),
                child: Text(
                  account.fName.isNotEmpty
                      ? account.fName.trim()[0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    color: _AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.fName.isEmpty ? "Unnamed" : account.fName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "#${account.id}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.6)),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Divider(color: Colors.white.withOpacity(0.08), height: 1),
          const SizedBox(height: 14),

          _infoRow(Icons.phone_outlined, account.fNumber),
          const SizedBox(height: 8),
          _infoRow(Icons.email_outlined, account.fEmail),
          const SizedBox(height: 8),
          _infoRow(Icons.location_on_outlined, account.fLocation),

          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _AppColors.rejected,
                        side: BorderSide(
                            color: _AppColors.rejected.withOpacity(0.6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isUpdating ? null : onReject,
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text("Reject"),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _AppColors.approved,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isUpdating ? null : onAccept,
                      icon: isUpdating
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                          : const Icon(Icons.check, size: 18),
                      label: const Text("Accept"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _AppColors.textGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}