import 'dart:io';
import 'dart:async';

import 'package:ecommerce_app/api_service/api_helper.dart';
import 'package:ecommerce_app/conts_data/const_data.dart';
import 'package:ecommerce_app/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UpdateCategory extends StatefulWidget {
  UpdateCategory({Key? key, required this.categoryDataModel}) : super(key: key);

  CategoryDataModel categoryDataModel;

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? categoryImage, categoryIconImage;
  ImagePicker picker = ImagePicker();

  Future<void> getIconImageFromGalery() async {
    print('pic img');
    var pickedIconImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedIconImage == null) {
      } else {
        categoryIconImage = File(pickedIconImage.path);
      }
    });
  }

  Future<void> getImageFromGalery() async {
    print('pic img');
    var pickedIconImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedIconImage == null) {
      } else {
        categoryImage = File(pickedIconImage.path);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = "${widget.categoryDataModel.name}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update category"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        blur: 2,
        progressIndicator: showSpniKit(),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Category name',
                      style: myStyle16(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "please enter category name";
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        hintText: 'Write category name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Category icon iamge', style: myStyle16()),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        getIconImageFromGalery();
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: categoryIconImage == null ||
                                categoryIconImage!.path.isEmpty
                            ? Image(
                                image: NetworkImage(
                                    'https://apihomechef.antopolis.xyz/images/${widget.categoryDataModel.icon}'),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image(
                                image: FileImage(categoryIconImage!),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Category icon iamge', style: myStyle16()),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        getImageFromGalery();
                      },
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5)),
                        child:
                            categoryImage == null || categoryImage!.path.isEmpty
                                ? Image(
                                    image: NetworkImage(
                                        'https://apihomechef.antopolis.xyz/images/${widget.categoryDataModel.image}'),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image(
                                    image: FileImage(categoryImage!),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          var result = await ApiHttpService()
                              .updateCategoryDeatils(
                                id: widget.categoryDataModel.id,
                                name: nameController.text,
                                iconImage: categoryIconImage?.path,
                                categoryImage: categoryImage?.path,
                              );
                          if(result?.statusCode == 200){
                            setState(() {
                              isLoading = false;
                              nameController.text = '';
                              categoryIconImage = null;
                              categoryImage = null;
                              Navigator.pop(context);
                            });
                            print("Category updated successfully");
                            showTopToast(msg: "Category updated successfully");
                          }
                          else{
                            setState(() {
                              isLoading = false;
                            });
                            showTopToast(msg: "Category updated unsuccessfull");
                          }
                        }
                      },
                      child: Text('Update Category'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 1, 50),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
