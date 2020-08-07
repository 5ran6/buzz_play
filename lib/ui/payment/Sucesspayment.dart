import 'package:flutter/material.dart';
import 'package:buzz_play/ui/home/HomeUI.dart';
import 'package:buzz_play/utils/AppConfig.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'EasyListView Demo',
        theme: ThemeData(accentColor: Colors.pinkAccent),
        home: Sucesspayment(),
      );
}

class Sucesspayment extends StatefulWidget {
  @override
  _SucesspaymentState createState() => _SucesspaymentState();
}

class _SucesspaymentState extends State<Sucesspayment> {
  AppConfig _appConfig;

  @override
  Widget build(BuildContext context) {
    _appConfig = new AppConfig(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/cplan/sucesss.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: _appConfig.rHP(68.5),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
              height: _appConfig.rHP(8),
              width: _appConfig.rWP(72),
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(30)),
//                border: Border.all(color: Colors.red),
                  color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
