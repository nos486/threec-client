import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:threec/models/app.dart';
import 'package:threec/models/user.dart';
import 'package:threec/services/authentication.dart';
import 'package:threec/services/captcha.dart';
import 'package:threec/store.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final textFiledCaptcha = TextEditingController();
  String username = "", password = "";
  String stringSvg, captcha = "", captchaKey = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      Store().openBoxes().then((_){
        print(Store().storeBox.get("jwtToken"));
        if (Store().storeBox.containsKey("userId")){
          Navigator.pushReplacementNamed(context, '/home');
        }else{
          updateCaptcha();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 350),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.vpn_lock,
                    color: Theme.of(context).primaryColor,
                    size: 120,
                  ),
                  Text(
                    "THREEC",
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextField(
                    onChanged: (val) {
                      username = val;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        hintText: 'Enter username'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    obscureText: true,
                    onChanged: (val) {
                      password = val;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter password'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    maxLength: 4,
                    controller: textFiledCaptcha,
                    onChanged: (val) {
                      captcha = val;
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        border: OutlineInputBorder(),
                        suffixIcon: (stringSvg != null)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.string(
                                  stringSvg,
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .color,
                                ),
                              )
                            : Container(
                                height: 50,
                                width: 100,
                                child: LoadingFlipping.circle(
                                  borderColor: Theme.of(context).primaryColor,
                                ),
                              ),
                        labelText: 'Captcha',
                        hintText: 'Enter captcha'),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      loginButtonClick(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void loginButtonClick(BuildContext context) {
    context.showLoaderOverlay();
    FocusScope.of(context).requestFocus(new FocusNode());

    Authentication().login(username, password, captcha, captchaKey).then((res) {
      context.hideLoaderOverlay();


      if (res.statusCode == 200) {
        print(res.data);


        User user = new User(id: res.data["id"], username: res.data["username"], email: res.data["email"]);
        user.setRole(res.data["role"]);

        Store().userBox.put(user.id, user);

        Store().storeBox.put("userId", user.id);
        Store().storeBox.put("jwtToken", res.data["jwtToken"]);
        Store().storeBox.put("refreshToken", res.data["refreshToken"]);

        // after save token to db
        user.updateAvatar();


        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print(res);
        updateCaptcha();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res.data["message"])));
      }
    });

  }

  void updateCaptcha() {
    Captcha().getCaptcha().then((res) {
      setState(() {
        textFiledCaptcha.clear();
        stringSvg = res.data["svg"];
        captchaKey = res.data["key"];
      });
    });
  }
}
