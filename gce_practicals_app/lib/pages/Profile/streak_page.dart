import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gce_practicals_app/pages/Profile/profile_page.dart';

// Import your shared theme file:
// import 'theme_notifier.dart';

class StreakPage extends StatefulWidget {
  final int streakDays;
  final int coins;
  final List<bool> weekStreak;

  const StreakPage({
    super.key,
    this.streakDays = 4,
    this.coins = 340,
    this.weekStreak = const [true, true, true, true, false, false, false],
  });

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fireController;
  late Animation<double> _fireScale;
  late Animation<double> _fireGlow;

  // Milestone goals: [min, max] pairs
  static const List<List<int>> _milestones = [
    [0, 5],
    [5, 15],
    [15, 30],
    [30, 50],
    [50, 100],
    [100, 200],
    [200, 300],
  ];

  static const List<String> _weekDays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  bool get _isDark => themeNotifier.value == ThemeMode.dark;

  // Colour helpers
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

  // Find current milestone bracket
  List<int> get _currentMilestone {
    for (final m in _milestones) {
      if (widget.streakDays < m[1]) return m;
    }
    return _milestones.last;
  }

  double get _milestoneProgress {
    final m = _currentMilestone;
    final range = m[1] - m[0];
    final progress = (widget.streakDays - m[0]).clamp(0, range);
    return progress / range;
  }

  int get _daysToNextMilestone {
    final m = _currentMilestone;
    return (m[1] - widget.streakDays).clamp(0, m[1]);
  }

  String get _streakStartDate => 'Feb 24, 2026'; // dummy

  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(_onThemeChange);

