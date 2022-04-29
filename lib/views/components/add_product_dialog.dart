import 'package:aliposter_waiter/model/product.dart';
import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget addProductDialog({
  required BuildContext context,
  required Product product,
  required void Function(double) addProduct,
}) {
  double count = 1;
  final formatter = NumberFormat.currency(name: '', locale: 'uz_UZ', decimalDigits: 0);
  final _countController = TextEditingController(text: count.toString());
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    clipBehavior: Clip.hardEdge,
    child: Container(
      height: 320.0,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              product.productPhotos.isEmpty
                  ? Image.asset(
                      'assets/images/background.jpg',
                      height: 64.0,
                      width: 64.0,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      product.productPhotos.first.photoPath,
                      height: 64.0,
                      width: 64.0,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(
                width: 72.0,
              ),
              Flexible(
                child: Text(
                  product.title,
                  style: AppTextStyle.header0.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatter.format(product.price),
              style: AppTextStyle.header0.copyWith(
                color: AppColors.green,
              ),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          StatefulBuilder(
              builder: (context, setState) => Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 46.0,
                        onPressed: () {
                          if (count > 0.5) {
                            setState(() {
                              count -= 0.5;
                              _countController.text = count.toString();
                            });
                          }
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
                      Container(
                          height: 48.0,
                          width: 96.0,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            border: Border.all(color: Colors.black, width: 2.0),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _countController,
                            style: AppTextStyle.header0.copyWith(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            scrollPadding: EdgeInsets.zero,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 0.0,
                                  top: 0.0,
                                  right: 0.0,
                                  bottom: 12.0,
                                )),
                          )),
                      IconButton(
                          iconSize: 46.0,
                          onPressed: () => setState(() {
                                count += 0.5;
                                _countController.text = count.toString();
                              }),
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
                              ))),
                    ],
                  )),
          const SizedBox(
            height: 24.0,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                height: 54.0,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: AppColors.green,
                child: Text(
                  'Добавить',
                  style: AppTextStyle.title0,
                ),
                onPressed: () {
                  addProduct(count);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
