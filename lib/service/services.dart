import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mksc_mobile/service/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthResult {
  final bool success;
  final dynamic data;

  AuthResult(this.success, {this.data});
}

class Services {
  final authUrl = 'http://mkscportal.co.tz/api/v1/auth/user';
  final chickenUrl = 'http://mkscportal.co.tz/api/v1/chickenHouse';
  final chickenToDayUrl = 'http://mkscportal.co.tz/api/v1/chicken/House/today/';
  final alldataurl = 'http://mkscportal.co.tz/api/v1/chickenHouse/all';
  final getchickendata = 'http://mkscportal.co.tz/api/v1/chickenHouse/';
  final getcampurl = 'http://mkscportal.co.tz/panel/api/v1/camps';
  final getcamptypeurl = 'http://mkscportal.co.tz/panel/api/v1/menu_type_by_camp_name/';
  final getMenurl = 'http://mkscportal.co.tz/panel/api/v1/menu_by_day_type_camp';
  final getMenutetails = "http://mkscportal.co.tz/panel/api/v1/menu_details";
  final getVideoURL = "http://mkscportal.co.tz/panel/api/v1/dish_video";
  final vegetableUrl = "https://mkscportal.co.tz/panel/api/v1/vegetable-list";
  final availablevegetableUrl = "http://mkscportal.co.tz/api/v1/vegetable-today";
  final vegetabledataurl = "http://mkscportal.co.tz/api/v1/vegetable";
  final savevegetableUrl = "https://mkscportal.co.tz/api/v1/vegetable";
  final getbydishesurl = "http://mkscportal.co.tz/panel/api/v1/dish_details";

  Future<AuthResult> authenticateUser(BuildContext context, String category,
      String password, int countNo, String modifiedselectedCategory) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(category);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final payload = json.encode({
      'email': "laundry@laundry.com",
      'password': password,
    });
    try {
      final response = await http.post(
        Uri.parse(authUrl),
        body: payload,
        headers: headers,
      );
      final responseData = json.decode(response.body);
      print("responseData are ");
      print(responseData['token']);
      if (responseData['token'] != null) {
        //SAVE DATA ON LOCAL STORAGE
        String formattedTime = DateTime.now().toIso8601String();
        await prefs.setString('token', responseData['token']);
        await prefs.setString('currentTime', formattedTime);
        print("token saved..................");
        if (category == "Chicken House") {
          bool dataSaved = await postData(responseData['token'], category,
              countNo, modifiedselectedCategory);
          if (dataSaved) {
            return AuthResult(true, data: responseData['token']);
          } else {
            return AuthResult(false);
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: "Authentication failed!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      throw error;
    }

    return AuthResult(false);
  }

  Future<bool> postData(
      String token, String name, int countnum, modifiedselectedCategory) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final payload = json.encode(
        {'item': modifiedselectedCategory, 'token': token, 'number': countnum});
    print("payload sent ................");
    print(payload);
    try {
      final response = await http.post(
        Uri.parse(name == "Chicken House"
            ? chickenUrl
            : name == "Vegetable"
                ? savevegetableUrl
                : ""),
        body: payload,
        headers: headers,
      );
      final responseData = json.decode(response.body);
      print(responseData);
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> editVegetableData(String token, String name, int countnum,
      String modifiedselectedCategory, int itemId) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final payload = json.encode({
      'item': modifiedselectedCategory,
      'token': token,
      'number': countnum,
    });
    try {
      final response = await http.patch(
        Uri.parse(name == "Chicken House"
            ? chickenUrl
            : name == "Vegetable"
                ? '$savevegetableUrl/$itemId'
                : ""),
        body: payload,
        headers: headers,
      );
      final responseData = json.decode(response.body);
      print(responseData);
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> editData(String token, int countnum, item, id) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final payload =
        json.encode({'item': item, 'token': token, 'number': countnum});
    print(payload);
    try {
      final response = await http.patch(
        Uri.parse('$chickenUrl/$id'),
        body: payload,
        headers: headers,
      );
      final responseData = json.decode(response.body);
      print(responseData);
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> getData(String page) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(
        Uri.parse(page == 'daydata'
            ? chickenToDayUrl
            : page == 'chickendata'
                ? getchickendata
                : alldataurl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> getVegetableData(String page) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(
        Uri.parse(vegetabledataurl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List> getCamps() async {
    final response = await http.get(Uri.parse(getcampurl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<String> campNames =
          data.map((camp) => camp['camp'].toString()).toList();
      print("data God is Here................");
      print(data);
      return data;
    } else {
      throw Exception('Failed to load camp list');
    }
  }

  Future<List> getMenuType(camp) async {
    final response = await http.get(Uri.parse('$getcamptypeurl$camp'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<String> campNames =
          data.map((camp) => camp['camp'].toString()).toList();
      return data;
    } else {
      throw Exception('Failed to load MenuType list');
    }
  }

  Future<List> getMenu(day, menutype, camp) async {
    final response =
        await http.get(Uri.parse('$getMenurl/$day/$menutype/$camp'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List campNames = data;
      print(data);
      return data;
    } else {
      throw Exception('Failed to load Menu list');
    }
  }

  getMenuDetails(id) async {
    final response = await http.get(Uri.parse('$getMenutetails/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load MenuDetails list');
    }
  }

  getMenuByDishes(id) async {
    final response = await http.get(Uri.parse('$getbydishesurl/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load MenuDetails list');
    }
  }

  getVideos(id) async {
    final response = await http.get(Uri.parse('$getVideoURL/$id'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data['video']['path']);
      return data['video']['path'];
    } else {
      throw Exception('Failed to load video');
    }
  }

  getVegetableList() async {
    final response = await http.get(Uri.parse('$vegetableUrl'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // print(data['data']);
      return data;
    } else {
      throw Exception('Failed to load video');
    }
  }

  getAvailableVegetableList() async {
    final response = await http.get(Uri.parse('$availablevegetableUrl'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print("data available ...............  ${data['data']}");
      return data;
    } else {
      throw Exception('Failed to load video');
    }
  }

  Future authentication(
      BuildContext context, String category, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(category);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final payload = json.encode({
      'email': category == "Vegetable"
          ? "vegetable@vegetable.com"
          : category == "Chicken House"
              ? "laundry@laundry.com"
              : '',
      'password': password,
    });
    print("PAYLOAD.....................");
    print(payload);
    try {
      final response = await http.post(
        Uri.parse(authUrl),
        body: payload,
        headers: headers,
      );
      final responseData = json.decode(response.body);
      print("responseData are ....................................");
      print(responseData['token']);
      if (responseData['token'] != null) {
        //SAVE DATA ON LOCAL STORAGE
        String formattedTime = DateTime.now().toIso8601String();
        if (category == "Vegetable") {
          await prefs.setString('vegetabletoken', responseData['token']);
          await prefs.setString('vegetablecurrentTime', formattedTime);
        } else {
          await prefs.setString('token', responseData['token']);
          await prefs.setString('currentTime', formattedTime);
        }
        print("token saved..................");
        return responseData['token'];
      } else {
        Fluttertoast.showToast(
            msg: "Authentication failed!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return "Failed";
      }
    } catch (error) {
      throw error;
    }
  }
}
