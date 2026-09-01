class ScanPhotoModel {
  bool? status;
  String? message;
  ScanPhotoData? data;

  ScanPhotoModel({
    this.status,
    this.message,
    this.data,
  });

  ScanPhotoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ScanPhotoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ScanPhotoData {
  int? count;
  List<PhotoItem>? photos;

  ScanPhotoData({
    this.count,
    this.photos,
  });

  ScanPhotoData.fromJson(Map<String, dynamic> json) {
    count = json['count'] != null ? int.tryParse(json['count'].toString()) : null;
    if (json['photos'] != null) {
      photos = <PhotoItem>[];
      json['photos'].forEach((v) {
        photos!.add(PhotoItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (photos != null) {
      data['photos'] = photos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PhotoItem {
  int? id;
  String? imageUrl;
  int? faceCount;
  String? createdAt;

  PhotoItem({
    this.id,
    this.imageUrl,
    this.faceCount,
    this.createdAt,
  });

  PhotoItem.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    imageUrl = json['image_url'] ?? json['image'];
    faceCount = json['faces_count'] != null
        ? int.tryParse(json['faces_count'].toString())
        : (json['face_count'] != null
            ? int.tryParse(json['face_count'].toString())
            : (json['faces_detected'] != null ? int.tryParse(json['faces_detected'].toString()) : null));
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    data['faces_count'] = faceCount;
    data['created_at'] = createdAt;
    return data;
  }
}
