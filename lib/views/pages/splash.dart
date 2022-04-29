import 'dart:async';

import 'package:aliposter_waiter/res/style.dart';
import 'package:aliposter_waiter/views/pages/auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static const route = '/splash';

   const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () => Navigator.popAndPushNamed(context, AuthPage.route));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.fill,
            height: mediaQuery.size.height,
            width: mediaQuery.size.width,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               const SizedBox(
                height: 108.0,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 256.0,
                width: 256.0,
                fit: BoxFit.cover,
              ),
              Text(
                'ALIPOSTER',
                style: AppTextStyle.header3,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/poweredby.png',
                    height: 84.0,
                    width: 108.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
