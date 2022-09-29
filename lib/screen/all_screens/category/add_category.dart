import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:ecommerce_app/api_service/api_helper.dart';
import 'package:ecommerce_app/conts_data/const_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  bool isLoading = false;

  TextEditingController nameController = TextEditingController();

  GlobalKey<FormState>formKey = GlobalKey<FormState>();

  File? c_image, c_i_icon;
  ImagePicker picker = ImagePicker();

  Future<void>getIconImageFromGalery() async{
    print('pic img');
    var pickedIconImage = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedIconImage==null){

      }else{
        c_i_icon = File(pickedIconImage.path);
      }
    });
  }
  Future<void>getImageFromGalery() async{
    print('pic img');
    var pickedIconImage = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedIconImage==null){

      }else{
        c_image = File(pickedIconImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new category"),
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
                    Text('Category name',style: myStyle16(),),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if(value.toString().isEmpty){
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
                    SizedBox(height: 10,),
                    Text('Category icon iamge',style: myStyle16()),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        getIconImageFromGalery();
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child:c_i_icon==null||c_i_icon!.path.isEmpty? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image,size: 30,),
                            Text("Upload"),
                          ],
                        ):Image(image: FileImage(c_i_icon!),width: double.infinity,fit: BoxFit.cover,),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text('Category icon iamge',style: myStyle16()),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        getImageFromGalery();
                      },
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child:c_image==null||c_image!.path.isEmpty? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image,size: 50,),
                            Text("Upload"),
                          ],
                        ):Image(image: FileImage(c_image!),width: double.infinity,fit: BoxFit.cover,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: () async {
                      if(formKey.currentState!.validate()){
                        if(c_i_icon==null||c_i_icon!.path.isEmpty){
                          showTopToast(msg: "Please select category icon image");
                        }
                        else if(c_image==null||c_image!.path.isEmpty){
                          showTopToast(msg: "Please select category image");
                        }
                        else{
                          setState(() {
                            isLoading = true;
                          });
                          var result = await ApiHttpService().postCategoryDeatils(name: nameController.text, iconImage: c_i_icon!.path, categoryImage: c_image!.path);
                          // print('all done');
                          if(result!.statusCode == 201){
                            nameController.text = '';
                            c_image = null;
                            c_i_icon = null;
                            setState(() {
                              isLoading = false;
                            });
                            showTopToast(msg: "Category added successfully");
                          }
                          else{
                            setState(() {
                              isLoading = false;
                            });
                            showTopToast(msg: "Category added unsuccessfull");
                          }
                        }
                      }
                    }, child: Text('Add Category'),style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      fixedSize: Size(MediaQuery.of(context).size.width*1, 50),
                    ),)
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
