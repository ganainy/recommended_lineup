import 'package:recommended_lineup/models/previous_match_model.dart';

import 'avatar_urls_model.dart';

class PlayerModel implements Comparable<PlayerModel> {
  var avgScore;
  String? id;
  String? clubId;
  String? firstName;
  bool? injured;
  String? lastName;
  String? position;
  int? jerseyNumber;
  PreviousMatchModel? previousMatch;
  AvatarUrlsModel? avatarUrlsModel;
  bool? suspended;

  PlayerModel.fromMap(playerMap) {
    id = playerMap['id'];
    avgScore = playerMap['avg_score'];
    clubId = playerMap['club_id'];
    firstName = playerMap['first_name'];
    injured = playerMap['injured'];
    lastName = playerMap['last_name'];
    position = playerMap['position'];
    previousMatch = PreviousMatchModel.fromMap(playerMap['previous_match']);
    avatarUrlsModel = AvatarUrlsModel.fromMap(playerMap['avatar_urls']);
    suspended = playerMap['suspended'];
    jerseyNumber = playerMap['jersey_number'];
  }

  //override compare to method to sort players based on average score+ previous match score
  @override
  int compareTo(PlayerModel otherPlayer) {
    if (avgScore + previousMatch?.finalScore >
        otherPlayer.avgScore + otherPlayer.previousMatch?.finalScore) {
      return -1;
    } else if (avgScore + previousMatch?.finalScore <
        otherPlayer.avgScore + otherPlayer.previousMatch?.finalScore) {
      return 1;
    } else {
      return 0;
    }
  }
}
