import 'package:citylife/utils/constants.dart';
import 'package:flutter/material.dart';

class B {
  static final Map<Badge, BadgeResources> adges = {
    Badge.Daily3: BadgeResources(
      image: AssetImage("assets/images/avatar_1.jpg"),
      text: "logging in for 3 days consecutively!",
      description:
          "Log into the application 3 days in a row in order to unlock this badge!",
    ),
    Badge.Daily5: BadgeResources(
      image: AssetImage("assets/images/avatar_2.jpg"),
      text: "logging in for 5 days straight! You must really like us!",
      description:
          "Log into the application 5 days in a row in order to unlock this badge!",
    ),
    Badge.Daily10: BadgeResources(
      image: AssetImage("assets/images/avatar_3.jpg"),
      text:
          "logging in for the 10th day in a row! Should we be getting a restraining order on your behalf?",
      description:
          "Log into the application 10 days in a row in order to unlock this badge!",
    ),
    Badge.Daily30: BadgeResources(
      image: AssetImage("assets/images/avatar_4.jpg"),
      text:
          "reaching the highest daily reward! You've been with us for a month straight! Unbelievable!",
      description:
          "Log into the application 30 days in a row in order to unlock this badge!",
    ),
    Badge.Techie: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text:
          "becoming a techie! Now your impressions are going to be even more accurate!",
      description:
          "Come to the dark side, we have cookies and reinforced concrete beams.",
    ),
    Badge.Structural1: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 1st structural impression!",
      description:
          "Spot 1 structural hazards in your city (or somewhere in the world)!",
    ),
    Badge.Structural5: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 5th structural impression!",
      description:
          "Spot 5 different structural hazards in your city (or somewhere in the world)!",
    ),
    Badge.Structural10: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 10th structural impression!",
      description:
          "Spot 10 different structural hazards in your city (or somewhere in the world)!",
    ),
    Badge.Structural25: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 25th structural impression!",
      description:
          "Spot 25 different structural hazards in your city (or somewhere in the world)!",
    ),
    Badge.Structural50: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 50th structural impression!",
      description:
          "Spot 50 different structural hazards in your city (or somewhere in the world)!",
    ),
    Badge.Emotional1: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 1st emotional impression!",
      description:
          "Feeling emotional yet? State your feelings by adding 1 emotional impressions!",
    ),
    Badge.Emotional5: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 5th emotional impression!",
      description:
          "Feeling emotional yet? State your feelings by adding 5 emotional impressions!",
    ),
    Badge.Emotional10: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 10th emotional impression!",
      description:
          "Feeling emotional yet? State your feelings by adding 10 emotional impressions!",
    ),
    Badge.Emotional25: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 25th emotional impression!",
      description:
          "Feeling emotional yet? State your feelings by adding 25 emotional impressions!",
    ),
    Badge.Emotional50: BadgeResources(
      image: AssetImage("assets/images/avatar_5.jpg"),
      text: "uploading your 50th emotional impression!",
      description:
          "Feeling emotional yet? State your feelings by adding 50 emotional impressions!",
    ),
  };
}

class BadgeResources {
  final AssetImage image;
  final String text;
  final String description;

  BadgeResources({
    this.image,
    this.text,
    this.description,
  });
}
