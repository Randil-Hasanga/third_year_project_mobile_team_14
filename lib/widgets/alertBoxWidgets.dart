import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AlertBoxWidgets {
  AlertBoxWidgets();

  void showAlert(BuildContext context, QuickAlertType alertType, String title) {
    QuickAlert.show(
      context: context,
      type: alertType,
      title: title,
    );
  }
}
