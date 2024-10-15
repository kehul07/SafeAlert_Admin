import 'dart:async';

import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_alert_admin/Utils.dart';
import 'package:safe_alert_admin/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  String _email = "";
  String _password = "";
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome Admin!",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.yellow.shade700),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Log in here!!",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),
                inputTextField(
                    label: "Email",
                    errorMsg: "Please enter email",
                    icon: Icon(
                      Icons.email,
                      color: Colors.yellow.shade700,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    toggle: false,
                    onSaved: (value) {
                      _email = value!;
                    }),
                const SizedBox(height: 10),
                inputTextField(
                    label: "Password",
                    errorMsg: "Please enter password",
                    icon: Icon(
                      Icons.password,
                      color: Colors.yellow.shade700,
                    ),
                    keyboardType: TextInputType.text,
                    toggle: true,
                    onSaved: (value) {
                      _password = value!;
                    }),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: const TextTheme(
                          titleMedium: TextStyle(
                              color: Colors.white), // Change the text color
                        ),
                      ),
                      child: CountryStateCityPicker(
                        country: country,
                        state: state,
                        city: city,
                        dialogColor: Colors.grey.shade200,
                        textFieldDecoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.grey),
                          fillColor:
                              Colors.black, // Background color of the text field
                          filled:
                              true, // Enable filling the background with color
                          suffixIcon: const Icon(
                              Icons.arrow_downward_rounded), // Custom icon
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey, // Border color
                              width: 1.0, // Border width
                            ),
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors
                                  .yellow.shade700, // Border color when focused
                              width: 1.0, // Border width when focused
                            ),
                            borderRadius: BorderRadius.circular(
                                20), // Rounded corners when focused
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (_email == "admin123@gmail.com" &&
                            _password == "admin123") {


                          // save location

                          await saveLocationAndLoginState(country.text, state.text, city.text);

                          Utils.showSnackbar(
                              context: context, msg: "Logged in successfully!!");
                          Utils.navigateWithSlideTransitionWithPushReplacement(
                              context: context,
                              screen: HomeScreen(cityName: city.text.toString()),
                              begin: const Offset(1, 0),
                              end: Offset.zero);
                        } else {
                          Utils.showSnackbar(
                              context: context, msg: "Invalid Credentials!!");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.yellow.shade700),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> saveLocationAndLoginState(String country, String state, String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('country', country);
    await prefs.setString('state', state);
    await prefs.setString('city', city);
  }


  Widget inputTextField(
      {required String label,
      required String errorMsg,
      required Icon icon,
      required TextInputType keyboardType,
      required bool toggle,
      required FormFieldSetter<String> onSaved}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        obscureText: toggle,
        decoration: InputDecoration(
            prefixIcon: icon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.yellow.shade700,
                )),
            labelStyle: const TextStyle(color: Colors.grey),
            labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMsg;
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}
