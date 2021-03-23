import 'package:citylife/utils/constants.dart';
import 'package:flutter/material.dart';

class B {
  static final Map<Badge, BadgeResources> adges = {
    Badge.Daily3: BadgeResources(
      image: AssetImage("assets/images/avatar_1.jpg"),
      text: "logging in for 3 days consecutively!",
    ),
    Badge.Daily5: BadgeResources(
      image: AssetImage("assets/images/avatar_2.jpg"),
      text: "logging in for 5 days straight! You must really like us!",
    ),
    Badge.Daily10: BadgeResources(
      image: AssetImage("assets/images/avatar_3.jpg"),
      text:
          "logging in for the 10th day in a row! Should we be getting a restraining order on your behalf?",
    ),
    Badge.Daily30: BadgeResources(
      image: AssetImage("assets/images/avatar_4.jpg"),
      text:
          "reaching the highest daily reward! You've been with us for a month straight! Unbelievable!",
    ),
    Badge.Techie: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text:
          "becoming a techie! Now your impressions are going to be even more accurate!",
    ),
    Badge.Structural1: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 1st structural impression!",
    ),
    Badge.Structural5: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 5th structural impression!",
    ),
    Badge.Structural10: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 10th structural impression!",
    ),
    Badge.Structural25: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 25th structural impression!",
    ),
    Badge.Structural50: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 50th structural impression!",
    ),
    Badge.Emotional1: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 1st emotional impression!",
    ),
    Badge.Emotional5: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 5th emotional impression!",
    ),
    Badge.Emotional10: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 10th emotional impression!",
    ),
    Badge.Emotional25: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 25th emotional impression!",
    ),
    Badge.Emotional50: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 50th emotional impression!",
    ),
  };
}

class BadgeResources {
  final AssetImage image;
  final String text;

  BadgeResources({
    this.image,
    this.text,
  });
}
