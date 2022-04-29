import 'package:aliposter_waiter/api/api_service.dart';
import 'package:aliposter_waiter/model/report.dart';
import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:aliposter_waiter/socket/signal_socket.dart';
import 'package:aliposter_waiter/views/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  static const route = '/report';

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  var _reports = ApiService.getInstance().getReports('', '');
  String startTime = '', finalTime = '';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Material(
      child: Column(
        children: [
          DefaultAppBar(
            mediaQuery: mediaQuery,
            title: "Отчёты",
            connectionStatus: (Provider.of<TableSocket>(context).hubConnection.state != null &&
                Provider.of<TableSocket>(context).hubConnection.state!.index == 2),
            currentRoute: ReportPage.route,
          ),
          Material(
            child: IconButton(
              icon: const Icon(
                Icons.date_range,
                size: 36.0,
                color: AppColors.greenAccent,
              ),
              onPressed: () => showDateRangePicker(
                context: context,
                firstDate: DateTime(2022),
                lastDate: DateTime(2100),
              ).then((value) => setState(() {
                    startTime = value?.start != null
                        ? (value!.start.year.toString() +
                            '.' +
                            (value.start.month < 10 ? ('0' + value.start.month.toString()) : value.start.month.toString()) +
                            '.' +
                            (value.start.day < 10 ? ('0' + value.start.day.toString()) : value.start.day.toString()))
                        : '';
                    finalTime = value?.end != null
                        ? (value!.end.year.toString() +
                            '.' +
                            (value.end.month < 10 ? ('0' + value.end.month.toString()) : value.end.month.toString()) +
                            '.' +
                            (value.end.day < 10 ? ('0' + value.end.day.toString()) : value.end.day.toString()))
                        : '';
                    _reports = ApiService.getInstance().getReports(startTime, finalTime);
                  })),
            ),
          ),
          FutureBuilder(
            future: _reports,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const SizedBox();
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final data = snapshot.data as List<Report>;
                    return LimitedBox(
                      maxHeight: mediaQuery.size.height * .735,
                      maxWidth: mediaQuery.size.width,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                        itemCount: data.length,
                        itemBuilder: (context, index) => Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Время заказа: " +
                                      data[index].date.year.toString() +
                                      '.' +
                                      (data[index].date.month < 10
                                          ? '0' + data[index].date.month.toString()
                                          : data[index].date.month.toString()) +
                                      '.' +
                                      (data[index].date.day < 10 ? '0' + data[index].date.day.toString() : data[index].date.day.toString()),
                                  style: AppTextStyle.header0.copyWith(color: Colors.black),
                                ),
                                Text(
                                  "Заработал: " + data[index].profit.toString(),
                                  style: AppTextStyle.header0.copyWith(color: Colors.black),
                                ),
                                Text(
                                  "Общая сумма: " + data[index].orderTotal.toString(),
                                  style: AppTextStyle.header0.copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                default:
                  return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
