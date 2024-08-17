import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectRessources.dart';
import 'package:naxxum_projectplanner_mobile_local/core/models/ProjectTask.dart';

class Project {
  String id;
  String title;
  String description;
  String statuts;
  DateTime dateDebut;
  DateTime dateFin;
  DateTime createdOn;
  DateTime updatedOn;
  String idEntreprise;
  List<ProjectTask> projectTasks;
  List<ProjectResources> projectResources;

  Project({
    this.id,
    this.title,
    this.description,
    this.statuts,
    this.dateDebut,
    this.dateFin,
    this.createdOn,
    this.updatedOn,
    this.idEntreprise,
    this.projectTasks,
    this.projectResources
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    var lstTasks = json['projectTasks'] as List;
    List<ProjectTask> tasksList =
        lstTasks.map((i) => ProjectTask.fromJson(i)).toList();
    var lstRess = json['projectResources'] as List;
    List<ProjectResources> ressourcesList =
        lstRess.map((i) => ProjectResources.fromjson(i)).toList();
    return Project(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        statuts: json['statuts'],
        dateDebut: DateTime.tryParse(json['date_debut']),
        dateFin: DateTime.tryParse(json['date_fin']),
        createdOn: DateTime.tryParse(json['createdOn']),
        updatedOn: DateTime.tryParse(json['updatedOn']),
        idEntreprise: json['idEnterprise'],
        projectTasks: tasksList,
        projectResources: ressourcesList
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'statuts': statuts,
      'date_debut': dateDebut.toIso8601String(),
      'date_fin': dateFin.toIso8601String(),
      'idEnterprise' : idEntreprise,
      'projectTasks': projectTasks != null ? projectTasks : <ProjectTask>[],
      'projectResources' : projectResources != null ? projectResources : <ProjectResources>[]
    };
  }

  String get getId {
    return id;
  }


  String get getTitle {
    return title;
  }

  set setTitle(String title) {
    this.title = title;
  }

  String get getDescription {
    return description;
  }

  set setDescription(String newDescription) {
    description = newDescription;
  }

  String get getStatuts {
    return statuts;
  }

  set setStatuts(String newStatuts) {
    statuts = newStatuts;
  }

  DateTime get getDateDebut {
    return dateDebut;
  }

  set setDateDebut(DateTime newDateDebut) {
    dateDebut = newDateDebut;
  }

  DateTime get getDateFin {
    return dateFin;
  }

  set setDateFin(DateTime newDateFin) {
    dateFin = newDateFin;
  }

  String get getIdEntreprise{
    return idEntreprise;
  }

  set setIdEntreprise(String idEnt){
    idEntreprise = idEnt;
  }

  List<ProjectTask> get getProjectTasks {
    return projectTasks;
  }

  void setProjectTasks(List<ProjectTask> lstTasks) {
    projectTasks = lstTasks;
  }

  List<ProjectResources> get getProjectRessources{
    return projectResources;
  }

  void setProjectRessources(List<ProjectResources> lstRessources){
    projectResources = lstRessources;
  }
}
