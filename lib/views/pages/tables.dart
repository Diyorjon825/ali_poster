import 'package:aliposter_waiter/api/api_service.dart';
import 'package:aliposter_waiter/model/hall.dart';
import 'package:aliposter_waiter/model/table.dart';
import 'package:aliposter_waiter/model/table_message.dart';
import 'package:aliposter_waiter/model/worker.dart';
import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/socket/signal_socket.dart';
import 'package:aliposter_waiter/views/components/app_bar.dart';
import 'package:aliposter_waiter/views/components/on_open_table.dart';
import 'package:aliposter_waiter/views/components/tab.dart';
import 'package:aliposter_waiter/views/components/table_view.dart';
import 'package:aliposter_waiter/views/pages/table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({
    Key? key,
    required this.worker,
  }) : super(key: key);

  static const route = '/home';

  final Worker worker;

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  List<TableModel> tables = [];
  List<Hall> halls = [];

  // Stream<int?>? _connectionStateStream = Stream.value(0);

  // final void Function(Hall) onHallSelected;
  List<bool> isSelected = List.filled(1000, false);

  @override
  void initState() {
    ApiService.getInstance()
        .getHalls()
        .then((value) => setState(() => halls = value));
    Provider.of<TableSocket>(
      context,
      listen: false,
    ).hubConnection.on("OrderCancelOrComplete", (arguments) {
      final receivedTable =
          CancelOrCompleteOrderMessage.fromJson(arguments!.first as Map);
      for (var elementHigher in halls) {
        for (var element in elementHigher.tableModels) {
          if (element.tableModelId == receivedTable.tableId) {
            setState(() {
              element.orderId = 0;
              element.workerFIO = "";
              element.hasOrder = false;
              element.guestCount = 0;
              element.isBusy = false;
              element.orderItemsCount = 0;
              element.orderNumber = "";
              element.total = 0.0;
            });
            break;
          }
        }
      }
    });
    Provider.of<TableSocket>(
      context,
      listen: false,
    ).hubConnection.on("RecieveSwapTable", (arguments) {
      final swapObject = SwapModel.fromJson(arguments!.first as Map);
      int? fromTableHallIndex;
      int? fromTableTableIndex;
      int? toTableHallIndex;
      int? toTableTableIndex;
      for (int i = 0; i < halls.length; i++) {
        for (int j = 0; j < halls[i].tableModels.length; j++) {
          if (halls[i].tableModels[j].tableModelId == swapObject.toTableId) {
            toTableHallIndex = i;
            toTableTableIndex = j;
          }
          if (halls[i].tableModels[j].tableModelId == swapObject.fromTableId) {
            fromTableHallIndex = i;
            fromTableTableIndex = j;
          }
        }
      }
      if (fromTableTableIndex != null &&
          fromTableHallIndex != null &&
          toTableTableIndex != null &&
          toTableHallIndex != null) {
        // var to = halls[toTableHallIndex].tableModels[toTableTableIndex];
        var from = halls[fromTableHallIndex].tableModels[fromTableTableIndex];
        setState(() {
          halls[toTableHallIndex!].tableModels[toTableTableIndex!].orderId =
              from.orderId;
          halls[toTableHallIndex].tableModels[toTableTableIndex].workerFIO =
              from.workerFIO;
          halls[toTableHallIndex].tableModels[toTableTableIndex].hasOrder =
              from.hasOrder;
          halls[toTableHallIndex].tableModels[toTableTableIndex].guestCount =
              from.guestCount;
          halls[toTableHallIndex].tableModels[toTableTableIndex].isBusy =
              from.isBusy;
          halls[toTableHallIndex]
              .tableModels[toTableTableIndex]
              .orderItemsCount = from.orderItemsCount;
          halls[toTableHallIndex].tableModels[toTableTableIndex].orderNumber =
              from.orderNumber;
          halls[toTableHallIndex].tableModels[toTableTableIndex].total =
              from.total;

          halls[fromTableHallIndex!].tableModels[fromTableTableIndex!].orderId =
              0;
          halls[fromTableHallIndex].tableModels[fromTableTableIndex].workerFIO =
              "";
          halls[fromTableHallIndex].tableModels[fromTableTableIndex].hasOrder =
              false;
          halls[fromTableHallIndex]
              .tableModels[fromTableTableIndex]
              .guestCount = 0;
          halls[fromTableHallIndex].tableModels[fromTableTableIndex].isBusy =
              false;
          halls[fromTableHallIndex]
              .tableModels[fromTableTableIndex]
              .orderItemsCount = 0;
          halls[fromTableHallIndex]
              .tableModels[fromTableTableIndex]
              .orderNumber = "";
          halls[fromTableHallIndex].tableModels[fromTableTableIndex].total =
              0.0;
        });
      }
    });
    Provider.of<TableSocket>(
      context,
      listen: false,
    ).hubConnection.on("RecieveTableMessage", (arguments) async {
      final receivedTable = TableMessage.fromJson(arguments!.first as Map);
      if (!receivedTable.isBusy) {
        final TableModel activeOrder = await ApiService.getInstance()
            .getTableWithActiveOrders(receivedTable.id);
        for (var elementHigher in halls) {
          for (var element in elementHigher.tableModels) {
            if (element.tableModelId == receivedTable.id) {
              setState(() {
                // element = activeOrder;
                element.isOpen = receivedTable.type == 0 ? false : true;
                element.isBusy = activeOrder.isBusy;
                element.orderId = activeOrder.orderId;
                element.hasOrder = activeOrder.hasOrder;
                element.guestCount = activeOrder.guestCount;
                element.total = activeOrder.total;
                element.created = activeOrder.created;
                element.workerFIO = activeOrder.workerFIO;
              });
              break;
            }
          }
        }
      } else {
        for (var elementHigher in halls) {
          for (var element in elementHigher.tableModels) {
            if (element.tableModelId == receivedTable.id) {
              setState(() =>
                  element.isOpen = receivedTable.type == 0 ? false : true);
              break;
            }
          }
        }
      }
    });
    ApiService.getInstance()
        .getHalls()
        .then((value) => setState(() => halls = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    print(
        "connection state: ${Provider.of<TableSocket>(context).hubConnection.state}");
    return Material(
      child: Column(
        children: [
          DefaultAppBar(
            title: 'Столы',
            mediaQuery: mediaQuery,
            connectionStatus: (Provider.of<TableSocket>(context)
                        .hubConnection
                        .state !=
                    null &&
                Provider.of<TableSocket>(context).hubConnection.state!.index ==
                    2),
            currentRoute: TablesPage.route,
          ),
          // ),
          Container(
            color: AppColors.green,
            height: mediaQuery.size.height * .08,
            width: mediaQuery.size.width,
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              scrollDirection: Axis.horizontal,
              itemCount: halls.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => setState(() {
                  isSelected = List.filled(1000, false);
                  isSelected[index] = true;
                  tables = halls[index].tableModels;
                  for (var element in tables) {
                    element.hallTitle = halls[index].title;
                  }
                }),
                child: TabView(
                  title: halls[index].title,
                  isSelected: isSelected[index],
                ),
              ),
            ),
          ),
          LimitedBox(
            maxHeight: mediaQuery.size.height * .7,
            child: ListView.builder(
              itemCount: tables.length,
              itemBuilder: (context, index) => TableView(
                table: tables[index],
                worker: widget.worker,
                onPlayPressed: () async {
                  Provider.of<TableSocket>(context, listen: false)
                      .invokeRemoteMethod('SendMessageTableFromMobile', [
                    {
                      "TableId": tables[index].tableModelId,
                      "TableMessageType": 1
                    }
                  ]);
                  var order = await ApiService.getInstance()
                      .getOrderForTable(tables[index].orderId!);
                  Navigator.of(context).pushNamed(TablePage.route,
                      arguments: [tables[index], order, widget.worker]);
                },
                onOpenPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      onOpenTable(context, tables[index], widget.worker),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
