import 'package:ecommerce_app/api_service/api_helper.dart';
import 'package:ecommerce_app/model/category_model.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier{
  List<CategoryDataModel> categoryList = [];
  getAllCategoryData() async {
    categoryList = await ApiHttpService().getAllCategoryDatas();
    notifyListeners();
  }
}