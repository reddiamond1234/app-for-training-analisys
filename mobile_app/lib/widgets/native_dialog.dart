import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../util/constants.dart';

Future<void> showNativeDialogWithOk(
  BuildContext context,
  String? title,
  String? content,
) async {
  if (!context.mounted) return;
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(content ?? ""),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  } else {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BVColors.background,
        title: Text(title ?? ""),
        content: Text(content ?? ""),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

Future<bool?> showNativeConfirmCancelDialog(
  BuildContext context,
  String? title,
  String? content,
) async {
  if (!context.mounted) return null;
  if (Platform.isIOS) {
    return showCupertinoDialog<bool?>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: title == null ? null : Text(title),
        content: Text(content ?? ""),
        actions: [
          CupertinoDialogAction(
            child: const Text('Prekliči'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            isDestructiveAction: true,
            child: const Text('Potrdi'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  } else {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? ""),
        content: Text(content ?? ""),
        actions: [
          TextButton(
            child: const Text('Prekliči', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Potrdi',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}

Future<void> showNativeRetryDialog(
  BuildContext context,
  String? title,
  String? content,
  Function retry,
) async {
  if (!context.mounted) return;
  const String message = "Retry";
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(content ?? ""),
        actions: [
          CupertinoDialogAction(
            child: const Text(message),
            onPressed: () {
              retry();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  } else {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? ""),
        content: Text(content ?? ""),
        actions: [
          TextButton(
            child: const Text(message),
            onPressed: () {
              retry();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

Future<DateTime?> showNativeDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? minDate,
}) async {
  if (!context.mounted) return null;
  DateTime? selectedDate;
  // fixes crash when initial date is before min date
  if (minDate != null && initialDate.isBefore(minDate)) {
    initialDate = minDate;
  }

  if (Platform.isIOS) {
    await showModalBottomSheet(
      shape: slidingPanelShape,
      context: context,
      builder: (context) => SizedBox(
        height: 300,
        child: CupertinoDatePicker(
          minimumDate: minDate,
          initialDateTime: initialDate,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (newDate) => selectedDate = newDate,
        ),
      ),
    );
    selectedDate ??= initialDate;
  } else {
    selectedDate = await showDatePicker(
      helpText: "Izberi datum",
      context: context,
      firstDate: minDate ?? initialDate.subtract(const Duration(days: 365)),
      initialDate: initialDate,
      lastDate: initialDate.add(
        const Duration(days: 365),
      ),
    );
  }
  return selectedDate;
}
