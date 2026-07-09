import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NovaTodoNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const NovaTodoNavbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().day.toString();
    return BottomAppBar(
      //shape: const CircularNotchedRectangle(),
      shape: const AutomaticNotchedShape(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        StadiumBorder(), // smooth cut
      ),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                //icon containing today date in the calender
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: currentIndex == 0 ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      DateTime.now().day.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: currentIndex == 0 ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                  // Stack(
                  //   alignment: Alignment.center,
                  //   children: [
                  //     Icon(Icons.calendar_today_outlined,  size: 30, color: currentIndex == 0 ? Colors.blue : Colors.grey),
                  //     Text(today, style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w600, color: currentIndex == 0 ? Colors.blue : Colors.grey)),
                  //   ],
                  // ),
                  Text(
                    'Today',
                    style: TextStyle(
                        color: currentIndex == 0 ? Colors.blue : Colors.grey),
                  ),
                ],
              ),
              onTap: () => onTap(0),
            ),
          ),

          const SizedBox(width: 60), //space for the mic,
          Expanded(
            child: InkWell(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: currentIndex == 1 ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.calendar_month,
                        size: 18,
                        color: currentIndex == 1 ? Colors.blue : Colors.grey),
                  ),

                  // Icon(Icons.event, size: 30,
                  //     color: currentIndex == 2 ? Colors.blue : Colors.grey),
                 Text("Upcoming", style: TextStyle(color: currentIndex == 1 ? Colors.blue : Colors.grey)),
                ],
              ),
              onTap:()=> onTap(1),
            ),
          ),
        ],
      ),
    );
  }
}
