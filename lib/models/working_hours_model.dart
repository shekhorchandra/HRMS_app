class WorkingHoursModel {
  final String totalHours;
  final String overtimeHours;
  final List<double> chartData;
  final List<String> chartLabels;

  WorkingHoursModel({
    required this.totalHours,
    required this.overtimeHours,
    required this.chartData,
    required this.chartLabels,
  });
}
