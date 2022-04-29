import 'package:aliposter_waiter/res/style.dart';
import 'package:aliposter_waiter/views/components/open_menu_dialog.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({
    Key? key,
    required this.mediaQuery,
    required this.title,
    required this.connectionStatus,
    required this.currentRoute,
  }) : super(key: key);

  final String currentRoute;
  final MediaQueryData mediaQuery;
  final String title;
  final bool? connectionStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.size.height * .2,
      width: mediaQuery.size.width,
      decoration:  const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding:  const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: Image.asset(
                'assets/images/menu.png',
                height: mediaQuery.size.height * .08,
                width: mediaQuery.size.width * .08,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => openMenuDialog(context, mediaQuery, currentRoute),
                );
              },
            ),
          ),
           const SizedBox(width: 64.0),
          Text(
            title,
            style: AppTextStyle.header4.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (connectionStatus != null)
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                margin:  const EdgeInsets.only(right: 24.0),
                child: Icon(
                  Icons.circle,
                  color: connectionStatus! ? Colors.green : Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
