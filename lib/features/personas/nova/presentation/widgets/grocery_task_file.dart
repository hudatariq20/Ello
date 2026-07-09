// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:voice_input/shared/providers/providers.dart';

// class GroceryTaskFile extends ConsumerStatefulWidget {
//   final IconData icon;
//   final String title;
//   final List<String> groceryItems;
//   const GroceryTaskFile({super.key, required this.icon, required this.title, required this.groceryItems});

//   @override
//   ConsumerState<GroceryTaskFile> createState() => _GroceryTaskFileState();
// }

// class _GroceryTaskFileState extends ConsumerState<GroceryTaskFile> {
//   @override
//   Widget build(BuildContext context) {
//     var theme = ref.watch(personaThemeProvider);
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: theme.appBarColor,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             child: Row(
//               children: [
//                 Icon(icon, color: Colors.black),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   title,
//                   style: GoogleFonts.urbanist(
//                       fontSize: 20, fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             height: MediaQuery.of(context).size.height * 0.05,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Text(
//               detail ?? "",
//               style: GoogleFonts.urbanist(
//                   fontSize: 20, fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
