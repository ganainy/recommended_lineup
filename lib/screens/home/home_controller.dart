import 'package:get/get.dart';
import 'package:recommended_lineup/models/club_model.dart';
import 'package:recommended_lineup/models/player_model.dart';
import 'package:recommended_lineup/models/result_model.dart';

import '../../models/download_status.dart';
import '../../network/dio_helper.dart';
import '../../shared/constants.dart';

class HomeController extends GetxController {
  //used to show status of download
  var downloadStatusObs = Rxn<DownloadStatus>();
  //lists for top players of each position
  var topGoalKeepersObs = [].obs;
  var topDefendersObs = [].obs;
  var topMidfieldersObs = [].obs;
  var topAttackersObs = [].obs;
  //this field containts API response
  ResultModel? result;
  //selected formation with default formation of formations[0] (4-3-3)
  var selectedFormationObs = formations[0].obs;
  //variable for saving captain id
  var captainIdObs = Rxn<String?>();

  @override
  void onInit() {
    loadData(selectedFormationObs.value);
    getCaptainId();
  }

  void loadData(FormationModel formation) {
    downloadStatusObs.value = DownloadStatus.downloading;

    //load data from server
    DioHelper.loadApiData().then((value) {
      result = ResultModel.fromMap(value.data);
      getRecommendedLineup(formation); //assuming formation is 3-4-3
    }).onError((error, stackTrace) {
      downloadStatusObs.value = DownloadStatus.error;
    });
  }

  //get recommended lineup based on players and selected formation
  ///formation: takes integer list with number of players in each position [defenders,midfielders,attackers]*/
  void getRecommendedLineup(FormationModel formation) {
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
    topGoalKeepersObs.value = getRecommendedPlayers(goalkeeperList, 1);
    topDefendersObs.value =
        getRecommendedPlayers(defenderList, formation.getDefenderCount());
    topMidfieldersObs.value =
        getRecommendedPlayers(midfielderList, formation.getMidfieldersCount());
    topAttackersObs.value =
        getRecommendedPlayers(attackerList, formation.getAttackersCount());

    downloadStatusObs.value = DownloadStatus.complete;
  }

  /// quantity: number of top players in that position*/
  List getRecommendedPlayers(List playersList, int quantity) {
    playersList.sort(); //sort players by average score + previous match score
    return (playersList.getRange(0, quantity).toList());
  }

  //get club info for certain player
  ClubModel? getPlayerClub(PlayerModel? player) {
    if (result?.clubs == null) {
      return null;
    }

    for (var club in result!.clubs) {
      if (club.id == player?.clubId) {
        return club;
      }
    }
    return null;
  }

  //change formation of players and load the new one
  void setFormation(FormationModel formation) {
    loadData(formation);
    selectedFormationObs.value = formation;
  }

  //set player as captain
  void setCaptain(PlayerModel? player) {
    captainIdObs.value = player?.id;
    //save captain id to local storage
    getStorage.write(captainId, player?.id);
  }

  //check if player is captain
  isCaptain(PlayerModel? player) {
    return player?.id == captainIdObs.value;
  }

  //returns true if this formation is selected
  bool isSelectedFormation(FormationModel? formation) {
    return selectedFormationObs.value == formation;
  }

  //get captain id from db if exists on app start
  void getCaptainId() {
    captainIdObs.value = getStorage.read(captainId);
  }
}
