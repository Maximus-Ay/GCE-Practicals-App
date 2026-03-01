import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gce_practicals_app/pages/Profile/profile_page.dart';

// ── Dummy paper data per subject ──────────────────────────────────────────────
Map<String, List<Map<String, dynamic>>> _subjectPapers = {
  'OL Computer Science': [
    {'year': 2024, 'code': 'OL Computer Science 2024 – P2', 'pages': 12},
    {'year': 2023, 'code': 'OL Computer Science 2023 – P2', 'pages': 10},
    {'year': 2022, 'code': 'OL Computer Science 2022 – P2', 'pages': 11},
    {'year': 2021, 'code': 'OL Computer Science 2021 – P2', 'pages': 10},
    {'year': 2020, 'code': 'OL Computer Science 2020 – P2', 'pages': 9},
    {'year': 2019, 'code': 'OL Computer Science 2019 – P2', 'pages': 10},
  ],
  'AL Computer Science': [
    {'year': 2025, 'code': 'AL Computer Science 2025 – P3', 'pages': 14},
    {'year': 2024, 'code': 'AL Computer Science 2024 – P3', 'pages': 16},
    {'year': 2023, 'code': 'AL Computer Science 2023 – P3', 'pages': 15},
    {'year': 2022, 'code': 'AL Computer Science 2022 – P3', 'pages': 14},
    {'year': 2021, 'code': 'AL Computer Science 2021 – P3', 'pages': 13},
    {'year': 2020, 'code': 'AL Computer Science 2020 – P3', 'pages': 12},
    {'year': 2019, 'code': 'AL Computer Science 2019 – P3', 'pages': 13},
    {'year': 2018, 'code': 'AL Computer Science 2018 – P3', 'pages': 11},
  ],
  'AL ICT': [
    {'year': 2025, 'code': 'AL ICT 2025 – P3', 'pages': 14},
    {'year': 2024, 'code': 'AL ICT 2024 – P3', 'pages': 13},
    {'year': 2023, 'code': 'AL ICT 2023 – P3', 'pages': 12},
    {'year': 2022, 'code': 'AL ICT 2022 – P3', 'pages': 11},
    {'year': 2021, 'code': 'AL ICT 2021 – P3', 'pages': 10},
    {'year': 2020, 'code': 'AL ICT 2020 – P3', 'pages': 10},
    {'year': 2019, 'code': 'AL ICT 2019 – P3', 'pages': 9},
  ],
  'AL Physics': [
    {'year': 2025, 'code': 'AL Physics 2025 – P4', 'pages': 18},
    {'year': 2024, 'code': 'AL Physics 2024 – P4', 'pages': 17},
    {'year': 2023, 'code': 'AL Physics 2023 – P4', 'pages': 16},
    {'year': 2022, 'code': 'AL Physics 2022 – P4', 'pages': 16},
    {'year': 2021, 'code': 'AL Physics 2021 – P4', 'pages': 15},
    {'year': 2020, 'code': 'AL Physics 2020 – P4', 'pages': 14},
    {'year': 2019, 'code': 'AL Physics 2019 – P4', 'pages': 13},
    {'year': 2018, 'code': 'AL Physics 2018 – P4', 'pages': 13},
  ],
  'AL Chemistry': [
    {'year': 2025, 'code': 'AL Chemistry 2025 – P4', 'pages': 16},
    {'year': 2024, 'code': 'AL Chemistry 2024 – P4', 'pages': 15},
    {'year': 2023, 'code': 'AL Chemistry 2023 – P4', 'pages': 14},
    {'year': 2022, 'code': 'AL Chemistry 2022 – P4', 'pages': 14},
    {'year': 2021, 'code': 'AL Chemistry 2021 – P4', 'pages': 13},
    {'year': 2020, 'code': 'AL Chemistry 2020 – P4', 'pages': 12},
    {'year': 2019, 'code': 'AL Chemistry 2019 – P4', 'pages': 11},
  ],
  'AL Biology': [
    {'year': 2025, 'code': 'AL Biology 2025 – P4', 'pages': 15},
    {'year': 2024, 'code': 'AL Biology 2024 – P4', 'pages': 14},
    {'year': 2023, 'code': 'AL Biology 2023 – P4', 'pages': 13},
    {'year': 2022, 'code': 'AL Biology 2022 – P4', 'pages': 12},
    {'year': 2021, 'code': 'AL Biology 2021 – P4', 'pages': 12},
    {'year': 2020, 'code': 'AL Biology 2020 – P4', 'pages': 11},
    {'year': 2019, 'code': 'AL Biology 2019 – P4', 'pages': 10},
  ],
};

