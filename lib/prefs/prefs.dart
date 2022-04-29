import 'dart:convert';

import 'package:aliposter_waiter/model/worker.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

Future<void> saveWorker(Worker worker) async {
  var prefs = await SharedPreferences.getInstance();
  await prefs.setString('worker', jsonEncode(worker.toJson()));
}

Future<Worker> getWorker() async {
  var prefs = await SharedPreferences.getInstance();
  return Worker.fromJson(jsonDecode(prefs.getString('worker')!));
}

Future<void> insertAddress(String ipAddress) async {
  var prefs = RxSharedPreferences.getInstance();
  await prefs.setString('ip_address', ipAddress);
}

Future<void> insertPort(String ipPort) async {
  var prefs = RxSharedPreferences.getInstance();
  await prefs.setString('ip_port', ipPort);
}

Future<String?> getAddress() async {
  var prefs = RxSharedPreferences.getInstance();
  return (await prefs.getString('ip_address'));
}

Future<String?> getPort() async {
  var prefs = RxSharedPreferences.getInstance();
  return (await prefs.getString('ip_port'));
}
