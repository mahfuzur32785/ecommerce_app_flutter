import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFeild extends StatelessWidget {
  CustomTextFeild({Key? key,this.autovalidateMode,this.inputType,this.hintText,this.suffixIcon,this.validator,this.controller,required this.obsecureText}) : super(key: key);

  String? hintText;
  IconButton? suffixIcon;
  TextEditingController? controller;
  dynamic validator;
  bool obsecureText = false;
  TextInputType? inputType;
  AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: inputType,
        obscureText: obsecureText,
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          fillColor: Colors.white,
          filled: true,
          errorStyle: TextStyle(
            fontSize: 16
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade700,
              width: 1,
            )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade700,
                width: 1,
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade700,
                width: 1,
              )
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade700,
                width: 1,
              )
          ),
        ),
      ),
    );
  }
}

