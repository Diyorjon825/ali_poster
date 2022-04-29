import 'package:aliposter_waiter/model/worker.dart';
import 'package:aliposter_waiter/socket/signal_socket.dart';
import 'package:aliposter_waiter/views/pages/auth.dart';
import 'package:aliposter_waiter/views/pages/menu.dart';
import 'package:aliposter_waiter/views/pages/report.dart';
import 'package:aliposter_waiter/views/pages/splash.dart';
import 'package:aliposter_waiter/views/pages/table.dart';
import 'package:aliposter_waiter/views/pages/tables.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

const double minValue = -79228162514264337593543950335.0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) =>
      print('${rec.level.name}: ${rec.time}: ${rec.message}'));
  TableSocket socket = TableSocket();
  socket.connect();
  runApp(Provider.value(value: socket, child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late WebSocketChannel socket;

  @override
  void initState() {
    // getAddress().then((value) => socket = WebSocketChannel.connect(Uri.parse('ws://' + value)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        AuthPage.route: (context) => const AuthPage(),
        MenuPage.route: (context) => const MenuPage(),
        ReportPage.route: (context) => const ReportPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == TablesPage.route) {
          final arg = settings.arguments as Worker;
          return MaterialPageRoute(
              builder: (context) => TablesPage(worker: arg));
        }
        if (settings.name == TablePage.route) {
          final arg = settings.arguments as List;
          return MaterialPageRoute(
            builder: (context) => TablePage(
              table: arg.elementAt(0),
              order: arg.elementAt(1),
              worker: arg.elementAt(2),
            ),
          );
        }
        return null;
      },
      home: const SplashPage(),
      // builder: (ctx, child) {
      //   return MediaQuery(
      //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      //     child: child!,
      //   );
      // },
    );
  }
}
