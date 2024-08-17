class ProjectTask {
  String id;
  String title;
  String description;
  String status;
  DateTime startDate;
  DateTime endDate;
  DateTime createdOn;
  DateTime updatedOn;
  String idResource;

  ProjectTask(
      {this.id,
      this.title,
      this.description,
      this.status,
      this.startDate,
      this.endDate,
      this.createdOn,
      this.updatedOn,
      this.idResource});

  factory ProjectTask.fromJson(Map<String, dynamic> json) {
    return ProjectTask(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: json['status'],
        startDate: DateTime.tryParse(json['startDate']),
        endDate: DateTime.tryParse(json['endDate']),
        createdOn: DateTime.tryParse(json['createdOn']),
        updatedOn: DateTime.tryParse(json['updatedOn']),
        idResource: json['idResource']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'idResource': idResource
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
    return status;
  }

  set setStatuts(String newStatuts) {
    status = newStatuts;
  }

  DateTime get getStartDate {
    return startDate;
  }

  set setDateDebut(DateTime newDateDebut) {
    startDate = newDateDebut;
  }

  DateTime get getEndDate {
    return endDate;
  }

  set setDateFin(DateTime newDateFin) {
    endDate = newDateFin;
  }

  String get getIdResource {
    return idResource;
  }

  set setIdRessource(String idRess) {
    idResource = idRess;
  }
}
