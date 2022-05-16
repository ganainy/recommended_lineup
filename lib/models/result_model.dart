import 'package:recommended_lineup/models/player_model.dart';

import 'club_model.dart';

class ResultModel {
  var players = [];
  var clubs = [];

  ResultModel.fromMap(resultMap) {
    resultMap['players'].forEach((playerMap) {
      players.add(PlayerModel.fromMap(playerMap));
    });

    resultMap['clubs'].forEach((clubMap) {
      clubs.add(ClubModel.fromMap(clubMap));
    });
  }
}
