import 'package:flutter/material.dart';

class Confirmdialog {
  const Confirmdialog(
      {@required this.title,
      @required this.message,
      @required this.confirm_button,
      @required this.cancel_button,
      @required this.onConfirmation})
      : assert(title != null),
        assert(message != null),
        assert(confirm_button != null),
        assert(cancel_button != null),
        assert(onConfirmation != null);

  final String title, message, confirm_button, cancel_button;
  final VoidCallback onConfirmation;

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(cancel_button, style: TextStyle(color: Colors.black87)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(confirm_button, style: TextStyle(color: Colors.black87)),
      onPressed: () {
        Navigator.of(context).pop();
        onConfirmation();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
