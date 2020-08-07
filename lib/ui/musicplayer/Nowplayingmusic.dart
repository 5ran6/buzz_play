import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/Myownplaylist.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/payment/Choesplan.dart';
import 'package:buzz_play/utils/AppConfig.dart';
import 'package:buzz_play/ui/albumdetails/AlbumScreen.dart';
import 'package:buzz_play/utils/Dialogs.dart';
import 'package:buzz_play/utils/utility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:progress_dialog/progress_dialog.dart';

enum PlayerState { stopped, playing, paused }

class NowPlaying extends StatefulWidget {
  int mode;
  List<Recentplay> songs;
  int index;

  NowPlaying(this.songs, this.index, this.mode);

  @override
  State<StatefulWidget> createState() {
    return new _stateNowPlaying();
  }
}

class _stateNowPlaying extends State<NowPlaying>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Duration duration;
  Duration position;
  bool isPlaying = false;
  int islike = 0;
  Recentplay song;
  int isfav;
  Orientation orientation;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  bool isOpened = true;
  String status = 'hidden';
  Animation<double> _animateIcon;

  Animation<double> animation;
  TextStyle boldtextStyle;

  TextStyle regulartextstyle;

  TextStyle countmusiccountstyle;

  TextStyle regular2textstyle;

  TextStyle unselectd;

  TextStyle recnttexttitle;
  bool _permissionReady;
  TextStyle recnttextview;
  NetworkUtil networkUtil;

  @override
  void initState() {
    super.initState();

    networkUtil = new NetworkUtil();

    song = widget.songs[widget.index];
    this.isLocal = false;
    this.mode = PlayerMode.MEDIA_PLAYER;
    url = NetworkUtil.BASE_URL1 + song.music_file;
    islike = song.is_liked;

    print(url);

    _checkPermission().then((hasGranted) {
      setState(() {
        _permissionReady = hasGranted;
      });
    });

    _initAudioPlayer();
    getownplaylist();
//    _play();
//    initAnim();
//    initPlayer();
//
    /* MediaNotification.setListener('pause', () {
      _play();
    });

    MediaNotification.setListener('play', () {
      _pause();
    });

 */ /*   MediaNotification.setListener('next', () {
      ();
    });

    MediaNotification.setListener('prev', () {
      prev();
    });*/ /*

    MediaNotification.setListener('select', () {
      // yet to be impl
    });*/
  }

  List<USerplaylistItem> userplaylist = new List();

  void getownplaylist() async {
    //  Dialogs.showLoadingDialog(context, _keyLoader);//inv
    await networkUtil.ownplaylist(NetworkUtil.userid).then((value) {
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
//          .pop();
    });
//    registers=NetworkUtil.rregisters;
    await networkUtil.isdownad(NetworkUtil.userid);
    userplaylist = USerplaylist.userplaylistLIst;

    setState(() {
      print(userplaylist[0].user_playlist_name);
      Fluttertoast.showToast(
          msg: "Create Playlist done!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1);
    });
  }

  Future<void> hide() async {
    try {
      await MediaNotification.hideNotification();
      setState(() => status = 'hidden');
    } on PlatformException {}
  }

  Future<void> show(title, author) async {
    try {
      await MediaNotification.showNotification(title: title, author: author);
      setState(() => status = 'play');
    } on PlatformException {}
  }

  initAnim() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.purpleAccent[700],
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
  }

  animateForward() {
    _animationController.forward();
  }

  animateReverse() {
    _animationController.reverse();
  }

  @override
  void dispose() async {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
    await MediaNotification.hideNotification();
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // set atleast title to see the notification bar on ios.
        /*  _audioPlayer.setNotification(
            title: 'App Name',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));*/
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _play();
  }

  Future<int> _play() async {
//    Dialogs.showLoadingDialog(context, _keyLoader);
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result =
        await _audioPlayer.play(url, isLocal: isLocal, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    isplay = true;

    // TODO implemented for iOS, waiting for android impl
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // default playback rate is 1.0
      // this should be called after _audioPlayer.play() or _audioPlayer.resume()
      // this can also be called everytime the user wants to change playback rate in the UI
//      _audioPlayer.setPlaybackRate(playbackRate: 1.0);
    }

//    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1)
      setState(() {
        _playerState = PlayerState.paused;

        isplay = false;
      });

    return result;
  }

  ProgressDialog pr;

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);

    if (widget.index < widget.songs.length)
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) =>
              new NowPlaying(widget.songs, widget.index + 1, 1)));
  }

  bool isshuffle = false;

  List<Recentplay> re = new List();

  void shuffllist() {
    if (isshuffle) {
      isshuffle = false;
    } else {
      isshuffle = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    _appConfig = new AppConfig(context);

    boldtextStyle = TextStyle(
        fontSize: _appConfig.rWP(5),
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat');

    regulartextstyle = TextStyle(
        fontSize: _appConfig.rWP(1),
        fontWeight: FontWeight.w400,
        fontFamily: 'Montserrat');

    countmusiccountstyle = TextStyle(
      fontSize: _appConfig.rWP(3),
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
      color: Colors.black,
    );

    regular2textstyle = TextStyle(
        fontSize: _appConfig.rWP(4),
        fontWeight: FontWeight.w900,
        fontFamily: 'Montserrat');

    unselectd = TextStyle(
        fontSize: _appConfig.rWP(4),
        fontWeight: FontWeight.w900,
        color: Colors.grey,
        fontFamily: 'Montserrat');

    recnttexttitle = TextStyle(
        fontSize: _appConfig.rWP(4.3),
        fontWeight: FontWeight.bold,
        color: Color(0xff5d5d5d),
        fontFamily: 'Montserrat');

    recnttextview = TextStyle(
        fontSize: _appConfig.rWP(4),
        fontWeight: FontWeight.w600,
        color: Color(0xffD1D1D1),
        fontFamily: 'Montserrat');

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      key: scaffoldState,
      body: Stack(children: <Widget>[
        potrait(),
        new Positioned(
          //Place it at the top, and not use the entire screen
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            title: Text(
              'Now Playing',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: _appConfig.rWP(5),
              ),
            ),
            //No more green
            backgroundColor: Colors.transparent,
            elevation: 0.0, //Shadow gone
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () => {Navigator.pop(context)},
            ),
          ),
        ),
      ]),
    );
  }

  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Playlist Name'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter Name"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Create'),
                onPressed: () async {
                  creteplaylist(_textFieldController.text);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  /// playlist bottombar
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: userplaylist.length + 1,
            itemBuilder: (BuildContext context, int pos) {
              return userplaylist.length != pos
                  ? new ListTile(
                      leading: new Icon(Icons.music_note),
                      title: new Text(userplaylist[pos].user_playlist_name),
                      onTap: () {
                        addplaylist(
                            song.music_id, userplaylist[pos].user_playlist_id);
                        Navigator.of(context).pop();
                      })
                  : new ListTile(
                      leading: new Icon(Icons.add),
                      title: new Text('Create New Playlist'),
                      onTap: () {
                        Navigator.of(context).pop();

                        _displayDialog(context);
                      },
                    );
            },
          )

              /*new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Music'),
                    onTap: () => {}
                ),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Video'),
                  onTap: () => {},
                ),
              ],
            ),*/
              );
        });
  }

  /// playlist bottombar
  void bottomque(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.songs.length,
            itemBuilder: (BuildContext context, int pos) {
              return new ListTile(
                  leading: new Icon(Icons.music_note),
                  title: new Text(widget.songs[pos].music_title),
                  onTap: () {
                    _audioPlayer.stop();
                    _durationSubscription?.cancel();
                    _positionSubscription?.cancel();
                    _playerCompleteSubscription?.cancel();
                    _playerErrorSubscription?.cancel();
                    _playerStateSubscription?.cancel();

                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) =>
                            new NowPlaying(widget.songs, pos, 1)));
                  });
            },
          )

              /*new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Music'),
                    onTap: () => {}
                ),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Video'),
                  onTap: () => {},
                ),
              ],
            ),*/
              );
        });
  }

  void addplaylist(String id, String playlistid) async {
    networkUtil.addplaylis(NetworkUtil.userid, playlistid, id).then((value) {});
    Fluttertoast.showToast(
        msg: "Add in PlayList Done..",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepPurple,
        textColor: Colors.white,
        fontSize: 16.0);
    setState(() {});
  }

  void creteplaylist(String playlistid) async {
    await networkUtil
        .createplylist(NetworkUtil.userid, _textFieldController.text)
        .then((value) {});

    getownplaylist();

    setState(() {});
  }

  double convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    print(todayDate);
    print(formatDate(todayDate, [nn, ':', ss]));

