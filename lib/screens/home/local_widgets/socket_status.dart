import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:threec/socket.dart';

class SocketStatus extends StatefulWidget {
  const SocketStatus({
    Key key,
  }) : super(key: key);

  @override
  _SocketStatusState createState() => _SocketStatusState();
}

class _SocketStatusState extends State<SocketStatus> {
  WS ws = WS();
  String status = "";
  bool isConnect = false;

  double bannerHeight = 0;

  @override
  void initState() {
    super.initState();

    //first check
    if(! ws.socket.connected){
      isConnect = false;
      bannerHeight = 30;
      status = "Connecting...";
    }

    ws.socketIsConnectCallback = (bool connected) {
      updateStatus(connected);
    };
  }

  updateStatus(bool connected) {
    setState(() {
      isConnect = connected;
      status = connected ? "Connected" : "Connecting...";
    });

    if (connected) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        setState(() {
          bannerHeight = 0;
        });
      });
    } else {
      setState(() {
        bannerHeight = 30;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: bannerHeight,
      width: double.infinity,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      color: isConnect ? Colors.greenAccent : Colors.orangeAccent,
      child: Center(child: Text("$status",style: TextStyle(fontWeight: FontWeight.w300),)),
    );
  }
}
