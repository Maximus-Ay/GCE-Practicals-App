import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gce_practicals_app/pages/Profile/profile_page.dart';

// ── Node model ────────────────────────────────────────────────────────────────
enum _NodeState { completed, active, locked }

class _PathNode {
  final String title;
  final String subtitle;
  final IconData icon;
  final _NodeState state;
  final int lessons;

  const _PathNode({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.state,
    required this.lessons,
  });
}

// ── Page ──────────────────────────────────────────────────────────────────────
class OlComputerSciencePage extends StatefulWidget {
  const OlComputerSciencePage({super.key});

  @override
  State<OlComputerSciencePage> createState() => _OlComputerSciencePageState();
}

class _OlComputerSciencePageState extends State<OlComputerSciencePage>
    with TickerProviderStateMixin {
  static const List<Color> _grad = [Color(0xFF4FC3F7), Color(0xFF0288D1)];
  static const String _title = 'OL Computer Science';
  static const String _levelLabel = 'O Level';

  static const List<_PathNode> _nodes = [
    _PathNode(
      title: 'Structure of Practicals',
      subtitle: 'Overview of the OL CS practical exam format',
      icon: Icons.map_rounded,
      state: _NodeState.completed,
      lessons: 4,
    ),
    _PathNode(
      title: 'Understanding Word',
      subtitle: 'Document creation, formatting & mail merge',
      icon: Icons.description_rounded,
      state: _NodeState.completed,
      lessons: 8,
    ),
    _PathNode(
      title: 'Understanding Excel',
      subtitle: 'Spreadsheets, formulas & data analysis',
      icon: Icons.table_chart_rounded,
      state: _NodeState.active,
      lessons: 10,
    ),
    _PathNode(
      title: 'Understanding Access',
      subtitle: 'Databases, queries, forms & reports',
      icon: Icons.storage_rounded,
      state: _NodeState.locked,
      lessons: 9,
    ),
    _PathNode(
      title: 'Programming in C',
      subtitle: 'Variables, loops, functions & arrays',
      icon: Icons.code_rounded,
      state: _NodeState.locked,
      lessons: 12,
    ),
    _PathNode(
      title: 'Common Exercises',
      subtitle: 'Mixed practice questions & exam tricks',
      icon: Icons.fitness_center_rounded,
      state: _NodeState.locked,
      lessons: 15,
    ),
    _PathNode(
      title: 'Final Revision',
      subtitle: 'Full exam simulation & past paper walkthrough',
      icon: Icons.emoji_events_rounded,
      state: _NodeState.locked,
      lessons: 6,
    ),
  ];

  late final List<AnimationController> _popCtrl;
  late final List<Animation<double>> _popAnim;

  // ── Theme ──────────────────────────────────────────────────────────────────
  bool get _isDark => themeNotifier.value == ThemeMode.dark;
  Color get _bg1 => _isDark ? AppColors.darkBg1 : AppColors.lightBg1;
  Color get _bg2 => _isDark ? AppColors.darkBg2 : AppColors.lightBg2;
  Color get _bg3 => _isDark ? AppColors.darkBg3 : AppColors.lightBg3;
  Color get _titleCol => _isDark ? AppColors.darkTitle : AppColors.lightTitle;
  Color get _subCol =>
      _isDark ? AppColors.darkSubtitle : AppColors.lightSubtitle;
  Color get _cardCol => _isDark ? AppColors.darkCard : AppColors.lightCard;
  Color get _borderCol =>
      _isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
  Color get _backBg => _isDark
      ? AppColors.darkCard.withValues(alpha: 0.85)
      : Colors.white.withValues(alpha: 0.85);

  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(_onTheme);
    _popCtrl = List.generate(
      _nodes.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 560),
      ),
    );
    _popAnim = _popCtrl
        .map((c) => CurvedAnimation(parent: c, curve: Curves.elasticOut))
        .toList();
    _animateIn();
  }

  Future<void> _animateIn() async {
    for (int i = 0; i < _popCtrl.length; i++) {
      await Future.delayed(Duration(milliseconds: 75 * i));
      if (mounted) _popCtrl[i].forward();
    }
  }

  void _onTheme() => setState(() {});

  @override
  void dispose() {
    for (final c in _popCtrl) {
      c.dispose();
    }
    themeNotifier.removeListener(_onTheme);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            // Header and progress banner — plain gradient, NO pattern
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_bg1, _bg2, _bg3],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(topPad, sw),
                  _buildProgressBanner(sw),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            // Path area — gradient + pattern overlay
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: _buildBackground()),
                  _buildPath(sw),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Background ─────────────────────────────────────────────────────────────
  // ┌─────────────────────────────────────────────────────────────────────────┐
  // │  To remove the pattern and go back to a plain gradient, simply replace  │
  // │  the CustomPaint(...) child below with a const SizedBox.shrink()        │
  // │  and delete the _PatternPainter class at the bottom of this file.       │
  // └─────────────────────────────────────────────────────────────────────────┘
  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_bg1, _bg2, _bg3],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      // ── Pattern overlay — remove CustomPaint to disable ───────────────────
      child: CustomPaint(
        painter: _PatternPainter(isDark: _isDark),
        child: const SizedBox.expand(),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(double topPad, double sw) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, topPad + 10, 20, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _backBg,
                shape: BoxShape.circle,
                border: Border.all(color: _borderCol, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: _grad[1].withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: _titleCol,
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
                  fontSize: sw < 360 ? 17 : 20,
                  fontWeight: FontWeight.w700,
                  color: _titleCol,
                  fontFamily: 'GoogleSansFlex',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: _grad),
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
    );
  }

  // ── Progress banner ────────────────────────────────────────────────────────
  Widget _buildProgressBanner(double sw) {
    final done = _nodes.where((n) => n.state == _NodeState.completed).length;
    final total = _nodes.length;
    final pct = done / total;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _grad[0].withValues(alpha: 0.14),
            _grad[1].withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _grad[0].withValues(alpha: 0.28), width: 1.2),
      ),
      child: Row(
        children: [
          // Lightning bolt icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: _grad,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: _grad[1].withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          // Progress text + bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$done of $total units done',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _titleCol,
                        fontFamily: 'GoogleSansFlex',
                      ),
                    ),
                    Text(
                      '${(pct * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0288D1),
                        fontFamily: 'GoogleSansFlex',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 7,
                    backgroundColor: _isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF0288D1)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Path ───────────────────────────────────────────────────────────────────
  Widget _buildPath(double sw) {
    final double nodeR = sw < 360 ? 30.0 : 36.0;
    final double nodeDiameter = nodeR * 2;
    final double ringExtra = 10.0;

    // Each row is tall enough for the circle + ring + label breathing room
    final double rowH = nodeDiameter + ringExtra + (sw < 360 ? 62 : 72);

    // Top padding — leave room for the ring on the first node
    final double vPad = ringExtra + 10;

    final double canvasH = vPad + _nodes.length * rowH + 40;
    final double innerW = sw - 40;

    // Node centres: left nodes flush to left, right nodes flush to right
    // with enough inset so the ring never clips the padding edge
    final double leftCX = nodeR + ringExtra / 2;
    final double rightCX = innerW - nodeR - ringExtra / 2;

    final List<double> nodeCX = List.generate(
      _nodes.length,
      (i) => i.isEven ? leftCX : rightCX,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 16),
        child: SizedBox(
          width: innerW,
          height: canvasH,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Connector lines (behind nodes) ───────────────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: _ConnectorPainter(
                    nodes: _nodes,
                    nodeCX: nodeCX,
                    rowH: rowH,
                    vPad: vPad,
                    nodeR: nodeR,
                    ringExtra: ringExtra,
                    isDark: _isDark,
                    activeColor: _grad[0],
                    lockedColor: _borderCol,
                  ),
                ),
              ),

              // ── Node rows ────────────────────────────────────────────────
              ..._nodes.asMap().entries.map((e) {
                final i = e.key;
                final node = e.value;
                final cx = nodeCX[i];
                final cy = vPad + i * rowH + nodeR; // node centre Y
                final isLeft = i.isEven;

                // Position top so ring has space above it
                final double rowTop = cy - nodeR - ringExtra / 2;

                return Positioned(
                  top: rowTop,
                  left: 0,
                  width: innerW,
                  child: ScaleTransition(
                    scale: _popAnim[i],
                    child: _NodeRow(
                      node: node,
                      grad: _grad,
                      nodeR: nodeR,
                      ringExtra: ringExtra,
                      isDark: _isDark,
                      titleCol: _titleCol,
                      subCol: _subCol,
                      borderCol: _borderCol,
                      nodeCX: cx,
                      isLeft: isLeft,
                      sw: innerW,
                      onTap: () => node.state == _NodeState.locked
                          ? _showLocked()
                          : _showSheet(node),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocked() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.lock_rounded, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text(
              'Complete previous units to unlock',
              style: TextStyle(fontFamily: 'GoogleSansFlex'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0288D1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSheet(_PathNode node) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _NodeSheet(
        node: node,
        grad: _grad,
        isDark: _isDark,
        titleCol: _titleCol,
        subCol: _subCol,
        cardCol: _cardCol,
        borderCol: _borderCol,
      ),
    );
  }
}

// ── Node row widget ───────────────────────────────────────────────────────────
class _NodeRow extends StatelessWidget {
  final _PathNode node;
  final List<Color> grad;
  final double nodeR;
  final double ringExtra;
  final bool isDark;
  final Color titleCol;
  final Color subCol;
  final Color borderCol;
  final double nodeCX;
  final bool isLeft;
  final double sw;
  final VoidCallback onTap;

  const _NodeRow({
    required this.node,
    required this.grad,
    required this.nodeR,
    required this.ringExtra,
    required this.isDark,
    required this.titleCol,
    required this.subCol,
    required this.borderCol,
    required this.nodeCX,
    required this.isLeft,
    required this.sw,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = node.state == _NodeState.completed;
    final isActive = node.state == _NodeState.active;
    final isLocked = node.state == _NodeState.locked;
    final d = nodeR * 2;

    final List<Color> circleGrad = isLocked
        ? (isDark
              ? [const Color(0xFF2E3355), const Color(0xFF232744)]
              : [const Color(0xFFCDD2F0), const Color(0xFFB8BFE8)])
        : grad;

    // ── Circle ───────────────────────────────────────────────────────────────
    final double circleTotalSize = d + ringExtra;
    final Widget circle = SizedBox(
      width: circleTotalSize,
      height: circleTotalSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Border ring for active node — sits fully inside SizedBox bounds
          if (isActive)
            Container(
              width: d + ringExtra,
              height: d + ringExtra,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: grad[0].withValues(alpha: 0.6),
                  width: 2.5,
                ),
              ),
            ),

          // Main circle body
          Container(
            width: d,
            height: d,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: circleGrad,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isLocked
                    ? (isDark
                          ? const Color(0xFF4A5280)
                          : const Color(0xFF8892C8))
                    : grad[0].withValues(alpha: 0.5),
                width: isActive ? 3 : 2,
              ),
              boxShadow: isLocked
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: grad[1].withValues(
                          alpha: isActive ? 0.42 : 0.20,
                        ),
                        blurRadius: isActive ? 20 : 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: isCompleted
                ? Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: nodeR * 0.72,
                  )
                : isLocked
                ? Icon(
                    Icons.lock_rounded,
                    color: isDark
                        ? const Color(0xFF9BA8CC)
                        : const Color(0xFF5C6BC0),
                    size: nodeR * 0.58,
                  )
                : Icon(node.icon, color: Colors.white, size: nodeR * 0.64),
          ),

          // Gold star badge for completed
          if (isCompleted)
            Positioned(
              top: isActive ? 0 : -2,
              right: isActive ? 0 : -2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.coin,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.darkBg1 : Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.coin.withValues(alpha: 0.45),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 11,
                ),
              ),
            ),
        ],
      ), // end Stack
    ); // end SizedBox circle

    // ── Label ─────────────────────────────────────────────────────────────────
    final Widget label = Column(
      crossAxisAlignment: isLeft
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          node.title,
          textAlign: isLeft ? TextAlign.left : TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: nodeR < 34 ? 10 : 12,
            fontWeight: FontWeight.w700,
            color: isLocked
                ? (isDark ? const Color(0xFFB0BAD4) : const Color(0xFF3D4470))
                : titleCol,
            fontFamily: 'GoogleSansFlex',
            letterSpacing: -0.2,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${node.lessons} lessons',
          textAlign: isLeft ? TextAlign.left : TextAlign.right,
          style: TextStyle(
            fontSize: nodeR < 34 ? 9 : 11,
            fontWeight: FontWeight.w500,
            color: isLocked
                ? (isDark ? const Color(0xFF8892C8) : const Color(0xFF5C6BC0))
                : grad[1],
            fontFamily: 'GoogleSansFlex',
          ),
        ),
      ],
    );

    // ── Compose the full row ──────────────────────────────────────────────────
    final double totalH = d + ringExtra;
    final double circleLeft = nodeCX - nodeR - ringExtra / 2;
    final double circleRight = sw - (circleLeft + d + ringExtra);
    const double gapToLabel = 12.0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: sw,
        height: totalH,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Circle (including ring) — always fully visible
            Positioned(
              left: circleLeft,
              top: 0,
              width: d + ringExtra,
              height: d + ringExtra,
              child: circle,
            ),

            // Label on the OPPOSITE side from the circle
            if (isLeft)
              // Circle is on the left → label goes to the RIGHT of it
              Positioned(
                left: circleLeft + d + ringExtra + gapToLabel,
                top: 0,
                bottom: 0,
                right: 0,
                child: label,
              )
            else
              // Circle is on the right → label goes to the LEFT of it
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                right: circleRight + d + ringExtra + gapToLabel,
                child: label,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Connector painter ─────────────────────────────────────────────────────────
