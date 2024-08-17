import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectRessources.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelAjouterProjet.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/ButtonWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/Drawer%20Widgets/AppDrawer.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/DropDownWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextFormFieldWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/busy_overlay.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/ressource_listview_item.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl/intl.dart';
import 'package:naxxum_projectplanner_mobile_local/i18n/translations.i18n.dart';

class AjouterProjetView extends StatefulWidget {
  @override
  _AjouterProjetViewState createState() => _AjouterProjetViewState();
}

class _AjouterProjetViewState extends State<AjouterProjetView> {
  //Form Fields
  final _formKey = GlobalKey<FormState>();
  TextEditingController _editingControllerTitle, _editingControllerDescription;
  FocusNode _titleFocusNode, _descriptionFocusNode;

  //Project Fields
  DateTime _dateStartProject, _dateEndProject;
  String _statusSelectedItem;
  List<ProjectResources> _lstProjectRessource;
  List<String> _selectedList;

  @override
  void initState() {
    super.initState();
    _editingControllerTitle = TextEditingController();
    _editingControllerDescription = TextEditingController();
    _titleFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _dateStartProject =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _dateEndProject =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _statusSelectedItem = EnumToString.parse(ProjectStatus.NotStarted);
    _lstProjectRessource = List<ProjectResources>();
    _selectedList = List<String>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ViewModelProvider<ViewModelAjouterProjet>.withConsumer(
      viewModel: ViewModelAjouterProjet(),
      onModelReady: (model) => model.fetchAllResources(),
      builder: (context, model, child) => Scaffold(
        drawer: AppDrawer(),
        backgroundColor: Color.fromARGB(240, 248, 255, 255),
        appBar: AppBar(
          title: Text("Ressource Management"),
        ),
        body: Builder(builder: (BuildContext ctx) {
          return BusyOverlay(
            show: model.state == ViewState.Busy,
            isDisabled: model.state == ViewState.Busy ? true : false,
            child: Form(
                key: _formKey,
                child: Container(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "New Project".i18n,
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        verticalSpaceSmall,
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextWidget(
                            text: "Title".i18n,
                          ),
                        ),
                        verticalSpaceSmall,
                        _buildTitle(_editingControllerTitle, _titleFocusNode,
                            _descriptionFocusNode),
                        verticalSpaceMedium,
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextWidget(
                            text: "Description".i18n,
                          ),
                        ),
                        verticalSpaceSmall,
                        _buildDescription(_editingControllerDescription,
                            _descriptionFocusNode),
                        verticalSpaceMedium,
                        Row(
                          children: <Widget>[
                            Container(
                              width: screenWidth(context) / 2 - 20,
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: TextWidget(text: "Start Date".i18n),
                                  ),
                                  verticalSpaceTiny,
                                  Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: <Widget>[
                                          _dateStartProject != null
                                              ? new Text(
                                                  new DateFormat('yyyy-MM-dd')
                                                      .format(
                                                          _dateStartProject),
                                                  style: new TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.0,
                                                  ),
                                                )
                                              : new SizedBox(
                                                  width: 0.0,
                                                  height: 0.0,
                                                ),
                                          IconButton(
                                            icon: new Icon(
                                              Icons.date_range,
                                              color: Colors.black,
                                            ),
                                            onPressed: () =>
                                                _showDateStartedTimePicker(),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              width: (screenWidth(context) / 2 - 20),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: TextWidget(text: "End Date".i18n),
                                  ),
                                  verticalSpaceTiny,
                                  Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: <Widget>[
                                          _dateEndProject != null
                                              ? new Text(
                                                  new DateFormat('yyyy-MM-dd')
                                                      .format(_dateEndProject),
                                                  style: new TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.0,
                                                  ),
                                                )
                                              : new SizedBox(
                                                  width: 0.0,
                                                  height: 0.0,
                                                ),
                                          IconButton(
                                            icon: new Icon(
                                              Icons.date_range,
                                              color: Colors.black,
                                            ),
                                            onPressed: () =>
                                                _showDateEndTimePicker(),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceTiny,
                        Row(
                          children: <Widget>[
                            TextWidget(
                              text: "Status".i18n,
                            ),
                            horizentalSpace(50),
                            DropDownWidget(
                              itemsToBeSelected: _listDropDownStatuts(),
                              selectedItem: _statusSelectedItem,
                              onChanged: (String value) {
                                setState(() {
                                  _statusSelectedItem = value;
                                });
                              },
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextWidget(text: "Assign Resources".i18n),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            height: screenHeight(context) / 5,
                            child: new ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: model.resources.length,
                              itemBuilder: (context, index) {
                                return RessourceListViewItem(
                                  ressourceName:
                                      model.resources[index].getName +
                                          " " +
                                          model.resources[index].lastName,
                                  ressourceRole:
                                      model.userAccess[index].roleName,
                                  urlImgRessource:
                                      "https://cdn.maikoapp.com/3d4b/4quqa/150.jpg",
                                  isChecked: _selectedList
                                      .contains(model.resources[index].getId),
                                  onChanged: (bool value) {
                                    setState(() {
                                      print(value);
                                      if (value) {
                                        if (_verifProjectRessources(
                                                _lstProjectRessource,
                                                model.resources[index].id) ==
                                            false) {
                                          _selectedList.add(
                                              model.resources[index].getId);
                                          _lstProjectRessource.add(
                                              ProjectResources(
                                                  idRessource:
                                                      model.resources[index].id,
                                                  idRole: model.resources[index]
                                                      .roleId));
                                        }
                                      } else {
                                        _selectedList.remove(
                                            model.resources[index].getId);
                                        _lstProjectRessource.removeWhere((pr) =>
                                            pr.getIdResource ==
                                            model.resources[index].getId);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        verticalSpaceTiny,
                        ButtonWidget(
                          text: "Save".i18n,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              Project newProject = Project(
                                  title: _editingControllerTitle.text,
                                  description:
                                      _editingControllerDescription.text,
                                  statuts: _statusSelectedItem,
                                  dateDebut: _dateStartProject,
                                  dateFin: _dateEndProject,
                                  projectResources:
                                      _lstProjectRessource.length != 0
                                          ? _lstProjectRessource
                                          : <ProjectResources>[]);
                              model.ajouterProjet(newProject, ctx);
                              resetForm(_formKey, _editingControllerTitle,
                                  _editingControllerDescription, _selectedList);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _editingControllerTitle.dispose();
    _editingControllerDescription.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  _showDateStartedTimePicker() async {
    _dateStartProject = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
    setState(() {});
  }

  _showDateEndTimePicker() async {
    _dateEndProject = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
    setState(() {});
  }
}

Widget _buildTitle(TextEditingController editingController, FocusNode actualFN,
    FocusNode nextFN) {
  return TextFormFieldWidget(
    textAlign: TextAlign.start,
    prefixIcon: Icons.title,
    textEditingController: editingController,
    inputBorder: new OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    textInputAction: TextInputAction.next,
    fieldFocusNode: actualFN,
    nextFocusNode: nextFN,
    validator: (String value) {
      if (value.isEmpty) {
        return "Title should not be empty".i18n;
      }
      return null;
    },
  );
}

Widget _buildDescription(
    TextEditingController editingController, FocusNode actualFN) {
  return TextFormFieldWidget(
    textAlign: TextAlign.start,
    prefixIcon: Icons.description,
    textEditingController: editingController,
    maxLines: 2,
    inputBorder: new OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    textInputAction: TextInputAction.next,
    fieldFocusNode: actualFN,
    validator: (String value) {
      if (value.isEmpty) {
        return "Description should not be empty".i18n;
      }
      return null;
    },
  );
}

List<String> _listDropDownStatuts() {
  List<String> itemsTobeSelected = [
    EnumToString.parse(ProjectStatus.NotStarted),
    EnumToString.parse(ProjectStatus.Started),
    EnumToString.parse(ProjectStatus.InProgress),
    EnumToString.parse(ProjectStatus.Archived),
  ];
  return itemsTobeSelected;
}

void resetForm(GlobalKey<FormState> globalKey, TextEditingController titleEC,
    TextEditingController descriptionEC, List<String> selectedRess) {
  globalKey.currentState.reset();
  titleEC.clear();
  descriptionEC.clear();
  selectedRess.clear();
}

bool _verifProjectRessources(List<ProjectResources> lstPR, String idRess) {
  int i = 0;
  bool result = false;
  while (i < lstPR.length) {
    if (lstPR[i].getIdResource == idRess) {
      result = true;
      return result;
    }
    i++;
  }

  return result;
}
