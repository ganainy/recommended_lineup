import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recommended_lineup/models/player_model.dart';
import 'package:recommended_lineup/screens/home/home_controller.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../customization/my_theme.dart';
import '../../models/download_status.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Obx(() {
      return Column(
        children: [
          SizedBox(
            height: Get.height - 180,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/field.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                homeController.downloadStatusObs.value ==
                        DownloadStatus.downloading
                    ? buildLoadingView()
                    : homeController.downloadStatusObs.value ==
                            DownloadStatus.error
                        ? buildErrorView()
                        : buildFormationView(context),
              ],
            ),
          ),
          buildFormationSelector(context),
        ],
      );
    })));
  }

  Widget buildFormationView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //attackers row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...homeController.topAttackersObs.value.map((player) {
                return buildPlayerCard(player, context);
              }).toList(),
            ],
          ),
          //midfielders row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...homeController.topMidfieldersObs.value.map((player) {
                return buildPlayerCard(player, context);
              }).toList(),
            ],
          ),
          //defenders row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...homeController.topDefendersObs.value.map((player) {
                return buildPlayerCard(player, context);
              }).toList(),
            ],
          ),
          //goal keeper
          buildPlayerCard(
              homeController.topGoalKeepersObs.value.elementAt(0), context),
        ],
      ),
    );
  }

  Widget buildPlayerCard(PlayerModel? player, BuildContext context) {
    var playerClub = homeController.getPlayerClub(player);
    debugPrint("Player club: ${playerClub?.name}");
    return InkWell(
      onTap: () {
        homeController.setCaptain(player);
      },
      child: Column(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              children: [
                buildNetworkImage(imageUrl: playerClub?.jerseyUrl),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${player?.jerseyNumber}',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: playerClub?.jerseyNumberColor),
                  ),
                ),
                homeController.isCaptain(player)
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          'assets/images/captain.png',
                          width: 25,
                          height: 25,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              '${player?.lastName}',
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 16,
                  color: MyTheme.grey,
                  height: 1.2,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            '${player?.avgScore + player?.previousMatch?.finalScore} Pts',
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style:
                const TextStyle(fontSize: 14, color: MyTheme.grey, height: 1.2),
          )
        ],
      ),
    );
  }

  Widget buildFormationSelector(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Column(
        children: [
          Text('Select formation',
              style: Theme.of(context).textTheme.headline6),
          Flexible(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: formations.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      homeController.setFormation(formations[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          color: homeController
                                  .isSelectedFormation(formations[index])
                              ? Colors.green[200]
                              : null,
                          child: Container(
                              margin: const EdgeInsets.all(8),
                              child: Text(formations[index].name))),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingView() {
    return Center(
      child: SizedBox(
        height: 120,
        child: Card(
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Downloading top formation...'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildErrorView() {
    return Center(
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(32),
          child: const Text('Error loading from server...'),
        ),
      ),
    );
  }
}
