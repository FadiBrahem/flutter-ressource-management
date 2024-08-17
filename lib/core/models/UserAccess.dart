
import 'package:naxxum_projectplanner_mobile_local/core/models/RoleServices.dart';

class UserAccess{
  List<RoleServices> services;
  String roleName;

  UserAccess({this.services,this.roleName});

  factory UserAccess.fromJson(Map<String,dynamic> json){
     var lstServices = json['services'] as List;
    List<RoleServices> servicesList =
        lstServices.map((i) => RoleServices.fromJson(i)).toList();
    return UserAccess(
      services: servicesList,
      roleName: json['roleName']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "services":services != null ? services : <RoleServices>[],
      "roleName" : roleName
    };
  }
}