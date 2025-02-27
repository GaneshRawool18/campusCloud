import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_tracing/view/admin/adminHome/adminDashBoard.dart';

class CourseTaskChart extends StatefulWidget {
  @override
  _CourseTaskChartState createState() => _CourseTaskChartState();
}

class _CourseTaskChartState extends State<CourseTaskChart>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 84, 178, 254),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Course Task Cards",
          style: GoogleFonts.jost(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          );
        }),
        backgroundColor: const Color.fromARGB(255, 84, 178, 254),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: courseData.length,
          itemBuilder: (context, index) {
            var course = courseData[index];
            var totalTasks = course['totalTasks'] as int;
            var taskCompleted = Map<String, int>.from(course['taskCompleted']);
            var courseName = course['courseName'] as String;

            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (totalTasks > 0)
                      SizedBox(
                        width: double.infinity,
                        height: 200.0,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return BarChart(
                              BarChartData(
                                maxY: totalTasks.toDouble(),
                                groupsSpace: 20.0,
                                alignment: BarChartAlignment.spaceAround,
                                barGroups: taskCompleted.entries.map((entry) {
                                  String userId = entry.key;
                                  int completed = entry.value;

                                  return BarChartGroupData(
                                    x: int.parse(userId),
                                    barRods: [
                                      BarChartRodData(
                                        width: 30.0,
                                        toY: completed * _animation.value,
                                        color: Colors.blueAccent,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ],
                                  );
                                }).toList(),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        );
                                      },
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: const FlGridData(show: true),
                                barTouchData: BarTouchData(enabled: true),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      const Center(
                        child: Text(
                          "No tasks available for this course.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: CourseTaskChart()));
}
