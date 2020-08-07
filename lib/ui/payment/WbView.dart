import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/payment/Sucesspayment.dart';
import 'package:buzz_play/utils/AppConfig.dart';

class WbView extends StatefulWidget {
  String userid, pkgid, totlprice;

  WbView(@required this.userid, @required this.pkgid, @required this.totlprice);

  @override
  _WbViewState createState() => _WbViewState();
}

class _WbViewState extends State<WbView> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  String selectedUrl =
      'https://appiconmakers.com/demoMusicPlayer/API/getStripePaymentScreen';

  final _history = [];
  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();
    widget.totlprice = widget.totlprice.replaceAll("\$", "");

    selectedUrl = NetworkUtil.BASE_URL +
        "getStripePaymentScreen?user_id=" +
        widget.userid +
        "\&package_id=" +
        widget.pkgid +
        "\&total_package_price=" +
        widget.totlprice;
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');

          if (url == "https://appiconmakers.com/demoMusicPlayer/stripePost") {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (context) => new Sucesspayment()));
          }
        });
      }
    });

//    flutterWebViewPlugin.evalJavascript();
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.

    super.dispose();
    flutterWebViewPlugin.dispose();
  }

  AppConfig _appConfig;

  @override
  Widget build(BuildContext context) {
//    flutterWebViewPlugin.launch(selectedUrl);
    _appConfig = new AppConfig(context);
    return WebviewScaffold(
      url: selectedUrl,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Payment',
                  style: TextStyle(
                      fontSize: _appConfig.rHP(3),
                      color: Colors.black,
                      fontFamily: 'Montserrat'),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
            onPressed: () => Navigator.pop(context, false),
          )),
      withZoom: true,
      withLocalStorage: true,
      withJavascript: true,
      hidden: false,
      initialChild: Container(
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