Map<String, List<Map<String, dynamic>>> _subjectSolutions = {
  'OL Computer Science': [
    {'year': 2024, 'code': 'OL Computer Science 2024 – Solutions', 'pages': 8},
    {'year': 2023, 'code': 'OL Computer Science 2023 – Solutions', 'pages': 7},
    {'year': 2022, 'code': 'OL Computer Science 2022 – Solutions', 'pages': 7},
    {'year': 2021, 'code': 'OL Computer Science 2021 – Solutions', 'pages': 6},
  ],
  'AL Computer Science': [
    {'year': 2025, 'code': 'AL Computer Science 2025 – Solutions', 'pages': 10},
    {'year': 2024, 'code': 'AL Computer Science 2024 – Solutions', 'pages': 11},
    {'year': 2023, 'code': 'AL Computer Science 2023 – Solutions', 'pages': 10},
    {'year': 2022, 'code': 'AL Computer Science 2022 – Solutions', 'pages': 9},
    {'year': 2021, 'code': 'AL Computer Science 2021 – Solutions', 'pages': 9},
    {'year': 2020, 'code': 'AL Computer Science 2020 – Solutions', 'pages': 8},
  ],
  'AL ICT': [
    {'year': 2025, 'code': 'AL ICT 2025 – Solutions', 'pages': 9},
    {'year': 2024, 'code': 'AL ICT 2024 – Solutions', 'pages': 8},
    {'year': 2023, 'code': 'AL ICT 2023 – Solutions', 'pages': 8},
    {'year': 2022, 'code': 'AL ICT 2022 – Solutions', 'pages': 7},
  ],
  'AL Physics': [
    {'year': 2025, 'code': 'AL Physics 2025 – Solutions', 'pages': 12},
    {'year': 2024, 'code': 'AL Physics 2024 – Solutions', 'pages': 11},
    {'year': 2023, 'code': 'AL Physics 2023 – Solutions', 'pages': 11},
    {'year': 2022, 'code': 'AL Physics 2022 – Solutions', 'pages': 10},
    {'year': 2021, 'code': 'AL Physics 2021 – Solutions', 'pages': 9},
  ],
  'AL Chemistry': [
    {'year': 2025, 'code': 'AL Chemistry 2025 – Solutions', 'pages': 10},
    {'year': 2024, 'code': 'AL Chemistry 2024 – Solutions', 'pages': 9},
    {'year': 2023, 'code': 'AL Chemistry 2023 – Solutions', 'pages': 9},
    {'year': 2022, 'code': 'AL Chemistry 2022 – Solutions', 'pages': 8},
  ],
  'AL Biology': [
    {'year': 2025, 'code': 'AL Biology 2025 – Solutions', 'pages': 9},
    {'year': 2024, 'code': 'AL Biology 2024 – Solutions', 'pages': 8},
    {'year': 2023, 'code': 'AL Biology 2023 – Solutions', 'pages': 8},
    {'year': 2022, 'code': 'AL Biology 2022 – Solutions', 'pages': 7},
  ],
};

// ── SubjectPapersPage ─────────────────────────────────────────────────────────
class SubjectPapersPage extends StatefulWidget {
  final Map<String, dynamic> subject;

  const SubjectPapersPage({super.key, required this.subject});

  @override
  State<SubjectPapersPage> createState() => _SubjectPapersPageState();
}

