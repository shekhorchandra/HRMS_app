class AttendanceModel {
  final int presentDays;
  final int lateDays;
  final int absentDays;
  final int leaveDays;
  final int sickLeaveDays;
  final int casualLeaveDays;

  AttendanceModel({
    required this.presentDays,
    required this.lateDays,
    required this.absentDays,
    required this.leaveDays,
    required this.sickLeaveDays,
    required this.casualLeaveDays,
  });
}
