import 'package:calculator/constants/constants.dart';
import 'package:calculator/controller/calculator_controller.dart';
import 'package:calculator/theme_service.dart';
import 'package:calculator/widgets/calc_button.dart';
import 'package:calculator/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Keyboard extends StatelessWidget {
  Keyboard({
    Key? key,
  }) : super(key: key);

  final CalculatorController _controller = Get.find<CalculatorController>();

  @override
  Widget build(BuildContext context) {
    // _controller.getHistory();
    // _controller.checkTheme();
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildBtn(
                onTap: () {
                  _controller.getHistory();
                  _controller.isHistory.value = !_controller.isHistory.value;
                },
                color: Get.isDarkMode ? colorBlueDark : colorGrey,
                icon: Icon(
                  Icons.history,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              // Change themes
              buildBtn(
                onTap: () => ThemeService().switchTheme(),
                color: Get.isDarkMode ? colorBlueDark : Colors.orange.shade100,
                icon: Icon(
                  Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Get.isDarkMode ? Colors.blue.shade700 : orangeColor,
                ),
              ),
              Expanded(child: Container()),
              IconButton(
                icon: const Icon(Icons.backspace_outlined),
                onPressed: () {},
              )
            ],
          ),
        ),
        Obx(() => SizedBox(
              height: Get.height * 0.56,
              width: double.infinity,
              child: _controller.isHistory.value
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          _controller.history.isNotEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: _controller.history
                                      .map(
                                        (e) => Column(
                                          children: [
                                            Text(e.key,
                                                style: kTextStyle(
                                                    24, Colors.blueGrey)),
                                            Text(e.value,
                                                style: kTextStyle(
                                                    28, Colors.green)),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                )
                              : Center(
                                  child: Text('No History',
                                      style: kTextStyle(22, Colors.blueGrey)),
                                )
                        ],
                      ),
                    )
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: operationString.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () {
                            _controller
                                .onButtonTap(operationString[index].toString());
                          },
                          child: CalcButton(index: index),
                        );
                      },
                    ),
            )),
      ],
    );
  }

  InkWell buildBtn(
      {required Color color,
      required Widget icon,
      required Function()? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40), color: color),
        child: icon,
      ),
    );
  }
}
