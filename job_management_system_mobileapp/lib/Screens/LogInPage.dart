import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  double? _deviceHeight, _deviceWidth;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 227, 223, 1),
      body: Container(
        child: Stack(
          children: [
            _loginTopDecoration(),
            Column(
              children: [
                SizedBox(
                  height: _deviceHeight! * 0.12,
                ),
                _avatar_image(),
              ],
            ),
            //_loginForm(),
          ],
        ),
      ),
    );
  }

  Widget _loginText() {
    return Container(
      margin: EdgeInsets.only(
        left: _deviceWidth! * 0.05,
        //top: _deviceHeight! * 0.05,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Login",
            style: TextStyle(
              fontSize: 40,
            ),
          ),
          Text(
            "Welcome Back !",
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }

  Widget _avatar_image() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: _deviceWidth! * 0.05),
        height: _deviceHeight! * 0.15,
        width: _deviceHeight! * 0.15,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2.0,
              spreadRadius: 0.5,
              offset: Offset(0, 2), // adjust the vertical offset
            ),
          ],
          color: Color.fromARGB(255, 255, 219, 195),
          borderRadius: BorderRadius.circular(500),
          image: const DecorationImage(
            image: AssetImage("assets/images/main_avatar.png"),
          ),
        ),
      ),
    );
  }

  Widget _loginTopDecoration() {
    return Column(
      children: [
        Container(
          height: _deviceHeight! * 0.2,
          width: _deviceWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2.0,
                spreadRadius: 0.5,
                offset: Offset(0, 2), // adjust the vertical offset
              ),
            ],
            color: const Color.fromARGB(255, 255, 102, 0),
            borderRadius: const BorderRadius.only(
              //bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: _loginText(),
        ),
        SizedBox(height: _deviceHeight! * 0.02,),
        Expanded(
          child: Container(
            decoration:  BoxDecoration(
              boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2.0,
                spreadRadius: 0.5,
                offset: Offset(2, 0), // adjust the vertical offset
              ),
            ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                )),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //SizedBox(height: 60,),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .2),
                                  blurRadius: 20,
                                  offset: Offset(0, 0))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: const TextField(
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: const TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1500),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.grey),
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1600),
                      child: MaterialButton(
                        onPressed: () {},
                        height: 50,
                        // margin: EdgeInsets.symmetric(horizontal: 50),
                        color: Colors.orange[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        // decoration: BoxDecoration(
                        // ),
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginForm() {
    return Container();
  }
}
