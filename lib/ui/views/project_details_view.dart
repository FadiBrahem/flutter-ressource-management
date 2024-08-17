import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectRessources.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/project.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelUpdateProject.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/ButtonWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/Drawer%20Widgets/AppDrawer.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/DropDownWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextFormFieldWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextWidget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/busy_overlay.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/ressource_listview_item.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:intl/intl.dart';

class ProjectDetailsView extends StatefulWidget {
  final Project project;

  ProjectDetailsView({@required this.project});

  @override
  _ProjectDetailsViewState createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<ProjectDetailsView> {
  //Form Fields
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleEditingController;
  TextEditingController _descriptionEditingController;
  FocusNode _titleFN = new FocusNode();
  FocusNode _descriptionFN = new FocusNode();
  bool _titleEnabled, _descriptionEnabled;

  //Project Fields
  String _selectedStatus;
  DateTime _dateStartProject;
  DateTime _dateEndProject;
  List<ProjectResources> _lstProjectRessource;
  List<String> _selectedList;

  @override
  void initState() {
    super.initState();
    print(widget.project.idEntreprise);
    _titleEditingController = TextEditingController(text: widget.project.title);
    _descriptionEditingController =
        TextEditingController(text: widget.project.description);
    _titleEnabled = false;
    _descriptionEnabled = false;
    _selectedStatus = widget.project.statuts;
    _dateStartProject = widget.project.dateDebut;
    _dateEndProject = widget.project.dateFin;
    _lstProjectRessource = List<ProjectResources>();
    _lstProjectRessource = widget.project.projectResources;
    _selectedList = List<String>();
    for (var i = 0; i < _lstProjectRessource.length; i++) {
      _selectedList.add(_lstProjectRessource[i].getIdResource);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ViewModelProvider<ViewModelUpdateProject>.withConsumer(
      viewModel: ViewModelUpdateProject(),
      onModelReady: (model) => model.fetchAllResources(),
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
            child: Form(
              key: _formKey,
              child: Container(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          widget.project.title + " details",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      verticalSpaceSmall,
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextWidget(
                          text: "Title",
                        ),
                      ),
                      verticalSpaceSmall,
                      _buildTitle(),
                      verticalSpaceSmall,
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextWidget(
                          text: "Description",
                        ),
                      ),
                      verticalSpaceSmall,
                      _buildDescription(),
                      verticalSpaceSmall,
                      Row(
                        children: <Widget>[
                          Container(
                            width: screenWidth(context) / 2 - 20,
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(text: "Date Debut :"),
                                ),
                                verticalSpaceTiny,
                                Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: <Widget>[
                                        _dateStartProject != null
                                            ? new Text(
                                                new DateFormat('yyyy-MM-dd')
                                                    .format(_dateStartProject),
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
                                  child: TextWidget(text: "Date Fin :"),
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
                      verticalSpaceSmall,
                      _buildStatus(),
                      verticalSpaceSmall,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextWidget(text: "Affecter Ressources :"),
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
                                ressourceName: model.resources[index].getName +
                                    " " +
                                    model.resources[index].lastName,
                                ressourceRole:
                                    model.resourcesAccess[index].roleName,
                                urlImgRessource:
                                    "https://cdn.maikoapp.com/3d4b/4quqa/150.jpg",
                                isChecked: _selectedList
                                    .contains(model.resources[index].getId),
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      if (_verifProjectRessources(
                                              _lstProjectRessource,
                                              model.resources[index].id) ==
                                          false) {
                                        _selectedList
                                            .add(model.resources[index].getId);
                                        _lstProjectRessource.add(
                                            ProjectResources(
                                                idRessource:
                                                    model.resources[index].id,
                                                idRole: model
                                                    .resources[index].roleId));
                                      }
                                    } else {
                                      _selectedList
                                          .remove(model.resources[index].getId);
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
                      verticalSpaceSmall,
                      Align(
                        alignment: Alignment.topCenter,
                        child: ButtonWidget(
                          text: "Save",
                          onPressed: () {
                            widget.project.dateDebut = _dateStartProject;
                            widget.project.dateFin = _dateEndProject;
                            model.updateProjet(widget.project, ctx);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    _titleFN.dispose();
    _descriptionFN.dispose();
  }

  Widget _buildTitle() {
    return InkWell(
      onLongPress: () {
        setState(() {
          _titleEnabled = true;
          _titleFN.requestFocus();
        });
      },
      child: TextFormFieldWidget(
        textEditingController: _titleEditingController,
        isEnabled: _titleEnabled,
        prefixIcon: Icons.title,
        inputBorder: new OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.next,
        fieldFocusNode: _titleFN,
        nextFocusNode: _descriptionFN,
        onChanged: (value) {
          widget.project.setTitle = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return "Title should not be empty";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDescription() {
    return InkWell(
      onLongPress: () {
        setState(() {
          _descriptionEnabled = true;
        });
      },
      child: TextFormFieldWidget(
        textEditingController: _descriptionEditingController,
        isEnabled: _descriptionEnabled,
        maxLines: 2,
        prefixIcon: Icons.description,
        textAlign: TextAlign.start,
        fieldFocusNode: _descriptionFN,
        textInputAction: TextInputAction.next,
        inputBorder: new OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        onChanged: (value) {
          widget.project.setDescription = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return "Description should not be empty";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildStatus() {
    return Row(
      children: <Widget>[
        horizontalSpaceSmall,
        TextWidget(
          text: "Statuts :",
        ),
        horizontalSpaceMedium,
        DropDownWidget(
            itemsToBeSelected: _listDropDownStatuts(),
            selectedItem: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
                widget.project.setStatuts = value;
              });
            }),
      ],
    );
  }

  _showDateStartedTimePicker() async {
    _dateStartProject = await showDatePicker(
      context: context,
      initialDate: _dateStartProject,
      firstDate: DateTime(1960),
      lastDate: DateTime(2050),
    );
    setState(() {});
  }

  _showDateEndTimePicker() async {
    _dateEndProject = await showDatePicker(
      context: context,
      initialDate: _dateEndProject,
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
    setState(() {});
  }
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
