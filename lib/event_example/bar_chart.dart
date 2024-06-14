import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_table_calendart/model/health.dart';

class BarChartExample extends StatefulWidget {
  const BarChartExample({super.key});

  @override
  State<BarChartExample> createState() => _BarChartExampleState();
}

class _BarChartExampleState extends State<BarChartExample> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Health? healthData;

  Future<Health> getHealthData() async {
    try {
      final data =
          await db.collection('health').doc('Mhej1ZmSLOf8YvTtrLHy').get();
      return Health.fromJson(data.data()!);
    } on Exception catch (e) {
      throw Exception('Failed to load health data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar Chart Example'),
      ),
      body: FutureBuilder<Health>(
        future: getHealthData(),
        builder: (BuildContext context, AsyncSnapshot<Health> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData == false) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            healthData = snapshot.data;
            return Column(
              children: [
                const SizedBox(height: 30.0),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(
                          border: const Border(
                        top: BorderSide(width: 1),
                        right: BorderSide(width: 1),
                        left: BorderSide(width: 1),
                        bottom: BorderSide(width: 1),
                      )),
                      groupsSpace: 10,
                      barGroups: [
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(
                              fromY: 0,
                              toY: healthData!.diet!.toDouble(),
                              width: 15,
                              color: Colors.amber),
                        ]),
                        BarChartGroupData(x: 2, barRods: [
                          BarChartRodData(
                              fromY: 0,
                              toY: healthData!.sleep!.toDouble(),
                              width: 15,
                              color: Colors.indigo),
                        ]),
                        BarChartGroupData(x: 3, barRods: [
                          BarChartRodData(
                              fromY: 0,
                              toY: healthData!.exercise!.toDouble(),
                              width: 15,
                              color: Colors.orange),
                        ]),
                        BarChartGroupData(x: 4, barRods: [
                          BarChartRodData(
                              fromY: 0,
                              toY: healthData!.mentalState!.toDouble(),
                              width: 15,
                              color: Colors.green),
                        ]),
                      ],
                    ),
                  ),
                ),
                //  健康の説明を表示
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('食事'),
                    Text('睡眠'),
                    Text('運動'),
                    Text('精神状態'),
                  ],
                ),
                const SizedBox(height: 30.0),
              ],
            );
          }
          return const Text("loading");
        },
      ),
    );
  }
}
