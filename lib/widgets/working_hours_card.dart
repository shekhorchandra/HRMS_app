import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For bar chart


//Constructor
class WorkingHoursCard extends StatelessWidget {
  final String title;
  final String totalHours;
  final String? overtimeHours; // Optional for screen 1
  final bool showChart;
  final List<double>? chartData; // Data for the bar chart
  final List<String>? chartLabels; // Labels for the bar chart

  const WorkingHoursCard({
    super.key,
    required this.title,
    required this.totalHours,
    this.overtimeHours,
    this.showChart = false,
    this.chartData,
    this.chartLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoChip("Total Hours", totalHours, Icons.timer),
            if (overtimeHours != null)
              _buildInfoChip("Overtime", overtimeHours!, Icons.access_alarms),
          ],
        ),
        if (showChart && chartData != null && chartLabels != null) ...[
          const SizedBox(height: 20),
          SizedBox(
            height: 180, // Height for the bar chart
            child: BarChart(
              BarChartData(
                barGroups: _buildBarGroups(chartData!),
                gridData: FlGridData(show: false), // no grid
                borderData: FlBorderData(show: false), // no border
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(), // Y axis (hours)
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < chartLabels!.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              chartLabels![index], // X axis (days)
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            )

          ),
        ],
      ],
    );
  }

  //Total Hours & Overtime Chip
  Widget _buildInfoChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Colors.black),
              ),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

//barGroups: বারগুলোর ডেটা কেমন হবে তা নির্ধারণ করে
// Build only the bar groups
  List<BarChartGroupData> _buildBarGroups(List<double> data) {
    return List.generate(data.length, (index) {
      String dayLabel = chartLabels?[index] ?? '';

      // Default gradient for working days
      LinearGradient barGradient = const LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

      // Gradient for holidays (Friday and Saturday)
      if (dayLabel == "Fri" || dayLabel == "Sat") {
        barGradient = const LinearGradient(
          colors: [Colors.orange, Colors.deepOrangeAccent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        );
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index],
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
            gradient: barGradient,
          ),
        ],
      );
    });
  }



}