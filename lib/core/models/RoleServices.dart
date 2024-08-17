
class RoleServices{
  String id;
  String serviceName;
  String icon;
  String path;

  RoleServices({this.id,this.serviceName,this.icon,this.path});


  factory RoleServices.fromJson(Map<String,dynamic> json){
    return RoleServices(
      id: json['id'],
      serviceName: json['serviceName'],
      icon: json['icon'],
      path: json['path']
    );
  }

}