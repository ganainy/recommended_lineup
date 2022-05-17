import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recommended_lineup/models/player_model.dart';
import 'package:recommended_lineup/screens/home/home_controller.dart';

import '../../customization/my_theme.dart';
import '../../models/download_status.dart';
import '../../shared/components.dart';
import '../../shared/constants.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController homeController = Get.find<HomeController>();

  late double maxHeight; // height of screen
  late double maxWidth; // width of screen
  late double
      fieldHeight; // height of the field background that players show on
  late double playerCardHeight; // height of player card
  late double playerCardWidth; // width of player card

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false, //dont resize when keyboard is open
            body: LayoutBuilder(
              builder: (context, constraints) {
                maxHeight = constraints.maxHeight;
                maxWidth = constraints.maxWidth;
                fieldHeight = maxHeight * 0.8;
                playerCardHeight = (fieldHeight / 4) - 16; /*margin*/
                playerCardWidth = maxWidth / 5 - 16; /*margin*/

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: fieldHeight,
                        child: Obx(() {
                          return Stack(
                            children: [
                              buildFieldBackground(),
                              homeController.downloadStatusObs.value ==
                                      DownloadStatus.downloading
                                  ? buildLoadingView()
                                  : homeController.downloadStatusObs.value ==
                                          DownloadStatus.error
                                      ? buildErrorView()
                                      : buildFormationView(context),
                            ],
                          );
                        }),
                      ),
                      buildFormationSelector(context),
                    ],
                  ),
                );
              },
            )));
  }

  Container buildFieldBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/field.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget buildFormationView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //attackers row
          buildFormationRow(context, homeController.topAttackersObs.value),
          //midfielders row
          buildFormationRow(context, homeController.topMidfieldersObs.value),
          //defenders row
          buildFormationRow(context, homeController.topDefendersObs.value),
          //goalkeeper
          buildPlayerCard(
              homeController.topGoalKeepersObs.value.elementAt(0), context),
        ],
      ),
    );
  }

  Row buildFormationRow(BuildContext context, List<dynamic> players) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...players.map((player) {
          return buildPlayerCard(player, context);
        }).toList(),
      ],
    );
  }

  Widget buildPlayerCard(PlayerModel? player, BuildContext context) {
    var playerClub = homeController.getPlayerClub(player);
    debugPrint("Player club: ${playerClub?.name}");
    return InkWell(
      onTap: () {
        homeController.setCaptain(player);
        //show toast
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${player?.lastName} has been set as captain"),
        ));
      },
      child: Container(
        width: playerCardWidth,
        height: playerCardHeight,
        child: Column(
          children: [
            Expanded(
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
            FittedBox(
              child: Text(
                '${player?.lastName}',
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 16,
                    color: MyTheme.grey,
                    height: 1.2,
                    fontWeight: FontWeight.w700),
              ),
            ),
            FittedBox(
              child: Text(
                '${player?.avgScore + player?.previousMatch?.finalScore} Pts',
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14, color: MyTheme.grey, height: 1.2),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFormationSelector(BuildContext context) {
    return SizedBox(
      height: maxHeight - fieldHeight,
      child: Column(
        children: [
          Text('Select formation',
              style: Theme.of(context).textTheme.headline6),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: formations.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      homeController.setFormation(formations[index]);
                      //show toast
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("formation set to ${formations[index].name} "),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() {
                        return AspectRatio(
                          aspectRatio: 1,
                          child: Card(
                              color: homeController
                                      .isSelectedFormation(formations[index])
                                  ? Colors.green[200]
                                  : null,
                              child:
                                  Center(child: Text(formations[index].name))),
                        );
                      }),
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
