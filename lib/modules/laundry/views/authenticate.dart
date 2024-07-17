import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc_mobile/modules/laundry/views/laundy_screen.dart';
import 'package:mksc_mobile/service/services.dart';
import 'package:mksc_mobile/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateScreen extends StatefulWidget {
  final String title;

  const AuthenticateScreen({Key? key, required this.title}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<AuthenticateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool isLoading = false;
  bool tokenExpired = true;
  int _currentStep = 0;
  String? token;

  void initializeApp() async {
    token = await getToken();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.laundrytoken);
  }

  Services _serv = Services();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Authenticate'),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue,
              Color.fromARGB(255, 196, 216, 233),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tokenExpired == true) ...[
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Laundry",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Enter Code to Input Data for ${widget.title}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: 'Enter Code',
                      hintStyle: TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style:
                        const TextStyle(color: Color.fromARGB(255, 49, 49, 49)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your code';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_currentStep < 1) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async { 
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        final resp =
                            await _serv.login(_codeController.text, 'laundry');
                        if (resp) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LaundryScreen()),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Authentication failed!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      }
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
