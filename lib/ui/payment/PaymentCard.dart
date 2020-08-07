import 'package:flutter/material.dart';
import 'package:buzz_play/fetchdataapi/Model/paymet/Packget.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/payment/WbView.dart';
import 'package:buzz_play/utils/AppConfig.dart';

class PaymentCard extends StatefulWidget {


  List<Packget> pckglist;
  int i;
  PaymentCard(@required this.pckglist,@required this.i);
  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {

  AppConfig _appConfig;
  @override
  Widget build(BuildContext context) {
    _appConfig=new AppConfig(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Choice Payment Type',
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
            image: AssetImage("assets/image/cplan/payment-page.png"),
            fit: BoxFit.fill,
          ),
        ),

        child:
        Stack(
          children: <Widget>[

            Column(
              children: <Widget>[
                SizedBox(
                  height: _appConfig.rHP(20),




                ),
                GestureDetector(
                  onTap: (){

                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) =>
                        new WbView(NetworkUtil.userid,widget.pckglist[widget.i].package_id,
                            widget.pckglist[widget.i].total_package_price)));


                  },
                  child: Container(

                    height: _appConfig.rHP(21),
                    child: Container(),
                    color: Colors.transparent,

                  ),
                )
              ],
            )

,
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: _appConfig.rHP(10),
                child:  Center(
                  child: Text(widget.pckglist[widget.i].total_package_price,style: TextStyle(
                    color: Colors.white,
                      fontSize: _appConfig.rWP(7), fontWeight: FontWeight.w600, fontFamily: 'Montserrat'),),
                )

              ),
            )

          ],

        ),
      ),


    );
  }
}
