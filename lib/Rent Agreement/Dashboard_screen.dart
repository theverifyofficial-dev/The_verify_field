import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant.dart';
import 'Agreement_Form.dart';
import 'history_tab.dart';

class AgreementDashboard extends StatelessWidget {
  const AgreementDashboard({super.key});

  Widget _buildSectionCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // White Circle with Icon inside
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // White background
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.blueAccent, // Keep your blue color
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
  _launchURL() async {
    final Uri url = Uri.parse('https://theverify.in/example.html');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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
              SizedBox(
                width: 3,
              ),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
        actions:  [
          GestureDetector(
            onTap: () {
              _launchURL();
            },
            child: Row(
              children: [
                const Icon(
                  PhosphorIcons.share,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],

      ),

      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(12),
        children: [
          _buildSectionCard("Rental", Icons.home, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RentalWizardPage()),
            );
          }),
          _buildSectionCard("Lease", Icons.apartment, () {
            // Navigate to Lease Page
          }),
          _buildSectionCard("Sale", Icons.sell, () {
            // Navigate to Sale Page
          }),
          _buildSectionCard("Furnished", Icons.chair, () {
            // Navigate to Furnished Page
          }),

          InkWell(
            onTap: (){Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => const HistoryTab()),
          );
          },
            child: SizedBox(
              width: double.infinity, // Full width
              child:Card(
              elevation: 3,
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // White Circle with Icon inside
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // White background
                    ),
                    child: Icon(
                      Icons.history,
                      size: 30,
                      color: Colors.blueAccent, // Keep your blue color
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                  "History",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          )
          )
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
    setState(() => _scale = 0.9); // shrink
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0); // back to normal
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
          elevation: 3,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: widget.child,
        ),
      ),
    );
  }
}
