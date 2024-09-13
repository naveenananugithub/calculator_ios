import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(IOSCalculatorApp());
}

class IOSCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String display = "0";
  String _input = "";
  double _result = 0;
  String _operator = "";
  String _activeOperator = "";

  void _buttonPressed(String value) {
    setState(() {
      if (value == "AC" || value == "C") {
        if (_input.isEmpty) {
          display = "0";
          _input = "";
          _operator = "";
          _result = 0;
          _activeOperator = "";
        } else {
          display = "0";
          _input = "";
          _operator = "";
        }
      } else if (value == "=") {
        if (_input.isNotEmpty) {
          double numInput = double.parse(_input);
          switch (_operator) {
            case "+":
              _result += numInput;
              break;
            case "-":
              _result -= numInput;
              break;
            case "×":
              _result *= numInput;
              break;
            case "÷":
              if (numInput != 0) {
                _result /= numInput;
              } else {
                display = "Error";
                _input = "";
                _operator = "";
                return;
              }
              break;
          }
          display = _formatNumber(_result);
          _input = "";
          _operator = "";
          _activeOperator = "";
        }
      } else if (value == "%") {
        if (_input.isNotEmpty) {
          double numInput = double.parse(_input);
          _input = (numInput / 100).toString();
          display = _formatNumber(double.parse(_input));
        }
      } else if (value == "+/-") {
        if (_input.isNotEmpty) {
          double numInput = double.parse(_input);
          _input = (-numInput).toString();
          display = _input;
        }
      } else if ("÷×+-".contains(value)) {
        if (_input.isNotEmpty) {
          _result = double.parse(_input);
          _input = "";
        }
        _operator = value;
        _activeOperator = value;
      } else {
        if (_input == "0") {
          _input = value;
        } else {
          _input += value;
        }
        display = _input;
      }
    });
  }

  String _formatNumber(double number) {
    final formatter = NumberFormat("#,##0.########", "en_US");
    return formatter.format(number);
  }

  Widget _buildButton(String text,
      {Color textColor = CupertinoColors.white,
      Color bgColor = CupertinoColors.darkBackgroundGray,
      double width = 70.0,
      AlignmentGeometry alignment = Alignment.center,
      bool isHighlighted = false}) {
    return Expanded(
      flex: (text == "0") ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.white : bgColor,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: CupertinoButton(
            padding: EdgeInsets.all(20.0),
            onPressed: () {
              _buttonPressed(text);
              if ("÷×+-".contains(text)) {
                setState(() {
                  _activeOperator = text;
                });
              }
            },
            child: Align(
              alignment: alignment,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 32.0,
                  color: isHighlighted ? Color(0xFFf39c12) : textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black.withOpacity(0.7),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Result Display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.bottomRight,
                child: Text(
                  display,
                  style: TextStyle(
                    fontSize: 60, // Adjust font size for result
                    fontWeight: FontWeight.w300,
                    color: CupertinoColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Keypad
              _buildRow([
                _input.isEmpty ? "AC" : "C",
                "+/-",
                "%",
                "÷"
              ], [
                Color(0xFFa5a5a5),
                Color(0xFFa5a5a5),
                Color(0xFFa5a5a5),
                Color(0xFFf39c12)
              ], [
                Colors.black,
                Colors.black,
                Colors.black,
                _activeOperator == "÷" ? Color(0xFFf39c12) : Colors.white
              ]),
              _buildRow([
                "7",
                "8",
                "9",
                "×"
              ], [
                Color(0xFF333333),
                Color(0xFF333333),
                Color(0xFF333333),
                Color(0xFFf39c12)
              ], [
                Colors.white,
                Colors.white,
                Colors.white,
                _activeOperator == "×" ? Color(0xFFf39c12) : Colors.white
              ]),
              _buildRow([
                "4",
                "5",
                "6",
                "-"
              ], [
                Color(0xFF333333),
                Color(0xFF333333),
                Color(0xFF333333),
                Color(0xFFf39c12)
              ], [
                Colors.white,
                Colors.white,
                Colors.white,
                _activeOperator == "-" ? Color(0xFFf39c12) : Colors.white
              ]),
              _buildRow([
                "1",
                "2",
                "3",
                "+"
              ], [
                Color(0xFF333333),
                Color(0xFF333333),
                Color(0xFF333333),
                Color(0xFFf39c12)
              ], [
                Colors.white,
                Colors.white,
                Colors.white,
                _activeOperator == "+" ? Color(0xFFf39c12) : Colors.white
              ]),
              _buildRow(
                  ["0", ".", "="],
                  [Color(0xFF333333), Color(0xFF333333), Color(0xFFf39c12)],
                  [Colors.white, Colors.white, Colors.white],
                  lastRow: true,
                  alignments: [
                    Alignment.centerLeft,
                    Alignment.center,
                    Alignment.center
                  ],
                  highlightButtons: [false, false, false]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRow(
      List<String> buttons, List<Color> bgColors, List<Color> textColors,
      {bool lastRow = false,
      List<AlignmentGeometry>? alignments,
      List<bool>? highlightButtons}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((text) {
        return _buildButton(
          text,
          textColor: textColors[buttons.indexOf(text)],
          bgColor: bgColors[buttons.indexOf(text)],
          alignment: alignments != null
              ? alignments[buttons.indexOf(text)]
              : Alignment.center,
          isHighlighted: text == _activeOperator,
        );
      }).toList(),
    );
  }
}
