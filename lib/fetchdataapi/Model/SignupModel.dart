

import 'package:flutter/material.dart';

class Registers{



  final String user_token;
  final String user_email;
  final String user_password;
  final String user_id;
  final String user_name;
  final String user_profile_pic;

  Registers({ this.user_token, this.user_profile_pic, this.user_email,
    this.user_name,this.user_id,
    this.user_password});



    factory Registers.fromJson(Map<String, dynamic> jsonMap){
      return Registers(user_token : jsonMap['user_token'],
          user_email : jsonMap['user_email'],
          user_name: jsonMap['user_name'],
          user_password : jsonMap['user_password'],
          user_id: jsonMap['user_id'],
          user_profile_pic : jsonMap['user_profile_pic']);


    }


}





