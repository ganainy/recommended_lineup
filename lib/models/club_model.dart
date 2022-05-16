import 'package:recommended_lineup/customization/hex_color.dart';

class ClubModel {
  String? id;
  String? jerseyUrl;
  String? logo;
  String? name;
  String? jerseyNumberColorString;
  HexColor? jerseyNumberColor;

  ClubModel.fromMap(clubMap) {
    id = clubMap['id'];
    jerseyUrl = clubMap['jersey_url'];
    logo = clubMap['logo'];
    name = clubMap['name'];
    jerseyNumberColorString = clubMap['jersey_number_color'];
    if (jerseyNumberColorString != null) {
      jerseyNumberColor = HexColor(jerseyNumberColorString!);
    }
  }
}
