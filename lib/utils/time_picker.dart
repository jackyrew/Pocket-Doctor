import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<TimeOfDay?> pickTime(
  BuildContext context,
  TimeOfDay initialTime,
) async {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    TimeOfDay? selected;

    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 260,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(
                  0,
                  0,
                  0,
                  initialTime.hour,
                  initialTime.minute,
                ),
                onDateTimeChanged: (dt) {
                  selected = TimeOfDay(
                    hour: dt.hour,
                    minute: dt.minute,
                  );
                },
              ),
            ),
            CupertinoButton(
              child: const Text("Done"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );

    return selected;
  }

  return showTimePicker(
    context: context,
    initialTime: initialTime,
  );
}
