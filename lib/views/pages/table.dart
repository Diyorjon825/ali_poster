import 'package:aliposter_waiter/api/api_service.dart';
import 'package:aliposter_waiter/model/category.dart';
import 'package:aliposter_waiter/model/order.dart';
import 'package:aliposter_waiter/model/product.dart';
import 'package:aliposter_waiter/model/table.dart';
import 'package:aliposter_waiter/model/worker.dart';
import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:aliposter_waiter/socket/signal_socket.dart';
import 'package:aliposter_waiter/views/components/add_product_dialog.dart';
import 'package:aliposter_waiter/views/components/app_bar_in_table_page.dart';
import 'package:aliposter_waiter/views/components/edit_product_dialog.dart';
import 'package:aliposter_waiter/views/components/product_view.dart';
import 'package:aliposter_waiter/views/components/status_bar.dart';
import 'package:aliposter_waiter/views/components/table_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TablePage extends StatefulWidget {
  static const route = '/table';

  const TablePage({
    Key? key,
    required this.table,
    this.order,
    required this.worker,
  }) : super(key: key);

  final TableModel table;
  final Order? order;
  final Worker worker;

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final formatter =
      NumberFormat.currency(locale: 'uz_UZ', name: '', decimalDigits: 0);
  final Future _categories = ApiService.getInstance().getCategories();
  List<OrderItem> orderItems = [];
  List<Product> products = [];
  bool _showBottom = true;
  late Order order;

  @override
  void initState() {
    super.initState();
    order = widget.order ??
        Order(
            tableModelId: widget.table.tableModelId,
            guestCount: widget.table.guestCount,
            orderItems: []);
    setState(() => orderItems = order.orderItems);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        Provider.of<TableSocket>(context, listen: false)
            .invokeRemoteMethod("SendMessageTableFromMobile", [
          {"TableId": widget.table.tableModelId, "TableMessageType": 0}
        ]);
        return true;
      },
      child: Stack(
        children: [
          Material(
            child: Column(
              children: [
                CustomAppBar(
                    mediaQuery: mediaQuery,
                    tableId: widget.table.tableModelId,
                    hallTitle: widget.table.hallTitle,
                    workerFIO: widget.table.workerFIO,
                    currentRoute: TablePage.route,
                    inheritedContext: context,
                    onPop: () =>
                        Provider.of<TableSocket>(context, listen: false)
                            .invokeRemoteMethod("SendMessageTableFromMobile", [
                          {
                            "TableId": widget.table.tableModelId,
                            "TableMessageType": 0
                          }
                        ])),
                StatusBar(
                  created: widget.order?.created,
                  guestCount: widget.table.guestCount,
                  total: order.total,
                ),
                SizedBox(
                  height: _showBottom
                      ? mediaQuery.size.height * .3
                      : mediaQuery.size.height * .637,
                  width: mediaQuery.size.width,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) => TableOrder(
                      worker: widget.worker,
                      orderItem: orderItems[index],
                      onDelete: () =>
                          setState(() => orderItems.removeAt(index)),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => editProductDialog(
                          worker: widget.worker,
                          context: context,
                          product: orderItems[index].product!,
                          removeProduct: () =>
                              setState(() => orderItems.removeAt(index)),
                          saveProduct: (double count) => setState(() {
                            orderItems[index].count = count;
                            orderItems[index].workerId = widget.worker.id;
                            orderItems[index].workerPercent =
                                widget.worker.percent.toDouble();
                            order.total = 0.0;
                            order.workerCreateId = widget.worker.id;
                            for (var element in orderItems) {
                              order.total =
                                  (order.total ?? 0.0) + (element.total ?? 0.0);
                            }
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: _categories,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data as List<Category>;
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          color: AppColors.green,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                  height: 48.0,
                                  width: mediaQuery.size.width * .85,
                                  child: DropdownButtonFormField<Category>(
                                    isDense: false,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                        left: 16.0,
                                        top: 0.0,
                                        right: 0.0,
                                        bottom: 0.0,
                                      ),
                                      isDense: false,
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.green),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.green),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.green),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    iconEnabledColor: AppColors.green,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      size: 36.0,
                                    ),
                                    dropdownColor: AppColors.green,
                                    focusColor: Colors.white,
                                    onChanged: (element) => setState(() =>
                                        products = element?.products ?? []),
                                    selectedItemBuilder: (context) => data
                                        .map<DropdownMenuItem<Category>>(
                                            (Category e) => DropdownMenuItem(
                                                child: Text(e.title,
                                                    style: AppTextStyle.title0
                                                        .copyWith(
                                                      color: Colors.black,
                                                    )),
                                                value: e))
                                        .toList(),
                                    items: data
                                        .map<DropdownMenuItem<Category>>(
                                            (Category e) => DropdownMenuItem(
                                                child: Text(e.title,
                                                    style: AppTextStyle.title0
                                                        .copyWith(
                                                      color: Colors.white,
                                                    )),
                                                value: e))
                                        .toList(),
                                  )),
                              IconButton(
                                onPressed: () =>
                                    setState(() => _showBottom = !_showBottom),
                                icon: AnimatedSwitcher(
                                  duration: const Duration(microseconds: 2000),
                                  child: _showBottom
                                      ? const Icon(
                                          Icons.arrow_upward,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.arrow_downward,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
                Visibility(
                  visible: _showBottom,
                  child: LimitedBox(
                    maxHeight: mediaQuery.size.height * .33,
                    maxWidth: mediaQuery.size.width,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 8.0),
                      itemCount: products.length,
                      itemBuilder: (context, index) => GestureDetector(
                        child: ProductView(product: products[index]),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => addProductDialog(
                            context: context,
                            product: products[index],
                            addProduct: (double count) => setState(() {
                              order.id = widget.order?.id ?? 0;
                              order.created ??= DateTime.now();
                              products[index].count = count;
                              orderItems.add(OrderItem(
                                orderId: order.id,
                                created: DateTime.now(),
                                workerId: widget.worker.id,
                                workerPercent: widget.worker.percent.toDouble(),
                                productId: products[index].id,
                                product: products[index],
                                count: count,
                                total: count * products[index].price,
                              ));
                              order.total = 0.0;
                              order.workerCreateId = widget.worker.id;
                              for (var element in orderItems) {
                                order.total = (order.total ?? 0.0) +
                                    (element.total ?? 0.0);
                              }
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // if (!(order.orderItems == orderItems) && orderItems.isNotEmpty)
          Positioned(
            right: 10.0,
            bottom: _showBottom ? 10.0 : 64.0,
            child: FloatingActionButton(
              backgroundColor: AppColors.greenAccent,
              onPressed: () {
                try {
                  if (widget.table.hasOrder) {
                    order.orderItems = orderItems;
                    ApiService.getInstance().updateOrder(order);
                  } else {
                    order.orderItems = orderItems;
                    ApiService.getInstance().createOrder(order);
                  }
                } catch (e) {}
                Provider.of<TableSocket>(context, listen: false)
                    .invokeRemoteMethod('SendMessageTableFromMobile', [
                  {"TableId": widget.table.tableModelId, "TableMessageType": 0}
                ]);
                Navigator.pop(context);
              },
              child: const Icon(Icons.done),
            ),
          ),
        ],
      ),
    );
  }
}
