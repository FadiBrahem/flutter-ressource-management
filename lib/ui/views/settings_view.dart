import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelSettings.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/Drawer%20Widgets/AppDrawer.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/DropDownWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/busy_overlay.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:naxxum_projectplanner_mobile_local/i18n/translations.i18n.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _statusSelectedItem;

  @override
  void initState() {
    super.initState();
    _statusSelectedItem = EnumToString.parse(I18nLanguage.English);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ViewModelProvider<ViewModelSettings>.withConsumer(
        viewModel: ViewModelSettings(),
        builder: (context, model, child) => Scaffold(
              drawer: AppDrawer(),
              backgroundColor: Color.fromARGB(240, 248, 255, 255),
              appBar: AppBar(
                title: Text("Ressource Management"),
              ),
              body: BusyOverlay(
                show: model.state == ViewState.Busy,
                isDisabled: model.state == ViewState.Busy ? true : false,
                child: Container(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Settings".i18n,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      verticalSpaceMedium,
                      Row(
                        children: <Widget>[
                          TextWidget(
                            text: "Switch language to:",
                          ),
                          horizentalSpace(10),
                          DropDownWidget(
                            itemsToBeSelected: _listDropDownStatuts(),
                            selectedItem: _statusSelectedItem,
                            onChanged: (String value) {
                              setState(() {
                                _statusSelectedItem = value;
                                model.switchLanguage(
                                    _statusSelectedItem, context);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}

List<String> _listDropDownStatuts() {
  List<String> itemsTobeSelected = [
    EnumToString.parse(I18nLanguage.English),
    EnumToString.parse(I18nLanguage.French),
  ];
  return itemsTobeSelected;
}
