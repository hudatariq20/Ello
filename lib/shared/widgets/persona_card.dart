// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PersonaCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final List<Color> gradientColors;

//   const PersonaCard({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.gradientColors,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: gradientColors,
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 5),

//           Text(
//             title,
//             style: GoogleFonts.urbanist(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           // const SizedBox(height: 4),
//           Icon(icon, size: 60, color: Colors.white),
//           Text(
//             subtitle,
//             textAlign: TextAlign.center,
//             style: GoogleFonts.urbanist(
//               fontSize: 10,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonaCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;

  const PersonaCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(8), // Reduced padding
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16), // Reduced borderRadius
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: constraints.maxWidth * 0.3, color: Colors.white),  // Made sizes relative
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: constraints.maxWidth * 0.12,  // Made sizes relative
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: constraints.maxWidth * 0.08,  // Made sizes relative
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}