import 'package:calculator/controller/calculator_controller.dart';
import 'package:calculator/widgets/keyboard.dart';
import 'package:calculator/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final CalculatorController _controller = Get.put(CalculatorController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _controller.output.value != '0'
                        ? Text(_controller.output.value,
                            style: kTextStyle(50, Colors.green))
                        : Text(_controller.input.value,
                            style: kTextStyle(50, Colors.blueGrey)),
                    // Text(_controller.output.value,
                    //     style: kTextStyle(30, Colors.black54)),
                  ],
                ),
              ),
            ),
          ),
          Keyboard(),
        ],
      ),
    );
  }
}
