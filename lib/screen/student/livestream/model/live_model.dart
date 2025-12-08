class LiveModel {
  final int id;
  final int teacherId;
  final String name;
  final String? url;
  final String date; // بصيغة yyyy-MM-dd
  final String time; // بصيغة HH:mm
  final String? notes;

  LiveModel({
    required this.id,
    required this.teacherId,
    required this.name,
    this.url,
    required this.date,
    required this.time,
    this.notes,
  });

  factory LiveModel.fromJson(Map<String, dynamic> json) {
    return LiveModel(
      id: json['id'],
      teacherId: json['teacher_id'],
      name: json['name'],
      url: json['url'],
      date: json['date'],
      time: json['time'],
      notes: json['notes'],
    );
  }
}
