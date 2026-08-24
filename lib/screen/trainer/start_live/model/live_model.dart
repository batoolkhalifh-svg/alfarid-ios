class LivesModel {
  final String? liveName;
  final String? type;
  final String date;
  final String? groupId;
  final String? docName;
  final String time;
  final String details;
  final String? groupName;
  final String? teacherName;
  final String? teacherPhoto;
  final String? roomStudent;
  final String link;
  final String? jitsiUrl;
  final String? slug;
  final bool active;
  final bool finish;

  LivesModel(
      {this.liveName, this.type, this.slug,
        this.docName, this.roomStudent,
        this.teacherPhoto,
        this.groupName,
        this.teacherName,
        this.groupId,
        this.jitsiUrl,
        required this.date,
        required this.time,
        required this.details,
        required this.link,
        required this.active,
        required this.finish,
      });
}
