import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../constant.dart';
import 'Forms/Agreement_Form.dart';
import 'Forms/External_Form.dart';

class AgreementDashboard extends StatelessWidget {
  const AgreementDashboard({super.key});

  Widget _buildSectionItem(String title, IconData icon, VoidCallback onTap) {
    return _BubbleCard(
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
                color: Colors.white.withOpacity(0.3),
              ),
              child: Icon(icon, size: 28, color: Colors.blue),
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

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildSectionItem("Rental", Icons.home, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RentalWizardPage()),
            );
          }),
          _buildSectionItem("Sell", Icons.sell, () {
            // Navigate to Lease Page
          }),
          _buildSectionItem("Commercial", Icons.apartment_sharp, () {
            // Navigate to Commercial Page
          }),
          _buildSectionItem("External Rental", Icons.add_business, () {
            // Navigator.push(
            // context,
            // MaterialPageRoute(builder: (context) => const ExternalForm()),
            // );
          }),
        ],
      ),
    );
  }
}

class _BubbleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BubbleCard({required this.child, required this.onTap});

  @override
  State<_BubbleCard> createState() => _BubbleCardState();
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
          child: widget.child,
        ),
      ),
    );
  }
}
