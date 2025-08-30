import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';

class TaskTile extends ConsumerWidget {
  final IconData icon;
  final String title;
  //final String? subtitle;
  final String? detail;

  const TaskTile({
    super.key,
    required this.icon,
    required this.title,
    // this.subtitle,
    this.detail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(personaThemeProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.appBarColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Icon(icon, color: Colors.black),
                const SizedBox(width: 10,),
                Text(title, style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w500),),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.05,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(detail ?? "", style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w500),),
          ),
        ],
      ),
    );
    // return Card(
    //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    //   elevation: 3, // adds subtle shadow
    //   child: ListTile(
    //     leading: Icon(icon, color: Colors.black),
    //     title: Text(
    //       title,
    //       style: const TextStyle(
    //         fontWeight: FontWeight.w600,
    //         fontSize: 16,
    //       ),
    //     ),
    //     subtitle: detail != null
    //         ? Container(
    //             margin: const EdgeInsets.only(top: 4),
    //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    //             decoration: BoxDecoration(
    //               color: Colors.grey.shade200, // background for detail
    //               borderRadius: BorderRadius.circular(6),
    //             ),
    //             child: Text(
    //               detail!,
    //               style: const TextStyle(
    //                 fontSize: 13,
    //                 color: Colors.black87,
    //               ),
    //             ),
    //           )
    //         : null,
    //     onTap: () {
    //       // TODO: handle navigation or action
    //     },
    //   ),
    // );
  }
}
