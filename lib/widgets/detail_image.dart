import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:services_controll_app/utils/constants.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'openImage',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                ),
              )),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
