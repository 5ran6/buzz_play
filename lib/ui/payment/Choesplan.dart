import 'package:flutter/material.dart';
import 'package:buzz_play/fetchdataapi/Model/paymet/Packget.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/payment/PaymentCard.dart';
import 'package:buzz_play/utils/AppConfig.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MediaQuery Demo',
      theme: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      home: new ChoicePlan(),
    );
  }
}

class ChoicePlan extends StatefulWidget {
  @override
  _ChoicePlanState createState() => _ChoicePlanState();
}

class _ChoicePlanState extends State<ChoicePlan> {
  bool isone = false, istwo = false, isthre = false, isfour = true;



int i=3;
  AppConfig _appConfig;
String rate="\$ 4.99";
String mrate="\$ 4.99";
  void selection(int i) {
    if (i == 1) {
      isone = true;
      isthre = false;
      istwo = false;
      isfour = false;
      rate=pckglist[0].package_price;
      mrate=pckglist[0].total_package_price;


    } else if (i == 2) {
      isone = false;
      isthre = false;
      istwo = true;
      isfour = false;
      rate=pckglist[1].package_price;
      mrate=pckglist[1].total_package_price;
    } else if (i == 3) {
      isone = false;
      isthre = true;
      istwo = false;
      isfour = false;
      rate=pckglist[2].package_price;
      mrate=pckglist[2].total_package_price;
    } else if (i == 4) {
      isone = false;
      isthre = false;
      istwo = false;
      isfour = true;
      rate=pckglist[3].package_price;
      mrate=pckglist[3].total_package_price;
    }
    setState(() {

    });
  }
  NetworkUtil networkUtil;
List<Packget> pckglist=new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    networkUtil = new NetworkUtil();

    getpackprice();

  }


  void getpackprice() async {
    await networkUtil.getpckg().then((value) {});
    pckglist = MyPackge.myPackgelist;
    setState(() {
      rate=pckglist[3].package_price;
      mrate=pckglist[3].total_package_price;
    });
  }

  @override
  Widget build(BuildContext context) {
    _appConfig = new AppConfig(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Choice Plan',
                  style: TextStyle(
                      fontSize: _appConfig.rHP(3), color: Colors.black,fontFamily: 'Montserrat'),
                ),

              ],
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black54),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/cplan/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: _appConfig.rHP(47),
                ),
                Container(
                  height: _appConfig.rHP(38),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              selection(1);
                              i=0;
                            },
                            child: Container(
                              child: !isone
                                  ? Image.asset(
                                      "assets/image/cplan/month_1.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "assets/image/cplan/month_1 pressed.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              selection(2);
                              i=1;
                            },
                            child: Container(
                              child: !istwo
                                  ? Image.asset(
                                      "assets/image/cplan/month_3.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "assets/image/cplan/month_3 pressed.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              selection(3);
                              i=2;
                            },
                            child: Container(
                              child: !isthre
                                  ? Image.asset(
                                "assets/image/cplan/month_6.png",
                                height: _appConfig.rHP(10),
                                width: _appConfig.rWP(40),
                                fit: BoxFit.fill,
                              )
                                  : Image.asset(
                                "assets/image/cplan/month_6 pressed.png",
                                height: _appConfig.rHP(10),
                                width: _appConfig.rWP(40),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              selection(4);
                              i=3;
                            },
                            child: Container(
                              child: !isfour
                                  ? Image.asset(
                                "assets/image/cplan/year_1.png",
                                height: _appConfig.rHP(10),
                                width: _appConfig.rWP(40),
                                fit: BoxFit.fill,
                              )
                                  : Image.asset(
                                "assets/image/cplan/year_1 pressed.png",
                                height: _appConfig.rHP(10),
                                width: _appConfig.rWP(40),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        ],
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[



                          Text("Your Total Cost is "+rate,style: TextStyle(color: Colors.deepPurple,
                              fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Montserrat'),),

                          SizedBox(
                            height: 4,
                          ),
                          Text("Your Monthly Cost is "+mrate,style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Montserrat'),)


                        ],
                      )

                    ],
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {

                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) =>
                        new PaymentCard(pckglist,i)));

                  },
                  child: Container(
                    child: Image.asset(
                      "assets/image/cplan/btn_continue.png",
                      height: _appConfig.rHP(10),
                      fit: BoxFit.fill,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
