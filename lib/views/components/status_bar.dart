import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    Key? key,
    required this.created,
    required this.guestCount,
    required this.total,
  }) : super(key: key);

  final DateTime? created;
  final int guestCount;
  final double? total;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(name: '', locale: 'uz_UZ', decimalDigits: 0);
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: AppColors.green,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${created?.day != null ? (created!.day < 10 ? '0' + created!.day.toString() : created!.day) : 0}.${created?.month != null ? (created!.month < 10 ? '0' + created!.month.toString() : created!.month.toString()) : 0} /'
                  ' ${created?.hour != null ? (created!.hour < 10 ? '0' + created!.hour.toString() : created!.hour) : 0}:${created?.minute != null ? (created!.minute < 10 ? '0' + created!.minute.toString() : created!.minute) : 0}',
                  style: AppTextStyle.title0,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            color: AppColors.green,
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  '$guestCount чел',
                  style: AppTextStyle.title0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.money),
                  const SizedBox(width: 4.0),
                  Text(
                    formatter.format(total ?? 0.0),
                    style: AppTextStyle.title0.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
