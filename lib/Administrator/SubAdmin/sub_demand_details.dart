import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Demand_2/demand_Form.dart';
import '../../model/demand_model.dart';
import '../../utilities/bug_founder_fuction.dart';
import 'Redemand_subadmin.dart';

class SubDemandDetails extends StatefulWidget {
  final String demandId;
  final bool fromNotification;
  const SubDemandDetails({
    super.key, required
    this.demandId,
    this.fromNotification = false,});

  @override
  State<SubDemandDetails> createState() => _SubDemandDetailsState();
}

class _SubDemandDetailsState extends State<SubDemandDetails> {
  Map<String, dynamic>? _demand;
  bool _isLoading = true;
  bool _assigning = false;
  int? _myUserId;
  String? _finalReason;
  bool _isSubmittingFinal = false;
  final TextEditingController _otherReasonCtrl = TextEditingController();
  bool _isDisclosing = false;
  String? _selectedName;
  String? _selectedLocation;
  List<TenantDemandModel> _redemands = [];
  String? _parentId;
  String? _myName;

  final List<String> _nameList = [
    "Faizan Khan",
    "Ravi Kumar",
    "Sumit",
    "avjit"
  ];

  final List<String> _nameList2 = [
    "Manish",
    "Abhay",
  ];

  @override
  void initState() {
    super.initState();
    _fetchDemandDetails();
    _loadUser();
  }



  List<String> get _activeNameList {
    final loc = _demand?["assigned_subadmin_location"]
        ?.toString()
        .toLowerCase() ??
        "";

    return loc.contains("sultanpur") ? _nameList : _nameList2;
  }

