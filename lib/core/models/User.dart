
class User{
   String id;
   String name;
   String lastName;
   String phoneNumber;
   String email;
   String roleId;
  
  User({this.id,this.name,this.lastName,this.phoneNumber,this.email,this.roleId});

  factory User.fromJson(Map<String,dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      roleId: json['roleId']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "id":id,
      "name" : name,
      "lastName" : lastName,
      "phoneNumber" : phoneNumber,
      "email": email,
      "roleId" : roleId
    };
  }

String get getId {
    return id;
  }

String get getName{
  return name;
}

String get getlastName{
  return lastName;
}

String get getPhoneNumber{
  return phoneNumber;
}

String get getEmail{
  return email;
}

String get getRoleId{
  return roleId;
}

set setName(String newName){
  name = newName;
}

set setLastName(String lastN){
  lastName = lastN;
}

set setPhoneNumber(String newPhoneNumber){
  phoneNumber = newPhoneNumber;
}

set setEmail(String newEmail){
 email= newEmail;
}

set setRoleId(String newRole){
  roleId = newRole;
}


}