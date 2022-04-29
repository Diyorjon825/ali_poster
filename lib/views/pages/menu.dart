import 'package:aliposter_waiter/api/api_service.dart';
import 'package:aliposter_waiter/model/category.dart';
import 'package:aliposter_waiter/model/product.dart';
import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:aliposter_waiter/socket/signal_socket.dart';
import 'package:aliposter_waiter/views/components/app_bar.dart';
import 'package:aliposter_waiter/views/components/product_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  static const route = '/menu';

  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Future _categories = ApiService.getInstance().getCategories();
  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Material(
      child: Column(
        children: [
          DefaultAppBar(
            title: 'Меню',
            mediaQuery: mediaQuery,
            connectionStatus: (Provider.of<TableSocket>(context).hubConnection.state != null &&
                Provider.of<TableSocket>(context).hubConnection.state!.index == 2),
            currentRoute: MenuPage.route,
          ),
          FutureBuilder(
              future: _categories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data as List<Category>;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    color: AppColors.green,
                    width: mediaQuery.size.width,
                    child: SizedBox(
                        height: 48.0,
                        width: mediaQuery.size.width * .8,
                        child: DropdownButtonFormField<Category>(
                          isDense: false,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 16.0, top: 0.0, right: 0.0, bottom: 0.0),
                            isDense: false,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.green),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.green),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.green),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          iconEnabledColor: AppColors.green,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            size: 36.0,
                          ),
                          dropdownColor: AppColors.green,
                          focusColor: Colors.white,
                          onChanged: (element) => setState(() => products = element?.products ?? []),
                          selectedItemBuilder: (context) => data
                              .map<DropdownMenuItem<Category>>((Category e) => DropdownMenuItem(
                                  child: Text(e.title,
                                      style: AppTextStyle.title0.copyWith(
                                        color: Colors.black,
                                      )),
                                  value: e))
                              .toList(),
                          items: data
                              .map<DropdownMenuItem<Category>>((Category e) => DropdownMenuItem(
                                  child: Text(e.title,
                                      style: AppTextStyle.title0.copyWith(
                                        color: Colors.white,
                                      )),
                                  value: e))
                              .toList(),
                        )),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
          LimitedBox(
            maxHeight: mediaQuery.size.height * .7,
            maxWidth: mediaQuery.size.width,
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 8.0,
                right: 16.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) => ProductView(product: products[index]),
            ),
          ),
        ],
      ),
    );
  }
}
