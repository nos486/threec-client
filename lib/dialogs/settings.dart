import 'package:flutter/material.dart';

class SettingDialog extends StatelessWidget {
  const SettingDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Setting"),
      children: [
        Card(
          color: Colors.red,
          child: Text("text"),
        )
      ],
    );
  }
}
