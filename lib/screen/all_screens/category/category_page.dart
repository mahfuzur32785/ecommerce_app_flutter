import 'package:ecommerce_app/api_service/api_helper.dart';
import 'package:ecommerce_app/conts_data/const_data.dart';
import 'package:ecommerce_app/provider/category_provider.dart';
import 'package:ecommerce_app/screen/all_screens/category/add_category.dart';
import 'package:ecommerce_app/screen/all_screens/category/update_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../model/category_model.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoryDataModel> categoryProviderDataList = [];

  bool isVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).getAllCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    categoryProviderDataList =
        Provider.of<CategoryProvider>(context).categoryList;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        blur: 2,
        progressIndicator: showSpniKit(),
        child: Container(
          child: Center(
            child: Column(
              children: [
                categoryProviderDataList.isNotEmpty
                    ? Expanded(
                        child: NotificationListener<UserScrollNotification>(
                          onNotification: (notification) {
                            setState(() {
                              if (notification.direction ==
                                  ScrollDirection.forward) {
                                isVisible = false;
                              } else if (notification.direction ==
                                  ScrollDirection.reverse) {
                                isVisible = true;
                              }
                            });
                            return true;
                          },
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return Container(
                                height: 220,
                                color: Colors.grey.shade400,
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image(
                                          image: NetworkImage(
                                              "https://apihomechef.antopolis.xyz/images/${categoryProviderDataList[index].image ?? ""}"),
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                            "${categoryProviderDataList[index].name}"),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Container(
                                                child: ElevatedButton.icon(
                                                  label: Text('Edit'),
                                                  onPressed: () {
                                                    editCategory(
                                                      index: index,
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey.shade400,
                                                    elevation: 0,
                                                    foregroundColor:
                                                        Colors.deepOrange,
                                                  ),
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.deepOrange,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 20,
                                              width: 2,
                                              color: Colors.red,
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Container(
                                                child: ElevatedButton.icon(
                                                  label: Text('Delete'),
                                                  onPressed: () {
                                                    deleteCategory(
                                                        index: index);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey.shade400,
                                                    elevation: 0,
                                                    foregroundColor:
                                                        Colors.deepOrange,
                                                  ),
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.deepOrange,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Positioned(
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            "https://apihomechef.antopolis.xyz/images/${categoryProviderDataList[index].icon ?? ""}"),
                                      ),
                                      bottom: 0,
                                      right: 50,
                                      top: 0,
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 20,
                              );
                            },
                            itemCount: categoryProviderDataList.length,
                            shrinkWrap: true,
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isVisible == true
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCategory(),
                    )).then((value) {
                  setState(() {
                    Provider.of<CategoryProvider>(context, listen: false)
                        .getAllCategoryData();
                  });
                });
              },
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  void deleteCategory({index}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure ?'),
            titleTextStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
            titlePadding: EdgeInsets.only(left: 35, top: 25),
            content: Text('Do you delete this item permanently?'),
            contentTextStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
            contentPadding: EdgeInsets.only(left: 35, top: 10, right: 40),
            actions: <Widget>[
              TextButton(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 0.2)),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.green),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  ApiHttpService()
                      .deleteCategoryItem(
                          id: categoryProviderDataList[index].id!.toInt())
                      .then((value) => () {
                            setState(() {
                              isLoading = false;
                              categoryProviderDataList.removeAt(index);
                              //categories.removeWhere((element) => element.id==categories[index].id);
                            });
                          });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }).then((value) {
      setState(() {
        isLoading = false;
        Provider.of<CategoryProvider>(context, listen: false)
            .getAllCategoryData();
      });
    });
  }

  void editCategory({index}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateCategory(
      categoryDataModel: categoryProviderDataList[index],
    ),)).then((value) => setState((){
      Provider.of<CategoryProvider>(context, listen: false).getAllCategoryData();
    }));
  }
}
