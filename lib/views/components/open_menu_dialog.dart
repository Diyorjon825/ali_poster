import 'package:aliposter_waiter/prefs/prefs.dart';
import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:aliposter_waiter/views/pages/auth.dart';
import 'package:aliposter_waiter/views/pages/menu.dart';
import 'package:aliposter_waiter/views/pages/report.dart';
import 'package:aliposter_waiter/views/pages/tables.dart';
import 'package:flutter/material.dart';

Widget openMenuDialog(
  BuildContext context,
  MediaQueryData mediaQuery,
  String currentRoute,
) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Container(
      padding: const EdgeInsets.all(24.0),
      height: mediaQuery.size.height * .55,
      width: mediaQuery.size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                height: 100.0,
                minWidth: 128.0,
                color: AppColors.green,
                onPressed: () async {
                  final worker = await getWorker();
                  if (currentRoute != TablesPage.route) {
                    // Navigator.removeRoute(context, route);
                    Navigator.popAndPushNamed(context, TablesPage.route, arguments: worker);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/kitchen.png',
                      height: 65.0,
                      width: 65.0,
                    ),
                    Text(
                      'Столы',
                      style: AppTextStyle.label0,
                    ),
                  ],
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                height: 100.0,
                minWidth: 128.0,
                color: AppColors.green,
                onPressed: () {
                  if (currentRoute != MenuPage.route) {
                    Navigator.popAndPushNamed(context, MenuPage.route);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/menu_icon.png',
                      height: 48.0,
                      width: 48.0,
                    ),
                    Text(
                      'Меню',
                      style: AppTextStyle.label0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                height: 100.0,
                minWidth: 128.0,
                color: AppColors.green,
                onPressed: () {
                  Navigator.popAndPushNamed(context, ReportPage.route);
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/money.png',
                      height: 48.0,
                      width: 48.0,
                    ),
                    Text(
                      'Отчеты',
                      style: AppTextStyle.label0,
                    ),
                  ],
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                height: 100.0,
                minWidth: 128.0,
                color: AppColors.green,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 24.0,
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            height: 65.0,
            minWidth: double.infinity,
            color: AppColors.green,
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName(AuthPage.route));
            },
            child: Image.asset(
              'assets/images/lock.png',
              height: 48.0,
              width: 48.0,
            ),
          ),
        ],
      ),
    ),
  );
}
