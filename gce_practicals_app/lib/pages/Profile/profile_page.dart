import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Theme notifier with SharedPreferences persistence ─────────────────────────
// Place this in a shared file (e.g. theme_notifier.dart) in your real app.
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const _key = 'app_theme_dark';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? false;
    value = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggle() async {
    value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value == ThemeMode.dark);
  }
}

// Global singleton — wire into your MaterialApp (see comment at bottom of file)
final themeNotifier = ThemeNotifier();

// ── Colour tokens ─────────────────────────────────────────────────────────────
class AppColors {
  // Light
  static const lightBg1 = Color(0xFFEEF0FF);
  static const lightBg2 = Color(0xFFF8F9FF);
  static const lightBg3 = Color(0xFFE8F4FF);
  static const lightTitle = Color(0xFF1A237E);
  static const lightSubtitle = Color(0xFF90A4AE);
  static const lightAccent = Color(0xFF3949AB);
  static const lightCard = Colors.white;
  static const lightCardBorder = Color(0xFFE8EAF6);
  static const lightIcon = Color(0xFF3949AB);
  static const lightDivider = Color(0xFFE8EAF6);

  // Dark
  static const darkBg1 = Color(0xFF0D0F1E);
  static const darkBg2 = Color(0xFF131629);
  static const darkBg3 = Color(0xFF0A0C18);
  static const darkTitle = Color(0xFFE8EAFF);
  static const darkSubtitle = Color(0xFF6B7A99);
  static const darkAccent = Color(0xFF738AFF);
  static const darkCard = Color(0xFF1A1D35);
  static const darkCardBorder = Color(0xFF252845);
  static const darkIcon = Color(0xFF738AFF);
  static const darkDivider = Color(0xFF252845);

  // Shared
  static const orange = Color(0xFFFF7043);
  static const coin = Color(0xFFFFB74D);
  static const coinDark = Color(0xFFF57C00);
}

