
import 'package:flutter/material.dart';

class MicInput extends StatelessWidget {
  const MicInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.red.shade100.withOpacity(0.8),
      ),
      child: SizedBox(
        width: 50,
        height: 50,
        child: IconButton(
          icon: Icon(
            Icons.mic_rounded,
            color: Colors.red,
          ),
          onPressed: (){
          },
          splashRadius: 25,
          // padding: EdgeInsets.only(left: 3.0),
        ),
      ),
    );
  }
}

