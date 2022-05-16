import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recommended_lineup/models/player_model.dart';
import 'package:recommended_lineup/models/result_model.dart';

import '../../constants.dart';
import '../../models/download_status.dart';
import '../../network/dio_helper.dart';

class HomeController extends GetxController {
  //used to show status of download
  var downloadStatusObs = Rxn<DownloadStatus>();

  @override
  void onInit() {
    downloadStatusObs.value = DownloadStatus.downloading;

    //load data from server
    DioHelper.loadApiData().then((value) {
      ResultModel? result = ResultModel.fromMap(value.data);
      getRecommendedLineup(result, [3, 4, 3]); //assuming formation is 3-4-3
      downloadStatusObs.value = DownloadStatus.complete;
    }).onError((error, stackTrace) {
      downloadStatusObs.value = DownloadStatus.error;
    });
  }

  //get recommended lineup based on players and selected formation
  ///formation: takes integer list with number of players in each position [defenders,midfielders,attackers]*/
  void getRecommendedLineup(ResultModel? result, List<int> formation) {
    List<PlayerModel?> goalkeeperList = [];
    List<PlayerModel?> defenderList = [];
    List<PlayerModel?> midfielderList = [];
    List<PlayerModel?> attackerList = [];

    //separate players based on position
    result?.players.forEach((player) {
      if (player.position == goalkeeper) {
        goalkeeperList.add(player);
      } else if (player.position == defender) {
        defenderList.add(player);
      } else if (player.position == midfielder) {
        midfielderList.add(player);
      } else if (player.position == attacker) {
        attackerList.add(player);
      }
    });

    //get top players in each position
    getRecommendedPlayers(goalkeeperList, 1);
    getRecommendedPlayers(defenderList, formation[0]);
    getRecommendedPlayers(midfielderList, formation[1]);
    getRecommendedPlayers(attackerList, formation[2]);
  }

  /// quantity: number of top players in that position*/
  void getRecommendedPlayers(List playersList, int quantity) {
    playersList.sort(); //sort players by average score + previous match score
    playersList.getRange(0, quantity).forEach((player) {
      debugPrint(
          "${player?.position}: ${player?.firstName} ${player?.lastName} ${player?.avgScore + player?.previousMatch?.finalScore} ");
    });
  }
}