  Future<void> _fetchDemandDetails() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}"));

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);



        if (jsonRes["success"] == true &&
            jsonRes["data"] is List &&
            (jsonRes["data"] as List).isNotEmpty) {

          final d = Map<String, dynamic>.from(jsonRes["data"][0]);

          setState(() {
            _demand = d;
            _selectedLocation = d["assigned_subadmin_location"]?.toString() ?? "";
            _isLoading = false;
            _parentId = widget.demandId;
          });
          await _fetchRedemands();
        } else {
          setState(() => _isLoading = false);
          await BugLogger.log(
            apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}",
            error: response.body.toString(),
            statusCode: response.statusCode ?? 0,
          );
        }
      }
      else{
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}",
          error: response.body.toString(),
          statusCode: response.statusCode ?? 0,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching details: $e")),
      );
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}",
        error: e.toString(),
        statusCode: 500,
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchRedemands() async {
    if (_parentId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final subadminName = prefs.getString('name') ?? "";
      final subadminLocation = prefs.getString('location') ?? "";
      print(subadminName);
      print(subadminLocation);

      if (subadminName.isEmpty || subadminLocation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User info missing. Please login again.")),
        );
        return;
      }
      final encodedName = Uri.encodeQueryComponent(subadminName);
      final encodedLoc = Uri.encodeQueryComponent(subadminLocation);

      final url =
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_based_on_sub_id_and_name_location.php?subid=$_parentId&assigned_subadmin_name=$encodedName&assigned_subadmin_location=$encodedLoc";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);

        if (jsonRes["status"] == true && jsonRes["data"] is List) {
          List data = jsonRes["data"];

          // convert to model
          final list = data
              .map<TenantDemandModel>((e) =>
              TenantDemandModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          list.sort((a, b) => b.id.compareTo(a.id));

          setState(() => _redemands = list);
          return;
        }
      }
      setState(() => _redemands = []);
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_based_on_sub_id_and_name_location.php?subid=$_parentId&assigned_subadmin_name=$encodedName&assigned_subadmin_location=$encodedLoc",
        error: response.body.toString(),
        statusCode: response.statusCode ?? 0,
      );
    } catch (e) {
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_based_on_sub_id_and_name_location.php?subid=$_parentId&assigned_subadmin_name=encodedName&assigned_subadmin_location=encodedLoc}",
        error: e.toString(),
        statusCode: 500,
      );
      setState(() => _redemands = []);
    }
  }

  String formatApiDate(dynamic raw) {
    if (raw == null) return "-";

    try {
      // If string (comes from list API)
      if (raw is String) {
        final dt = DateTime.parse(raw);
        return "${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}";
      }

      // If map (details API)
      if (raw is Map && raw["date"] != null) {
        final dt = DateTime.parse(raw["date"]);
        return "${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}";
      }

      return "-";
    } catch (_) {
      return "-";
    }
  }

  String _month(int m) {
    const names = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return names[m];
  }

  Future<void> _assignDemand() async {
    if (_selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select the Name first.")),
      );
      return;
    }

    setState(() => _assigning = true);

    try {
      final body = jsonEncode({
        "demand_id": widget.demandId,
        "fieldworker_role": "FieldWorkar",
        "fieldworker_name": _selectedName,
        "fieldworker_location": _selectedLocation
      });
      print(body);

      final response = await http.post(
        Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/assign_fieldoworkar.php"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final result = jsonDecode(response.body);

      print('${response.body}');

      if (response.statusCode == 200) {
        if (mounted) Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(result["message"] ?? "Demand assigned successfully"),
          ),
        );

        Navigator.pop(context);
      } else {
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/assign_fieldoworkar.php",
          error: response.body.toString(),
          statusCode: response.statusCode ?? 0,
        );
        throw Exception(result["message"] ?? "Assignment failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/assign_fieldoworkar.php",
        error: e.toString(),
        statusCode: 500,
      );
    } finally {
      if (mounted) setState(() => _assigning = false);
    }
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _myName = prefs.getString("name");
      _myUserId = prefs.getInt("id");
    });
  }

  Future<void> _transferDemand({
    required String newOffice,
    required String newSubAdmin,
  })
  async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final myUserId = prefs.getInt("id");

      print("🆔 Demand ID: ${_demand!["id"]}");
      print("👤 UserID: $myUserId");
      print("🏢 New Office: $newOffice");
      print("🧑 SubAdmin: $newSubAdmin");

      final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/share_demand_to_another_location.php",
      );

      /// ✅ FORM DATA (x-www-form-urlencoded)
      final response = await http.post(
        uri,
        body: {
          "id": _demand!["id"].toString(),
          "assigned_subadmin_name": newSubAdmin,
          "assigned_subadmin_location": newOffice,
        },
      );

      print("📡 RESPONSE BODY: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Demand transferred successfully"),
          ),
        );

        Navigator.pop(context);

        // await _fetchDemandDetails(); // refresh UI
      } else {
        throw Exception(result["message"] ?? "Transfer failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Transfer failed: $e"),
        ),
      );

      await BugLogger.log(
        apiLink:
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/share_demand_to_another_location.php",
        error: e.toString(),
        statusCode: 500,
      );
    }
  }





  String maskPhone(String? phone) {
    if (phone == null || phone.length < 3) return "Hidden";
    return "XXXXXXX${phone.substring(phone.length - 3)}";
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final bool isUrgent = _demand?["mark"]?.toString() == "1";
    final Color accent = isUrgent ? Colors.redAccent : theme.colorScheme.primary;



    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0B0C10) : const Color(0xFFF7F5F0),

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Demand Details",
          style: TextStyle(color: accent, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accent))
          : _demand == null
          ? const Center(child: Text("No data found"))
          : _buildMainBody(isDark, accent),
    );
  }

  Widget _fieldWorkerNotice(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.orange.withOpacity(isDark ? 0.15 : 0.12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.engineering_rounded,
            color: Colors.orange.shade700,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Field Worker Added Demand",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "This demand was added directly by a field worker.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainBody(bool isDark, Color accent) {
    final status = _demand?["Status"]?.toLowerCase();
    final isReturn = _demand?["Result"];
    final String? result = _demand?["Result"]?.toString().trim();

    final bool hasReturnMessage =
        result != null && result.isNotEmpty;

    print(_myUserId);
    print(_demand?["Status"]?.toString());

    bool _isAddedByFieldWorker(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == "true";
      return false;
    }

    final String? assignedFW = _demand?["assigned_fieldworker_name"];
    final String myName = _myName ?? "";
    final bool hasFieldworkerAssigned = assignedFW != null && assignedFW.isNotEmpty;
    final bool addedByField =
    _isAddedByFieldWorker(_demand?["by_field"]);

    final bool isDisclosed = _demand?["Status"]?.toString().toLowerCase() == "disclosed" || _demand?["Status"]?.toString().toLowerCase() == "redemand" ;

    final theme = Theme.of(context);
    print("isfield: $isReturn");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          // --- REDEMAND LIST ---
          if (_redemands.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ReDemands (${_redemands.length})",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: _fetchRedemands)
              ],
            ),
            const SizedBox(height: 6),
            ..._redemands.asMap().entries.map((e) {
              return _redemandTile(e.value, Theme.of(context), e.key == 0);
            }),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 14),
          ],

          if (addedByField) _fieldWorkerNotice(isDark),




          if (status == "redemand")
            infoBanner(
              icon: Icons.repeat,
              color: Colors.blue,
              title: "Demand Reopened",
              message:
              "This demand was previously disclosed, but a new redemand was created. "
                  "The workflow is active again.",
              isDark: isDark,
            ),

          if (hasReturnMessage)
            infoBanner(
              icon: Icons.back_hand_outlined,
              color: Colors.amber,
              title: "Demand Returned by Field Worker",
              message: _demand?["Result"] ?? '',
              isDark: isDark,
            ),

          _buildTenantCard(isDark, accent),

          SizedBox(height: 10,),


          if(status == "progressing" || status == "disclosed" || status == "redemand")
            _buildProgressDetailsCard(_demand!, isDark, accent),

          if (status == "progressing")
            _buildCompletionSection(isDark, accent),

          if (status == "disclosed" || status == "redemand")
            _buildFinalSummarySection(isDark, accent),

          const SizedBox(height: 12),

          if (hasFieldworkerAssigned) ...[
            _buildAssignmentCard(
              title: "Assigned to Fieldworker",
              name: _demand!["assigned_fieldworker_name"],
              role: _demand!["assigned_fieldworker_role"],
              location: _demand!["assigned_fieldworker_location"],
              date: _demand!["fieldworker_assigned_at"],
              accent: Colors.green,
              isDark: isDark,
            ),
          ],


          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDisclosed
                    ? Colors.grey.shade300   // 🔒 disabled state
                    : theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isDisclosed
                  ? null // 🔒 fully disabled
                  : () {
                if (_demand == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TenantDemandUpdatePage(demand: _demand!),
                  ),
                ).then((_) => _fetchDemandDetails());
              },
              child: Text(
                isDisclosed  ? "Demand Closed" : "Add More Details",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("OR",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 5,),


          if (status == "assign to subadmin") ...[
            _buildAssignButton(accent, isDark),

          SizedBox(height: 10,),

            if (status == "assign to subadmin")
              SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.swap_horiz, color: Colors.white),
                label: const Text(
                  "Transfer to Another Office",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _openTransferBottomSheet(isDark),
              ),
            ),

          ],
          SizedBox(height: 10,),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white),
              label: const Text(
                "Contact History",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () => _openContactSheet(context, accent, isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionSection(bool isDark, Color accent) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Completion Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),


          const SizedBox(height: 18),

          // Final Reason
          Text("Final Reason",
              style: theme.textTheme.titleSmall!
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _showFinalReasonSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceVariant.withOpacity(0.15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _finalReason ?? "Select Reason",
                    style: TextStyle(
                      color: _finalReason == null
                          ? Colors.grey
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontSize: 15,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      size: 22, color: theme.iconTheme.color),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),
          TextField(
            controller: _otherReasonCtrl,
            decoration: InputDecoration(
              labelText: "Enter Reason Details",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 2,
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 15),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: (_isDisclosing || _isSubmittingFinal)
                  ? null
                  : _showDiscloseConfirmDialog,
              child: _isDisclosing
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : const Text(
                "Disclose Demand",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFinalReasonSheet() {
    final reasons = [
      "Completed Successfully",
      "Wrong Contact Number",
      "Not Reachable",
      "No Respond",
      "Property Not Found",
      "Customer Cancelled",
      "Mismatch Requirements",
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text(
            "Select Final Reason",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const Divider(),

          ...reasons.map((e) {
            return ListTile(
              title: Text(e),
              onTap: () {
                Navigator.pop(ctx);

                setState(() {
                  _finalReason = e;
                });
              },
            );
          }),
        ],
      ),
    );
  }

  void _showDiscloseConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text("Confirm Action"),
          content: const Text(
            "Are you sure you want to disclose this demand? "
                "This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(ctx);
                _submitFinalUpdate();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitFinalUpdate() async {

    if (_finalReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please select final reason"),
        ),
      );
      return;
    }

    final now = DateTime.now();


    final String finishingDateTime =
        "${now.year}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')}";


    final String finalReasonToSend =
        (_finalReason ?? "") +
            (_otherReasonCtrl.text.trim().isEmpty
                ? ""
                : " - ${_otherReasonCtrl.text.trim()}");

    setState(() => _isSubmittingFinal = true);

    try {
      final response = await http.post(
        Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/update_api_tenant_demand.php"),
        body: {
          "id": _demand!["id"].toString(),
          "finishing_date": finishingDateTime,
          "final_reason": finalReasonToSend,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Final Update Submitted"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/update_api_tenant_demand.php",
        error: e.toString(),
        statusCode: 500,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Error: $e"),
        ),
      );
    }

    setState(() => _isSubmittingFinal = false);
  }


  Widget infoBanner({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
    bool isDark = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(isDark ? 0.15 : 0.12),
        border: Border.all(
          color: color.withOpacity(0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$message ",
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? color.withOpacity(0.9)
                              : color.withOpacity(0.85),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.sentiment_satisfied_alt,
                          size: 16,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openTransferBottomSheet(bool isDark) {
    final theme = Theme.of(context);
    String? selectedOffice;
    String? selectedSubAdmin;

    // Map office → subadmin
    final Map<String, String> officeMap = {
      "Sultanpur": "Saurabh yadav",
      "Rajpur Khurd": "Shivani Joshi",
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111217) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text(
                    "Transfer Demand",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// OFFICE SELECTION
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Office Location",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: officeMap.keys
                        .where((o) =>
                    o != _demand?["assigned_subadmin_location"])
                        .map(
                          (office) => DropdownMenuItem(
                        value: office,
                        child: Text(office),
                      ),
                    )
                        .toList(),
                    onChanged: (v) {
                      setSheetState(() {
                        selectedOffice = v;
                        selectedSubAdmin = v == null ? null : officeMap[v];
                      });
                    },
                  ),

                  const SizedBox(height: 14),

                  /// AUTO SUBADMIN DISPLAY
                  if (selectedSubAdmin != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: theme.colorScheme.primary.withOpacity(0.12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: theme.colorScheme.primary),
                          const SizedBox(width: 10),
                          Text(
                            selectedSubAdmin!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: selectedOffice == null
                          ? null
                          : () async {
                        Navigator.pop(context);
                        await _transferDemand(
                          newOffice: selectedOffice!,
                          newSubAdmin: selectedSubAdmin!,
                        );
                      },
                      child: const Text(
                        "Confirm Transfer",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildAssignmentCard({
    required String title,
    required String? name,
    required String? role,
    required String? location,
    required dynamic date,
    required Color accent,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: accent.withOpacity(0.10),
        border: Border.all(color: accent.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_rounded, color: accent, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: accent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(name ?? "--",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87)),
                Text(role ?? "--",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(location ?? "--",
                        style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    Text(
                      "Assigned: ${formatApiDate(date)}",
                      style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<List<dynamic>> _fetchLogs(String id) async {
    try {
      final url =
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_calling_option_in_tenant_demand.php?subid=$id";

      print("📡 Fetching Logs: $url");

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body["success"] == true && body["data"] is List) {
          print("📥 Logs fetched: ${body["data"].length}");
          return body["data"];
        }
      }
      else{
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_calling_option_in_tenant_demand.php?subid=$id",
          error: res.body.toString(),
          statusCode: res.statusCode ?? 0,
        );
      }
    } catch (e) {
      print("❌ Error fetching logs: $e");
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_calling_option_in_tenant_demand.php?subid=$id",
        error: e.toString(),
        statusCode: 500,
      );
    }
    return [];
  }

  void _openContactSheet(BuildContext context, Color accent, bool isDark) async {
    final number = _demand?["Tnumber"] ?? "";
    final name = _demand?["Tname"] ?? "";
    final BuyRent = _demand?["Buy_rent"] ?? "";
    final location = _demand?["Location"] ?? "Sultanpur";
    final Bhk = _demand?["Bhk"] ?? "";
    final id = _demand?["id"].toString() ?? "";
    final nextWord = Bhk.contains('commercial') ? 'Space' : 'Flat';
    // FIRST LOAD LOGS
    List<dynamic> logs = [];
    await _fetchLogs(id).then((list) => logs = list);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            // function to reload logs live inside bottomsheet
            Future<void> refreshLogs() async {
              print("🔄 Refreshing Logs...");
              final updated = await _fetchLogs(id);
              setSheetState(() {
                logs = updated;
              });
              print("✅ Logs Updated: ${logs.length}");
            }

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111217) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // drag handle
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "Customer History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: _contactButton(
                          label: "Call",
                          color: Colors.blue,
                          icon: Icons.call,
                          onTap: () async {
                            print("☎ CALL tapped");

                            await _logContact(
                                message: "Try to Call ${maskPhone(number)}", id: id);

                            print("📌 Log Inserted → Calling...");
                            await refreshLogs();

                            final uri = Uri.parse("tel:$number");
                            await launchUrl(uri);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _contactButton(
                          label: "WhatsApp",
                          color: Colors.green,
                          icon: Icons.chat,
                          onTap: () async {
                            print("💬 WhatsApp tapped");

                            await _logContact(
                                message: "Try to message on WhatsApp ${maskPhone(number)}",
                                id: id);

                            print("📌 Log Inserted → Opening WhatsApp...");
                            await refreshLogs();

                            final phone = normalizeWhatsAppNumber(number);
                            final txt = Uri.encodeComponent(
                                "Hello $name, Looking for a ${Bhk} $nextWord for $BuyRent in $location? "
                                    "Feel free to contact us for further details.\n\nRegards,\nVerify Properties");                            final url =
                            Uri.parse("https://wa.me/$phone?text=$txt");

                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // LOG HEADER
                  Row(
                    children: [
                      Icon(Icons.history, color: accent, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        "Contact Logs",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // LOG LIST
                  SizedBox(
                    height: 250,
                    child: logs.isEmpty
                        ? Center(
                      child: Text(
                        "No activity logs found.",
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    )
                        : ListView.separated(
                      itemCount: logs.length,
                      separatorBuilder: (_, __) => Divider(
                          color: isDark
                              ? Colors.white12
                              : Colors.black12),
                      itemBuilder: (context, i) {
                        final log = logs[i];
                        final msg = log['message'] ?? "";
                        final date = log['date'] ?? "";
                        final time = log['time'] ?? "";
                        final by = log['who_calling'] ?? "";


                        final isCall =
                        msg.toLowerCase().contains("call");
                        final isWhatsapp =
                        msg.toLowerCase().contains("whatsapp");

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCall
                                    ? Colors.blue.withOpacity(0.15)
                                    : isWhatsapp
                                    ? Colors.green.withOpacity(0.15)
                                    : Colors.grey.withOpacity(0.15),
                              ),
                              child: Icon(
                                isCall
                                    ? Icons.call
                                    : isWhatsapp
                                    ? Icons.chat
                                    : Icons.info_outline,
                                color: isCall
                                    ? Colors.blue
                                    : isWhatsapp
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "$date • $time",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        "by $by",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String normalizeWhatsAppNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');

    // If already has country code (starts with 91 and length > 10)
    if (cleaned.length > 10 && cleaned.startsWith('91')) {
      return cleaned;
    }

    // Default to India
    if (cleaned.length == 10) {
      return '91$cleaned';
    }

    return cleaned; // fallback
  }


  Future<void> _logContact({
    required String message,
    required String id,
  })
  async {
    final now = DateTime.now();
    final date = "${now.year}-${now.month}-${now.day}";
    final time = "${now.hour}:${now.minute}";

    const apiUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/calling_option_for_fieldworkar.php";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final storedName = prefs.getString('name');
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"message": message, "date": date, "time": time, "subid": id,"who_calling":storedName,},
      );

      debugPrint("Log saved: ${response.body}");
    } catch (e) {
      await BugLogger.log(
        apiLink: apiUrl,
        error: e.toString(),
        statusCode: 500,
      );
      debugPrint("Error logging contact: $e");
    }
  }



  Widget _contactButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildProgressDetailsCard(
      Map<String, dynamic> data,
      bool isDark,
      Color accent,
      ) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Work Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
          const SizedBox(height: 16),

          _infoRow("Parking", data["parking"]),
          _infoRow("Lift", data["lift"]),
          _infoRow("Furnished", data["furnished_unfurnished"]),
          _infoRow("Family Structure", data["family_structur"]),
          _infoRow("Family Members", data["family_member"]),
          _infoRow("Religion", data["religion"]),
          _infoRow("Visiting Date", data["visiting_dates"]),
          _infoRow("Vehicle Type", data["vichle_type"]),
          _infoRow("Vehicle No", data["vichle_no"]),
          _infoRow("Floor", data["floor"]),
          _infoRow("Shifting Date", data["shifting_date"]),
        ],
      ),
    );
  }

  // ---------------------- TENANT CARD ---------------------- //

  Widget _buildTenantCard(bool isDark, Color accent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _buildAvatar(accent),
            const SizedBox(width: 14),
            _buildTenantInfo(isDark),
            if (_demand?["mark"] == "1") _buildUrgentDot(),
          ]),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.withOpacity(0.3)),

          _infoRow("Buy / Rent", _demand?["Buy_rent"]),
          _infoRow("Location", _demand?["Location"]),
          _infoRow("Price Range", _demand?["Price"]),
          _infoRow("BHK Range", _demand?["Bhk"]),
          _infoRow("Reference", _demand?["Reference"]),
          _infoRow("Status", _demand?["Status"]),
          _infoRow("Message", _demand?["Message"]),
        ],
      ),
    );
  }

  Widget _buildAvatar(Color accent) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [accent, accent.withOpacity(0.7)],
        ),
      ),
      child: Center(
        child: Text(
          _demand?["Tname"]?.substring(0, 1).toUpperCase() ?? "?",
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildTenantInfo(bool isDark) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _demand?["Tname"] ?? "--",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Text(
            maskPhone(_demand?["Tnumber"]),
            style: TextStyle(color: Colors.grey.shade500),
          ),
          Text(
            "Created: ${formatApiDate(_demand?["created_date"])}",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          Text('Demand ID: ${_demand?["id"].toString()}' ?? "0",
              style: TextStyle(
                  color: isDark
                      ? Colors.white38
                      : Colors.black45,
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildUrgentDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.8),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
          Flexible(
            child: Text(
              value?.toString().isNotEmpty == true ? value! : "-",
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignButton(Color accent, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _openAssignBottomSheet(accent, isDark),
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 6,
        ),
        child: const Text(
          "Assign Demand",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }

  void _openAssignBottomSheet(Color accent, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          minChildSize: 0.35,
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111217) : Colors.white,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 18),

                  Text("Assign To Fieldworker",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: accent)),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    value: _selectedName,
                    onChanged: (v) => setState(() => _selectedName = v),
                    items: _activeNameList
                        .map(
                          (name) => DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      ),
                    )
                        .toList(),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: accent.withOpacity(0.15)),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: accent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedLocation ?? "--",
                            style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Assign Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _assigning ? null : _assignDemand,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _assigning
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.3,
                                    color: Colors.black)),
                            SizedBox(width: 12),
                            Text("Assigning...",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                            : const Text(
                          "Assign Now",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildFinalSummarySection(bool isDark, Color accent) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Disclosing Details",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
          const SizedBox(height: 14),

          Text("Finishing Date",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _summaryBox(_demand?["finishing_date"], isDark, theme),

          const SizedBox(height: 18),

          Text("Final Reason",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _summaryBox(_demand?["final_reason"], isDark, theme),
        ],
      ),
    );
  }

  Widget _summaryBox(String? text, bool isDark, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.12),
      ),
      child: Text(
        text ?? "-",
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _redemandTile(TenantDemandModel d, ThemeData theme, bool isFirst) {
    final bool isDark = theme.brightness == Brightness.dark;
    final bool isUrgent = d.mark == "1";
    final Color baseColor = isUrgent ? Colors.redAccent : theme.colorScheme.primary;

    return Stack(
      children: [



        if (d.status.toLowerCase() == "disclosed")
          Positioned(
            top: 12,
            left: -30,
            child: Transform.rotate(
              angle: -0.785398, // -45 degrees in radians
              child: Container(
                width: 140,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade500,
                      Colors.red.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "DISCLOSED   ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ),
          ),
        if (d.status.toLowerCase() == "assigned to fieldworker")
          Positioned(
            top: 12,
            left: -30,
            child: Transform.rotate(
              angle: -0.785398, // -45 degrees in radians
              child: Container(
                width: 140,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade500,
                      Colors.green.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "ASSIGNED   ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ),
          ),


        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RedemandSubadmin(redemandId: d.id.toString(), demandId: widget.demandId,),
              ),
            ).then((_) {
              _fetchRedemands();
              _fetchDemandDetails();
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: baseColor.withOpacity(isDark ? 0.35 : 0.85),
              boxShadow: [
                BoxShadow(
                  color: isUrgent
                      ? Colors.redAccent.withOpacity(0.25)
                      : Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isUrgent
                    ? Colors.redAccent.withOpacity(0.6)
                    : Colors.white.withOpacity(0.05),
                width: 1.2,
              ),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isUrgent
                        ? [
                      Colors.redAccent,
                      Colors.redAccent.shade700,
                    ]
                        : [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isUrgent
                          ? Colors.redAccent.withOpacity(0.3)
                          : theme.colorScheme.primary.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    d.tname.isNotEmpty ? d.tname[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      d.tname,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // 🔥 NEWEST BADGE HERE
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? Colors.redAccent.withOpacity(0.8)
                          : theme.colorScheme.primary.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(d.buyRent.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${d.location} • ${d.bhk}",
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 14)),
                    const SizedBox(height: 2),
                    Text("₹ ${d.price}",
                        style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontSize: 14)),
                    if (d.reference.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Ref: ${d.reference}",
                                style: TextStyle(
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.black45,
                                    fontSize: 13)),
                            Text(
                              formatApiDate(d.createdDate),
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (d.status.toLowerCase() == "disclosed")
          _buildRibbon("DISCLOSED", Colors.red.shade500, Colors.red.shade700),

        if (d.status.toLowerCase() == "progressing")
          _buildRibbon("Progressing", Colors.green.shade500, Colors.green.shade700),

        if (d.status.toLowerCase() == "assign to subadmin")
          _buildRibbon("NEW", Colors.green.shade500, Colors.green.shade700),

        if (d.status.toLowerCase() == "assigned to fieldworker")
          _buildRibbon("ASSIGNED", Colors.green.shade500, Colors.green.shade700),
      ],
    );
  }

  Widget _buildRibbon(String text, Color c1, Color c2) {
    return Positioned(
      top: 12,
      left: -30,
      child: Transform.rotate(
        angle: -0.785398,
        child: Container(
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [c1, c2]),
            boxShadow: [
              BoxShadow(
                color: c1.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            "$text   ",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              fontSize: 11.5,
            ),
          ),
        ),
      ),
    );
  }

}
