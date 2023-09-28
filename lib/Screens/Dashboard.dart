import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sky_pad/constant/url.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Data_service/Dashboard_api.dart';
import '../models/Constants.dart';
import 'Leaves.dart';

class DashboardScreen extends StatefulWidget {
  final List<Task> tasks; // Pass the list of tasks to the dashboard

  const DashboardScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Task> tasks;
  late TooltipBehavior _tooltipBehavior;

  late final DataLabelSettings dataLabelSettings;

  List<ChartData> _chartData = [];

  List<dynamic> leavetypecount = [];

  //**********         API function  (admin leave view)       *************//
  // Future<void> _loadLeaveRequests() async {
  //   final apiUrl = DASHBOARD; // Replace with the actual API URL
  //   final headers = {
  //     'Accept': 'application/json',
  //     'Authorization':
  //         'Bearer $tokens', // Make sure you have 'tokens' defined somewhere
  //   };
  //
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl), headers: headers);
  //     print(response.statusCode);
  //     // print(response.body['leaves']);
  //     // print(response.body[0]);
  //     if (response.statusCode == 200) {
  //       if (response.body.isNotEmpty) {
  //         final responseData = jsonDecode(response.body);
  //         setState(() {
  //           leavetypecount = responseData['admin'];
  //         });
  //       } else {
  //         setState(() {
  //           leavetypecount = []; // Set an empty list to indicate no data
  //         });
  //         print('No leave requests available.');
  //       }
  //     } else {
  //       print('Error fetching leave requests: ${response.body}');
  //     }
  //   } catch (error) {
  //     print('Error connecting to the API: $error');
  //   }
  // }
  //**********         API function  (admin leave view)       *************//
  final DashboardleaveApiService apiService =
      DashboardleaveApiService(DASHBOARD, tokens);

  //**********         API function  (admin leave view)       *************//
  Future<void> _loadLeaveRequests() async {
    final leavetypecount = await apiService.dashboardleaveview();
    setState(() {
      this.leavetypecount = leavetypecount;
    });
  }

  //**********         API function  (admin leave view)       *************//
  @override
  void initState() {
    fetchtoken();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    _fetchChartData();
    _loadLeaveRequests();
    // _fetchLeaveCounts();
    print(tokens);
    // Fetch data from the Laravel API
    tasks = widget.tasks; // Initialize tasks from the widget's data
  }

  // Function to update tasks when a new time sheet is added

  // Function to fetch data from the Laravel API
  Future<void> _fetchChartData() async {
    final apiUrl =
        DASHBOARD; // Replace with your Laravel API endpoint URL to fetch expenses

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokens',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> categories = data["sub"];

      _chartData = categories
          .map((item) => ChartData(
                item["categories"],
                item["sums"],
              ))
          .toList();
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget buildChartSection() {
    if (_chartData.isEmpty) {
      return Center(
        child: Text(
          "No expenses found.",
          style: TextStyle(fontSize: 15.0, color: Colors.black),
        ),
      );
    } else {
      return Card(
        color: Colors.white10,
        child: Container(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Expenses Category for one month",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Expanded(
                child: SfCircularChart(
                  tooltipBehavior: _tooltipBehavior,
                  legend: Legend(
                    isVisible: true,
                    textStyle: TextStyle(color: Colors.white, fontSize: 8.0),
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  series: <CircularSeries>[
                    // Render pie chart
                    PieSeries<ChartData, String>(
                      enableTooltip: true,
                      dataSource: _chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF001E36),
      body: Column(
        children: [
          for (int index = 0; index < leavetypecount.length; index++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularSection(
                  title: 'Sick',
                  value: leavetypecount[index]['sick'],
                  // value: sickCount.toString(),
                  color: Colors.red,
                  valueFontSize: 25.0,
                ),
                CircularSection(
                  title: 'Casual',
                  // value: ,
                  value: leavetypecount[index]['casual'],
                  color: Colors.lightBlue,
                  valueFontSize: 25.0,
                ),
                CircularSection(
                  title: 'Total',
                  // value: ,
                  value: (int.parse(leavetypecount[index]['sick']) +
                          int.parse(leavetypecount[index]['casual']))
                      .toString(),
                  color: Colors.orangeAccent,
                  valueFontSize: 25.0,
                ),
              ],
            ),
          buildChartSection(),
          // Container(
          //   height: 300,
          //   padding: EdgeInsets.all(16),
          //   child: SfCartesianChart(
          //     primaryXAxis: CategoryAxis(),
          //     series: <ChartSeries>[
          //       // Bar series for total hours worked per project
          //       BarSeries<Task, String>(
          //         // Set your data source for the bar chart
          //         dataSource: tasks,
          //         xValueMapper: (Task task, _) => task.project,
          //         yValueMapper: (Task task, _) =>
          //             task.durationInHours, // Use durationInHours
          //         dataLabelSettings: DataLabelSettings(
          //           isVisible: true,
          //           labelAlignment: ChartDataLabelAlignment.middle,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class Task {
  final String project;
  final String? description;
  final DateTime date;
  final String startTime;
  final String endTime;

  Task({
    required this.project,
    this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  // Calculate the duration in hours
  double get durationInHours {
    final start = DateTime.parse('2023-01-01 $startTime');
    final end = DateTime.parse('2023-01-01 $endTime');
    final duration = end.difference(start);
    return duration.inMinutes / 60.0;
  }
}
