


class ApiKey{

  final String results;
  final String message;
  ApiKey({ this.results,this.message});



  factory ApiKey.fromJson(Map<String, dynamic> parsedJson){


    return ApiKey(

      message: parsedJson['message'] as String,
        results: parsedJson['result'] as String
    );
  }


}

class Results {

  final String api_key_value;

  Results({this.api_key_value});


  factory Results.fromJson(Map<String, dynamic> parsedJson){
    return Results(
        api_key_value:parsedJson['api_key_value']
    );
  }
}
