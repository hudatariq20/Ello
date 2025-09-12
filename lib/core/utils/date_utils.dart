// lib/core/utils/date_utils.dart

DateTime today0() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

DateTime clampToToday(DateTime d) {
  final dd = DateTime(d.year, d.month, d.day);
  final t = today0();
  return dd.isBefore(t) ? t : dd;
}

bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime nextMondayFrom(DateTime from) {
  final weekday = from.weekday;
  final daysUntilMon = (DateTime.monday - weekday + 7) % 7;
  final add = daysUntilMon == 0 ? 7 : daysUntilMon;
  final base = DateTime(from.year, from.month, from.day);
  return base.add(Duration(days: add));
}

DateTime weekend(DateTime from) {
  final weekday = from.weekday;
  final daysUntilFri = (DateTime.friday - weekday + 7) % 7;
  final add = daysUntilFri == 0 ? 7 : daysUntilFri;
  final base = DateTime(from.year, from.month, from.day);
  return base.add(Duration(days: add));
}

String fmtDayMonth(DateTime d) {
  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return '${d.day} ${months[d.month - 1]}';
}

