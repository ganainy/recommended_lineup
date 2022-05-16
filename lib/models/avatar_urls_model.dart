class AvatarUrlsModel {
  String? large;
  String? medium;
  String? small;

  AvatarUrlsModel.fromMap(avatarUrlsMap) {
    large = avatarUrlsMap['large'];
    medium = avatarUrlsMap['medium'];
    small = avatarUrlsMap['small'];
  }
}
