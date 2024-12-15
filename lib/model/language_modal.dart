// ignore_for_file: prefer_collection_literals, unnecessary_new, unnecessary_this

class LanguageModal {
  int? status;
  String? imageURL;
  String? message;
  List<Data>? data;

  LanguageModal({this.status, this.imageURL, this.message, this.data});

  LanguageModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    imageURL = json['imageURL'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['imageURL'] = this.imageURL;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? code;
  String? image;
  String? slug;
  String? createdBy;
  String? status;
  String? deleteStatus;

  Data(
      {this.id,
      this.name,
      this.code,
      this.image,
      this.slug,
      this.createdBy,
      this.status,
      this.deleteStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    image = json['image'];
    slug = json['slug'];
    createdBy = json['created_by'];
    status = json['status'];
    deleteStatus = json['delete_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['image'] = this.image;
    data['slug'] = this.slug;
    data['created_by'] = this.createdBy;
    data['status'] = this.status;
    data['delete_status'] = this.deleteStatus;
    return data;
  }
}
