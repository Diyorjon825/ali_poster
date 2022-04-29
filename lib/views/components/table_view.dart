import 'package:aliposter_waiter/model/table.dart';
import 'package:aliposter_waiter/model/worker.dart';
import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TableView extends StatelessWidget {
  const TableView({
    Key? key,
    required this.onPlayPressed,
    required this.onOpenPressed,
    required this.worker,
    required this.table,
  }) : super(key: key);

  final Worker? worker;
  final TableModel table;
  final VoidCallback? onOpenPressed;
  final VoidCallback? onPlayPressed;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      name: "сум",
      locale: "uz_UZ",
      decimalDigits: 0,
    );
    final mediaQuery = MediaQuery.of(context);

    final canOpen = !table.isBusy &&
        ((worker?.canEditOrderOpenedNotMyself == true) ||
            ((worker?.id == table.createdByWorkerId)));
    return table.hasOrder
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    width: mediaQuery.size.width,
                    decoration: BoxDecoration(
                      color: table.isBusy ? Colors.red : AppColors.green,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/table.png',
                        ),
                        const SizedBox(
                          width: 24.0,
                        ),
                        Text(
                          table.tableTitle,
                          style: AppTextStyle.title0,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 12.0,
                      right: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'счет: ',
                                style: AppTextStyle.header0.copyWith(
                                  color: AppColors.green,
                                ),
                                children: [
                                  TextSpan(
                                    text: formatter.format(table.total),
                                    style: AppTextStyle.header1.copyWith(
                                      color: AppColors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 32.0,
                                      color: AppColors.grey,
                                    ),
                                    Text(
                                      '${table.guestCount} чел',
                                      style: AppTextStyle.label0.copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 24.0),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.no_food,
                                      size: 32.0,
                                      color: AppColors.grey,
                                    ),
                                    SizedBox(
                                      width: 120.0,
                                      child: Text(
                                        table.workerFIO ?? "",
                                        style: AppTextStyle.label0.copyWith(
                                          color: AppColors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          iconSize: 64.0,
                          onPressed: canOpen ? onPlayPressed : null,
                          icon: Icon(
                            Icons.play_circle_filled_rounded,
                            color: canOpen ? AppColors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    width: mediaQuery.size.width,
                    decoration: BoxDecoration(
                      color: table.isOpen ? Colors.red : AppColors.grey,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/table.png',
                        ),
                        const SizedBox(
                          width: 24.0,
                        ),
                        Text(
                          table.tableTitle,
                          style: AppTextStyle.title0,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(128.0, 32.0)),
                        fixedSize:
                            MaterialStateProperty.all(const Size(170.0, 56.0)),
                        maximumSize:
                            MaterialStateProperty.all(const Size(256.0, 64.0)),
                      ),
                      onPressed: onOpenPressed,
                      child: Row(
                        children: [
                          Text(
                            'Открыть стол',
                            style: AppTextStyle.title0.copyWith(
                              color: AppColors.green,
                            ),
                          ),
                          const Icon(
                            Icons.play_arrow,
                            size: 32.0,
                            color: AppColors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