class _ConnectorPainter extends CustomPainter {
  final List<_PathNode> nodes;
  final List<double> nodeCX;
  final double rowH;
  final double vPad;
  final double nodeR;
  final double ringExtra;
  final bool isDark;
  final Color activeColor;
  final Color lockedColor;

  const _ConnectorPainter({
    required this.nodes,
    required this.nodeCX,
    required this.rowH,
    required this.vPad,
    required this.nodeR,
    required this.ringExtra,
    required this.isDark,
    required this.activeColor,
    required this.lockedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < nodes.length - 1; i++) {
      final x1 = nodeCX[i];
      // Node centre Y = vPad + i*rowH + nodeR, bottom of ring = centre + nodeR + ringExtra/2
      final y1 = vPad + i * rowH + nodeR + nodeR + ringExtra / 2;
      final x2 = nodeCX[i + 1];
      // Top of next ring = vPad + (i+1)*rowH (the rowTop offset)
      final y2 = vPad + (i + 1) * rowH - ringExtra / 2;

      // Solid line only when FROM node is completed.
      // Active → next is dashed (not yet done). Locked → next is dashed.
      final isSolid = nodes[i].state == _NodeState.completed;

      final paint = Paint()
        ..color = isSolid
            ? activeColor.withValues(alpha: 0.55)
            : (isDark
                  ? const Color(0xFF4A5280).withValues(alpha: 0.85)
                  : const Color(0xFF8892C8).withValues(alpha: 0.85))
        ..strokeWidth = isSolid ? 3.5 : 2.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      final midY = (y1 + y2) / 2;
      path.moveTo(x1, y1);
      path.cubicTo(x1, midY, x2, midY, x2, y2);

      if (isSolid) {
        canvas.drawPath(path, paint);
        _drawChevron(canvas, x1, y1, x2, y2);
      } else {
        _drawDashed(canvas, path, paint);
      }
    }
  }