class _SubjectPapersPageState extends State<SubjectPapersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showStickyBar = false;
  static const double _headerTriggerOffset = 100.0;

  // ── Theme helpers ──────────────────────────────────────────────────────────
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
  Color get _dividerColor =>
      _isDark ? AppColors.darkDivider : AppColors.lightDivider;
  Color get _stickyBarBg =>
      _isDark ? AppColors.darkBg2 : const Color(0xFF1A237E);

  // ── Responsive helpers ─────────────────────────────────────────────────────
  bool _isMediumTablet(double w) => w >= 600 && w < 800;
  bool _isLargeTablet(double w) => w >= 800;
  bool _isTablet(double w) => w >= 600;
  double _hPad(double w) => _isLargeTablet(w)
      ? 32
      : _isMediumTablet(w)
      ? 24
      : 16;

  List<Map<String, dynamic>> get _papers =>
      _subjectPapers[widget.subject['subject']] ?? [];

  List<Map<String, dynamic>> get _solutions =>
      _subjectSolutions[widget.subject['subject']] ?? [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    themeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    final gradientColors = widget.subject['gradient'] as List<Color>;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: true,
        top: false,
        child: Container(
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
              // ── Main content ───────────────────────────────────────────────
              NestedScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: _buildHeroHeader(
                      context,
                      topPadding,
                      screenWidth,
                      gradientColors,
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(
                      tabController: _tabController,
                      isDark: _isDark,
                      accentColor: _accentColor,
                      cardColor: _cardColor,
                      cardBorder: _cardBorder,
                      dividerColor: _dividerColor,
                      titleColor: _titleColor,
                      subtitleColor: _subtitleColor,
                      gradientColors: gradientColors,
                    ),
                  ),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    // Past Papers tab
                    _buildPapersList(_papers, screenWidth, gradientColors),
                    // Solutions tab
                    _buildSolutionsList(
                      _solutions,
                      screenWidth,

                      gradientColors,
                    ),
                  ],
                ),
              ),

              // ── Sticky app bar ─────────────────────────────────────────────
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
      ),
    );
  }

  // ── Hero header with subject card ──────────────────────────────────────────
  Widget _buildHeroHeader(
    BuildContext context,
    double topPadding,
    double screenWidth,
    List<Color> gradientColors,
  ) {
    final hPad = _hPad(screenWidth);
    final isTablet = _isTablet(screenWidth);
    final isLarge = _isLargeTablet(screenWidth);
    final isMedium = _isMediumTablet(screenWidth);

    final double cardHeight = isLarge
        ? 200
        : isMedium
        ? 170
        : 150;
    final double imageWidth = isLarge
        ? 220
        : isMedium
        ? 185
        : 155;
    final double fadeCoverWidth = isLarge
        ? 250
        : isMedium
        ? 215
        : 175;
    final double borderRadius = isLarge ? 22 : 18;

    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Back button row ────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, topPadding + 10, hPad, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: isTablet ? 42 : 36,
                    height: isTablet ? 42 : 36,
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _cardBorder, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: _accentColor.withValues(alpha: 0.07),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: _accentColor,
                      size: isTablet ? 18 : 15,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Past Papers',
                  style: TextStyle(
                    fontSize: isLarge ? 28 : 22,
                    fontWeight: FontWeight.w700,
                    color: _titleColor,
                    fontFamily: 'GoogleSansFlex',
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Subject hero card ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 4, hPad, 16),
            child: Container(
              height: cardHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[1].withValues(alpha: 0.28),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 40,
                      top: -40,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),

                    // Subject image flush right
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius),
                        ),
                        child: Image.asset(
                          widget.subject['image'] as String,
                          width: imageWidth,
                          height: cardHeight,
                          fit: BoxFit.cover,
                          alignment: Alignment.centerRight,
                          errorBuilder: (_, __, ___) => Container(
                            width: imageWidth,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Gradient fade over image
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: fadeCoverWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              gradientColors[0],
                              gradientColors[0].withValues(alpha: 0.0),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),

                    // Text left
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      right: 100,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          isTablet ? 22 : 18,
                          isTablet ? 20 : 16,
                          0,
                          isTablet ? 20 : 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isLarge ? 12 : 8,
                                    vertical: isLarge ? 5 : 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    widget.subject['tag'] as String,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isLarge ? 13 : 9,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'GoogleSansFlex',
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 8 : 6),
                                Text(
                                  widget.subject['subject'] as String,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isLarge ? 22 : 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'GoogleSansFlex',
                                    letterSpacing: -0.3,
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.folder_rounded,
                                  size: isLarge ? 17 : 12,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.subject['papers'] as String,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: isLarge ? 15 : 11,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'GoogleSansFlex',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Papers list ────────────────────────────────────────────────────────────
  Widget _buildPapersList(
    List<Map<String, dynamic>> papers,
    double screenWidth,
    List<Color> gradientColors,
  ) {
    final hPad = _hPad(screenWidth);

    if (papers.isEmpty) {
      return _buildEmptyState('No past papers available yet.');
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
      physics: const BouncingScrollPhysics(),
      itemCount: papers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final paper = papers[index];
        return _PaperItemCard(
          code: paper['code'] as String,
          year: paper['year'] as int,
          pages: paper['pages'] as int,
          isSolution: false,
          isDark: _isDark,
          accentColor: _accentColor,
          cardColor: _cardColor,
          cardBorder: _cardBorder,
          titleColor: _titleColor,
          subtitleColor: _subtitleColor,
          gradientColors: gradientColors,
          screenWidth: screenWidth,
        );
      },
    );
  }

  // ── Solutions list ─────────────────────────────────────────────────────────
  Widget _buildSolutionsList(
    List<Map<String, dynamic>> solutions,
    double screenWidth,
    List<Color> gradientColors,
  ) {
    final hPad = _hPad(screenWidth);

    if (solutions.isEmpty) {
      return _buildEmptyState('Solutions coming soon.');
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 10),
      physics: const BouncingScrollPhysics(),
      itemCount: solutions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final solution = solutions[index];
        return _PaperItemCard(
          code: solution['code'] as String,
          year: solution['year'] as int,
          pages: solution['pages'] as int,
          isSolution: true,
          isDark: _isDark,
          accentColor: _accentColor,
          cardColor: _cardColor,
          cardBorder: _cardBorder,
          titleColor: _titleColor,
          subtitleColor: _subtitleColor,
          gradientColors: gradientColors,
          screenWidth: screenWidth,
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, size: 56, color: _subtitleColor),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              color: _subtitleColor,
              fontFamily: 'GoogleSansFlex',
            ),
          ),
        ],
      ),
    );
  }

  // ── Sticky bar ─────────────────────────────────────────────────────────────
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
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.subject['subject'] as String,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF5F6FF),
                fontFamily: 'GoogleSansFlex',
                letterSpacing: -0.3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── TabBar pinned delegate ────────────────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final bool isDark;
  final Color accentColor;
  final Color cardColor;
  final Color cardBorder;
  final Color dividerColor;
  final Color titleColor;
  final Color subtitleColor;
  final List<Color> gradientColors;

  const _TabBarDelegate({
    required this.tabController,
    required this.isDark,
    required this.accentColor,
    required this.cardColor,
    required this.cardBorder,
    required this.dividerColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.gradientColors,
  });

  @override
  double get minExtent => 56;
  @override
  double get maxExtent => 56;

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      oldDelegate.isDark != isDark ||
      oldDelegate.tabController != tabController;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg2 : AppColors.lightBg2,
        border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
      ),
      child: TabBar(
        controller: tabController,
        indicatorColor: gradientColors[1],
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: gradientColors[1],
        unselectedLabelColor: subtitleColor,
        labelStyle: const TextStyle(
          fontFamily: 'GoogleSansFlex',
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'GoogleSansFlex',
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Past Papers'),
          Tab(text: 'Solutions'),
        ],
      ),
    );
  }
}

