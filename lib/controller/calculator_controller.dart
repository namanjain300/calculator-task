import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CalculatorController extends GetxController {
  var input = '0'.obs;
  var output = '0'.obs;
  String operator = '';
  double firstNum = 0;
  double secondNum = 0;
  final List<String> inputList = [];
  final storageCalulationKey = 'calculations';
  var isHistory = false.obs;
  List<MapEntry<String, String>> history = [];

  void getHistory() {
    var dataFromMemory = GetStorage().read(storageCalulationKey);
    dataFromMemory as List<MapEntry<String, String>>?;
    if (dataFromMemory != null) {
      history.clear();
      history.addAll(dataFromMemory);
    }
  }

  void onButtonTap(String operation) {
    if (operation != "C" &&
        operation != "=" &&
        operation != "()" &&
        operation != "+/-" &&
        operation != "%") {
      // for every other button except the one's given above
      getOperations(operation);
    }
    if (operation == 'C') {
      clearInput();
    }
    if (operation == '=') {
      calculate();
    }
    if (operation == '+/-') {
      plusOrminus();
    }
    if (operation == '%') {
      percent();
    }
  }

  void getOperations(String operation) {
    if (operation == '+' ||
        operation == '/' ||
        operation == 'x' ||
        operation == '-') {
      if (input.value.contains('-')) {
        final newValue = double.parse(input.value.split('-')[1]);
        clearInput();
        inputList.insert(0, '-');
        inputList.insert(1, newValue.toString());
        concateString();
      }
    }

    if (inputList.contains('+') ||
        inputList.contains('/') ||
        inputList.contains('x')) {
      if (operation == '+' ||
          operation == '/' ||
          operation == 'x' ||
          operation == '-') {
        return;
      } else {
        inputList.add(operation);
        concateString();
      }
    } else if (operation == '.' && inputList.isEmpty) {
      return;
    } else {
      inputList.add(operation);
      concateString();
    }
  }

  void clearInput() {
    inputList.clear();
    input.value = '0';
    output.value = '0';
    concateString();
  }

  void clearLastInput() {
    if (inputList.isNotEmpty) {
      inputList.removeAt(inputList.length - 1);
    }
    if (inputList.isEmpty) {
      input.value = '0';
    }
    concateString();
  }

  void plusOrminus() {
    if (!inputList.contains('-')) {
      inputList.insert(0, '-');
    } else {
      if (inputList[0] == '-') {
        inputList.removeAt(0);
      }
    }
    concateString();
  }

  void percent() {
    if (input.value != '0') {
      final double oldResult = double.parse(input.value);
      clearInput();
      getOperations(oldResult.toString());
      input.value = (oldResult / 100).toString();
    } else {
      firstNum = double.parse(input.value);
      input.value = (firstNum / 100).toString();
    }
  }

  void getOperator() {
    if (inputList[0] != '-') {
      if (input.contains('-')) operator = '-';
    } else if (inputList[0] == '-') {
      for (int i = 1; i < inputList.length; i++) {
        if (inputList[i].contains('-')) operator = '-';
      }
    }
    if (input.contains('+')) operator = '+';
    if (input.contains('/')) operator = '/';
    if (input.contains('x')) operator = 'x';
  }

  void splitInput() {
    getOperator();
    try {
      if (operator == '-' && inputList[0] == '-') {
        firstNum = -double.parse(input.split(operator)[1]);
        secondNum = -double.parse(input.split(operator)[2]);
      } else if (operator != '-' && inputList[0] == '-') {
        firstNum = double.parse(input.split(operator)[0]);
        secondNum = double.parse(input.split(operator)[1]);
      } else if (inputList[0] != '-') {
        firstNum = double.parse(input.split(operator)[0]);
        secondNum = double.parse(input.split(operator)[1]);
      }
    } catch (e) {
      print('DEBUG: Error trying to split $e');
    }
  }

  void calculate() {
    splitInput();

    if (input.value != '0') {
      final String newNum = input.value;
      clearInput();
      getOperations(newNum);
    }

    if (input.contains('+')) {
      try {
        output.value = (firstNum + secondNum).toString();
      } catch (e) {
        print('DEBUG: Calculation error $e');
      }
    }

    if (input.contains('-') && inputList[0] != '-') {
      try {
        output.value = (firstNum - secondNum).toString();
      } catch (e) {
        print('DEBUG: $e');
      }
    }
    if (operator == '-' && inputList[0] == '-') {
      try {
        output.value = (firstNum + secondNum).toString();
      } catch (e) {
        print('DEBUG: $e');
      }
    }
    if (input.contains('/')) {
      try {
        if (secondNum > 0) {
          output.value = (firstNum / secondNum).toStringAsFixed(1);
        } else {
          print('DEBUG: second number is less than zero $secondNum');
        }
      } catch (e) {
        print('DEBUG: Calculation error $e');
      }
    }
    if (input.contains('x')) {
      try {
        output.value = (firstNum * secondNum).toString();
      } catch (e) {
        print('DEBUG: Calculation error $e');
      }
    }
    saveToHistory(input.value, output.value);
  }

  void concateString() {
    input.value = '';
    for (var num in inputList) {
      input.value += num;
    }
  }

  void saveToHistory(String input, String output) {
    MapEntry<String, String> calculation = MapEntry(input, output);
    var dataFromMemory = GetStorage().read(storageCalulationKey);
    dataFromMemory as List<MapEntry<String, String>>?;
    if (dataFromMemory != null) {
      history.addAll(dataFromMemory);
      history.add(calculation);

      GetStorage().write(storageCalulationKey, history);
    } else {
      GetStorage().write(storageCalulationKey, [calculation]);
    }
  }
}