  void _drawChevron(Canvas canvas, double x1, double y1, double x2, double y2) {
    final mx = (x1 + x2) / 2;
    final my = (y1 + y2) / 2;
    const s = 6.0;

    final p = Paint()
      ..color = activeColor.withValues(alpha: 0.7)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(mx - s, my - s * 0.5), Offset(mx, my + s * 0.5), p);
    canvas.drawLine(Offset(mx + s, my - s * 0.5), Offset(mx, my + s * 0.5), p);
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    const dashLen = 8.0;
    const gapLen = 5.0;
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        final end = (d + dashLen).clamp(0.0, m.length);
        canvas.drawPath(m.extractPath(d, end), paint);
        d += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(_ConnectorPainter o) =>
      o.isDark != isDark || o.nodeCX != nodeCX;
}

// ── Bottom sheet ──────────────────────────────────────────────────────────────
class _NodeSheet extends StatelessWidget {
  final _PathNode node;
  final List<Color> grad;
  final bool isDark;
  final Color titleCol;
  final Color subCol;
  final Color cardCol;
  final Color borderCol;

  const _NodeSheet({
    required this.node,
    required this.grad,
    required this.isDark,
    required this.titleCol,
    required this.subCol,
    required this.cardCol,
    required this.borderCol,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = node.state == _NodeState.completed;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        decoration: BoxDecoration(
          color: cardCol,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderCol, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: grad[1].withValues(alpha: 0.14),
              blurRadius: 30,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: subCol.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Icon
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: grad,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: grad[1].withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(node.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 14),

            Text(
              node.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: titleCol,
                fontFamily: 'GoogleSansFlex',
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              node.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: subCol,
                fontFamily: 'GoogleSansFlex',
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),

            // Lesson pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: grad[0].withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: grad[0].withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_rounded, size: 14, color: grad[1]),
                  const SizedBox(width: 6),
                  Text(
                    '${node.lessons} lessons in this unit',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: grad[1],
                      fontFamily: 'GoogleSansFlex',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // CTA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: grad),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: grad[1].withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isCompleted ? '🔁  Review Unit' : '▶  Start Unit',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'GoogleSansFlex',
                      letterSpacing: -0.2,
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
}

// ── WhatsApp-style pattern painter ───────────────────────────────────────────
// Draws a subtle repeating icon grid that matches your app theme.
// To REMOVE the pattern: in _buildBackground(), replace the CustomPaint(...)
// child with const SizedBox.shrink() — you can also delete this whole class.
class _PatternPainter extends CustomPainter {
  final bool isDark;
  const _PatternPainter({required this.isDark});

  static const List<IconData> _icons = [
    Icons.code_rounded,
    Icons.description_rounded,
    Icons.table_chart_rounded,
    Icons.storage_rounded,
    Icons.computer_rounded,
    Icons.school_rounded,
    Icons.lightbulb_rounded,
    Icons.quiz_rounded,
    Icons.edit_rounded,
    Icons.folder_rounded,
    Icons.calculate_rounded,
    Icons.psychology_rounded,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final color = isDark
        ? const Color(0xFF4FC3F7).withValues(alpha: 0.06)
        : const Color(0xFF1A237E).withValues(alpha: 0.055);

    const double tileSize = 55.0;
    const double iconSize = 22.0;
    int iconIndex = 0;

    for (double y = 0; y < size.height + tileSize; y += tileSize) {
      for (double x = 0; x < size.width + tileSize; x += tileSize) {
        // Stagger every other row like a brick pattern
        final double rowOffset = ((y / tileSize).floor() % 2 == 0)
            ? 0
            : tileSize / 2;
        final double drawX = x + rowOffset - tileSize / 2;

        _drawIcon(
          canvas,
          _icons[iconIndex % _icons.length],
          Offset(drawX, y),
          iconSize,
          color,
        );
        iconIndex++;
      }
    }
  }

  void _drawIcon(
    Canvas canvas,
    IconData icon,
    Offset center,
    double size,
    Color color,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_PatternPainter old) => old.isDark != isDark;
}
