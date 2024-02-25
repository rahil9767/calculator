import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  dynamic displayText = '0';
  // Calculate the font size based on the length of the displayed number
  double calculateFontSize(String text) {
    if (text.length <= 8) {
      return 100.0; // Default font size
    } else if (text.length <= 12) {
      return 80.0; // Decrease font size for longer numbers
    } else if (text.length <= 16) {
      return 60.0; // Further decrease font size for even longer numbers
    } else {
      return 40.0; // Minimum font size
    }
  }

  Widget calcButton(String buttonText, Color buttonColor, Color textColor) {
    return Container(
      width: 90,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: buttonColor,
      ),
      child: ElevatedButton(
        onPressed: () {
          calculation(buttonText);
        },
        child: Text(
          '$buttonText',
          style: TextStyle(
            fontSize: 35,
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.all(20),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMd().format(DateTime.now());
    String formattedTime = DateFormat.Hm().format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Hello User'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        // Wrap Text widget with Expanded
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '$displayText',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: calculateFontSize(displayText),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    calcButton('AC', Colors.grey, Colors.black),
                    calcButton('+/-', Colors.grey, Colors.black),
                    calcButton('%', Colors.grey, Colors.black),
                    calcButton('/', Colors.amber[700]!, Colors.white),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    calcButton('7', Colors.grey[850]!, Colors.white),
                    calcButton('8', Colors.grey[850]!, Colors.white),
                    calcButton('9', Colors.grey[850]!, Colors.white),
                    calcButton('x', Colors.amber[700]!, Colors.white),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    calcButton('4', Colors.grey[850]!, Colors.white),
                    calcButton('5', Colors.grey[850]!, Colors.white),
                    calcButton('6', Colors.grey[850]!, Colors.white),
                    calcButton('-', Colors.amber[700]!, Colors.white),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    calcButton('1', Colors.grey[850]!, Colors.white),
                    calcButton('2', Colors.grey[850]!, Colors.white),
                    calcButton('3', Colors.grey[850]!, Colors.white),
                    calcButton('+', Colors.amber[700]!, Colors.white),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        calculation('0');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(34, 20, 128, 20),
                        backgroundColor: Colors.grey[850],
                        shape: StadiumBorder(),
                      ),
                      child: const Text(
                        '0',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    calcButton('.', Colors.grey[850]!, Colors.white),
                    calcButton('=', Colors.amber[700]!, Colors.white),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: $formattedDate',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Time: $formattedTime',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                FutureBuilder(
                  future: _getLocation(),
                  builder:
                      (BuildContext context, AsyncSnapshot<Position> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while fetching location
                    } else if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Location:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Latitude: ${snapshot.data!.latitude}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Longitude: ${snapshot.data!.longitude}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error fetching location',
                        style: TextStyle(color: Colors.red),
                      );
                    } else {
                      return Text(
                        'Location: Fetching...',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Position> _getLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  dynamic result = '';
  double numOne = 0;
  double numTwo = 0;
  String operation = '';
  dynamic finalResult = '';
  dynamic preOpr = '';

  void calculation(String buttonText) {
    if (buttonText == 'AC') {
      result = '';
      numOne = 0;
      numTwo = 0;
      finalResult = '0';
      operation = '';
      preOpr = '';
    } else if (buttonText == '+' ||
        buttonText == '-' ||
        buttonText == 'x' ||
        buttonText == '/') {
      if (numOne == 0) {
        numOne = double.parse(result);
      } else {
        numTwo = double.parse(result);
      }
      operation = buttonText;
      result = '';
    } else if (buttonText == '=') {
      numTwo = double.parse(result);
      switch (operation) {
        case '+':
          finalResult = (numOne + numTwo).toString();
          preOpr = '+';
          break;
        case '-':
          finalResult = (numOne - numTwo).toString();
          preOpr = '-';
          break;
        case 'x':
          finalResult = (numOne * numTwo).toString();
          preOpr = 'x';
          break;
        case '/':
          finalResult = (numOne / numTwo).toString();
          preOpr = '/';
          break;
      }
    } else if (buttonText == '%') {
      result = (numOne / 100).toString();
      finalResult = result;
    } else if (buttonText == '.') {
      if (!result.contains('.')) {
        result += '.';
        finalResult = result;
      }
    } else if (buttonText == '+/-') {
      if (result != '') {
        if (result.startsWith('-')) {
          result = result.substring(1);
        } else {
          result = '-' + result;
        }
        finalResult = result;
      }
    } else {
      result += buttonText;
      finalResult = result;
    }

    setState(() {
      displayText = finalResult;
    });
  }
}
