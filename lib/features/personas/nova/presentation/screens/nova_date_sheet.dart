import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/core/utils/date_utils.dart';
import 'package:voice_input/shared/providers/persona_theme_provider.dart';

import '../widgets/nova_widgets.dart';

enum DateSheetKind { deadline, date }

class NovaDateSheetResult {
  final DateTime? date;
  final TimeOfDay? time;
  final String repeatRule;

  NovaDateSheetResult({this.date, this.time, required this.repeatRule});
}

Future<NovaDateSheetResult?> showNovaDateSheet(
  BuildContext context, {
  required DateSheetKind kind,
  DateTime? initialDate,
  TimeOfDay? initialTime,
  String initialRepeat = 'none',
}) {
  final today = today0();
  final init = initialDate == null ? today : clampToToday(initialDate);
  return showModalBottomSheet<NovaDateSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MediaQuery.removePadding(
            context: ctx,
            removeBottom: true,
            child: NovaDateSheet(
                kind: kind,
                initialDate: init,
                initialTime: initialTime,
                initialRepeat: initialRepeat),
          ));
}

/* -------------------------------------------------------------------------- */
/*                               INTERNAL WIDGET                              */
/* -------------------------------------------------------------------------- */

class NovaDateSheet extends ConsumerStatefulWidget {
  final DateSheetKind kind;
  final DateTime initialDate;
  final TimeOfDay? initialTime;
  final String initialRepeat;

  const NovaDateSheet(
      {super.key,
      required this.kind,
      required this.initialDate,
      this.initialTime,
      required this.initialRepeat});

  @override
  ConsumerState<NovaDateSheet> createState() => _NovaDateSheetState();
}

class _NovaDateSheetState extends ConsumerState<NovaDateSheet> {
  late DateTime? _selectedDate;
  late TimeOfDay? _selectedTime;
  late String _repeat;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateSheetKind.date == widget.kind
        ? widget.initialDate
        : widget.initialDate;
    _selectedTime = widget.initialTime;
    _repeat = widget.initialRepeat;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(personaThemeProvider);
    final options = quickOptions(widget.kind);
    final date = widget.kind == DateSheetKind.deadline ? 'Deadline' : 'Today';
    return SafeArea(
        top: false,
        child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              color: theme.appBarColor,
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft, end: Alignment.bottomRight,
              //   colors: [Color(0xFFE5F1FF), Color(0xFFF5FAFF)], // light Nova look
              // ),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 14,
                    color: Colors.black26,
                    offset: Offset(0, -1)),
              ],
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85),
              child: Column(
                children: [
                  //Grabber
                  Center(
                      child: Container(
                    width: 44,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(3)),
                  )),
                  //Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.urbanist(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )),
                      Text(
                        date,
                        style: GoogleFonts.urbanist(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Done',
                            style: GoogleFonts.urbanist(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                  _FieldHint(fmtDayMonth(_selectedDate ??
                      today0())), //this should display the selected date
                  const SizedBox(height: 12),
                  //Quick Options,
                  //...options.map((opt) => QuickOption(opt))
                  // Quick Options
                  ...options.map(
                    (opt) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _QuickRow(
                        option: opt,
                        selectedDate: _selectedDate,
                        onPressed: () =>
                            setState(() => _selectedDate = opt.compute()),
                      ),
                    ),
                  ),
                  //datetimepicker.
                  Container(
                    margin: const EdgeInsets.only(top: 6, bottom: 8),
                    decoration: BoxDecoration(
                      color: theme.appBarColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _qDivider),
                    ),
                    child: CalendarDatePicker(
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      onDateChanged: (d) => setState(() => _selectedDate = d),
                    ),
                  ),
                  //option for time and repeat
                ],
              ),
            )));
  }
}

class _FieldHint extends StatelessWidget {
  final String hint;
  const _FieldHint(this.hint);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.5),
          borderRadius: BorderRadius.circular(12)),
      child: Text(hint, style: GoogleFonts.urbanist(color: Colors.black)),
    );
  }
}

// ---- Nova palette tokens ----
const _qPrimary = Color(0xFF4C8DF7); // Primary blue
const _qText = Color(0xFF0F2240); // Deep navy (labels)
const _qMuted = Color(0xFF6B7A90); // Muted text (trailing)
const _qIconBg = Color(0xFFEAF2FF); // Soft blue chip behind icon
const _qDivider = Colors.black26; // Hairline border/divider

// ---- Nova palette tokens (you already have these above) ----
// const _qPrimary = Color(0xFF4C8DF7);
// const _qText    = Color(0xFF0F2240);
// const _qMuted   = Color(0xFF6B7A90);
// const _qIconBg  = Color(0xFFEAF2FF);
// const _qDivider = Color(0xFFE7EEF9);

class _QuickRow extends StatelessWidget {
  //final IconData icon;
  final QuickOption option;
  final DateTime? selectedDate;
  final VoidCallback onPressed;

  const _QuickRow(
      {required this.option,
      required this.selectedDate,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isSelected = option.matches(selectedDate);
    final bg = isSelected ? _qPrimary : _qIconBg;
    final fg = isSelected ? _qPrimary : _qText;
    final chip = isSelected ? Colors.white.withOpacity(.18) : _qIconBg;

    final trailing = option.trailing();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            //icon chip
            Container(
              // width: 20,
              //height: 20,
              decoration: BoxDecoration(
                color: chip,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(option.icon, size: 24, color: _qPrimary),
            ),
            const SizedBox(width: 10),
            //label
            Expanded(
                child: Text(option.label,
                    style: GoogleFonts.urbanist(
                      color: fg,
                    ))),
        
            //trailing weekday (optional)
            if (trailing.isNotEmpty)
              Text(trailing,
                  style: GoogleFonts.urbanist(
                      color: isSelected ? _qText : _qMuted, fontSize: 16)),
        
            // const Divider(
            //   color: Colors.black,
            // ),
          ],
        ),
        
      ),
      const SizedBox(height: 8),
      const Divider(
          color: _qDivider,
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}
