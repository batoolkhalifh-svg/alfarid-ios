class StudentsModel {
  List<DataS>? data;
  String? message;
  bool? success;

  StudentsModel({this.data, this.message, this.success});

  StudentsModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <DataS>[];
      json['data'].forEach((v) {
        data!.add( DataS.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

}

class DataS {
  int? id;
  String? name;

  DataS({this.id, this.name});

  DataS.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
