import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelConsulterProjet.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/Drawer%20Widgets/AppDrawer.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/ListViewItem.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextFormFieldWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/busy_overlay.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ConsulterProjetView extends StatefulWidget {
  @override
  _ConsulterProjetViewState createState() => _ConsulterProjetViewState();
}

class _ConsulterProjetViewState extends State<ConsulterProjetView> {
  TextEditingController _searchEditingController;
  FocusNode _searchFN;

  @override
  void initState() {
    super.initState();
    _searchEditingController = TextEditingController();
    _searchFN = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ViewModelProvider<ViewModelConsulterProjet>.withConsumer(
      viewModel: ViewModelConsulterProjet(),
      onModelReady: (model) => model.fetchAllProjects(""),
      builder: (context, model, child) => Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Ressource Management"),
          backgroundColor: Colors.blue,
        ),
        body: Builder(builder: (BuildContext ctx) {
          return BusyOverlay(
            show: model.state == ViewState.Busy,
            isDisabled: model.state == ViewState.Busy ? true : false,
            child: Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: TextFormFieldWidget(
                      textEditingController: _searchEditingController,
                      textAlign: TextAlign.start,
                      counterColor: Colors.blue,
                      labelText: "Search",
                      labelTextColor: Colors.blue,
                      textInputAction: TextInputAction.search,
                      fieldFocusNode: _searchFN,
                      labelTextFontWeight: FontWeight.bold,
                      prefixIcon: Icons.search,
                      prefixColorIcon: Colors.blue,
                      inputBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      onEditingComplete: () =>
                          model.fetchAllProjects(_searchEditingController.text),
                    ),
                  ),
                  verticalSpaceSmall,
                  TextWidget(
                      text: "Displaying " +
                          model.projects.length.toString() +
                          " Projects"),
                  verticalSpaceSmall,
                  Expanded(
                    child: Container(
                      child: new ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: model.projects.length,
                        itemBuilder: (context, index) {
                          return ListViewItem(
                            project: model.projects[index],
                            onTap: () => model
                                .navigateToUpdateView(model.projects[index]),
                            onLongPress: () => model.supprimerProjet(
                                model.projects[index], ctx),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchEditingController.dispose();
    _searchFN.dispose();
  }
}
