import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_table_calendart/model/health.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({super.key});

  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
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
      body: FutureBuilder<Health>(
        future: getHealthData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          healthData = snapshot.data;
          List<PieChartSectionData> sections = [
            PieChartSectionData(
              color: Colors.red,
              value: healthData!.diet!.toDouble(),
              title: '食事',
            ),
            PieChartSectionData(
              color: Colors.blue,
              value: healthData!.sleep!.toDouble(),
              title: '睡眠',
            ),
            PieChartSectionData(
              color: Colors.yellow,
              value: healthData!.exercise!.toDouble(),
              title: '運動',
            ),
            PieChartSectionData(
              color: Colors.green,
              value: healthData!.mentalState!.toDouble(),
              title: '精神状態',
            ),
          ];
          return PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 3,
              centerSpaceRadius: 100,
              borderData: FlBorderData(show: false),
            ),
          );
        },
      ),
    );
  }
}
