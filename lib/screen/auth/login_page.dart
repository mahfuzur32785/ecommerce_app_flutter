import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_app/api_service/api_helper.dart';
import 'package:ecommerce_app/conts_data/const_data.dart';
import 'package:ecommerce_app/custom_things/custom_btm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../custom_things/custom_txt_feild.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  SharedPreferences? sharedPreferences;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isEmailLogin = false;
  bool isObsecure = false;
  bool isLoading = false;

  checkToken() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      sharedPreferences = await SharedPreferences.getInstance();
      var tokenData = sharedPreferences!.getString('token');

      if (tokenData != null || tokenData?.isNotEmpty == true) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CustomBtmNavBar()));
      } else {
        print('No Token Found');
      }
    }
    else{
      showButtomToast(msg: "You are not connected with internet");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Here'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          blur: 2,
          progressIndicator: showSpniKit(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: isEmailLogin
                  ? Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Image(
                                image: AssetImage("assets/images/logo.png"),
                                height: 250,
                              )),
                          Text(
                            'Login Here',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'With your email and password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CustomTextFeild(
                            controller: emailController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            hintText: 'Enter you email',
                            obsecureText: false,
                            validator: (value) {
                              RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                              if (value.toString().isEmpty) {
                                return 'Please enter your email';
                              }
                              else if (!regex.hasMatch(value) && value.toString().length<5)
                                return 'Enter valid email';
                              else
                                return null;
                            },
                            inputType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextFeild(
                            controller: passController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.toString().isEmpty){
                                return 'Please enter your password';
                              }
                              else if(value.toString().length<4) {
                                return 'Enter Valid password';
                              }
                            },
                            hintText: 'Enter you password',
                            obsecureText: isObsecure,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObsecure = !isObsecure;
                                  });
                                },
                                icon: isObsecure
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: (){
                              getLogin();
                            },
                            child: Text('Login with Email'),
                            style: ElevatedButton.styleFrom(
                              fixedSize:
                              Size(MediaQuery.of(context).size.width * 1, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.deepOrange,
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Or",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEmailLogin = false;
                              });
                            },
                            child: Text('Login with OTP'),
                            style: ElevatedButton.styleFrom(
                              fixedSize:
                              Size(MediaQuery.of(context).size.width * 1, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.deepOrange,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Create an account',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Image(
                          image: AssetImage("assets/images/logo.png"),
                          height: 250,
                        )),
                        Text(
                          'Login Here',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'With your mobile number',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFeild(
                          hintText: 'Enter you mobile number',
                          obsecureText: false,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Login with OTP'),
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                                Size(MediaQuery.of(context).size.width * 1, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.deepOrange,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Or",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEmailLogin = true;
                            });
                          },
                          child: Text('Login with Email'),
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                                Size(MediaQuery.of(context).size.width * 1, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.deepOrange,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Create an account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ));
  }
  void getLogin() async{
    if (_formKey.currentState!.validate()) {
      var connectivityResult = await (Connectivity()
          .checkConnectivity());
      setState(() {
        isLoading = true;
      });
      if (connectivityResult ==
          ConnectivityResult.mobile ||
          connectivityResult ==
              ConnectivityResult.wifi) {
        var result = await ApiHttpService().userLogIn({
          'email': emailController.text,
          'password': passController.text,
        });
        var data = jsonDecode(result!);
        setState(() {
          isLoading = false;
        });
        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences!.setString("token", data["access_token"]);
        var tokenData = sharedPreferences!.getString('token');
        print('token is: ${tokenData}');
        //print(data);
        Navigator.pushAndRemoveUntil(context, PageTransition(type: PageTransitionType.leftToRight, child: CustomBtmNavBar()),(route) => false,);
      }else{
        setState(() {
          isLoading = false;
        });
        showButtomToast(msg: "You are not connected with internet");
      }
    }
    else{
      _formKey.currentState!.save();
    }
  }
}
