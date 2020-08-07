import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buzz_play/ui/home/HomeUI.dart';
import 'package:buzz_play/ui/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:video_player/video_player.dart';

class VideoSplashScreen extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<VideoSplashScreen> {
  VideoPlayerController playerController;
  VoidCallback listener;

  @override
  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
    initializeVideo();
    playerController.play();

    ///video ui.splash display only 5 second you can change the duration according to your need
    startTime();
    _onChanged();
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    playerController.setVolume(0.0);
    playerController.removeListener(listener);
    if(isfirst==null)
      {
        isfirst=true;
      }
    if (isfirst) {
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => new Login(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => new HomeUI(),
        ),
      );
    }
    //  Navigator.of(context).pushReplacementNamed('/ui.login');
  }

  void initializeVideo() {
    playerController = VideoPlayerController.asset('assets/video/splash.mp4')
      ..addListener(listener)
      ..setVolume(1.0)
      ..initialize()
      ..play();
  }

  @override
  void deactivate() {
    if (playerController != null) {
      playerController.setVolume(0.0);
      playerController.removeListener(listener);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (playerController != null) playerController.dispose();
    super.dispose();
  }

  bool isfirst = true;
  SharedPreferences sharedPreferences;
String userid;
  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isfirst = sharedPreferences.getBool("isfirst");
    userid = sharedPreferences.getString("setuserid");


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      new AspectRatio(
          aspectRatio: 9 / 16,
          child: Container(
            child: (playerController != null
                ? VideoPlayer(
                    playerController,
                  )
                : Container()),
          )),
    ]));
  }
}
