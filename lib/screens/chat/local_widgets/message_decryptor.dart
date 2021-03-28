import 'package:flutter/material.dart';
import 'package:threec/models/Message.dart';
import 'package:threec/store.dart';
import 'package:threec/utils/encryption.dart';

class MessageDecryptor extends StatefulWidget {
  final Message message;
  final Function refresh;

  const MessageDecryptor({Key key,@required this.message,@required this.refresh}) : super(key: key);

  @override
  _MessageDecryptorState createState() => _MessageDecryptorState();
}

class _MessageDecryptorState extends State<MessageDecryptor> {
  String _encryptionKey = Store().storeBox.get("encryptionKey",defaultValue: "1234");
  TextEditingController textEditKey = TextEditingController();
  Encryption encryption = Encryption();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Column(
        children: [
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Icon(Icons.lock,color: Colors.red,size: 16,),
          //     Text("Message encrypted",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,),),
          //   ],
          // ),
          // SizedBox(height: 8,),
          TextField(
            obscureText: true,
            maxLength: 16,
            controller: textEditKey,
            onChanged: (key){},
            onSubmitted: (key){
              if(encryption.decryptMessage(widget.message,key: textEditKey.text)){
                widget.refresh();
              }
            },
            decoration: InputDecoration(
                // suffix: IconButton(
                //   icon: Icon(Icons.lock_open),
                //   onPressed: () {},
                // ),
                isDense: true,
                labelText: 'Encryption Key',
                hintText: 'Enter key for encryption',
                errorText: 'Cant decoded message with the main key.'
            ),
          ),

        ],
      ),
    );
  }
}
