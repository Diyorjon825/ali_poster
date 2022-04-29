import 'package:aliposter_waiter/model/table.dart';
import 'package:aliposter_waiter/model/worker.dart';
import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:aliposter_waiter/socket/signal_socket.dart';
import 'package:aliposter_waiter/views/pages/table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget onOpenTable(
  BuildContext context,
  TableModel table,
  Worker worker,
) {
  int guestCount = 1;
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Padding(
      // alignment: Alignment.center,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/table.png',
            color: AppColors.green,
          ),
          Text(
            'Открыть стол №${table.tableModelId}',
            style: AppTextStyle.header0.copyWith(
              color: AppColors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            table.hallTitle ?? '',
            style: AppTextStyle.title0.copyWith(
              color: AppColors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            'Количество гостей',
            style: AppTextStyle.title0.copyWith(
              color: AppColors.green,
            ),
          ),
          StatefulBuilder(
              builder: (context, setState) => Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 46.0,
                        onPressed: () {
                          if (guestCount > 1) setState(() => guestCount--);
                        },
                        icon: Ink(
                          height: 128.0,
                          width: 128.0,
                          padding: const EdgeInsets.all(4.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.green,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Container(
                        height: 48.0,
                        width: 96.0,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(color: Colors.black, width: 2.0),
                        ),
                        child: Text(
                          guestCount.toString(),
                          textAlign: TextAlign.center,
                          style: AppTextStyle.header1.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      IconButton(
                          iconSize: 46.0,
                          onPressed: () => setState(() => guestCount++),
                          icon: Ink(
                              height: 128.0,
                              width: 128.0,
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.green,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 24.0,
                                color: Colors.white,
                              )))
                    ],
                  )),
          const SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.green),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              )),
              fixedSize: MaterialStateProperty.all(const Size(250.0, 54.0)),
            ),
            onPressed: () async {
              table.workerFIO = worker.name;
              Provider.of<TableSocket>(context, listen: false).invokeRemoteMethod('SendTableIsBusy', [
                {"TableId": table.tableModelId, "TableMessageType": 1}
              ]);
              // var field = await Provider.of<HttpSocket>(context, listen: false).invokeRemoteMethod('SendTableIsBusy', [{"TableId": table.tableModelId, "TableMessageType": 1}]);
              // if (field) {
              table.total = 0.0;
              table.guestCount = guestCount;
              Navigator.popAndPushNamed(context, TablePage.route, arguments: [table, null, worker]);
              // }
            },
            child: Text(
              'Открыть стол',
              style: AppTextStyle.header0.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
