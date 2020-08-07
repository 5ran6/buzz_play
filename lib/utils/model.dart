//import 'package:musicplayer/database/flute_music_player.dart';
import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';
import 'package:buzz_play/ui/musicplayer/flute_music_player.dart';
import 'package:scoped_model/scoped_model.dart';

class SongModel extends Model {
  Recentplay _song;
  List<Recentplay> albums, recents, songs;
  Recentplay last;
  Recentplay top;
  int mode = 2;

  Recentplay get song => _song;

  void updateUI(Recentplay song) async {
    _song = song;
//    recents = await db.fetchRecentSong();
    //recents.removeAt(0);
//    top = await db.fetchTopSong().then((item) => item[0]);
    notifyListeners();
  }

  void setMode(int mode) {
    this.mode = mode;
    notifyListeners();
  }

  // void updateRecents(db)async{
  //   recents=await db.fetchRecentSong();
  //   recents.removeAt(0);
  //   notifyListeners();
  // }
  init(db) async {
    recents = (await db.fetchRecentSong());
    recents.removeAt(0); // as it is showing in header
    notifyListeners();
  }
}
