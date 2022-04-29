import 'dart:convert';
import 'dart:io';

import 'package:aliposter_waiter/model/category.dart';
import 'package:aliposter_waiter/model/hall.dart';
import 'package:aliposter_waiter/model/order.dart';
import 'package:aliposter_waiter/model/report.dart';
import 'package:aliposter_waiter/model/table.dart';
import 'package:aliposter_waiter/model/worker.dart';
import 'package:aliposter_waiter/prefs/prefs.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final _instance = ApiService._();

  ApiService._();

  // final apiUrl = 'http://192.168.0.17:8888/api/v1/';

  static ApiService getInstance() => _instance;

  Future<Worker?> auth(String code) async {
    final client = http.Client();
    final address = 'http://' +
        (await getAddress())! +
        ':' +
        (await getPort())! +
        '/api/v1/';
    final response = await http
        .get(Uri.parse(address + 'Worker/by-code/?code=$code'))
        .timeout(const Duration(seconds: 5));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseObj = json.decode(responseBody);
      final result = Worker.fromJson(responseObj["value"]);
      await saveWorker(result);
      print(result.toJson());
      return result;
    }
    print(response.body);
    throw Exception('failed to check');
  }

  Future<List<Hall>> getHalls() async {
    final address = 'http://' +
        (await getAddress())! +
        ':' +
        (await getPort())! +
        '/api/v1/';

    final response = await http.get(Uri.parse(
        // apiUrl +
        address + 'Hall/halls-and-tables/'));
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseObj = json.decode(responseBody);
      final List<Hall> result =
          List<Hall>.from(responseObj.map<Hall>((x) => Hall.fromJson(x)));
      return result;
    }
    throw Exception('failed');
  }

  Future<List<Category>> getCategories() async {
    final address = 'http://' +
        (await getAddress())! +
        ':' +
        (await getPort())! +
        '/api/v1/';
    final response = await http.get(Uri.parse(
        // apiUrl +
        address + 'Category/get-all-categories/'));
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseObj = json.decode(responseBody);
      final result = List<Category>.from(
          responseObj.map<Category>((x) => Category.fromJson(x)));
      return result;
    }
    print(response.body);
    throw Exception('failed');
  }

  Future<bool> openTable(int tableId) async {
    final address = 'http://' +
        (await getAddress())! +
        ':' +
        (await getPort())! +
        '/api/v1/';
    final response = await http.put(Uri.parse(
            // apiUrl +
            address + 'OrderMobile/change-table-state/'),
        headers: {
          HttpHeaders.contentEncodingHeader: 'utf-8',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          "tableModelId": tableId,
          "isBusy": true,
        }));
    if (response.statusCode == 200) {
      return true;
    }
    print(response.body);
    // throw Exception('failed ${response.statusCode}');
    return false;
  }

  Future updateOrder(Order order) async {
    final address = 'http://' +
        (await getAddress())! +
        ':' +
        (await getPort())! +
        '/api/v1/';
    final timeNow = DateTime.now();
    final worker = await getWorker();

    final payload = {
      "Order": {
        "id": order.id ?? 0,
        "total": order.total ?? 0.0,
        "workerCreateId": order.workerCreateId ?? 0,
        "created": order.created!.toIso8601String(),
        "tableModelId": order.tableModelId,
        "guestCount": order.guestCount,
        "orderItems": order.orderItems
            .map((element) => {
                  "id": element.id ?? 0,
                  "orderId": element.orderId,
                  "productId": element.productId ?? 0,
                  "price": element.product?.price ?? 0.0,
                  "count": element.count,
                  "total": element.total ?? 0.0,
                  "workerId": element.workerId ?? 0,
                  "created": timeNow.toIso8601String(),
                  "workerPercent": element.workerPercent ?? 0,
                })
            .toList(),
      },
      "workerId": worker.id,
    };
    final response = await http.put(
      Uri.parse(
          // apiUrl +
          address + 'OrderMobile/update-order/'),
      headers: {
        HttpHeaders.contentEncodingHeader: 'utf-8',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200) {
      throw Exception('error');
    }
    // print(payload.toString());
    // print(response.body);
  }

  Future createOrder(Order order) async {
    final address = 'http://' +
        (await getAddress())! +
        ':' +
        (await getPort())! +
        '/api/v1/';
    final timeNow = DateTime.now();
    final response = await http.post(Uri.parse(
            // apiUrl +
            address + 'OrderMobile/create-order/'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.contentEncodingHeader: 'utf-8',
        },
        body: jsonEncode({
          "id": order.id ?? 0.0,
          "total": order.total ?? 0.0,
          "workerCreateId": order.workerCreateId ?? 0,
          "created": (order.created ?? timeNow).toIso8601String(),
          "tableModelId": order.tableModelId,
          "comment": "string",
          "guestCount": order.guestCount,
          "orderItems": order.orderItems
              .map((element) => {
                    "id": element.id ?? 0,
                    "orderId": element.orderId ?? 0,
                    "productId": element.productId ?? 0,
                    "price": element.product?.price,
                    "count": element.count,
                    "total": element.total ?? 0.0,
                    "workerId": element.workerId ?? 0,
                    "created": (element.created ?? timeNow).toIso8601String(),
                    "workerPercent": element.workerPercent ?? 0.0,
                  })
              .toList(),
        }));
    if (response.statusCode == 200) {
      print('That\'s ok');
      return;
    }
    print(response.body);
    throw Exception('shit');
  }

  Future getOrderForTable(int orderId) async {
    final address = 'http://' +
        (await getAddress())! +
        ':' +
        (await getPort())! +
        '/api/v1/';
    final response = await http.get(Uri.parse(
        // apiUrl +
        address + 'Order/$orderId/'));
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseObj = json.decode(responseBody);
      return Order.fromJson(responseObj);
    }
    throw Exception('failed');
  }

  Future<TableModel> getTableWithActiveOrders(int id) async {
    final address = 'http://' +
        (await getAddress())! +
        ':' +
        (await getPort())! +
        '/api/v1/';
    final response = await http.get(Uri.parse(
        // apiUrl +
        address + 'table/tables-with-active-orders/$id'));
    print(response.body);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseObj = json.decode(responseBody);
      return TableModel.fromJson(responseObj);
    }
    return TableModel(
        tableModelId: 0,
        tableTitle: "",
        hasOrder: false,
        isBusy: false,
        guestCount: 0,
        total: 0.0,
        createdByWorkerId: 1);
    // throw Exception("failed");
  }

  Future<List<Report>> getReports(String from, String to) async {
    final ip = await getAddress();
    final port = int.tryParse((await getPort())!);
    final worker = await getWorker();
    final uri = Uri(
      scheme: 'http',
      host: ip,
      port: port,
      path: 'api/v1/Report/worker-order-detail',
      queryParameters: {
        'from': from,
        'to': to,
        'workerId': worker.id.toString(),
      },
    );
    print(uri.toString());
    final response = await http.get(uri, headers: {
      HttpHeaders.contentEncodingHeader: 'utf-8',
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    print(response.body);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseObj = json.decode(responseBody);
      return List.from(responseObj.map((x) => Report.fromJson(x)));
    }
    throw Exception('fuck');
  }
}
