import 'package:aliposter_waiter/model/order.dart';
import 'package:aliposter_waiter/model/worker.dart';
import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TableOrder extends StatelessWidget {
  const TableOrder(
      {Key? key,
      required this.orderItem,
      required this.onPressed,
      required this.onDelete,
      required this.worker})
      : super(key: key);

  final OrderItem orderItem;
  final VoidCallback onPressed;
  final VoidCallback onDelete;
  final Worker worker;

  @override
  Widget build(BuildContext context) {
    final formatter =
        NumberFormat.currency(locale: 'uz_UZ', name: '', decimalDigits: 0);
    final ondeleteButtonTap = worker.canRemoveOrderItem ? onDelete : null;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(width: 0.1),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FittedBox(
                        child: Text(
                          orderItem.product?.title ?? '',
                          style: AppTextStyle.header0.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${orderItem.count} x ${formatter.format(orderItem.product?.price)}',
                          style: AppTextStyle.title0.copyWith(
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          formatter.format(orderItem.total),
                          style: AppTextStyle.header0.copyWith(
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: ondeleteButtonTap,
                  icon: Icon(
                    Icons.delete_outline,
                    color:
                        (worker.canRemoveOrderItem) ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