//    double a=todayDate.millisecond;
//    return formatDate(todayDate, [nn,':',ss]);
  }

  String url;
  bool isLocal;
  PlayerMode mode;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  get _positionText => _position?.toString()?.split('.')?.first ?? '';
  bool isplay = false;

  AppConfig _appConfig;

  Widget potrait() {
    return new Container(
      child: Container(
        child: song == null
            ? Container()
            : new Column(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: _appConfig.rHP(14)),
                    height: _appConfig.rHP(30),
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/image/playing/bgplaymusic.png"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          new Hero(
                            tag: song.music_id,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: getImage(song) != null
                                    ? new Image.network(
                                        NetworkUtil.BASE_URL1 +
                                            song.music_image,
                                        height: _appConfig.rHP(25),
                                        width: _appConfig.rHP(25),
                                      )
                                    : new Image.asset(
                                        "images/back.jpg",
                                        fit: BoxFit.cover,
                                        color: Colors.deepPurple,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 30),
                    child: new Column(
                      children: <Widget>[
                        new Text(song.music_title,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: boldtextStyle),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              song.artistlist.length == 0
                                  ? Container()
                                  : new Text(
                                      song.artistlist[0].artist_name,
                                      maxLines: 1,
                                      style: unselectd,
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new AlbumScreen(
                                                    song.movie_name,
                                                    song.music_image,
                                                    "Movie",
                                                    song.movie_id,
                                                    "",
                                                    song.is_liked)));
                                  },
                                  child: new Text(
                                    song.movie_name,
                                    maxLines: 1,
                                    style: unselectd,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: _appConfig.rHP(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _settingModalBottomSheet(context);

                            print("bfjkgnkjgd");
                          },
                          child: Container(
                            child: Image.asset(
                              "assets/image/playing/ic_add_playlist.png",
                              height: _appConfig.rWP(14),
                              width: _appConfig.rWP(14),
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              shuffllist();
                              setState(() {});
                            },
                            child: isshuffle
                                ? Image.asset(
                                    "assets/image/playing/ic_suffel1.png",
                                    height: _appConfig.rWP(14),
                                    width: _appConfig.rWP(14),
                                  )
                                : Image.asset(
                                    "assets/image/playing/ic_suffel.png",
                                    height: _appConfig.rWP(14),
                                    width: _appConfig.rWP(14),
                                  ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              setFav(song.music_id);
                            },
                            child: islike == 1
                                ? Image.asset(
                                    "assets/image/playing/ic_favorite1.png",
                                    height: _appConfig.rWP(14),
                                    width: _appConfig.rWP(14),
                                  )
                                : Image.asset(
                                    "assets/image/playing/ic_favorite.png",
                                    height: _appConfig.rWP(14),
                                    width: _appConfig.rWP(14),
                                  ),
                          ),
                        ),
                        downloading
                            ? CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () {
                                  if (NetworkUtil.isdown == 1) {
                                    _download();
                                  } else {
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new ChoicePlan()));
                                  }
                                },
                                child: Container(
                                  child: Image.asset(
                                    "assets/image/playing/ic_download1.png",
                                    height: _appConfig.rWP(14),
                                    width: _appConfig.rWP(14),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  new Container(
                      margin: EdgeInsets.only(top: _appConfig.rHP(4)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                child: Stack(
                                  children: [
                                    Slider(
                                      activeColor: Color(0xff6052DB),
                                      inactiveColor: Colors.grey[350],
                                      onChanged: (v) {
                                        final Position =
                                            v * _duration.inMilliseconds;
                                        _audioPlayer.seek(Duration(
                                            milliseconds: Position.round()));
                                      },
                                      value: (_position != null &&
                                              _duration != null &&
                                              _position.inMilliseconds > 0 &&
                                              _position.inMilliseconds <
                                                  _duration.inMilliseconds)
                                          ? _position.inMilliseconds /
                                              _duration.inMilliseconds
                                          : 0.0,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      _position != null
                                          ? '${_positionText ?? ''} '
                                          : '0:00',
                                      style: unselectd,
                                    ),
                                    Text(
                                      song.music_duration == null
                                          ? ""
                                          : song.music_duration,
                                      style: unselectd,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
//        Text("State: $_audioPlayerState")
                        ],
                      )),
                  new Container(
                    margin: EdgeInsets.only(top: _appConfig.rHP(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /* IconButton(
                onPressed: _isPlaying ? null : () => _play(),
                iconSize: 64.0,
                icon: Icon(Icons.play_arrow),
                color: Colors.cyan),*/

                        GestureDetector(
                          onTap: () {
                            bottomque(context);
                          },
                          child: Container(
                            child: Image.asset(
                              "assets/image/playing/ic_playlist.png",
                              height: _appConfig.rWP(8),
                              width: _appConfig.rWP(8),
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
//                        _stop();

                              if (widget.index == 0) {
                              } else {
                                Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                        builder: (context) => new NowPlaying(
                                            widget.songs,
                                            widget.index - 1,
                                            1)));
                              }
                              setState(() {});
                            },
                            child: Image.asset(
                              "assets/image/playing/ic_previuse.png",
                              height: _appConfig.rWP(7),
                              width: _appConfig.rWP(7),
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () => isplay == true ? _pause() : _play(),
                            child: isplay == true
                                ? Image.asset(
                                    "assets/image/playing/ic_pause.png",
                                    height: _appConfig.rWP(12),
                                    width: _appConfig.rWP(12))
                                : Image.asset(
                                    "assets/image/playing/ic_play.png",
                                    height: _appConfig.rWP(12),
                                    width: _appConfig.rWP(12)),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.index + 1 < widget.songs.length)
                                Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                        builder: (context) => new NowPlaying(
                                            widget.songs,
                                            widget.index + 1,
                                            1)));
//                        _audioPlayer=new AudioPlayer(mode: mode);

//                        _play();
                              /*  setState(() {

                        });*/
                            },
                            child: Image.asset(
                              "assets/image/playing/ic_previuse1.png",
                              height: _appConfig.rWP(7),
                              width: _appConfig.rWP(7),
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              print("=========>>>>>>>>" + isvolum.toString());
                              if (isvolum) {
                                _audioPlayer.setVolume(0.0);
                                isvolum = false;
                              } else {
                                _pause();
                                _play();
                                _audioPlayer.setVolume(2.0);
                                isvolum = true;
                              }
                            },
                            child: isvolum
                                ? Image.asset(
                                    "assets/image/playing/ic_sound.png",
                                    height: _appConfig.rWP(8),
                                    width: _appConfig.rWP(8),
                                  )
                                : Image.asset(
                                    "assets/image/playing/ic_sound1.png",
                                    height: _appConfig.rWP(8),
                                    width: _appConfig.rWP(8),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  var progress = "";
  bool downloading = false;
  double percentage = 0.0;

  Future<bool> _checkPermission() async {
    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.requestPermissions([
      Permission.ACCESS_FINE_LOCATION,
      Permission.ACCESS_COARSE_LOCATION,
      Permission.READ_PHONE_STATE
    ]);

    if (permission[Permission.CAMERA] != PermissionState.GRANTED) {
      try {
        permission = await PermissionsPlugin.requestPermissions([
          Permission.READ_EXTERNAL_STORAGE,
          Permission.WRITE_EXTERNAL_STORAGE
        ]);
      } on Exception {
        debugPrint("Error");
      }

      if (permission[Permission.CAMERA] == PermissionState.GRANTED)
        print("permissions granted");
      else
        permissionsDenied(context);
    } else {
      print("Permission ok");
    }
  }

  void permissionsDenied(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return SimpleDialog(
            title: const Text("Permission denied"),
            children: <Widget>[
              Container(
                padding:
                EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                child: const Text(
                  "These permissions are needed for this application to run well",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            ],
          );
        });
  }


  String _localPath;

  Future<void> _download() async {
    _localPath = (await _findLocalPath()) + '/Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
      message: 'Downloading file...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: percentage,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    Dio dio = Dio();

    var dirToSave = await getApplicationDocumentsDirectory();

    await dio.download(NetworkUtil.BASE_URL1 + song.music_file,
        "$_localPath/" + song.music_title + ".mp3",
        onReceiveProgress: (rec, total) {
      setState(() {
        downloading = true;

        pr.show();

        Future.delayed(Duration(seconds: 2)).then((onvalue) {
          percentage = (percentage + 1.0);
          print("=======================>>>" + percentage.toString());
        });

        /*     Future.delayed(Duration(seconds: 10)).then((onValue) {
          print("PR status  ${pr.isShowing()}");
          if (pr.isShowing())
            pr.hide().then((isHidden) {
              print(isHidden);
            });
          print("PR status  ${pr.isShowing()}");
        });*/

        /*progress = ((rec / total)).toStringAsFixed(0) + "%";*/
      });
    });

    try {} catch (e) {
      throw e;
    }
    setState(() {
      downloading = false;
      print("${dirToSave.path}/" + song.music_title + ".mp3");
      progress = "Complete";
      Fluttertoast.showToast(
          msg: "Download Complated!" +
              "${dirToSave.path}/" +
              song.music_title +
              ".mp3",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      pr.hide().whenComplete(() {});
    });
  }

  void setFav(String id) async {
    if (islike == 1) {
      islike = 0;
      networkUtil.isunlike(NetworkUtil.userid, "Music", id).then((value) {});
    } else {
      islike = 1;
      networkUtil.islike(NetworkUtil.userid, "Music", id);
    }

    setState(() {});
  }

  bool isvolum = true;
}
