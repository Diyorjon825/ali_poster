import 'package:aliposter_waiter/api/api_service.dart';
import 'package:aliposter_waiter/prefs/prefs.dart';
import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:aliposter_waiter/socket/signal_socket.dart';
import 'package:aliposter_waiter/views/pages/tables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const route = '/auth';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _pinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    const defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 24.0,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2.0, color: Colors.white),
        ),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: const Border(
        bottom: BorderSide(width: 2.0, color: Colors.white),
      ),
    );
    final submittedPinTheme =
        defaultPinTheme.copyWith(decoration: defaultPinTheme.decoration);
    return ScaffoldMessenger(
      child: SafeArea(
        child: Scaffold(
          body: Container(
            constraints: BoxConstraints(
              minHeight: 0.0,
              minWidth: 0.0,
              maxHeight: mediaQuery.size.height,
              maxWidth: mediaQuery.size.width,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 32.0,
                ),
                Image.asset(
                  'assets/images/AP.png',
                  height: 84.0,
                  width: 256.0,
                ),
                Text(
                  'Вход в систему',
                  style: AppTextStyle.title0,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Введите свой персональный код доступа',
                  style: AppTextStyle.label0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Builder(
                    builder: (context) => Pinput(
                          showCursor: true,
                          controller: _pinController,
                          keyboardType: TextInputType.none,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          onCompleted: (pin) async {
                            final ip = await getAddress();
                            final port = await getPort();
                            if (ip != null &&
                                ip != "" &&
                                port != null &&
                                port != "") {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Dialog(
                                  child: SizedBox(
                                    height: 200.0,
                                    width: 100.0,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ),
                              );
                              ApiService.getInstance()
                                  .auth(pin)
                                  .then((response) async {
                                Navigator.pop(context);
                                if (response != null) {
                                  _pinController.clear();
                                  print("1) ${context != null}");
                                  Navigator.of(context).pushNamed(
                                      TablesPage.route,
                                      arguments: response);
                                } else if (await Vibrate.canVibrate) {
                                  _pinController.clear();
                                  await Vibrate.vibrate();
                                }
                              }).catchError((error) async {
                                Navigator.pop(context);
                                _pinController.clear();
                                if (await Vibrate.canVibrate) {
                                  await Vibrate.vibrate();
                                }
                                print("2) ${context != null}");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Произошла ошибка при подключении!")));
                              });
                            } else {
                              print("3) ${context != null}");
                              _pinController.clear();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: const Duration(seconds: 2),
                                content: Text("Нету IP и порта",
                                    style: AppTextStyle.title0
                                        .copyWith(color: Colors.white)),
                                backgroundColor: Colors.black,
                              ));
                            }
                          },
                        )),
                const SizedBox(height: 16.0),
                _pinCodeButtons(mediaQuery),
                _bottomPart(context, mediaQuery),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomPart(
    BuildContext context,
    MediaQueryData mediaQuery,
  ) {
    String ip = '', port = '';
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: TextButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            minimumSize: MaterialStateProperty.all(const Size(64.0, 32.0)),
            maximumSize: MaterialStateProperty.all(const Size(512.0, 64.0)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))),
          ),
          label: Text(
            'Настройка сервера',
            style: AppTextStyle.title0.copyWith(
              color: AppColors.greenAccent,
            ),
          ),
          icon: const Icon(
            Icons.settings,
            color: AppColors.greenAccent,
          ),
          onPressed: () => showDialog(
            useRootNavigator: false,
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                height: mediaQuery.size.height * .51,
                width: mediaQuery.size.width,
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.settings,
                        color: Colors.green,
                      ),
                      Text(
                        'Настройка сервера',
                        style: AppTextStyle.title2.copyWith(
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 4.0,
                        ),
                        child: Text(
                          'IP адрес сервера',
                          style: AppTextStyle.title0.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      TextFormField(
                        style:
                            AppTextStyle.title0.copyWith(color: Colors.black),
                        cursorColor: AppColors.greenAccent,
                        textAlign: TextAlign.center,
                        onChanged: (value) => ip = value,
                        decoration: InputDecoration(
                          fillColor: Colors.green,
                          // labelText: ,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide:
                                const BorderSide(color: AppColors.greenAccent),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide:
                                const BorderSide(color: Colors.redAccent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide:
                                const BorderSide(color: AppColors.greenAccent),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 4.0,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Порт сервера',
                          style: AppTextStyle.title0.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      TextFormField(
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        cursorColor: AppColors.greenAccent,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.title0.copyWith(
                          color: Colors.black,
                        ),
                        onChanged: (value) => port = value,
                        decoration: InputDecoration(
                          counter: const SizedBox(),
                          fillColor: AppColors.greenAccent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide:
                                const BorderSide(color: Colors.redAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide:
                                const BorderSide(color: AppColors.greenAccent),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     await insertAddress(ip);
                      //     await insertPort(port);
                      //     Provider.of<TableSocket>(context, listen: false)
                      //         .connect();
                      //     Navigator.pop(context);
                      //     print("fuck");
                      //   },
                      //   child: Text(
                      //     'Сохранить',
                      //     style: AppTextStyle.title0.copyWith(
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      // ),
                      MaterialButton(
                        height: 64.0,
                        minWidth: mediaQuery.size.width,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        color: AppColors.greenAccent,
                        child: Text(
                          'Сохранить',
                          style: AppTextStyle.title0.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () async {
                          await insertAddress(ip);
                          await insertPort(port);
                          Provider.of<TableSocket>(context, listen: false)
                              .connect();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pinCodeButtons(MediaQueryData mediaQuery) => Container(
        padding: const EdgeInsets.all(24.0),
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * .6,
          maxWidth: mediaQuery.size.width,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () {
                    if (_pinController.text.length <= 4)
                      _pinController.text += '1';
                  },
                  child: Text(
                    '1',
                    style:
                        AppTextStyle.header2.copyWith(color: AppColors.green),
                  ),
                  color: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
                MaterialButton(
                  child: Text(
                    '2',
                    style:
                        AppTextStyle.header2.copyWith(color: AppColors.green),
                  ),
                  onPressed: () {
                    if (_pinController.text.length <= 4)
                      _pinController.text += '2';
                  },
                  color: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
                MaterialButton(
                  child: Text(
                    '3',
                    style:
                        AppTextStyle.header2.copyWith(color: AppColors.green),
                  ),
                  onPressed: () {
                    if (_pinController.text.length <= 4)
                      _pinController.text += '3';
                  },
                  color: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  child: Text(
                    '4',
                    style: AppTextStyle.header2.copyWith(
                      color: AppColors.green,
                    ),
                  ),
                  onPressed: () {
                    if (_pinController.text.length <= 4)
                      _pinController.text += '4';
                  },
                  color: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
                MaterialButton(
                  child: Text(
                    '5',
                    style:
                        AppTextStyle.header2.copyWith(color: AppColors.green),
                  ),
                  onPressed: () {
                    if (_pinController.text.length <= 4)
                      _pinController.text += '5';
                  },
                  color: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
                MaterialButton(
                  child: Text(
                    '6',
                    style:
                        AppTextStyle.header2.copyWith(color: AppColors.green),
                  ),
                  onPressed: () {
                    if (_pinController.text.length <= 4)
                      _pinController.text += '6';
                  },
                  color: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  child: Text(
                    '7',
                    style:
                        AppTextStyle.header2.copyWith(color: AppColors.green),
                  ),
                  onPressed: () {
                    if (_pinController.text.length <= 4)
                      _pinController.text += '7';
                  },
                  color: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
                MaterialButton(
                  child: Text(
                    '8',
                    style:
                        AppTextStyle.header2.copyWith(color: AppColors.green),
                  ),
                  onPressed: () {
                    if (_pinController.text.length <= 4)
                      _pinController.text += '8';
                  },
                  color: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
                MaterialButton(
                  child: Text(
                    '9',
                    style:
                        AppTextStyle.header2.copyWith(color: AppColors.green),
                  ),
                  onPressed: () {
                    if (_pinController.text.length <= 4)
                      _pinController.text += '9';
                  },
                  color: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                child: Text(
                  '0',
                  style: AppTextStyle.header2.copyWith(color: AppColors.green),
                ),
                onPressed: () {
                  if (_pinController.text.length <= 4)
                    _pinController.text += '0';
                },
                color: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16.0),
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
            ),
          ],
        ),
      );
}
