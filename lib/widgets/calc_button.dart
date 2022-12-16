import 'package:calculator/constants/constants.dart';
import 'package:calculator/controller/calculator_controller.dart';
import 'package:calculator/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalcButton extends StatelessWidget {
  CalcButton({Key? key, required this.index}) : super(key: key);

  final int index;
  final CalculatorController _controller = Get.find<CalculatorController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: index == 19
            ? greenColor
            : Get.isDarkMode
                ? colorBlueDark
                : colorGrey,
      ),
      child: Center(
        child: Text(
          operationString[index]!.toString(),
          style: TextStyle(
              color: getButtonTextColor(index),
              fontSize: getSize(index),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Color getButtonTextColor(int index) {
    if (index == 0) return orangeColor;
    if ((index > 0 && index < 4) || index == 7 || index == 11 || index == 15) {
      return greenColor;
    }
    return Get.isDarkMode ? Colors.white : Colors.black;
  }

  double getSize(int index) {
    if (index == 7 || index == 11 || index == 15 || index == 19) return 40;
    return 30;
  }
}
