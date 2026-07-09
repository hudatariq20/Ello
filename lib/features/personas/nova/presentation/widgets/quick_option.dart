import 'package:flutter/material.dart';
import 'package:voice_input/core/utils/date_utils.dart';

import '../screens/nova_date_sheet.dart';

class QuickOption {
  final String label;
  final IconData icon;
  final DateTime? Function() compute;
  final String Function() trailing;
  final bool Function(DateTime?) matches;

  QuickOption(
      {required this.label,
      required this.icon,
      required this.compute,
      required this.trailing,
      required this.matches});
}

List<QuickOption> quickOptions(DateSheetKind kind) {
  final today = today0();
  final tomorrow = today.add(const Duration(days: 1));
  final nextWeek = nextMondayFrom(today);
  final thisWeekend = weekend(today);
  final weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  //today -> today selected, tommorow, next week , (maybe this weekend), no date
  //deadline -> today, tommorrow, next week, (maybe this weekend)

  //-----------------------------------------------------------------------------------//
  //                              HELPER FUNCTIONS                                     //
  //-----------------------------------------------------------------------------------//

/**
 * It synchronizes your calendar picker with the quick options row.
If the user taps a chip → the calendar updates.
If the user picks a calendar date → the matching chip highlights.
 * 
 */
  bool selectedDate(DateTime? selectedDate, DateTime? newDate) =>
      selectedDate != null && isSameDay(selectedDate, newDate);

  final List<QuickOption> quickOptions = [];

  if (kind == DateSheetKind.deadline) {
    quickOptions.add(QuickOption(
        label: 'Today',
        icon: Icons.event_available,
        compute: () => today,
        trailing: () => weekday[today.weekday - 1],
        matches: (date) => date != null && isSameDay(date, today)));
  }

  quickOptions.add(QuickOption(
      label: 'Tomorrow',
      icon: Icons.wb_sunny_outlined,
      compute: () => tomorrow,
      trailing: () => weekday[tomorrow.weekday - 1],
      matches: (date) => date != null && isSameDay(date, tomorrow)));

  quickOptions.add(QuickOption(
      label: 'This weekend',
      icon: Icons.cloud_sync_sharp,
      compute: () => thisWeekend,
      trailing: () => weekday[thisWeekend.weekday - 1],
      matches: (date) => date != null && isSameDay(date, thisWeekend)));

  quickOptions.add(QuickOption(
      label: 'Next week',
      icon: Icons.arrow_forward,
      compute: () => nextWeek,
      trailing: () => weekday[nextWeek.weekday - 1],
      matches: (date) => date != null && isSameDay(date, nextWeek)));

  if (kind == DateSheetKind.date) {
    quickOptions.add(
      QuickOption(
        label: 'No Date',
        icon: Icons.block,
        compute: () => null,
        trailing: () => '',
        matches: (sel) => sel == null,
      ),
    );
  } else if (kind == DateSheetKind.deadline) {
    quickOptions.add(
      QuickOption(
        label: 'No Deadline',
        icon: Icons.block,
        compute: () => null,
        trailing: () => '',
        matches: (sel) => sel == null,
      ),
    );
  }

  return quickOptions;
}


