import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class AppLogo extends StatelessWidget {
  final double scale;
  final bool isDark;

  const AppLogo({
    Key? key,
    this.scale = 1.0,
    this.isDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Image.asset(
        'assets/images/logo.png',
        height: 120,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to code-based logo if file is missing
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStyledLetter('O', const Color(0xFF4A9099)),
                  const SizedBox(width: 2),
                  _buildStyledLetter('X', const Color(0xFF9CA3AF)),
                  const SizedBox(width: 2),
                  _buildStyledLetter('4', AppColors.primaryBlue),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Transportes (su)',
                style: TextStyle(
                  fontSize: 24,
                  color: const Color(0xFF4A9099).withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'L I M I T A D A',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                  color: AppColors.primaryBlue.withOpacity(0.9),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStyledLetter(String letter, Color color) {
    return Text(
      letter,
      style: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.w900,
        color: color,
        letterSpacing: -2,
      ),
    );
  }
}
