import 'dart:io';
import 'dart:typed_data';

//import 'package:musicplayer/database/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/musicplayer/flute_music_player.dart';

dynamic getImage(Recentplay song) {
  return  NetworkUtil.BASE_URL1+song.music_image;
}

Widget avatar(context, File f, String title) {
  return new Material(
    borderRadius: new BorderRadius.circular(30.0),
    elevation: 2.0,
    child: f != null
        ? new CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            backgroundImage: new FileImage(
              f,
            ),
          )
        : new CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            child: new Text(title[0].toUpperCase()),
          ),
  );
}
