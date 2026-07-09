import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/shared/models/personaTheme_model.dart';

class NovaListButton extends StatelessWidget {
  final PersonaTheme theme;
  final Widget icon;
  final String text;
  const NovaListButton({
    super.key,
    required this.theme,
    required this.icon,
    required this.text,
  });

  //final PersonaTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: LinearGradient(  // **Added gradient**
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.6),  // Subtle highlight
            Colors.white.withOpacity(0.4),  // Base color
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          //add the image here from assets
          //replace with svg image
          //SvgPicture.asset('assets/images/shopping-cart.svg', width: 20, height: 20),
          icon,
          const SizedBox(width: 15),
          Text(
            //'Add to Grocery List',
            text,
            style: GoogleFonts.urbanist(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: theme.appBarIconColor),
          ),
        ]),
      ),
    );
  }
}
