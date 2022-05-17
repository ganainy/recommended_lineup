import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../customization/my_theme.dart';

buildNetworkImage({
  required String? imageUrl,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl ?? '',
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
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
