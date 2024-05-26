import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ColorFilter? getColorFilter(Color? color) =>
    color == null ? null : ColorFilter.mode(color, BlendMode.srcIn);

void setBottomNavBarColor(Color color) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: color,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
}

String getInitials(String name) {
  final List<String> nameSplit = name.split(" ");
  String initials = "";
  int numWords = 2;

  if (nameSplit.length < 2) {
    numWords = 1;
  }

  for (int i = 0; i < numWords; i++) {
    initials += nameSplit[i][0];
  }

  return initials;
}
