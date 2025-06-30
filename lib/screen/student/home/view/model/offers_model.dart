class OffersModel {
  late int id,classroomId,coursesCount;
  late String name,imageUrl,createdAt;
  late num price;

  OffersModel.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    name = json['name']??'';
    price = json['price']??0;
    classroomId = json['classroom_id']??0;
    imageUrl = json['image_url']??'';
    coursesCount = json['courses_count']??1;
    createdAt = json['created_at']??'';
  }
}
