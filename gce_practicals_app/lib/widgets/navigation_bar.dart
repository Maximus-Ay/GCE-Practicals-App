import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gce_practicals_app/pages/Profile/profile_page.dart';

// Import your themeNotifier and AppColors from your shared file, e.g.:
// import 'theme_notifier.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  int _previousIndex = 0;

  final List<_NavItem> _items = const [
    _NavItem(
      icon: Icons.home_rounded,
      outlinedIcon: Icons.home_outlined,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.article_rounded,
      outlinedIcon: Icons.article_outlined,
      label: 'Papers',
    ),
    _NavItem(
      icon: Icons.person_rounded,
      outlinedIcon: Icons.person_outline_rounded,
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation =
        Tween<double>(
          begin: widget.currentIndex.toDouble(),
          end: widget.currentIndex.toDouble(),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );
    themeNotifier.addListener(_onThemeChange);
  }

  void _onThemeChange() => setState(() {});

  @override
  void didUpdateWidget(CustomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _slideAnimation =
          Tween<double>(
            begin: _previousIndex.toDouble(),
            end: widget.currentIndex.toDouble(),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
          );
      _previousIndex = widget.currentIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    themeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

  void _handleTap(int index) {
    HapticFeedback.lightImpact();
    widget.onTap(index);
  }

  bool get _isDark => themeNotifier.value == ThemeMode.dark;

  // Colour tokens
  static const Color _activeColorLight = Color(0xFF1A237E);
  static const Color _inactiveColorLight = Color(0xFF5A5D62);
  static const Color _activeColorDark = Color(0xFF738AFF);
  static const Color _inactiveColorDark = Color(0xFF5A6380);

  Color get _activeColor => _isDark ? _activeColorDark : _activeColorLight;
  Color get _inactiveColor =>
      _isDark ? _inactiveColorDark : _inactiveColorLight;

  Color get _pillColor => _isDark
      ? const Color(0xFF4FC3F7).withValues(alpha: 0.15)
      : Colors.blue.shade300.withValues(alpha: 0.2);

  List<Color> get _bgGradient => _isDark
      ? [
          const Color(0xFF131629).withValues(alpha: 0.95),
          const Color(0xFF0D0F1E).withValues(alpha: 0.98),
        ]
      : [
          Colors.white.withValues(alpha: 0.85),
          Colors.white.withValues(alpha: 0.97),
        ];

  Color get _borderColor => _isDark
      ? const Color(0xFF252845).withValues(alpha: 0.8)
      : const Color(0xFF3949AB).withValues(alpha: 0.15);

  Color get _shadowColor => _isDark
      ? const Color(0xFF0D0F1E).withValues(alpha: 0.5)
      : const Color(0xFF3949AB).withValues(alpha: 0.06);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _bgGradient,
        ),
        border: Border(top: BorderSide(color: _borderColor, width: 1.2)),
        boxShadow: [
          BoxShadow(
            color: _shadowColor,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: _isDark
                ? const Color(0xFF131629).withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.9),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ColorFilter.matrix(<double>[
            1,
            0,
            0,
            0,
            _isDark ? 0 : 8,
            0,
            1,
            0,
            0,
            _isDark ? 0 : 8,
            0,
            0,
            1,
            0,
            _isDark ? 0 : 12,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              bottom: bottomPadding > 0 ? bottomPadding : 12.0,
            ),
            child: SizedBox(
              height: 60,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / _items.length;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Sliding pill
                      AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, _) {
                          final pillCenterX =
                              _slideAnimation.value * itemWidth + itemWidth / 2;
                          return Positioned(
                            left: pillCenterX - 35,
                            top: 2,
                            child: Container(
                              width: 70,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _pillColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          );
                        },
                      ),

                      // Nav items
                      Row(
                        children: List.generate(_items.length, (index) {
                          final isSelected = widget.currentIndex == index;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _handleTap(index),
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedScale(
                                    scale: isSelected ? 1.12 : 1.0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOutBack,
                                    child: Icon(
                                      isSelected
                                          ? _items[index].icon
                                          : _items[index].outlinedIcon,
                                      size: 24,
                                      color: isSelected
                                          ? _activeColor
                                          : _inactiveColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _items[index].label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? _activeColor
                                          : _inactiveColor,
                                      fontFamily: 'GoogleSansFlex',
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData outlinedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.outlinedIcon,
    required this.label,
  });
}
