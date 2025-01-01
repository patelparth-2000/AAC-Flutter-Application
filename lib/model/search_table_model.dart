class SearchTableModel {
  final String? category;
  final String? categorySlug;
  final String? subCategory;
  final String? subCategorySlug;
  final String voice;

  SearchTableModel({
    this.category,
    this.categorySlug,
    this.subCategory,
    this.subCategorySlug,
    required this.voice,
  });
}
