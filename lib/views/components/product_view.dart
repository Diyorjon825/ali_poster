import 'package:aliposter_waiter/model/product.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'uz_UZ', name: 'сум', decimalDigits: 0);
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            product.productPhotos.isEmpty
                ? Image.asset(
                    'assets/images/logo.png',
                    height: 36.0,
                    width: 36.0,
                  )
                : Image.network(
                    product.productPhotos.first.photoPath,
                    height: 36.0,
                    width: 36.0,
                  ),
            const SizedBox(
              width: 24.0,
            ),
            SizedBox(
              width: 200.0,
              child: Text(
                product.title + ((product.remainder ?? 0) > 0 ? '(${product.remainder})' : ''),
                style: AppTextStyle.title0.copyWith(
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Expanded(child: SizedBox()),
            Text(
              currencyFormat.format(product.price),
              style: AppTextStyle.title0.copyWith(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
