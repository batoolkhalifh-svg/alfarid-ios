class VrLabModel {
  final int? id;
  final String? subject;
  final String? labName;
  final String? vrModel;
  final String? description;

  VrLabModel({
    this.id,
    this.subject,
    this.labName,
    this.vrModel,
    this.description,
  });

  factory VrLabModel.fromJson(Map<String, dynamic> json) {
    return VrLabModel(
      id: json['id'],
      subject: json['subject'],
      labName: json['lab_name'],
      vrModel: json['vr_model'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject": subject,
      "lab_name": labName,
      "vr_model": vrModel,
      "description": description,
    };
  }
}