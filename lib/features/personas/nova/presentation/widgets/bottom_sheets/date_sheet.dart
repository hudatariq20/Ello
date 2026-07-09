import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateSheet extends StatefulWidget {
  const DateSheet({super.key});

  @override
  State<DateSheet> createState() => _DateSheetState();
}

class _DateSheetState extends State<DateSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [ 
          Text('Select a date', style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }
}