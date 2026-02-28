import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gce_practicals_app/pages/Profile/profile_page.dart';

// Import your shared themeNotifier and AppColors, e.g.:
// import 'theme_notifier.dart';

class PracticalsPage extends StatefulWidget {
  const PracticalsPage({super.key});

  @override
  State<PracticalsPage> createState() => _PracticalsPageState();
}

class _PracticalsPageState extends State<PracticalsPage> {
  static const List<Map<String, dynamic>> _examSchedule = [
    {
      'subject': 'OL Computer Science',
      'level': 'O Level',
      'date': 'June 3, 2026',
      'time': '9:00 AM - 11:00 AM',
      'duration': '2 hours',
      'icon': Icons.computer_rounded,
      'gradient': [Color(0xFF4FC3F7), Color(0xFF0288D1)],
    },
    {
      'subject': 'AL Computer Science',
      'level': 'A Level',
      'date': 'June 5, 2026',
      'time': '9:00 AM - 12:00 PM',
      'duration': '3 hours',
      'icon': Icons.developer_board_rounded,
      'gradient': [Color(0xFF7986CB), Color(0xFF3949AB)],
    },
    {
      'subject': 'AL ICT',
      'level': 'A Level',
      'date': 'June 8, 2026',
      'time': '9:00 AM - 12:00 PM',
      'duration': '3 hours',
      'icon': Icons.lan_rounded,
      'gradient': [Color(0xFF4DB6AC), Color(0xFF00796B)],
    },
    {
      'subject': 'AL Physics',
      'level': 'A Level',
      'date': 'June 10, 2026',
      'time': '9:00 AM - 11:30 AM',
      'duration': '2h 30min',
      'icon': Icons.bolt_rounded,
      'gradient': [Color(0xFFFFB74D), Color(0xFFF57C00)],
    },
    {
      'subject': 'AL Chemistry',
      'level': 'A Level',
      'date': 'June 12, 2026',
      'time': '9:00 AM - 11:30 AM',
      'duration': '2h 30min',
      'icon': Icons.science_rounded,
      'gradient': [Color(0xFFF06292), Color(0xFFC2185B)],
    },
    {
      'subject': 'AL Biology',
      'level': 'A Level',
      'date': 'June 15, 2026',
      'time': '9:00 AM - 11:30 AM',
      'duration': '2h 30min',
      'icon': Icons.eco_rounded,
      'gradient': [Color(0xFF81C784), Color(0xFF388E3C)],
    },
  ];

