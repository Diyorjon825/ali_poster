import 'package:aliposter_waiter/res/color.dart';
import 'package:aliposter_waiter/res/style.dart';
import 'package:flutter/material.dart';

class TabView extends StatelessWidget {
  const TabView({
    Key? key,
    required this.title,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              title,
              style: AppTextStyle.label1.copyWith(
                color: AppColors.green,
                fontWeight: FontWeight.w800,
              ),
            ))
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Colors.white, width: 2.0),
            ),
            child: Text(
              title,
              style: AppTextStyle.label1.copyWith(fontWeight: FontWeight.w800),
            ));
  }
}
