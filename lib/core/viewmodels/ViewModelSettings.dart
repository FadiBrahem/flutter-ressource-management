import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/BaseModel.dart';
import 'package:i18n_extension/i18n_widget.dart';

class ViewModelSettings extends BaseModel {
  void switchLanguage(String language, BuildContext context) {
    setState(ViewState.Busy);
    switch (language) {
      case "English":
        I18n.of(context).locale = null;
        break;
      case "French":
        I18n.of(context).locale = Locale("fr");
        break;
      default:
        print("no language");
        break;
    }
    setState(ViewState.Idle);
  }
}
