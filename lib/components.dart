import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'customization/my_theme.dart';

buildNetworkImage({
  required String? imageUrl,
  double width = 70.0,
  double height = 70.0,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl ?? '',
    imageBuilder: (context, imageProvider) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    ),
    placeholder: (context, url) => const SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(
          color: MyTheme.grey,
        )),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}