// ── Profile Page ──────────────────────────────────────────────────────────────
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyBar = false;
  static const double _headerTriggerOffset = 20.0;

  // Dummy data
  bool _isSignedIn = false;
  final int _coins = 340;
  final int _streakDays = 4;
  final List<bool> _weekStreak = [true, true, true, true, false, false, false];
  final List<String> _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

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
      final isDark = themeNotifier.value == ThemeMode.dark;
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: (shouldShow || isDark)
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
    themeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

  bool get _isDark => themeNotifier.value == ThemeMode.dark;

  // ── Colour helpers ────────────────────────────────────────────────────────
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

  // ── Responsive helpers ────────────────────────────────────────────────────
  bool _isMediumTablet(double w) => w >= 600 && w < 800;
  bool _isLargeTablet(double w) => w >= 800;
  bool _isTablet(double w) => w >= 600;
  double _hPad(double w) => _isLargeTablet(w)
      ? 32
      : _isMediumTablet(w)
      ? 24
      : 16;

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;

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
                SliverToBoxAdapter(child: _buildProfileCard(screenWidth)),
                SliverToBoxAdapter(child: _buildStreakCard(screenWidth)),
                SliverToBoxAdapter(child: _buildThemeToggle(screenWidth)),
                SliverToBoxAdapter(
                  child: _buildSectionTitle('Social Media', screenWidth),
                ),
                SliverToBoxAdapter(child: _buildSocialSection(screenWidth)),
                SliverToBoxAdapter(
                  child: _buildSectionTitle('About & Legal', screenWidth),
                ),
                SliverToBoxAdapter(child: _buildAboutSection(screenWidth)),
                SliverToBoxAdapter(child: _buildCopyrightFooter(screenWidth)),
                // ── Bottom padding ─────────────────────────────────────────
                // Adjust the value below (currently 24) to change the space
                // between the copyright text and the bottom nav bar.
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),

            // Sticky bar
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

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(
    BuildContext context,
    double topPadding,
    double screenWidth,
  ) {
    final hPad = _hPad(screenWidth);
    return Container(
      padding: EdgeInsets.fromLTRB(hPad, topPadding + 6, hPad, 6),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Profile',
            style: TextStyle(
              fontSize: _isLargeTablet(screenWidth) ? 32 : 26,
              fontWeight: FontWeight.w700,
              color: _titleColor,
              fontFamily: 'GoogleSansFlex',
              letterSpacing: -0.5,
            ),
          ),
          // Coins badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/coin.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.monetization_on_rounded,
                        color: AppColors.coin,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$_coins',
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

  // ── Sticky bar ────────────────────────────────────────────────────────────
  Widget _buildStickyBar(double topPadding) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 12),
      decoration: BoxDecoration(
        color: _isDark ? const Color(0xFF131629) : const Color(0xFF1A237E),
        boxShadow: [
          BoxShadow(
            color: (_isDark ? const Color(0xFF0D0F1E) : const Color(0xFF1A237E))
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
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF5F6FF),
              fontFamily: 'GoogleSansFlex',
              letterSpacing: -0.4,
            ),
          ),
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
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
                      size: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$_coins',
                style: const TextStyle(
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

  // ── Profile card ──────────────────────────────────────────────────────────
  Widget _buildProfileCard(double screenWidth) {
    final hPad = _hPad(screenWidth);
    final isTablet = _isTablet(screenWidth);
    final avatarSize = _isLargeTablet(screenWidth)
        ? 90.0
        : isTablet
        ? 76.0
        : 64.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 22 : 18),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
          border: Border.all(color: _cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: _accentColor.withValues(alpha: _isDark ? 0.08 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: _isSignedIn
            ? _buildSignedInProfile(avatarSize, screenWidth)
            : _buildGuestProfile(avatarSize, screenWidth),
      ),
    );
  }

  Widget _buildSignedInProfile(double avatarSize, double screenWidth) {
    final isTablet = _isTablet(screenWidth);
    return Row(
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [_accentColor, _accentColor.withValues(alpha: 0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _accentColor.withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: avatarSize * 0.5,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alex Johnson',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 17,
                  fontWeight: FontWeight.w700,
                  color: _titleColor,
                  fontFamily: 'GoogleSansFlex',
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'alex.johnson@gmail.com',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: _subtitleColor,
                  fontFamily: 'GoogleSansFlex',
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Complete your profile →',
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 11,
                    fontWeight: FontWeight.w600,
                    color: _accentColor,
                    fontFamily: 'GoogleSansFlex',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuestProfile(double avatarSize, double screenWidth) {
    final isTablet = _isTablet(screenWidth);
    return Row(
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isDark
                ? _accentColor.withValues(alpha: 0.12)
                : _accentColor.withValues(alpha: 0.08),
            border: Border.all(
              color: _accentColor.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.person_outline_rounded,
            color: _accentColor.withValues(alpha: 0.5),
            size: avatarSize * 0.45,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guest User',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 17,
                  fontWeight: FontWeight.w700,
                  color: _titleColor,
                  fontFamily: 'GoogleSansFlex',
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sign in to save your progress',
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  color: _subtitleColor,
                  fontFamily: 'GoogleSansFlex',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Streak card ───────────────────────────────────────────────────────────
  Widget _buildStreakCard(double screenWidth) {
    final hPad = _hPad(screenWidth);
    final isTablet = _isTablet(screenWidth);
    final isLarge = _isLargeTablet(screenWidth);

    final dotSize = isLarge
        ? 46.0
        : isTablet
        ? 40.0
        : 34.0;
    final dotFontSize = isLarge
        ? 13.0
        : isTablet
        ? 12.0
        : 11.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 22 : 18),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
          border: Border.all(color: _cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: isTablet ? 36 : 30,
                      height: isTablet ? 36 : 30,
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        color: AppColors.orange,
                        size: isTablet ? 20 : 17,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Streak',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 15,
                        fontWeight: FontWeight.w700,
                        color: _titleColor,
                        fontFamily: 'GoogleSansFlex',
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.orange.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$_streakDays day${_streakDays == 1 ? '' : 's'} 🔥',
                    style: TextStyle(
                      fontSize: isTablet ? 13 : 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.orange,
                      fontFamily: 'GoogleSansFlex',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final done = _weekStreak[i];
                return Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done
                            ? AppColors.orange
                            : _isDark
                            ? AppColors.darkCardBorder
                            : const Color(0xFFF0F0F0),
                        boxShadow: done
                            ? [
                                BoxShadow(
                                  color: AppColors.orange.withValues(
                                    alpha: 0.35,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: done
                          ? Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: dotSize * 0.48,
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _weekDays[i],
                      style: TextStyle(
                        fontSize: dotFontSize,
                        fontWeight: FontWeight.w600,
                        color: done ? AppColors.orange : _subtitleColor,
                        fontFamily: 'GoogleSansFlex',
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 14),
            Container(
              padding: EdgeInsets.all(isTablet ? 14 : 12),
              decoration: BoxDecoration(
                color: AppColors.coin.withValues(alpha: _isDark ? 0.08 : 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.coin.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: isTablet ? 32 : 26,
                    height: isTablet ? 32 : 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.coin.withValues(alpha: 0.15),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/coin.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.monetization_on_rounded,
                          color: AppColors.coin,
                          size: isTablet ? 18 : 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Coins',
                          style: TextStyle(
                            fontSize: isTablet ? 12 : 11,
                            color: _subtitleColor,
                            fontFamily: 'GoogleSansFlex',
                          ),
                        ),
                        Text(
                          '$_coins coins',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w700,
                            color: _isDark
                                ? AppColors.coin
                                : AppColors.coinDark,
                            fontFamily: 'GoogleSansFlex',
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
      ),
    );
  }

  // ── Theme toggle ──────────────────────────────────────────────────────────
  // To adjust toggle + container size: change the values marked with ← below.
  Widget _buildThemeToggle(double screenWidth) {
    final hPad = _hPad(screenWidth);
    final isTablet = _isTablet(screenWidth);
    final isLarge = _isLargeTablet(screenWidth);

    // ── Sizes to tweak ───────────────────────────────────────────────────────
    final double iconBoxSize = isLarge
        ? 48
        : isTablet
        ? 44
        : 40; // ← icon box
    final double iconSize = isLarge
        ? 26
        : isTablet
        ? 22
        : 20; // ← icon
    final double titleSize = isLarge
        ? 20
        : isTablet
        ? 18
        : 16; // ← title text
    final double subtitleSize = isLarge
        ? 15
        : isTablet
        ? 13
        : 12; // ← subtitle text
    final double pillW = isLarge
        ? 70
        : isTablet
        ? 62
        : 56; // ← toggle pill width
    final double pillH = isLarge
        ? 38
        : isTablet
        ? 34
        : 30; // ← toggle pill height
    final double thumbSize = pillH - 8; // ← thumb circle
    final double vPad = isTablet ? 20 : 18; // ← card vertical padding
    final double hPadCard = isTablet ? 22 : 18; // ← card horizontal padding

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: hPadCard, vertical: vPad),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
          border: Border.all(color: _cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: _accentColor.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: iconBoxSize,
              height: iconBoxSize,
              decoration: BoxDecoration(
                color: _isDark
                    ? const Color(0xFF738AFF).withValues(alpha: 0.12)
                    : const Color(0xFFFFB74D).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: _isDark
                    ? const Color(0xFF738AFF)
                    : const Color(0xFFFFB74D),
                size: iconSize,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      color: _titleColor,
                      fontFamily: 'GoogleSansFlex',
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _isDark ? 'Dark theme is on' : 'Light theme is on',
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: _subtitleColor,
                      fontFamily: 'GoogleSansFlex',
                    ),
                  ),
                ],
              ),
            ),
            // Toggle pill
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact(); // ← haptic feedback on toggle
                themeNotifier.toggle();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                width: pillW,
                height: pillH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: _isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF4FC3F7), Color(0xFF738AFF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: _isDark ? null : const Color(0xFFDDE1F0),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOut,
                  alignment: _isDark
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    width: thumbSize,
                    height: thumbSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                      size: thumbSize * 0.55,
                      color: _isDark
                          ? const Color(0xFF738AFF)
                          : const Color(0xFFFFB74D),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section title ─────────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title, double screenWidth) {
    final hPad = _hPad(screenWidth);
    final isTablet = _isTablet(screenWidth);
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad + 4, 24, hPad, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: isTablet ? 12 : 11,
          fontWeight: FontWeight.w700,
          color: _subtitleColor,
          fontFamily: 'GoogleSansFlex',
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ── Social media section ──────────────────────────────────────────────────
  Widget _buildSocialSection(double screenWidth) {
    final socials = [
      {
        'label': 'WhatsApp',
        'icon': Icons.chat_rounded,
        'color': const Color(0xFF25D366),
      },
      {
        'label': 'Instagram',
        'icon': Icons.camera_alt_rounded,
        'color': const Color(0xFFE1306C),
      },
      {
        'label': 'YouTube',
        'icon': Icons.play_circle_rounded,
        'color': const Color(0xFFFF0000),
      },
      {
        'label': 'Facebook',
        'icon': Icons.facebook_rounded,
        'color': const Color(0xFF1877F2),
      },
      {
        'label': 'TikTok',
        'icon': Icons.music_note_rounded,
        'color': const Color(0xFF010101),
      },
      {
        'label': 'LinkedIn',
        'icon': Icons.work_rounded,
        'color': const Color(0xFF0A66C2),
      },
    ];
    return _buildListCard(
      socials
          .map(
            (s) => _ListItem(
              label: s['label'] as String,
              icon: s['icon'] as IconData,
              iconColor: s['color'] as Color,
              onTap: () {},
            ),
          )
          .toList(),
      screenWidth,
    );
  }

  // ── About & legal section ─────────────────────────────────────────────────
  Widget _buildAboutSection(double screenWidth) {
    final items = [
      {
        'label': 'Terms of Service',
        'icon': Icons.description_rounded,
        'color': const Color(0xFF3949AB),
      },
      {
        'label': 'Privacy Policy',
        'icon': Icons.privacy_tip_rounded,
        'color': const Color(0xFF0288D1),
      },
      {
        'label': 'Legal',
        'icon': Icons.gavel_rounded,
        'color': const Color(0xFF5E35B1),
      },
      {
        'label': 'Rate the App ⭐',
        'icon': Icons.star_rounded,
        'color': const Color(0xFFFFB300),
      },
    ];
    return _buildListCard(
      items
          .map(
            (s) => _ListItem(
              label: s['label'] as String,
              icon: s['icon'] as IconData,
              iconColor: s['color'] as Color,
              onTap: () {},
            ),
          )
          .toList(),
      screenWidth,
    );
  }

  Widget _buildListCard(List<_ListItem> items, double screenWidth) {
    final hPad = _hPad(screenWidth);
    final isTablet = _isTablet(screenWidth);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Container(
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
          border: Border.all(color: _cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: _accentColor.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            final isLast = i == items.length - 1;
            return _buildListRow(item, isLast, isTablet);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildListRow(_ListItem item, bool isLast, bool isTablet) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 20 : 16,
              vertical: isTablet ? 16 : 14,
            ),
            child: Row(
              children: [
                Container(
                  width: isTablet ? 36 : 32,
                  height: isTablet ? 36 : 32,
                  decoration: BoxDecoration(
                    color: item.iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.iconColor,
                    size: isTablet ? 20 : 17,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: isTablet ? 15 : 14,
                      fontWeight: FontWeight.w500,
                      color: _titleColor,
                      fontFamily: 'GoogleSansFlex',
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _subtitleColor,
                  size: isTablet ? 22 : 20,
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              thickness: 1,
              color: _dividerColor,
              indent: isTablet ? 68 : 62,
            ),
        ],
      ),
    );
  }

  // ── Copyright footer ──────────────────────────────────────────────────────
  Widget _buildCopyrightFooter(double screenWidth) {
    final hPad = _hPad(screenWidth);
    final isTablet = _isTablet(screenWidth);
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 0),
      child: Column(
        children: [
          Divider(color: _dividerColor, thickness: 1, height: 1),
          const SizedBox(height: 20),
          Text(
            'Smart Way GCE Practicals',
            style: TextStyle(
              fontSize: isTablet ? 15 : 13,
              fontWeight: FontWeight.w700,
              color: _titleColor,
              fontFamily: 'GoogleSansFlex',
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '© 2026 Smart Way Inc. All rights reserved.',
            style: TextStyle(
              fontSize: isTablet ? 13 : 11,
              color: _subtitleColor,
              fontFamily: 'GoogleSansFlex',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: isTablet ? 12 : 10,
              color: _subtitleColor.withValues(alpha: 0.6),
              fontFamily: 'GoogleSansFlex',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Helper model ──────────────────────────────────────────────────────────────
class _ListItem {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  const _ListItem({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
}
