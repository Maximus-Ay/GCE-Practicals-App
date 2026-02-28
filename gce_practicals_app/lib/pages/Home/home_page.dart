import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gce_practicals_app/pages/Home/practicals_page.dart';
import 'package:gce_practicals_app/pages/Profile/profile_page.dart';
import 'package:gce_practicals_app/pages/Subjects/Biology/al_biology.dart';
import 'package:gce_practicals_app/pages/Subjects/Chemistry/al_chemistry.dart';
import 'package:gce_practicals_app/pages/Subjects/Computer/al_computer_science.dart';
import 'package:gce_practicals_app/pages/Subjects/ICT/al_ict.dart';
import 'package:gce_practicals_app/pages/Subjects/Physics/al_physics.dart';
import 'package:gce_practicals_app/pages/Subjects/csc/ol_computer_science.dart';

// Import your shared themeNotifier and AppColors, e.g.:
// import 'theme_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _subjectsSectionKey = GlobalKey();
  bool _showStickyBar = false;

  static const double _headerTriggerOffset = 20.0;

  static const List<Map<String, dynamic>> _subjects = [
    {
      'title': 'OL Computer Science',
      'subtitle': 'Ordinary Level',
      'icon': Icons.computer_rounded,
      'gradient': [Color(0xFF4FC3F7), Color(0xFF0288D1)],
      'tag': 'O Level',
      'page': 'ol_cs',
    },
    {
      'title': 'AL Computer Science',
      'subtitle': 'Advanced Level',
      'icon': Icons.developer_board_rounded,
      'gradient': [Color(0xFF7986CB), Color(0xFF3949AB)],
      'tag': 'A Level',
      'page': 'al_cs',
    },
    {
      'title': 'AL ICT',
      'subtitle': 'Advanced Level',
      'icon': Icons.lan_rounded,
      'gradient': [Color(0xFF4DB6AC), Color(0xFF00796B)],
      'tag': 'A Level',
      'page': 'al_ict',
    },
    {
      'title': 'AL Physics',
      'subtitle': 'Advanced Level',
      'icon': Icons.bolt_rounded,
      'gradient': [Color(0xFFFFB74D), Color(0xFFF57C00)],
      'tag': 'A Level',
      'page': 'al_physics',
    },
    {
      'title': 'AL Chemistry',
      'subtitle': 'Advanced Level',
      'icon': Icons.science_rounded,
      'gradient': [Color(0xFFF06292), Color(0xFFC2185B)],
      'tag': 'A Level',
      'page': 'al_chemistry',
    },
    {
      'title': 'AL Biology',
      'subtitle': 'Advanced Level',
      'icon': Icons.eco_rounded,
      'gradient': [Color(0xFF81C784), Color(0xFF388E3C)],
      'tag': 'A Level',
      'page': 'al_biology',
    },
  ];

  static const List<Map<String, dynamic>> _quickActions = [
    {'label': 'Notes', 'icon': Icons.menu_book_outlined, 'action': 'scroll'},
    {'label': 'Exercises', 'icon': Icons.edit_note_rounded, 'action': 'scroll'},
    {
      'label': 'Practicals',
      'icon': Icons.biotech_outlined,
      'action': 'practicals',
    },
  ];

  // -- Theme helpers ----------------------------------------------------------
  bool get _isDark => themeNotifier.value == ThemeMode.dark;

  Color get _bgGrad1 => _isDark ? AppColors.darkBg1 : AppColors.lightBg1;
  Color get _bgGrad2 => _isDark ? AppColors.darkBg2 : AppColors.lightBg2;
  Color get _bgGrad3 => _isDark ? AppColors.darkBg3 : AppColors.lightBg3;
  Color get _titleColor => _isDark ? AppColors.darkTitle : AppColors.lightTitle;
  Color get _subtitleColor =>
      _isDark ? AppColors.darkSubtitle : AppColors.lightSubtitle;
  Color get _accentColor =>
      _isDark ? AppColors.darkAccent : AppColors.lightAccent;
  Color get _cardColor => _isDark ? AppColors.darkCard : AppColors.lightCard;
  Color get _cardBorder =>
      _isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
  Color get _stickyBarBg =>
      _isDark ? AppColors.darkBg2 : const Color(0xFF1A237E);

  // -- Responsive helpers ----------------------------------------------------
  bool _isMediumTablet(double w) => w >= 600 && w < 800;
  bool _isLargeTablet(double w) => w >= 800;
  bool _isTablet(double w) => w >= 600;
  double _hPad(double w) => _isLargeTablet(w)
      ? 32
      : _isMediumTablet(w)
      ? 24
      : 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    themeNotifier.addListener(_onThemeChange);
  }

  void _onThemeChange() => setState(() {});

  void _onScroll() {
    final shouldShow = _scrollController.offset > _headerTriggerOffset;
    if (shouldShow != _showStickyBar) {
      setState(() => _showStickyBar = shouldShow);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: (shouldShow || _isDark)
              ? Brightness.light
              : Brightness.dark,
        ),
      );
    }
  }

  void _scrollToSubjects() {
    final ctx = _subjectsSectionKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleQuickAction(BuildContext context, String action) {
    if (action == 'scroll') {
      _scrollToSubjects();
    } else if (action == 'practicals') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PracticalsPage()),
      );
    }
  }

  void _navigateToSubject(BuildContext context, String page) {
    Widget destination;
    switch (page) {
      case 'ol_cs':
        destination = const OlComputerSciencePage();
        break;
      case 'al_cs':
        destination = const AlComputerSciencePage();
        break;
      case 'al_ict':
        destination = const AlIctPage();
        break;
      case 'al_physics':
        destination = const AlPhysicsPage();
        break;
      case 'al_chemistry':
        destination = const AlChemistryPage();
        break;
      case 'al_biology':
        destination = const AlBiologyPage();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    themeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive grid columns: 2 on phone, 3 on tablet
    final int gridColumns = _isTablet(screenWidth) ? 3 : 2;
    final double gridAspectRatio = _isLargeTablet(screenWidth)
        ? 0.95
        : _isMediumTablet(screenWidth)
        ? 0.92
        : 0.90;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_bgGrad1, _bgGrad2, _bgGrad3],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(context, topPadding, screenWidth),
                ),
                SliverToBoxAdapter(child: _buildBannerCard(screenWidth)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 6),
                    child: _buildQuickActions(context, screenWidth),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    key: _subjectsSectionKey,
                    padding: EdgeInsets.fromLTRB(
                      _hPad(screenWidth),
                      12,
                      _hPad(screenWidth),
                      12,
                    ),
                    child: Text(
                      'Subjects',
                      style: TextStyle(
                        fontSize: _isLargeTablet(screenWidth) ? 22 : 18,
                        fontWeight: FontWeight.w700,
                        color: _titleColor,
                        fontFamily: 'GoogleSansFlex',
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    _hPad(screenWidth) - 8,
                    0,
                    _hPad(screenWidth) - 8,
                    32,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: gridAspectRatio,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _SubjectCard(
                        subject: _subjects[index],
                        isDark: _isDark,
                        onTap: () => _navigateToSubject(
                          context,
                          _subjects[index]['page'] as String,
                        ),
                      ),
                      childCount: _subjects.length,
                    ),
                  ),
                ),
              ],
            ),

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

  // -- Header ----------------------------------------------------------------
  Widget _buildHeader(
    BuildContext context,
    double topPadding,
    double screenWidth,
  ) {
    final hPad = _hPad(screenWidth);
    final isLarge = _isLargeTablet(screenWidth);

    return Container(
      padding: EdgeInsets.fromLTRB(hPad, topPadding + 6, hPad, 6),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'GCE Practicals',
            style: TextStyle(
              fontSize: isLarge ? 32 : 26,
              fontWeight: FontWeight.w700,
              color: _titleColor,
              fontFamily: 'GoogleSansFlex',
              letterSpacing: -0.5,
            ),
          ),
          // Avatar bubble
          Container(
            width: isLarge ? 48 : 42,
            height: isLarge ? 48 : 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDark
                    ? [const Color(0xFF738AFF), const Color(0xFF4FC3F7)]
                    : [const Color(0xFF4FC3F7), const Color(0xFF3949AB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _accentColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isLarge ? 19 : 17,
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

  // -- Sticky bar ------------------------------------------------------------
  Widget _buildStickyBar(double topPadding) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 12),
      decoration: BoxDecoration(
        color: _stickyBarBg,
        boxShadow: [
          BoxShadow(
            color: (_isDark ? AppColors.darkBg1 : const Color(0xFF1A237E))
                .withValues(alpha: 0.3),
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
              const Text(
                'GCE Practicals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF5F6FF),
                  fontFamily: 'GoogleSansFlex',
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
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

  // -- Quick actions ---------------------------------------------------------
  Widget _buildQuickActions(BuildContext context, double screenWidth) {
    final hPad = _hPad(screenWidth);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: hPad),
        itemCount: _quickActions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final action = _quickActions[index];
          return GestureDetector(
            onTap: () =>
                _handleQuickAction(context, action['action'] as String),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              decoration: BoxDecoration(
                color: _isDark
                    ? AppColors.darkCard.withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _isDark
                      ? AppColors.darkCardBorder
                      : Colors.white.withValues(alpha: 0.85),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _accentColor.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                  if (!_isDark)
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
                    color: _accentColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    action['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _accentColor,
                      fontFamily: 'GoogleSansFlex',
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

  // -- Banner card -----------------------------------------------------------
  Widget _buildBannerCard(double screenWidth) {
    final hPad = _hPad(screenWidth) - 8;
    final isTablet = _isTablet(screenWidth);
    final isLarge = _isLargeTablet(screenWidth);

    return Container(
      margin: EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
      height: isLarge
          ? 150
          : isTablet
          ? 138
          : 130,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3949AB), Color(0xFF1565C0), Color(0xFF0288D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 13),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF3949AB,
            ).withValues(alpha: _isDark ? 0.2 : 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
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
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'GCE Examinations 2026',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'GoogleSansFlex',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prepare with past practical papers & notes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isLarge ? 18 : 16,
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

// -- Subject Card -------------------------------------------------------------

class _SubjectCard extends StatelessWidget {
  final Map<String, dynamic> subject;
  final VoidCallback onTap;
  final bool isDark;

  const _SubjectCard({
    required this.subject,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = subject['gradient'] as List<Color>;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLarge = screenWidth >= 800;
    final isTablet = screenWidth >= 600;

    // Card background adapts for dark mode
    final Color cardBg = isDark ? AppColors.darkCard : Colors.white;
    final Color titleTextColor = isDark
        ? AppColors.darkTitle
        : const Color(0xFF1A237E);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
          boxShadow: [
            BoxShadow(
              color: gradientColors[1].withValues(alpha: isDark ? 0.08 : 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coloured top gradient area with icon
            Container(
              height: isLarge
                  ? 130
                  : isTablet
                  ? 120
                  : 110,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isTablet ? 14 : 10),
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
                      size: isLarge
                          ? 48
                          : isTablet
                          ? 44
                          : 40,
                    ),
                  ),
                ],
              ),
            ),
            // Text area — dark/light adaptive
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 14 : 12,
                  isTablet ? 12 : 10,
                  isTablet ? 14 : 12,
                  14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subject['title'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isLarge
                            ? 15
                            : isTablet
                            ? 14
                            : 13,
                        fontWeight: FontWeight.w700,
                        color: titleTextColor,
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
                        color: gradientColors[0].withValues(
                          alpha: isDark ? 0.18 : 0.12,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subject['tag'] as String,
                        style: TextStyle(
                          fontSize: isTablet ? 11 : 10,
                          fontWeight: FontWeight.w600,
                          color: isDark ? gradientColors[0] : gradientColors[1],
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
