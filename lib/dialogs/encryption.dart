import 'package:flutter/material.dart';
import 'package:threec/store.dart';

class EncryptionDialog extends StatefulWidget {
  const EncryptionDialog({
    Key key,
  }) : super(key: key);

  @override
  _EncryptionDialogState createState() => _EncryptionDialogState();
}

class _EncryptionDialogState extends State<EncryptionDialog> {
  bool _obscureText = true;
  String _encryptionKey = Store().storeBox.get("encryptionKey",defaultValue: "1234");

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onKeyChange(key){
    _encryptionKey = key;
  }

  void _save(){
    Store().storeBox.put("encryptionKey", _encryptionKey);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Saved")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: 600
          ),
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Encryption Settings",
                  style: TextStyle(fontSize: 16),
              ),
              Divider(height: 32,),
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  TextField(
                    obscureText: _obscureText,
                    maxLength: 16,
                    controller: TextEditingController()..text = _encryptionKey,
                    onChanged: (key)=> _onKeyChange(key),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          padding: EdgeInsets.only(right: 12),
                          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                          onPressed: ()=> _toggle(),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Encryption Key',
                        hintText: 'Enter key for encryption'),
                  ),
                  SizedBox(height: 16,),
                  ElevatedButton(onPressed: ()=> _save(), child: Text("Save",style: TextStyle(color: Colors.white),))
                ],

              )


            ],
          ),
        )


    );
  }
}
