import 'package:flutter/material.dart';
import 'package:gce_practicals_app/pages/Profile/profile_page.dart';

// Import your shared themeNotifier and AppColors, e.g.:
// import 'theme_notifier.dart';

class AlChemistryPage extends StatefulWidget {
  const AlChemistryPage({super.key});

  @override
  State<AlChemistryPage> createState() => _AlChemistryPageState();
}

class _AlChemistryPageState extends State<AlChemistryPage> {
  static const List<Color> _gradient = [Color(0xFFF06292), Color(0xFFC2185B)];
  static const IconData _icon = Icons.science_rounded;
  static const String _title = 'AL Chemistry';
  static const String _levelLabel = 'A Level';

  bool get _isDark => themeNotifier.value == ThemeMode.dark;

  Color get _bgGrad1 => _isDark ? AppColors.darkBg1 : AppColors.lightBg1;
  Color get _bgGrad2 => _isDark ? AppColors.darkBg2 : AppColors.lightBg2;
  Color get _bgGrad3 => _isDark ? AppColors.darkBg3 : AppColors.lightBg3;
  Color get _titleColor => _isDark ? AppColors.darkTitle : AppColors.lightTitle;
  Color get _subtitleColor =>
      _isDark ? AppColors.darkSubtitle : AppColors.lightSubtitle;
  Color get _backBtnBg => _isDark
      ? AppColors.darkCard.withValues(alpha: 0.85)
      : Colors.white.withValues(alpha: 0.7);

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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, topPadding + 8, 20, 20),
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
                            color: _gradient[1].withValues(alpha: 0.15),
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
                        _title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _titleColor,
                          fontFamily: 'GoogleSansFlex',
                          letterSpacing: -0.5,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: _gradient),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          _levelLabel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'GoogleSansFlex',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: _gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _gradient[1].withValues(
                              alpha: _isDark ? 0.2 : 0.35,
                            ),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(_icon, color: Colors.white, size: 42),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Content coming soon',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _titleColor,
                        fontFamily: 'GoogleSansFlex',
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We're building this together.",
                      style: TextStyle(
                        fontSize: 14,
                        color: _subtitleColor,
                        fontFamily: 'GoogleSansFlex',
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
