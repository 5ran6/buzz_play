




class MyPackge {
  String status;
  String message;
  String response;

  static List<Packget> myPackgelist = new List();

  MyPackge.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"];
      if (status == null) {
        this.status = obj["status_code"];
      }
      this.message = obj["message"];
      this.response =
      obj["response"] != null ? obj["response"].toString() : null;
    }
  }

  MyPackge.getuserid(dynamic obj) {
    myPackgelist = obj
        .map<Packget>((json) => new Packget.fromJson(json))
        .toList();
  }
}






class Packget
{

  final String package_id;
  final String package_name;
  final String package_duration;
  final String package_price;
  final String total_package_price;









  Packget({this.package_id, this.package_name, this.package_duration,
    this.package_price,this.total_package_price});



  factory Packget.fromJson(Map<String, dynamic> jsonMap){

    return Packget(

      package_price:   jsonMap['package_price'],
      total_package_price:jsonMap['total_package_price'],
      package_id:jsonMap['package_id'],
      package_duration:jsonMap['package_duration'],
      package_name:jsonMap['package_name'],

    );


  }


}