  static const List<Map<String, dynamic>> _mustBring = [
    {
      'item': 'National ID / School ID Card',
      'icon': Icons.badge_rounded,
      'note': 'Mandatory for entry into the examination hall',
    },
    {
      'item': 'Examination Slip',
      'icon': Icons.confirmation_number_rounded,
      'note': 'Issued by your school - do not lose it',
    },
    {
      'item': 'Scientific Calculator',
      'icon': Icons.calculate_rounded,
      'note': 'Non-programmable only. Physics & Chemistry required',
    },
    {
      'item': 'Blue or Black Pens (x2)',
      'icon': Icons.edit_rounded,
      'note': 'Bring spares - no borrowing allowed in the hall',
    },
    {
      'item': 'Pencil & Eraser',
      'icon': Icons.draw_rounded,
      'note': 'For diagrams, graphs and multiple-choice sections',
    },
    {
      'item': 'Ruler & Compass',
      'icon': Icons.straighten_rounded,
      'note': 'Required for Physics and Maths practicals',
    },
    {
      'item': 'Lab Coat (Science subjects)',
      'icon': Icons.science_rounded,
      'note': 'Mandatory for Chemistry and Biology practical exams',
    },
    {
      'item': 'Water Bottle (sealed)',
      'icon': Icons.water_drop_rounded,
      'note': 'Transparent bottle only. No labels.',
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

  // Back button
  Color get _backBtnBg => _isDark
      ? AppColors.darkCard.withValues(alpha: 0.85)
      : Colors.white.withValues(alpha: 0.7);
  Color get _backBtnShadow => _isDark
      ? Colors.black.withValues(alpha: 0.2)
      : const Color(0xFF3949AB).withValues(alpha: 0.1);

  // Checklist item
  Color get _checklistBg => _isDark
      ? AppColors.darkCard.withValues(alpha: 0.9)
      : Colors.white.withValues(alpha: 0.75);
  Color get _checklistBorder =>
      _isDark ? AppColors.darkCardBorder : Colors.white.withValues(alpha: 0.9);
  Color get _checklistIconBg => _isDark
      ? AppColors.darkAccent.withValues(alpha: 0.12)
      : const Color(0xFFE8EAF6);
  Color get _checklistIconColor =>
      _isDark ? AppColors.darkAccent : const Color(0xFF3949AB);

  // Responsive helpers
  bool _isMediumTablet(double w) => w >= 600 && w < 800;
  bool _isLargeTablet(double w) => w >= 800;
  bool _isTablet(double w) => w >= 600;
  double _hPad(double w) => _isLargeTablet(w)
      ? 32
      : _isMediumTablet(w)
      ? 24
      : 16;

  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(_onThemeChange);
  }

  void _onThemeChange() => setState(() {});

  @override
  void dispose() {
    themeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // -- Header --------------------------------------------------------
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  _hPad(screenWidth),
                  topPadding + 8,
                  _hPad(screenWidth),
                  20,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _backBtnBg,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _backBtnShadow,
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
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Practicals',
                          style: TextStyle(
                            fontSize: _isLargeTablet(screenWidth) ? 28 : 24,
                            fontWeight: FontWeight.w700,
                            color: _titleColor,
                            fontFamily: 'GoogleSansFlex',
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'GCE Examinations 2026',
                          style: TextStyle(
                            fontSize: 13,
                            color: _subtitleColor,
                            fontFamily: 'GoogleSansFlex',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // -- Important notice banner ----------------------------------------
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  _hPad(screenWidth),
                  0,
                  _hPad(screenWidth),
                  4,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFFFF6B35,
                      ).withValues(alpha: _isDark ? 0.15 : 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.campaign_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Important Reminder',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'GoogleSansFlex',
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Arrive at least 30 minutes before your exam. Late entry is not permitted.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontFamily: 'GoogleSansFlex',
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -- Section: Exam Schedule ----------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  _hPad(screenWidth),
                  24,
                  _hPad(screenWidth),
                  12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isDark
                              ? [AppColors.darkAccent, const Color(0xFF4FC3F7)]
                              : [
                                  const Color(0xFF4FC3F7),
                                  const Color(0xFF3949AB),
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Exam Schedule',
                      style: TextStyle(
                        fontSize: _isLargeTablet(screenWidth) ? 20 : 17,
                        fontWeight: FontWeight.w700,
                        color: _titleColor,
                        fontFamily: 'GoogleSansFlex',
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -- Exam schedule cards -------------------------------------------
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ExamCard(
                  exam: _examSchedule[index],
                  isDark: _isDark,
                  hPad: _hPad(screenWidth),
                ),
                childCount: _examSchedule.length,
              ),
            ),

            // -- Section: What to bring ----------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  _hPad(screenWidth),
                  28,
                  _hPad(screenWidth),
                  12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isDark
                              ? [AppColors.darkAccent, const Color(0xFF4FC3F7)]
                              : [
                                  const Color(0xFF4FC3F7),
                                  const Color(0xFF3949AB),
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'What to Bring',
                      style: TextStyle(
                        fontSize: _isLargeTablet(screenWidth) ? 20 : 17,
                        fontWeight: FontWeight.w700,
                        color: _titleColor,
                        fontFamily: 'GoogleSansFlex',
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -- Checklist items -----------------------------------------------
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                _hPad(screenWidth),
                0,
                _hPad(screenWidth),
                100,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _ChecklistItem(
                    item: _mustBring[index],
                    isDark: _isDark,
                    checklistBg: _checklistBg,
                    checklistBorder: _checklistBorder,
                    checklistIconBg: _checklistIconBg,
                    checklistIconColor: _checklistIconColor,
                    titleColor: _titleColor,
                    subtitleColor: _subtitleColor,
                  ),
                  childCount: _mustBring.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -- Exam Card ----------------------------------------------------------------

class _ExamCard extends StatelessWidget {
  final Map<String, dynamic> exam;
  final bool isDark;
  final double hPad;

  const _ExamCard({
    required this.exam,
    required this.isDark,
    required this.hPad,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = exam['gradient'] as List<Color>;
    final Color cardBg = isDark ? AppColors.darkCard : Colors.white;
    final Color titleColor = isDark
        ? AppColors.darkTitle
        : const Color(0xFF1A237E);
    final Color subtitleColor = isDark
        ? AppColors.darkSubtitle
        : const Color(0xFF90A4AE);

    return Container(
      margin: EdgeInsets.fromLTRB(hPad, 0, hPad, 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: isDark
            ? Border.all(color: AppColors.darkCardBorder, width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: gradientColors[1].withValues(alpha: isDark ? 0.08 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Coloured left strip with icon
          Container(
            width: 64,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(14),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(exam['icon'] as IconData, color: Colors.white, size: 26),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    exam['level'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'GoogleSansFlex',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam['subject'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      fontFamily: 'GoogleSansFlex',
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: gradientColors[1],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        exam['date'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: gradientColors[1],
                          fontFamily: 'GoogleSansFlex',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: subtitleColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${exam['time']}  .  ${exam['duration']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: subtitleColor,
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
    );
  }
}

// -- Checklist Item -----------------------------------------------------------

class _ChecklistItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isDark;
  final Color checklistBg;
  final Color checklistBorder;
  final Color checklistIconBg;
  final Color checklistIconColor;
  final Color titleColor;
  final Color subtitleColor;

  const _ChecklistItem({
    required this.item,
    required this.isDark,
    required this.checklistBg,
    required this.checklistBorder,
    required this.checklistIconBg,
    required this.checklistIconColor,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: checklistBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: checklistBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : const Color(0xFF3949AB).withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: checklistIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item['icon'] as IconData,
              size: 18,
              color: checklistIconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['item'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    fontFamily: 'GoogleSansFlex',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['note'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: subtitleColor,
                    fontFamily: 'GoogleSansFlex',
                    height: 1.4,
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