    _fireController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _fireScale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _fireController, curve: Curves.easeInOut),
    );
    _fireGlow = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _fireController, curve: Curves.easeInOut),
    );
  }

  void _onThemeChange() => setState(() {});

  @override
  void dispose() {
    _fireController.dispose();
    themeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ──────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildHeader(context, topPadding, isTablet),
            ),

            // ── Fire hero + big number ───────────────────────────────────────
            SliverToBoxAdapter(child: _buildFireHero(screenWidth, isTablet)),

            // ── Stats row (streak started / top % / max) ──────────────────
            SliverToBoxAdapter(child: _buildStatsRow(isTablet)),

            // ── This Week card ────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildThisWeekCard(isTablet)),

            // ── Milestone progress card ───────────────────────────────────
            SliverToBoxAdapter(child: _buildMilestoneCard(isTablet)),

            // ── All milestones list ───────────────────────────────────────
            SliverToBoxAdapter(child: _buildMilestonesList(isTablet)),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  // ── Header with back button ─────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, double topPadding, bool isTablet) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 8, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _isDark
                    ? AppColors.darkCard.withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.7),
                shape: BoxShape.circle,
                border: Border.all(color: _cardBorder, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orange.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: _titleColor,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'DAY STREAK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFF7043),
                  fontFamily: 'GoogleSansFlex',
                  letterSpacing: 2.5,
                ),
              ),
            ),
          ),
          // Info button (placeholder)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isDark
                  ? AppColors.darkCard.withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              border: Border.all(color: _cardBorder, width: 1),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: _subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Fire hero — animated asset + big streak number ──────────────────────
  Widget _buildFireHero(double screenWidth, bool isTablet) {
    final fireSize = isTablet ? 160.0 : 130.0;
    final numSize = isTablet ? 80.0 : 68.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          // Animated fire icon
          AnimatedBuilder(
            animation: _fireController,
            builder: (context, child) {
              return Transform.scale(
                scale: _fireScale.value,
                child: Container(
                  width: fireSize,
                  height: fireSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orange.withValues(
                          alpha: _fireGlow.value * 0.55,
                        ),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/fire.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.orange,
                      size: fireSize * 0.65,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Big streak number
          Text(
            '${widget.streakDays}',
            style: TextStyle(
              fontSize: numSize,
              fontWeight: FontWeight.w700,
              color: _titleColor,
              fontFamily: 'GoogleSansFlex',
              letterSpacing: -3,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'DAY STREAK',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _subtitleColor,
              fontFamily: 'GoogleSansFlex',
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats row ────────────────────────────────────────────────────────────
  Widget _buildStatsRow(bool isTablet) {
    final dividerColor = _isDark
        ? AppColors.darkCardBorder
        : const Color(0xFFE0E4F0);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 32 : 20,
        vertical: 8,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 20 : 16,
          horizontal: isTablet ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
          border: Border.all(color: _cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _buildStatCol(
                label: 'Streak started',
                value: _streakStartDate,
                isTablet: isTablet,
              ),
              VerticalDivider(color: dividerColor, thickness: 1, width: 1),
              _buildStatCol(
                label: 'Total coins',
                value: '${widget.coins} 🪙',
                isTablet: isTablet,
                valueColor: _isDark ? AppColors.coin : AppColors.coinDark,
              ),
              VerticalDivider(color: dividerColor, thickness: 1, width: 1),
              _buildStatCol(
                label: 'Max streak',
                value: '${widget.streakDays}',
                isTablet: isTablet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCol({
    required String label,
    required String value,
    required bool isTablet,
    Color? valueColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w700,
              color: valueColor ?? _titleColor,
              fontFamily: 'GoogleSansFlex',
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 11 : 10,
              color: _subtitleColor,
              fontFamily: 'GoogleSansFlex',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── This Week card ───────────────────────────────────────────────────────
  Widget _buildThisWeekCard(bool isTablet) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isTablet ? 32 : 20,
        12,
        isTablet ? 32 : 20,
        0,
      ),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 22 : 18),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
          border: Border.all(color: _cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'THIS WEEK',
              style: TextStyle(
                fontSize: isTablet ? 12 : 11,
                fontWeight: FontWeight.w700,
                color: _subtitleColor,
                fontFamily: 'GoogleSansFlex',
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final done = widget.weekStreak[i];
                final dotSize = isTablet ? 44.0 : 36.0;
                return Column(
                  children: [
                    Text(
                      _weekDays[i],
                      style: TextStyle(
                        fontSize: isTablet ? 11 : 10,
                        fontWeight: FontWeight.w600,
                        color: done ? AppColors.orange : _subtitleColor,
                        fontFamily: 'GoogleSansFlex',
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? AppColors.orange : Colors.transparent,
                        border: done
                            ? null
                            : Border.all(
                                color: _isDark
                                    ? AppColors.darkCardBorder
                                    : const Color(0xFFDDE0EE),
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                        boxShadow: done
                            ? [
                                BoxShadow(
                                  color: AppColors.orange.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: done
                          ? Image.asset(
                              'assets/images/fire.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.local_fire_department_rounded,
                                color: Colors.white,
                                size: dotSize * 0.5,
                              ),
                            )
                          : null,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Milestone progress card ──────────────────────────────────────────────
  Widget _buildMilestoneCard(bool isTablet) {
    final m = _currentMilestone;
    final progress = _milestoneProgress;
    final daysLeft = _daysToNextMilestone;

    // Milestone colours: progress fill uses orange gradient
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isTablet ? 32 : 20,
        12,
        isTablet ? 32 : 20,
        0,
      ),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 22 : 18),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
          border: Border.all(color: _cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "X more days to unlock your next milestone"
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.orange.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$daysLeft more day${daysLeft == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: isTablet ? 13 : 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.orange,
                      fontFamily: 'GoogleSansFlex',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'to unlock your next milestone.',
                    style: TextStyle(
                      fontSize: isTablet ? 13 : 12,
                      color: _subtitleColor,
                      fontFamily: 'GoogleSansFlex',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress bar row: left milestone icon + bar + right milestone icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left milestone (current target start)
                _MilestoneCircle(
                  label: '${m[0]}',
                  isAchieved: true,
                  isDark: _isDark,
                  size: isTablet ? 52.0 : 44.0,
                ),
                const SizedBox(width: 10),

                // Progress bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            // Track
                            Container(
                              height: isTablet ? 10 : 8,
                              decoration: BoxDecoration(
                                color: _isDark
                                    ? AppColors.darkCardBorder
                                    : const Color(0xFFE8EAF6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            // Fill
                            FractionallySizedBox(
                              widthFactor: progress.clamp(0.03, 1.0),
                              child: Container(
                                height: isTablet ? 10 : 8,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFB74D),
                                      Color(0xFFFF7043),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.orange.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),
                // Right milestone (next target)
                _MilestoneCircle(
                  label: '${m[1]}',
                  isAchieved: false,
                  isDark: _isDark,
                  size: isTablet ? 52.0 : 44.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── All milestones list ─────────────────────────────────────────────────
  Widget _buildMilestonesList(bool isTablet) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isTablet ? 32 : 20,
        20,
        isTablet ? 32 : 20,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'MILESTONES',
              style: TextStyle(
                fontSize: isTablet ? 12 : 11,
                fontWeight: FontWeight.w700,
                color: _subtitleColor,
                fontFamily: 'GoogleSansFlex',
                letterSpacing: 1.8,
              ),
            ),
          ),
          Container(
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
              children: _milestones.asMap().entries.map((entry) {
                final i = entry.key;
                final m = entry.value;
                final isUnlocked = widget.streakDays >= m[1];
                final isCurrent =
                    widget.streakDays >= m[0] && widget.streakDays < m[1];
                final isLast = i == _milestones.length - 1;

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 20 : 16,
                        vertical: isTablet ? 14 : 12,
                      ),
                      child: Row(
                        children: [
                          // Fire icon with unlock state
                          Container(
                            width: isTablet ? 40 : 36,
                            height: isTablet ? 40 : 36,
                            decoration: BoxDecoration(
                              color: isUnlocked
                                  ? AppColors.orange.withValues(alpha: 0.15)
                                  : isCurrent
                                  ? AppColors.orange.withValues(alpha: 0.08)
                                  : (_isDark
                                        ? AppColors.darkCardBorder.withValues(
                                            alpha: 0.5,
                                          )
                                        : const Color(0xFFF0F2FA)),
                              shape: BoxShape.circle,
                              border: isCurrent
                                  ? Border.all(
                                      color: AppColors.orange.withValues(
                                        alpha: 0.5,
                                      ),
                                      width: 1.5,
                                    )
                                  : null,
                            ),
                            padding: const EdgeInsets.all(7),
                            child: Image.asset(
                              'assets/images/fire.png',
                              fit: BoxFit.contain,
                              color: isUnlocked
                                  ? null
                                  : isCurrent
                                  ? null
                                  : (_isDark
                                        ? AppColors.darkSubtitle
                                        : const Color(0xFFCDD0E0)),
                              colorBlendMode: (isUnlocked || isCurrent)
                                  ? null
                                  : BlendMode.srcIn,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.local_fire_department_rounded,
                                color: isUnlocked || isCurrent
                                    ? AppColors.orange
                                    : _subtitleColor,
                                size: isTablet ? 22 : 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${m[0]}–${m[1]} Day Streak',
                                  style: TextStyle(
                                    fontSize: isTablet ? 14 : 13,
                                    fontWeight: FontWeight.w700,
                                    color: isUnlocked || isCurrent
                                        ? _titleColor
                                        : _subtitleColor,
                                    fontFamily: 'GoogleSansFlex',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  isUnlocked
                                      ? 'Unlocked 🎉'
                                      : isCurrent
                                      ? '${_daysToNextMilestone} day${_daysToNextMilestone == 1 ? '' : 's'} to go'
                                      : '${m[0] - widget.streakDays} day${(m[0] - widget.streakDays) == 1 ? '' : 's'} away',
                                  style: TextStyle(
                                    fontSize: isTablet ? 12 : 11,
                                    color: isUnlocked
                                        ? AppColors.orange
                                        : _subtitleColor,
                                    fontFamily: 'GoogleSansFlex',
                                    fontWeight: isUnlocked
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Badge / lock
                          if (isUnlocked)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.orange.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '🔥',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          else if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFB74D),
                                    Color(0xFFFF7043),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: isTablet ? 12 : 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontFamily: 'GoogleSansFlex',
                                ),
                              ),
                            )
                          else
                            Icon(
                              Icons.lock_rounded,
                              size: isTablet ? 18 : 16,
                              color: _subtitleColor.withValues(alpha: 0.5),
                            ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: _isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        indent: isTablet ? 70 : 66,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Milestone circle widget ────────────────────────────────────────────────────
class _MilestoneCircle extends StatelessWidget {
  final String label;
  final bool isAchieved;
  final bool isDark;
  final double size;

  const _MilestoneCircle({
    required this.label,
    required this.isAchieved,
    required this.isDark,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isAchieved
                ? const LinearGradient(
                    colors: [Color(0xFFFFB74D), Color(0xFFFF7043)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isAchieved
                ? null
                : isDark
                ? AppColors.darkCardBorder
                : const Color(0xFFE8EAF6),
            boxShadow: isAchieved
                ? [
                    BoxShadow(
                      color: AppColors.orange.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: isAchieved
              ? Image.asset(
                  'assets/images/fire.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                )
              : Icon(
                  Icons.lock_rounded,
                  size: size * 0.38,
                  color: isDark
                      ? AppColors.darkSubtitle
                      : const Color(0xFFADB5C7),
                ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isAchieved
                ? AppColors.orange
                : isDark
                ? AppColors.darkSubtitle
                : const Color(0xFFADB5C7),
            fontFamily: 'GoogleSansFlex',
          ),
        ),
      ],
    );
  }
}
