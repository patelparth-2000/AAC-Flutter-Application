class GetCategoryModal {
  String? id;
  String? type;
  String? lang;
  String? categoryId;
  String? subCategoryId;
  String? name;
  String? code;
  String? image;
  String? slug;
  String? voiceFile;
  String? createdBy;
  String? status;
  String? deleteStatus;
  String? category;
  String? langName;
  String? subcategory;

  GetCategoryModal(
      {this.id,
      this.type,
      this.lang,
      this.categoryId,
      this.subCategoryId,
      this.name,
      this.code,
      this.image,
      this.slug,
      this.voiceFile,
      this.createdBy,
      this.status,
      this.deleteStatus,
      this.category,
      this.langName,
      this.subcategory});

  GetCategoryModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    lang = json['lang'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    name = json['name'];
    code = json['code'];
    image = json['image'];
    slug = json['slug'];
    voiceFile = json['voice_file'];
    createdBy = json['created_by'];
    status = json['status'];
    deleteStatus = json['delete_status'];
    category = json['category'];
    langName = json['lang_name'];
    subcategory = json['subcategory'];
    /*  category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    langName = json['lang_name'] != null
        ? new Category.fromJson(json['lang_name'])
        : null;
    subcategory = json['subcategory'] != null
        ? new Category.fromJson(json['subcategory'])
        : null; */
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['lang'] = this.lang;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['name'] = this.name;
    data['code'] = this.code;
    data['image'] = this.image;
    data['slug'] = this.slug;
    data['voice_file'] = this.voiceFile;
    data['created_by'] = this.createdBy;
    data['status'] = this.status;
    data['delete_status'] = this.deleteStatus;
    data['category'] = this.category;
    data['lang_name'] = this.langName;
    data['subcategory'] = this.subcategory;
    /*  if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.langName != null) {
      data['lang_name'] = this.langName!.toJson();
    }
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory!.toJson();
    } */
    return data;
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
