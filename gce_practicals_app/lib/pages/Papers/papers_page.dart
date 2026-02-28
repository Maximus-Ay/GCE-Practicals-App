import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gce_practicals_app/pages/Profile/profile_page.dart';

// ── Import your themeNotifier and AppColors from wherever you placed them ─────
// e.g. import 'theme_notifier.dart';
// This file assumes themeNotifier and AppColors are available globally,
// exactly as defined in profile_page.dart. Move them to a shared file and
// import that file here when you are ready.

class PapersPage extends StatefulWidget {
  const PapersPage({super.key});

  @override
  State<PapersPage> createState() => _PapersPageState();
}

class _PapersPageState extends State<PapersPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _showStickyBar = false;
  final int _selectedFilter = 0;

  static const double _headerTriggerOffset = 20.0;

  static const List<Map<String, dynamic>> _papers = [
    {
      'subject': 'OL Computer Science',
      'description':
          'Past practical papers for Ordinary Level CSC. Covers programming, data handling and hardware fundamentals.',
      'tag': 'O Level',
      'image': 'assets/images/Csc.png',
      'gradient': [Color(0xFF4FC3F7), Color(0xFF0288D1)],
      'filter': 1,
      'papers': '12 Papers',
    },
    {
      'subject': 'AL Computer Science',
      'description':
          'Advanced Level practical papers covering algorithms, data structures, OOP and system design.',
      'tag': 'A Level',
      'image': 'assets/images/Computer.png',
      'gradient': [Color(0xFF7986CB), Color(0xFF3949AB)],
      'filter': 2,
      'papers': '18 Papers',
    },
    {
      'subject': 'AL ICT',
      'description':
          'Information & Communication Technology practicals. Networks, databases, web technologies and more.',
      'tag': 'A Level',
      'image': 'assets/images/Ict.png',
      'gradient': [Color(0xFF4DB6AC), Color(0xFF00796B)],
      'filter': 3,
      'papers': '15 Papers',
    },
    {
      'subject': 'AL Physics',
      'description':
          'Advanced Level Physics practicals. Mechanics, electricity, optics and modern physics experiments.',
      'tag': 'A Level',
      'image': 'assets/images/Physics.png',
      'gradient': [Color(0xFFFFB74D), Color(0xFFF57C00)],
      'filter': 4,
      'papers': '20 Papers',
    },
    {
      'subject': 'AL Chemistry',
      'description':
          'Chemistry practicals for Advanced Level. Titrations, organic synthesis, qualitative analysis and more.',
      'tag': 'A Level',
      'image': 'assets/images/Chemistry.png',
      'gradient': [Color(0xFFF06292), Color(0xFFC2185B)],
      'filter': 5,
      'papers': '17 Papers',
    },
    {
      'subject': 'AL Biology',
      'description':
          'Biology practicals for Advanced Level. Microscopy, dissection, genetics and ecological studies.',
      'tag': 'A Level',
      'image': 'assets/images/Biology.png',
      'gradient': [Color(0xFF81C784), Color(0xFF388E3C)],
      'filter': 6,
      'papers': '16 Papers',
    },
  ];

  List<Map<String, dynamic>> get _filteredPapers {
    final query = _searchController.text.toLowerCase();
    return _papers.where((p) {
      final matchesFilter =
          _selectedFilter == 0 || p['filter'] == _selectedFilter;
      final matchesSearch =
          query.isEmpty ||
          (p['subject'] as String).toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
    }).toList();
  }

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
  Color get _searchBarColor => _isDark
      ? AppColors.darkCard.withValues(alpha: 0.85)
      : Colors.white.withValues(alpha: 0.75);
  Color get _searchBarBorder => _isDark
      ? AppColors.darkCardBorder.withValues(alpha: 0.8)
      : Colors.white.withValues(alpha: 0.9);
  Color get _searchTextColor =>
      _isDark ? AppColors.darkTitle : const Color(0xFF1A237E);
  Color get _searchHintColor => _isDark
      ? AppColors.darkSubtitle.withValues(alpha: 0.8)
      : const Color(0xFF90A4AE).withValues(alpha: 0.8);
  Color get _stickyBarBg =>
      _isDark ? AppColors.darkBg2 : const Color(0xFF1A237E);

  // -- Responsive helpers ----------------------------------------------------
  bool _isMediumTablet(double w) => w >= 600 && w < 800;
  bool _isLargeTablet(double w) => w >= 800;
  double _hPad(double w) => _isLargeTablet(w)
      ? 32
      : _isMediumTablet(w)
      ? 24
      : 16;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() => setState(() {}));
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    themeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    final filtered = _filteredPapers;

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
            // -- Main scroll view -------------------------------------------
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(context, topPadding, screenWidth),
                ),
                SliverToBoxAdapter(child: _buildSearchBar(screenWidth)),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    _hPad(screenWidth),
                    16,
                    _hPad(screenWidth),
                    10,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _PaperCard(paper: filtered[index], isDark: _isDark),
                      childCount: filtered.length,
                    ),
                  ),
                ),
              ],
            ),

            // -- Sticky app bar ---------------------------------------------
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
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Past Papers',
            style: TextStyle(
              fontSize: isLarge ? 32 : 26,
              fontWeight: FontWeight.w700,
              color: _titleColor,
              fontFamily: 'GoogleSansFlex',
              letterSpacing: -0.5,
            ),
          ),
          // Coin badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.coin.withValues(alpha: _isDark ? 0.15 : 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.coin.withValues(alpha: 0.3),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.white.withValues(alpha: 0.7),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.coin.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/coin.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.monetization_on_rounded,
                        color: AppColors.coin,
                        size: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '100',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _isDark ? AppColors.coin : AppColors.coinDark,
                    fontFamily: 'GoogleSansFlex',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -- Search bar ------------------------------------------------------------
  Widget _buildSearchBar(double screenWidth) {
    final hPad = _hPad(screenWidth);
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 0),
      child: Container(
        height: 53,
        decoration: BoxDecoration(
          color: _searchBarColor,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: _searchBarBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: _accentColor.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            fontSize: 16,
            color: _searchTextColor,
            fontFamily: 'GoogleSansFlex',
          ),
          decoration: InputDecoration(
            hintText: 'Search subjects...',
            hintStyle: TextStyle(
              fontSize: 15,
              color: _searchHintColor,
              fontFamily: 'GoogleSansFlex',
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: _accentColor,
              size: 20,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () => _searchController.clear(),
                    child: Icon(
                      Icons.close_rounded,
                      color: _subtitleColor,
                      size: 18,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
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
          const Text(
            'Past Papers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF5F6FF),
              fontFamily: 'GoogleSansFlex',
              letterSpacing: -0.4,
            ),
          ),
          // Coin — always white text, bar is always dark
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/coin.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.monetization_on_rounded,
                      color: AppColors.coin,
                      size: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '100',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'GoogleSansFlex',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -- Paper Card --------------------------------------------------------------

class _PaperCard extends StatelessWidget {
  final Map<String, dynamic> paper;
  final bool isDark;

  const _PaperCard({required this.paper, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final gradientColors = paper['gradient'] as List<Color>;
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isMediumTablet = screenWidth >= 600 && screenWidth < 800;
    final bool isLargeTablet = screenWidth >= 800;
    final bool isTablet = screenWidth >= 600;

    final double cardHeight = isLargeTablet
        ? 200
        : isMediumTablet
        ? 170
        : 140;
    final double imageWidth = isLargeTablet
        ? 230
        : isMediumTablet
        ? 190
        : 160;
    final double fadeCoverWidth = isLargeTablet
        ? 260
        : isMediumTablet
        ? 220
        : 180;
    final double tagFontSize = isLargeTablet
        ? 13
        : isMediumTablet
        ? 11
        : 9;
    final double subjectFontSize = isLargeTablet
        ? 22
        : isMediumTablet
        ? 19
        : 16;
    final double descFontSize = isLargeTablet
        ? 14
        : isMediumTablet
        ? 12
        : 10;
    final double paperCountFontSize = isLargeTablet
        ? 15
        : isMediumTablet
        ? 13
        : 11;
    final double iconSize = isLargeTablet
        ? 17
        : isMediumTablet
        ? 14
        : 12;
    final double cardPaddingH = isTablet ? 22.0 : 18.0;
    final double cardPaddingV = isTablet ? 20.0 : 16.0;
    final double tagPaddingH = isLargeTablet ? 12 : 8;
    final double tagPaddingV = isLargeTablet ? 5 : 3;
    final double borderRadius = isLargeTablet ? 22 : 18;
    final double decorCircle1Size = isLargeTablet
        ? 160
        : isMediumTablet
        ? 140
        : 120;
    final double decorCircle2Size = isLargeTablet
        ? 120
        : isMediumTablet
        ? 105
        : 90;

    // Slightly dimmer shadow in dark mode so it does not bloom
    final double shadowAlpha = isDark ? 0.18 : 0.30;

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: isTablet ? 18 : 14),
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
              color: gradientColors[1].withValues(alpha: shadowAlpha),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              // -- Decorative background circles -------------------------
              Positioned(
                left: -30,
                bottom: -30,
                child: Container(
                  width: decorCircle1Size,
                  height: decorCircle1Size,
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
                  width: decorCircle2Size,
                  height: decorCircle2Size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),

              // -- Subject image — flush right, fills height -------------
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
                    paper['image'] as String,
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

              // -- Gradient fade over image (left to transparent) --------
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

              // -- Text content on the left ------------------------------
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                right: 100,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    cardPaddingH,
                    cardPaddingV,
                    0,
                    cardPaddingV,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Level tag
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: tagPaddingH,
                              vertical: tagPaddingV,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              paper['tag'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: tagFontSize,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'GoogleSansFlex',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(height: isTablet ? 8 : 6),
                          // Subject name
                          Text(
                            paper['subject'] as String,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: subjectFontSize,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'GoogleSansFlex',
                              letterSpacing: -0.3,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                      // Description + papers count
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            paper['description'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: descFontSize,
                              fontFamily: 'GoogleSansFlex',
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: isTablet ? 8 : 6),
                          Row(
                            children: [
                              Icon(
                                Icons.folder_rounded,
                                size: iconSize,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                paper['papers'] as String,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: paperCountFontSize,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'GoogleSansFlex',
                                ),
                              ),
                            ],
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
    );
  }
}
