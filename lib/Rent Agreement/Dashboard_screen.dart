import 'dart:convert';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Custom_Widget/constant.dart';
import '../Custom_Widget/marquee_style.dart';
import 'Forms/Agreement_Form.dart';
import 'Forms/Commercial_Form.dart';
import 'Forms/External_Form.dart';
import 'Forms/Furnished_form.dart';
import 'Forms/Renewal_form.dart';
import 'Forms/Verification_form.dart';

class AgreementDashboard extends StatefulWidget {

  const AgreementDashboard({super.key});

  @override
  State<AgreementDashboard> createState() => _AgreementDashboardState();
}

class RewardStatus {
  final int totalAgreements;
  final bool isDiscounted;

  RewardStatus({
    required this.totalAgreements,
    required this.isDiscounted,
  });
}


class _AgreementDashboardState extends State<AgreementDashboard> {

  static const int monthlyTarget = 20;
  static const bool debugForceDiscount = false; // 🔥 TEMP ONLY
  late ConfettiController _confettiController;

  RewardStatus? _rewardStatus;
   bool _loadingReward = true;


   @override
   void initState() {
     super.initState();
     _confettiController =
         ConfettiController(duration: const Duration(seconds: 2));
     _loadReward();
   }

   Future<void> _loadReward() async {
     final reward = await fetchRewardStatus();

     if (!mounted) return;

     setState(() {
       _rewardStatus = reward;
       _loadingReward = false;
     });

     if (reward.isDiscounted) {
       _confettiController.play();
     }
   }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<RewardStatus> fetchRewardStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getString("number");

    if (number == null || number.isEmpty) {
      return RewardStatus(totalAgreements: 0, isDiscounted: false);
    }

    final res = await http.get(
      Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/count_api_for_all_agreement_with_reword.php"
            "?Fieldwarkarnumber=$number",
      ),
    );

    final data = jsonDecode(res.body);

    if (data["status"] == true) {
      final total = int.tryParse(data["total_agreement"].toString()) ?? 0;

      return RewardStatus(
        totalAgreements: total,
        isDiscounted: debugForceDiscount || total >= monthlyTarget,
      );
    }

    return RewardStatus(totalAgreements: 0, isDiscounted: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),

      body: Stack(
          children: [
            ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (!_loadingReward && _rewardStatus != null)
            _RewardBanner(reward: _rewardStatus!),

          _buildSectionItem("Rental", Icons.home, () async {

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RentalWizardPage(rewardStatus: _rewardStatus!,)),
            );
          },
            _rewardStatus?.isDiscounted == true,

          ),
          _buildSectionItem("Commercial", Icons.apartment_sharp, () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommercialWizardPage(rewardStatus: _rewardStatus!,)),
            );
          },
            _rewardStatus?.isDiscounted == true,

          ),
          _buildSectionItem("External Rental", Icons.add_business, () async {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExternalWizardPage(rewardStatus: _rewardStatus!,)),
            );
          },
            _rewardStatus?.isDiscounted == true,

          ),
          _buildSectionItem("Furnished", Icons.workspace_premium, ()  async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FurnishedForm(rewardStatus: _rewardStatus!,)),
            );
          },
            _rewardStatus?.isDiscounted == true,

          ),
          _buildSectionItem("Renewal", Icons.timer, ()  async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RenewalForm(rewardStatus: _rewardStatus!,)),
            );
          },
            _rewardStatus?.isDiscounted == true,

          ),
          _buildSectionItem("Police Verification", Icons.local_police_outlined, ()  async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerificationWizardPage(rewardStatus: _rewardStatus!,)),
            );
          },
            _rewardStatus?.isDiscounted == true,

          ),        ],
      ),
            if (_rewardStatus?.isDiscounted == true)
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.04,
                  numberOfParticles: 18,
                  gravity: 0.25,
                ),
              ),
    ]
      ),
    );
  }
}

Widget _buildSectionItem(String title, IconData icon, VoidCallback onTap,  bool showDiscount,) {
  return _BubbleCard(
    showDiscount: showDiscount,
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Circle icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.8),
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          const SizedBox(width: 16),
        ],
      ),
    ),
  );
}

class _BubbleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool showDiscount;

  const _BubbleCard({
    required this.child,
    required this.onTap,
    required this.showDiscount,
  });

  @override
  State<_BubbleCard> createState() => _BubbleCardState();
}

class _RewardBanner extends StatelessWidget {
  final RewardStatus reward;
  static const int target = 20;

  const _RewardBanner({required this.reward});

  @override
  Widget build(BuildContext context) {

    final progress =
    (reward.totalAgreements / target).clamp(0.0, 1.0);

    final unlocked = reward.isDiscounted;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: unlocked
              ? [Colors.green.shade700, Colors.greenAccent.shade400]
              : [Colors.grey.shade800, Colors.grey.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎉 TITLE
            Row(
              children: [
                Icon(
                  unlocked ? Icons.celebration : Icons.trending_up,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    unlocked
                        ? "🎉 Discount Unlocked!"
                        : "Monthly Target Progress",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 8),

          // 🧠 SUBTEXT
          Text(
            unlocked
                ? "You completed ${reward.totalAgreements} agreements this month.\nSpecial pricing is active!"
                : "${reward.totalAgreements} of $target agreements completed",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 12),

          // 📊 PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: AlwaysStoppedAnimation<Color>(
                unlocked ? Colors.white : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscountRibbon extends StatelessWidget {
  const DiscountRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -4,
      right: -4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          "DISCOUNT",
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _BubbleCardState extends State<_BubbleCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95); // shrink a bit
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0); // restore
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            children: [
              widget.child,
              if (widget.showDiscount) const DiscountRibbon(),
            ],
          ),
        ),
      ),
    );
  }
}
