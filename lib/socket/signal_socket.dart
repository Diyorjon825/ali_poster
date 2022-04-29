import 'dart:async';

import 'package:aliposter_waiter/prefs/prefs.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

class TableSocket {
  final hubProdLogger = Logger('SignalR - transport');

  // final serverUrl = "http://0fb4-194-55-93-229.ngrok.io/common";
  final transportProdLogger = Logger('SignalR - transport');
  final connectionOptions = HttpConnectionOptions;
  late HubConnection hubConnection;

  void connect() async {
    final ip = await getAddress();
    final serverUrl = 'http://$ip:7777/common/';
    final httpOptions = HttpConnectionOptions(
      // httpClient: WebSupportingHttpClient,
      requestTimeout: 5000,
      logger: transportProdLogger,
      // transport: HttpTransportType.WebSockets,
      // transport: HttpTransportType.LongPolling,
    );
    hubConnection = HubConnectionBuilder()
        .withUrl(serverUrl, options: httpOptions)
        //.withAutomaticReconnect(
        // reconnectPolicy: DefaultRetryPolicy(retryDelays: [0, 5000, 10000, 15000, 15000, 15000, 15000, 20000, 30000]),
        //   retryDelays: [0, 5000, 10000, 15000, 15000, 15000, 15000, 20000, 30000],
        //  )
        .configureLogging(hubProdLogger)
        .build();
    hubConnection.onreconnected(({connectionId}) {
      // Provider.of<ConnectionIndicator>(context, listen: false).updateState(true);
      print("Reconnected: $connectionId");
    });
    hubConnection.onreconnecting(({error}) {
      // Provider.of<ConnectionIndicator>(context, listen: false).updateState(false);
      print("Reconnecting: $error");
    });
    hubConnection.onclose(({error}) async {
      // Provider.of<ConnectionIndicator>(context, listen: false).updateState(false);
      print("Error: $error");
      await hubConnection.start();
    });
    // hubConnection.on('RecieveTableMessage', (arguments) {
    // print(arguments);
    // state.updateState(TableMessage.fromJson(arguments?.first as Map));
    // var c = myEvent.subscriberCount;
    // myEvent.broadcast(TableMessage.fromJson(arguments!.first as Map));
    // });
    if (ip != null && ip.isNotEmpty) await hubConnection.start();
  }

  Future<bool> invokeRemoteMethod(
      String methodName, List<Object> argument) async {
    var result = await hubConnection.invoke(methodName, args: argument);
    return result != null;
  }

  void close() => hubConnection.stop();
}
