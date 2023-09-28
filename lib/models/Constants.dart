import 'package:shared_preferences/shared_preferences.dart';

// var tokens =
//     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYjgwYmI2MDI1ZDcwYTQ3OGQ5NzliMTBiNGEwYWFiNjYyMmQ0ZDE2NzU3YTAwZDllZmJlYTQyMzUwOWRmYjI5NjQ1YTRmZmYwNjk0NWI5YWIiLCJpYXQiOjE2OTEwNjU3NzYuMTc0Njc3LCJuYmYiOjE2OTEwNjU3NzYuMTc0NjgxLCJleHAiOjE3MjI2ODgxNzYuMTA3Mzk4LCJzdWIiOiIzNiIsInNjb3BlcyI6W119.bTE0Lv04dt4uf6NN7n_vg3hL7wca4ZhgzZH-tuqSaCdF8nJkohKHZlRBsURZ8-jNzWBWedYhuI2WMK29BglKwcsmu6s7IQrvKQk-1CJ5o15RfiB7mLrkK-Fp_HpFSMLDEYY4vwKiMKj-aq5DRonOj5rhv64HBM9ORjK8D6FO5OxumsnpEIJMZvXSWOUWWAfVkPmmq0DFPpROUKtjkt_D018plG0IR4tzlJZ2Doc6jXaMZ0U-SeB5Gim3ZJPAcqo6LCMz0Q_r6xrHHKRSbiPm1OH57QJM7UuL-bWwFcCo7GG63iBCf3XD9407TP-G6RSglL9wgiswytqCZcvg08PbMx7Z8ZPlb5-OB3d5pShJ1yX0qRcSNzf9vJm5m3C_DhORN-NfY0-nWAyQAUG1iev4cMsBhAbcUzoriK4xb1n0svFYSX8yfwNtTJ1fpIS6yBeK5HElEm-Jz4kMxcr_OfoEePJAZ3ieJw4BBem5a1Cy8ThBT3IxtUseUzJMBkOCKtT1cUMlEZqIPdmvbTP9XtTo9u5VTY0RzewLOFyzwd33HV7T8kroMntrdThAj3TZNQ5lE4EnbTO4VvD7x5tPYyEsiTSeZgDjFAHty58NXvlomJeFbA5PCB33pMY0tXpLin1FVrPdSUbhHimlTRcsonPGzAzZfWzk7KwJgStZ0BSeyKs';
var tokens;
Future<String?> fetchtoken() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  tokens = token!;
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
