class AllowDownloads{



  final int is_allow_downloads;


  AllowDownloads({ this.is_allow_downloads});



  factory AllowDownloads.fromJson(Map<String, dynamic> jsonMap){
    return AllowDownloads(
      is_allow_downloads : jsonMap['is_allow_downloads'],
      );


  }


}











