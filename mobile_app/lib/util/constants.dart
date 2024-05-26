import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

const RoundedRectangleBorder slidingPanelShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(28),
    topRight: Radius.circular(28),
  ),
);

const double horizontalPadding = 20;

const double largeScreenThreshold = 600;

const EdgeInsets defaultTextPadding =
    EdgeInsets.symmetric(horizontal: 15, vertical: 10);

const String MOMENT_LONG_DATE_FORMAT = 'YYYY-MM-DDTHH:mm:ssZ';

enum ReasonForLeaving {
  notUsing,
  notUsing1,
  notUsing2;

  @override
  String toString() => translate("reason_for_leaving.$name");
}
