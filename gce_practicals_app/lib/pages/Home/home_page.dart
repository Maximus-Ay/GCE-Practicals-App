import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyBar = false;

  // Approx height of the header before sticky bar kicks in
  static const double _headerTriggerOffset = 20.0;

  // Subject data
  static const List<Map<String, dynamic>> _subjects = [
    {
      'title': 'OL Computer Science',
      'subtitle': 'Ordinary Level',
      'icon': Icons.computer_rounded,
      'gradient': [Color(0xFF4FC3F7), Color(0xFF0288D1)],
      'tag': 'O Level',
    },
    {
      'title': 'AL Computer Science',
      'subtitle': 'Advanced Level',
      'icon': Icons.developer_board_rounded,
      'gradient': [Color(0xFF7986CB), Color(0xFF3949AB)],
      'tag': 'A Level',
    },
    {
      'title': 'AL ICT',
      'subtitle': 'Advanced Level',
      'icon': Icons.lan_rounded,
      'gradient': [Color(0xFF4DB6AC), Color(0xFF00796B)],
      'tag': 'A Level',
    },
    {
      'title': 'AL Physics',
      'subtitle': 'Advanced Level',
      'icon': Icons.bolt_rounded,
      'gradient': [Color(0xFFFFB74D), Color(0xFFF57C00)],
      'tag': 'A Level',
    },
    {
      'title': 'AL Chemistry',
      'subtitle': 'Advanced Level',
      'icon': Icons.science_rounded,
      'gradient': [Color(0xFFF06292), Color(0xFFC2185B)],
      'tag': 'A Level',
    },
    {
      'title': 'AL Biology',
      'subtitle': 'Advanced Level',
      'icon': Icons.eco_rounded,
      'gradient': [Color(0xFF81C784), Color(0xFF388E3C)],
      'tag': 'A Level',
    },
  ];

  // Quick action chips
  static const List<Map<String, dynamic>> _quickActions = [
    {'label': 'Notes', 'icon': Icons.menu_book_outlined},
    {'label': 'Exercises', 'icon': Icons.edit_note_rounded},
    {'label': 'Practicals', 'icon': Icons.biotech_outlined},
    {'label': 'Saved', 'icon': Icons.bookmark_outline_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > _headerTriggerOffset;
    if (shouldShow != _showStickyBar) {
      setState(() => _showStickyBar = shouldShow);
      // Update status bar icon brightness to stay readable
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: shouldShow
              ? Brightness.light
              : Brightness.dark,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEEF0FF), // soft lavender-white top-left
              Color(0xFFF8F9FF), // near-white centre
              Color(0xFFE8F4FF), // very light cyan bottom-right
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ── Scrollable content ──────────────────────────────────
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header (scrolls away)
                SliverToBoxAdapter(child: _buildHeader(context)),

                // Banner card
                SliverToBoxAdapter(child: _buildBannerCard()),

                // Quick action chips (scrolls with content)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 6),
                    child: _buildQuickActions(),
                  ),
                ),

                // Section title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: const Text(
                      'Subjects',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A237E),
                        fontFamily: 'GoogleSansFlex',
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),

                // Subject cards grid
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 0.90,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _SubjectCard(subject: _subjects[index]),
                      childCount: _subjects.length,
                    ),
                  ),
                ),
              ],
            ),

            // ── Sticky app bar (fades in on scroll) ────────────────
            AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              top: _showStickyBar ? 0 : -(topPadding + 64),
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 120),
                opacity: _showStickyBar ? 1.0 : 0.0,
                child: _buildStickyBar(topPadding),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 6, 20, 6),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'GCE Practicals',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A237E),
              fontFamily: 'GoogleSansFlex',
              letterSpacing: -0.5,
            ),
          ),
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4FC3F7), Color(0xFF3949AB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3949AB).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'GoogleSansFlex',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Fixed sticky bar that slides in from top ──────────────────────────────
  Widget _buildStickyBar(double topPadding) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 12),
      decoration: BoxDecoration(
        // App bar background = deep blue (the color of the title text below)
        color: const Color(0xFF1A237E),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // App logo
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/practicals_logo.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Title color = scaffold background color
              const Text(
                'GCE Practicals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF5F6FF), // scaffold bg color as text color
                  fontFamily: 'GoogleSansFlex',
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          // Avatar stays visible
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4FC3F7), Color(0xFF3949AB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'GoogleSansFlex',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _quickActions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final action = _quickActions[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            decoration: BoxDecoration(
              // Frosted glass: white with low opacity so gradient bleeds through
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color.fromARGB(
                  255,
                  212,
                  226,
                  235,
                ).withValues(alpha: 0.85),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3949AB).withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.6),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  action['icon'] as IconData,
                  size: 16,
                  color: const Color(0xFF3949AB),
                ),
                const SizedBox(width: 6),
                Text(
                  action['label'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3949AB),
                    fontFamily: 'GoogleSansFlex',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 20, 12, 0),
      height: 130,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3949AB), Color(0xFF1565C0), Color(0xFF0288D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3949AB).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // ── Logo image replacing the school icon ──
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Image.asset(
                      'assets/images/practicals_logo.png',
                      width: 52,
                      height: 52,
                      fit: BoxFit.contain,
                      // Fallback if image not found yet
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GCE Examinations 2026',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'GoogleSansFlex',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Prepare with past practical papers & notes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'GoogleSansFlex',
                          letterSpacing: -0.3,
                          height: 1.3,
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
}

// ── Subject Card ──────────────────────────────────────────────────────────────

class _SubjectCard extends StatelessWidget {
  final Map<String, dynamic> subject;

  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    final gradientColors = subject['gradient'] as List<Color>;

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: gradientColors[1].withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient icon area
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -15,
                    bottom: -15,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      subject['icon'] as IconData,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),

            // Text area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subject['title'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A237E),
                        fontFamily: 'GoogleSansFlex',
                        letterSpacing: -0.2,
                        height: 1.3,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: gradientColors[0].withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subject['tag'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: gradientColors[1],
                          fontFamily: 'GoogleSansFlex',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
