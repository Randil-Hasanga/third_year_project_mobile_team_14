import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:job_management_system_mobileapp/widgets/alertBoxWidgets.dart';
import 'package:job_management_system_mobileapp/widgets/appbar_widget.dart';
import 'package:job_management_system_mobileapp/widgets/buttons.dart';
import 'package:job_management_system_mobileapp/widgets/textfield_widgets.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  final AppBarWidget _appBarWidget = AppBarWidget();
  final ButtonWidgets _buttonWidgets = ButtonWidgets();
  final TextFieldWidgets _textFieldWidgets = TextFieldWidgets();
  final AlertBoxWidgets _alertBoxWidgets = AlertBoxWidgets();
  double? _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;
  final GlobalKey<FormState> _changePasswordFormKey = GlobalKey<FormState>();
  bool showTextOldPwd = true;
  bool showTextNewPwd = true;
  bool showTextNewPwdReEnter = true;

  String? _oldPwd, _newPwd, _reenterNewPwd;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBarWidget.simpleAppBarWidget("Change Password", 20),
      bottomNavigationBar: _appBarWidget.bottomAppBarSeeker(context),
      backgroundColor: ScaffoldColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _changePasswordForm(),
          ],
        ),
      )),
    );
  }

  Widget _changePasswordForm() {
    return Container(
      child: Form(
        key: _changePasswordFormKey,
        child: Column(
          children: [
            SizedBox(
              height: _deviceHeight! * 0.05,
            ),
            _textFieldWidgets.passwordTextField(showTextOldPwd, () {
              setState(() {
                showTextOldPwd = !showTextOldPwd;
              });
            }, (value) {
              setState(() {
                _oldPwd = value;
                print(value);
              });
            }, "Enter your old password"),
            SizedBox(
              height: _deviceHeight! * 0.03,
            ),
            _textFieldWidgets.passwordTextField(showTextNewPwd, () {
              setState(() {
                showTextNewPwd = !showTextNewPwd;
              });
            }, (value) {
              setState(() {
                _newPwd = value;
              });
            }, "Enter your new password"),
            SizedBox(
              height: _deviceHeight! * 0.03,
            ),
            _textFieldWidgets.passwordTextField(showTextNewPwdReEnter, () {
              setState(() {
                showTextNewPwdReEnter = !showTextNewPwdReEnter;
              });
            }, (value) {
              setState(() {
                _reenterNewPwd = value;
              });
            }, "Re-enter new password"),
            SizedBox(
              height: _deviceHeight! * 0.03,
            ),
            _buttonRow(),
          ],
        ),
      ),
    );
  }

  Widget _buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buttonWidgets.simpleElevatedButtonWidget(
          onPressed: () {
            _validateAndVerify();
          },
          buttonText: "Change Password",
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 231, 104, 104),
          ),
        ),
      ],
    );
  }

  void _validateAndVerify() async {
    if (_changePasswordFormKey.currentState!.validate()) {
      print("$_oldPwd $_newPwd $_reenterNewPwd");

      if (_newPwd == _reenterNewPwd) {
        _changePasswordFormKey.currentState!.save();
        print("$_oldPwd $_newPwd $_reenterNewPwd");
        bool result = await _firebaseService!.validateCurrentPassword(_oldPwd!);
        if (result) {
          print("Password correct");
          bool result = await _firebaseService!.changePassword(_newPwd!);
          if (result) {
            print("Password Change Successfull");
            showAlertAndRedirectToLogin();
          } else {
            print("Password Change failed");
            _alertBoxWidgets.showAlert(
                context, QuickAlertType.error, "Password Change failed");
          }
        } else {
          print("Password incorrect");
          _alertBoxWidgets.showAlert(
              context, QuickAlertType.error, "Old Password is Incorrect");
        }
      } else {
        print("Passwords does not match");
        _alertBoxWidgets.showAlert(
            context, QuickAlertType.error, "Passwords Doesn't Match");
      }
    }
  }

  void showAlertAndRedirectToLogin() {
    QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "Password change successfull.")
        .then((_) {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    });
  }
}
