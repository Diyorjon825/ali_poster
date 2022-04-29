import 'package:aliposter_waiter/res/style.dart';
import 'package:aliposter_waiter/views/components/open_menu_dialog.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String currentRoute;

  const CustomAppBar({
    Key? key,
    required this.inheritedContext,
    required this.mediaQuery,
    required this.tableId,
    required this.hallTitle,
    required this.workerFIO,
    required this.onPop,
    required this.currentRoute,
  }) : super(key: key);

  final VoidCallback onPop;
  final BuildContext inheritedContext;
  final MediaQueryData mediaQuery;
  final int tableId;
  final String? hallTitle;
  final String? workerFIO;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32.0),
      height: mediaQuery.size.height * .21,
      width: mediaQuery.size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: IconButton(
                  icon: Image.asset(
                    'assets/images/menu.png',
                    height: mediaQuery.size.height * .08,
                    width: mediaQuery.size.width * .08,
                  ),
                  onPressed: () {
                    showDialog(
                      context: inheritedContext,
                      builder: (context) => openMenuDialog(context, mediaQuery, currentRoute),
                    );
                  },
                ),
              ),
              // const SizedBox(width: 64.0),
              Text(
                'Стол №$tableId',
                style: AppTextStyle.header1.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    size: 32.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    onPop();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Text(
            hallTitle ?? '',
            style: AppTextStyle.title2,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/food.png',
                height: 32.0,
                width: 32.0,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                workerFIO ?? '',
                style: AppTextStyle.title0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
