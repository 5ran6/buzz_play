import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';
import 'package:buzz_play/ui/musicplayer/flute_music_player.dart';

class MyQueue {
  static List<Recentplay> songs; // current playing queue
  static Recentplay song; // current playing song
  static int index; // current playing song index
  static MusicFinder player = new MusicFinder();
  static List<Recentplay> allSongs;
}
