import 'package:ecommerce_app/api_service/api_helper.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier{
  List<OrderDataModel> orderList = [];
  getorderDataListFromProvider()async{
    orderList = (await ApiHttpService().getAllOrderDatas())!;
    notifyListeners();
  }
}