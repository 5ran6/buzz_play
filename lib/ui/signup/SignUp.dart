import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:buzz_play/fetchdataapi/Model/SignupModel.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/home/HomeUI.dart';
import 'package:buzz_play/ui/login/login.dart';
import 'package:buzz_play/utils/AppConfig.dart';

import 'package:buzz_play/utils/Dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth _fAuth = FirebaseAuth.instance;

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  //my code

  //end my code

  Future<FirebaseUser> signIn(BuildContext context) async {


    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    FacebookAccessToken myToken = result.accessToken;

    ///assuming sucess in FacebookLoginStatus.loggedIn
    /// we use FacebookAuthProvider class to get a credential from accessToken
    /// this will return an AuthCredential object that we will use to auth in firebase
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: myToken.token);

// this line do auth in firebase with your facebook credential.
    FirebaseUser user = (await _fAuth.signInWithCredential(credential)).user;

    //Token: ${accessToken.token}

    submitgooglefb(user.email, user.displayName,user.photoUrl);

    return user;
  }

  Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    submitgooglefb(user.email, user.displayName,user.photoUrl);

    return user;
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  Future<Null> _signOut(BuildContext context) async {
    await facebookSignIn.logOut();
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign out button clicked'),
    ));
    print('Signed out');
  }

  String name;
  String imgurl;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String token = "";
  String _homeScreenText = "Waiting for token...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    networkUtil = new NetworkUtil();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        this.token = token;
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  NetworkUtil networkUtil;

  Registers registers;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  void submit() async {
    Dialogs.showLoadingDialog(context, _keyLoader); //inv
    await networkUtil
        .postregisterfb(emailController.text, passController.text, token, "",
            nameController.text)
        .then((value) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    });
    registers = NetworkUtil.rregisters;
   await _onChanged();



    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => new HomeUI(),
        ));


    setState(() {
      print(registers.user_email);
    });
  }



  SharedPreferences sharedPreferences;

  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("setuserid",NetworkUtil.rregisters.user_id );
      sharedPreferences.setBool("isfirst", false);
      sharedPreferences.setString("name", NetworkUtil.rregisters.user_name);
      sharedPreferences.setString("email", NetworkUtil.rregisters.user_email);
      sharedPreferences.setString("userprfpic",NetworkUtil.rregisters.user_profile_pic);
      sharedPreferences.commit();

    });
  }
  String _base64;


  void submitgooglefb(String email, String name,String url)  async {


    http.Response response = await http.get(
      url,
    );
    if (mounted) {

      _base64 =await base64.encode(response.bodyBytes);

    }


    print(_base64);
    await networkUtil.postregisterfb(email, "", token, _base64, name).then((value) {
    });
    registers = NetworkUtil.rregisters;
    setState(() {
      print(registers.user_email);
    });



    await _onChanged();



    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => new HomeUI(),
        ));




  }

  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return "";
    }

    // The pattern of the email didn't match the regex above.
    return 'Email is not valid';
  }
  AppConfig _appConfig;
  @override
  Widget build(BuildContext context) {
    _appConfig = new AppConfig(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,8.0),
              child: Container(
                 color: Color(0xffF6F6F6),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: double.infinity,
                      color: Colors.blue,
                    ),
                    Container(
                      width: double.infinity,
                      child: Image.asset(
                        "assets/image/banner.png",
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(
                      height: _appConfig.rH(2),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        child: TextField(
                          controller: nameController,
                        textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8E55C8), width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8E55C8), width: 1.0),
                            ),
                            hintText: 'Full Name',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _appConfig.rH(2.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        child: TextField(
                          controller: emailController,
                   keyboardType: TextInputType.emailAddress,       decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8E55C8), width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8E55C8), width: 1.0),
                            ),
                            hintText: 'Email',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _appConfig.rH(2.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        child: TextField(
                          obscureText: true,
                          controller: passController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8E55C8), width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8E55C8), width: 1.0),
                            ),
                            hintText: 'Password',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _appConfig.rH(1),
                    ),
                    GestureDetector(
                      onTap: () => _validateInputs(),
                      child: Container(
                        child: Image.asset("assets/image/sign_up_btn.png"),
                      ),
                    ),
                    SizedBox(
                      height: _appConfig.rH(2),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "or signup with",
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: _appConfig.rH(1),
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){

                              signIn(context);
                            },
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                child: Image.asset(
                                  "assets/image/ic_fb.png",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Container(
                            width: 1,
                            height: 55,
                            color: Colors.black,
                          ),
                          GestureDetector(
                            onTap: (){

                              signInWithGoogle(context);
                            },
                            child: Container(
                                margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Image.asset(
                                  "assets/image/ic_google.png",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _appConfig.rH(7),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new Login(),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "You have already account?",
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              " Login",
                              style: TextStyle(
                                  color: Color(0xff8E55C8), fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future _validateInputs() async {

    if(nameController.text=="")
    {
      return  Fluttertoast.showToast(
          msg: "Enter UserName",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

    if(_validateEmail(emailController.text)!="")
    {
      return  Fluttertoast.showToast(
          msg: "Enter Valid Email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    if(passController.text=="")
    {
      return  Fluttertoast.showToast(
          msg: "Enter Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }



    submit();
  }
}
