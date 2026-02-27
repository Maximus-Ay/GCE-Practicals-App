import 'package:flutter/material.dart';

class PapersPage extends StatelessWidget {
  const PapersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F6FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_rounded, size: 64, color: Color(0xFF4FC3F7)),
            SizedBox(height: 16),
            Text(
              'Papers Page',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A237E),
                fontFamily: 'GoogleSansFlex',
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We\'ll build this together soon.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF90A4AE),
                fontFamily: 'GoogleSansFlex',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
