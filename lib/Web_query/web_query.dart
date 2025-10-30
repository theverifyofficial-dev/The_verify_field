import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class WebQuery {
  final String name;
  final String email;
  final String contactNo;
  final String message;
  final String? subid;
  final String? dates;
  final String? times;

  WebQuery({
    required this.name,
    required this.email,
    required this.contactNo,
    required this.message,
    this.subid,
    this.dates,
    this.times,
  });

  factory WebQuery.fromJson(Map<String, dynamic> json) {
    return WebQuery(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contactNo: json['contact_no'] ?? '',
      message: json['message'] ?? '',
      subid: json['subid'],
      dates: json['dates'],
      times: json['times'],
    );
  }
}

class WebQueryPage extends StatefulWidget {
  const WebQueryPage({Key? key}) : super(key: key);

  @override
  State<WebQueryPage> createState() => _WebQueryPageState();
}

class _WebQueryPageState extends State<WebQueryPage> with SingleTickerProviderStateMixin {
  late Future<List<WebQuery>> futureQueries;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Future<List<WebQuery>> fetchQueries() async {
    final response = await http.get(Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate_for_website/show_contact.php"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Reverse the list to show newest first
      final List<WebQuery> queries = data.map((e) => WebQuery.fromJson(e)).toList();
      return queries.reversed.toList();
    } else {
      throw Exception("Failed to load queries");
    }
  }

  String formatDate(String? date) {
    if (date == null) return "Not Provided";
    try {
      final DateTime dt = DateTime.parse(date);
      return DateFormat("dd MMM yyyy").format(dt);
    } catch (e) {
      return date;
    }
  }

  String formatTime(String? time) {
    if (time == null) return "Not Provided";
    try {
      final DateTime t = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(t);
    } catch (e) {
      return time;
    }
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue.shade700,
      Colors.green.shade700,
      Colors.orange.shade700,
      Colors.purple.shade700,
      Colors.teal.shade700,
      Colors.indigo.shade700,
    ];
    final index = name.isEmpty ? 0 : name.codeUnits.reduce((a, b) => a + b) % colors.length;
    return colors[index];
  }

  @override
  void initState() {
    super.initState();
    futureQueries = fetchQueries();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Text colors that work well in both light and dark modes
    final primaryTextColor = isDarkMode ? Colors.white : Colors.grey.shade900;
    final secondaryTextColor = isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;
    final tertiaryTextColor = isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Web Query",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        actions: [
          ScaleTransition(
            scale: _fadeAnimation,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _animationController.reset();
                setState(() {
                  futureQueries = fetchQueries();
                });
                _animationController.forward();
              },
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<WebQuery>>(
        future: futureQueries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "Loading inquiries...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return ShakeAnimation(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Failed to load inquiries",
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Error: ${snapshot.error}",
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        _animationController.reset();
                        setState(() {
                          futureQueries = fetchQueries();
                        });
                        _animationController.forward();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 80,
                      color: tertiaryTextColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No inquiries yet",
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Customer inquiries will appear here",
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final queries = snapshot.data!;
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with count
                  SlideAnimation(
                    delay: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${queries.length} ${queries.length == 1 ? 'Inquiry' : 'Inquiries'}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  // List of queries
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: queries.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final q = queries[index];
                        return SlideAnimation(
                          delay: 200 + (index * 100),
                          child: _buildQueryCard(
                            q,
                            theme,
                            isDarkMode,
                            primaryTextColor,
                            secondaryTextColor,
                            tertiaryTextColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Future<void> _launchDetails(String subid) async {
    final Uri url = Uri.parse("https://theverify.in/details.html?id=$subid");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildQueryCard(
      WebQuery q,
      ThemeData theme,
      bool isDarkMode,
      Color primaryTextColor,
      Color secondaryTextColor,
      Color tertiaryTextColor,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar and name
            GestureDetector(
              onTap: () {
                print("SubID:"+'${q.subid}');
                if (q.subid != null) {
                  _launchDetails(q.subid!);
                }
              },

              child: Row(
                children: [
                  ScaleAnimation(
                    delay: 300,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _getAvatarColor(q.name),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          q.name.isNotEmpty ? q.name[0].toUpperCase() : "?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primaryTextColor,
                          ),
                        ),
                        if (q.subid != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            "Property ID : ${q.subid!}",
                            style: TextStyle(
                              fontSize: 12,
                              color: tertiaryTextColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Contact information
            _buildInfoRow(
              icon: Icons.phone_rounded,
              value: q.contactNo,
              iconColor: Colors.green,
              textColor: primaryTextColor,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.email_rounded,
              value: q.email,
              iconColor: Colors.blue,
              textColor: primaryTextColor,
            ),

            const SizedBox(height: 16),

            // Date and time
            ScaleAnimation(
              delay: 400,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDateTimeItem(
                      icon: Icons.calendar_today_rounded,
                      label: "Visit Date",
                      value: formatDate(q.dates),
                      textColor: primaryTextColor,
                      labelColor: tertiaryTextColor,
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.shade400,
                    ),
                    _buildDateTimeItem(
                      icon: Icons.access_time_rounded,
                      label: "Visit Time",
                      value: formatTime(q.times),
                      textColor: primaryTextColor,
                      labelColor: tertiaryTextColor,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Message
            Text(
              "Message:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: tertiaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            ScaleAnimation(
              delay: 500,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isDarkMode
                      ? Colors.blueGrey.shade900.withOpacity(0.5)
                      : Colors.blue.shade50,
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.blueGrey.shade700
                        : Colors.blue.shade100,
                    width: 1,
                  ),
                ),
                child: Text(
                  q.message,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: primaryTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String value,
    required Color iconColor,
    required Color textColor,
  }) {
    return FadeAnimation(
      delay: 350,
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeItem({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color labelColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 16,
            color: labelColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: labelColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Fixed Custom Animation Widgets with proper TickerProvider
class SlideAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const SlideAnimation({Key? key, required this.child, this.delay = 0})
      : super(key: key);

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const FadeAnimation({Key? key, required this.child, this.delay = 0})
      : super(key: key);

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class ScaleAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const ScaleAnimation({Key? key, required this.child, this.delay = 0})
      : super(key: key);

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class ShakeAnimation extends StatefulWidget {
  final Widget child;

  const ShakeAnimation({Key? key, required this.child}) : super(key: key);

  @override
  _ShakeAnimationState createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_controller.value * 4.0, 0),
          child: widget.child,
        );
      },
    );
  }
}