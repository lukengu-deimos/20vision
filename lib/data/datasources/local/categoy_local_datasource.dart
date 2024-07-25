import 'package:hive/hive.dart';
import 'package:visionapp/data/models/category_model.dart';
import 'package:visionapp/domain/entities/category.dart';

abstract interface class CategoryLocalDatasource {
  List<Category> getCategories();
  save(List<CategoryModel> categories);
}

class CategoryLocalDatasourceImpl implements CategoryLocalDatasource {
  final Box<Category> box;

  CategoryLocalDatasourceImpl(this.box);

  @override
  List<Category> getCategories() {
    List<Category> categories = [];
    for (Category post in box.values) {
      categories.add(post);
    }
    return categories;
  }

  @override
  save(List<CategoryModel> categories) {
    box.clear();
    for (int i = 0; i < categories.length; i++) {
      box.put(i, categories[i]);
    }
  }
}
