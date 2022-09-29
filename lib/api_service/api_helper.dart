import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_app/conts_data/const_data.dart';
import 'package:ecommerce_app/model/category_model.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHttpService {

  Map<String, String> defaultHeader = {
    "Accept": "application/json"
  };

  Future<Map<String,String>> getHederwithToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var tokenData = sharedPreferences.getString('token');
    Map<String, String> map;
    return map = {
      "Accept" : "application/json",
      "Authorization": "bearer $tokenData"
    };
  }

  //For admin Log in++++++++++++++++++++++++++++++
  Future<String?> userLogIn(body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    var data;

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var link = Uri.parse('${baseUrl}api/admin/sign-in');
        var response =
            await http.post(link, body: body, headers: defaultHeader);
        data = response.body;
        if (response.statusCode == 200) {
          showButtomToast(msg: "Login Successfull");
          return data;
        } else {
          showButtomToast(msg: "Invalid email or password");
        }
      } catch (e) {
        showButtomToast(msg: "${e}");
      }
      return null;
    } else {
      showButtomToast(msg: "You are not connected with internet");
    }
  }

  //For fetch admin all order++++++++++++++++++++++++++++++
  Future<List<OrderDataModel>> getAllOrderDatas()async{
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<OrderDataModel> orderList = [];

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try{
        var link = "${baseUrl}api/admin/all/orders";
        var response = await http.get(Uri.parse(link),headers: await getHederwithToken());
        print('status code is ${response.statusCode}');
        if(response.statusCode==200){
          var data = jsonDecode(response.body);
          for(var i in data){
            orderList.add(OrderDataModel.fromJson(i));
          }
          return orderList;
        }
      }catch(e){
        showButtomToast(msg: e);
        return orderList;
      }
    }
    else {
      showButtomToast(msg: "You are not connected with internet");
    }
    return orderList;
  }

  //For Fetch admin category data+++++++++++++++++++++++++
  Future<List<CategoryDataModel>>getAllCategoryDatas()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    List<CategoryDataModel> categoryList = [];
    if(connectivityResult==ConnectivityResult.mobile||connectivityResult==ConnectivityResult.wifi){
      try{
        var link = "${baseUrl}api/admin/category";
        var response = await http.get(Uri.parse(link),headers: await getHederwithToken());
        print('status code is ${response.statusCode}');
        if(response.statusCode==200){
          var data = jsonDecode(response.body);
          for(var i in data){
            categoryList.add(CategoryDataModel.fromJson(i));
          }
          return categoryList;
        }
      }catch(e){
        showButtomToast( msg: e );
      }
      return categoryList;
    }else{
      showButtomToast(msg: "You are not connected with internet");
    }
    return categoryList;
  }

  //For post a Category details++++++++++++++++++++++++++++++
  Future<http.StreamedResponse?> postCategoryDeatils({name, iconImage, categoryImage})async{
    var connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult==ConnectivityResult.mobile||connectivityResult==ConnectivityResult.wifi) {
      try {
        var link = Uri.parse("${baseUrl}api/admin/category/store");
        var request = http.MultipartRequest("POST", link);
        request.headers.addAll(await getHederwithToken());
        request.fields['name']= name;
        var icon = await http.MultipartFile.fromPath('icon', iconImage);
        request.files.add(icon);
        var image = await http.MultipartFile.fromPath('image', categoryImage);
        request.files.add(image);
        var response = await request.send();
        print(response.statusCode);

        return response;
      }catch(e){
        showButtomToast(msg: e.toString());
      }
    }else{
      showButtomToast(msg: "You are not connected with internet");
    }
    return null;
  }

  //For delete a category +++++++++++++++++++++++++++
  Future<void> deleteCategoryItem({id})async{
    var connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult==ConnectivityResult.mobile||connectivityResult==ConnectivityResult.wifi) {
      try {
        var link = Uri.parse(
            "https://apihomechef.antopolis.xyz/api/admin/category/$id/delete");
        var response = await http.delete(
            link, headers: await getHederwithToken()
        );
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data['message'].toString());
          showButtomToast(msg: '${data['message']}');
        }
        else {}
      } catch (e) {
        showButtomToast(msg: e);
      }
    }else{
      showButtomToast(msg: "You are not connected with internet");
    }
  }

  //For Update a category details++++++++++++++++++++++++++
  Future<http.StreamedResponse?> updateCategoryDeatils({id,name, iconImage, categoryImage})async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var link = Uri.parse("${baseUrl}api/admin/category/$id/update");
        var request = http.MultipartRequest("POST", link);
        request.headers.addAll(await getHederwithToken());
        request.fields['name'] = name;
        if (iconImage != null) {
          var icon = await http.MultipartFile.fromPath('icon', iconImage);
          request.files.add(icon);
        }
        else if (categoryImage != null) {
          var image = await http.MultipartFile.fromPath('image', categoryImage);
          request.files.add(image);
        }
        var response = await request.send();

        return response;
      } catch (e) {
        print(e);
        showButtomToast(msg: e.toString());
      }
    } else {
      showButtomToast(msg: "You are not connected with internet");
    }
    return null;
  }

}