// ── Individual paper / solution card ──────────────────────────────────────────
class _PaperItemCard extends StatelessWidget {
  final String code;
  final int year;
  final int pages;
  final bool isSolution;
  final bool isDark;
  final Color accentColor;
  final Color cardColor;
  final Color cardBorder;
  final Color titleColor;
  final Color subtitleColor;
  final List<Color> gradientColors;
  final double screenWidth;

  const _PaperItemCard({
    required this.code,
    required this.year,
    required this.pages,
    required this.isSolution,
    required this.isDark,
    required this.accentColor,
    required this.cardColor,
    required this.cardBorder,
    required this.titleColor,
    required this.subtitleColor,
    required this.gradientColors,
    required this.screenWidth,
  });

  bool get _isTablet => screenWidth >= 600;

  @override
  Widget build(BuildContext context) {
    final iconBg = gradientColors[0].withValues(alpha: 0.12);
    final iconColor = gradientColors[1];

    return GestureDetector(
      onTap: () {
        // TODO: navigate to paper viewer
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(_isTablet ? 18 : 14),
          border: Border.all(color: cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _isTablet ? 18 : 14,
            vertical: _isTablet ? 16 : 13,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: _isTablet ? 46 : 40,
                height: _isTablet ? 46 : 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSolution
                      ? Icons.lightbulb_rounded
                      : Icons.description_rounded,
                  color: iconColor,
                  size: _isTablet ? 22 : 19,
                ),
              ),
              const SizedBox(width: 14),
              // Title & meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: _isTablet ? 15 : 13.5,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                        fontFamily: 'GoogleSansFlex',
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: _isTablet ? 12 : 11,
                          color: subtitleColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$year',
                          style: TextStyle(
                            fontSize: _isTablet ? 12 : 11,
                            color: subtitleColor,
                            fontFamily: 'GoogleSansFlex',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.auto_stories_rounded,
                          size: _isTablet ? 12 : 11,
                          color: subtitleColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$pages pages',
                          style: TextStyle(
                            fontSize: _isTablet ? 12 : 11,
                            color: subtitleColor,
                            fontFamily: 'GoogleSansFlex',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Chevron / download hint
              Container(
                width: _isTablet ? 34 : 30,
                height: _isTablet ? 34 : 30,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.download_rounded,
                  color: iconColor,
                  size: _isTablet ? 17 : 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
