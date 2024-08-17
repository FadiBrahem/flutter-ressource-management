import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/dialog_models.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/DialogService.dart';
import 'package:naxxum_projectplanner_mobile_local/locator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  DialogManager({Key key, this.child}) : super(key: key);

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }

//Alert Dialog design using rFlutter => for custom design we should change the Alert with standard AlertDialog and custom it
  void _showDialog(DialogRequest request) {
    Alert(
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () =>
            _dialogService.dialogComplete(DialogResponse(confirmed: false)),
        buttons: [
          DialogButton(
            child: Text(request.buttonTitle),
            onPressed: () {
              _dialogService.dialogComplete(DialogResponse(confirmed: true));
            },
          )
        ]).show();
  }
}
