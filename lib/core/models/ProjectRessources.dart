
class ProjectResources {
  String idRessource;
  String idRole;

  ProjectResources({this.idRessource,this.idRole});

  factory ProjectResources.fromjson(Map<String,dynamic> json){
    return ProjectResources(
      idRessource: json['idResource'],
      idRole: json['idRole']
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'idResource': idRessource,
      'idRole': idRole,
    };
  }

  String get getIdResource{
    return idRessource;
  }

  String get getIdRole{
    return idRole;
  }
  
  set setIdRole(String newidRole){
    idRole = newidRole;
  }

  set setIdResource(String newidResource){
    idRessource = newidResource;
  }

}