import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naxxum_projectplanner_mobile_local/core/enums/enums.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/ViewModelAjouterDocument.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/Drawer%20Widgets/AppDrawer.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextFormFieldWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/TextWidget.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/widgets/busy_overlay.dart';
import 'package:provider_architecture/provider_architecture.dart';

class AjouterDocumentView extends StatefulWidget {
  @override
  _AjouterDocumentViewState createState() => _AjouterDocumentViewState();
}

class _AjouterDocumentViewState extends State<AjouterDocumentView> {
  //Form Fields
  final _formKey = GlobalKey<FormState>();
  TextEditingController _editingControllerTitle, _editingControllerNotes;
  FocusNode _titleFocusNode, _notesFocusNode;

  @override
  void initState() {
    super.initState();
    _editingControllerTitle = TextEditingController();
    _editingControllerNotes = TextEditingController();
    _titleFocusNode = FocusNode();
    _notesFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ViewModelProvider<ViewModelAjouterDocument>.withConsumer(
      viewModel: ViewModelAjouterDocument(),
      builder: (context, model, child) => Scaffold(
        drawer: AppDrawer(),
        backgroundColor: Color.fromARGB(240, 248, 255, 255),
        appBar: AppBar(
          title: Text("Ressource Management"),
        ),
        body: Builder(
          builder: (BuildContext ctx) {
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
                            "Assign Document",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        verticalSpaceMedium,
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextWidget(
                            text: "Title",
                          ),
                        ),
                        verticalSpaceSmall,
                        _buildTitle(_editingControllerTitle, _titleFocusNode,
                            _notesFocusNode),
                        verticalSpaceSmall,
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextWidget(
                            text: "Description",
                          ),
                        ),
                        verticalSpaceSmall,
                        _buildNotes(_editingControllerNotes, _notesFocusNode),
                        verticalSpaceSmall,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle(TextEditingController editingController,
      FocusNode actualFN, FocusNode nextFN) {
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
          return "Title should not be empty";
        }
        return null;
      },
    );
  }

  Widget _buildNotes(
      TextEditingController editingController, FocusNode actualFN) {
    return TextFormFieldWidget(
      textAlign: TextAlign.start,
      prefixIcon: Icons.description,
      textEditingController: editingController,
      maxLines: 4,
      inputBorder: new OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      textInputAction: TextInputAction.next,
      fieldFocusNode: actualFN,
      validator: (String value) {
        if (value.isEmpty) {
          return "Description should not be empty";
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _editingControllerTitle.dispose();
    _editingControllerNotes.dispose();
    _titleFocusNode.dispose();
    _notesFocusNode.dispose();
  }
}
