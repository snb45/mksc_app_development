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
  final authUrl = 'https://development.mkscportal.co.tz/api/v2/auth/user';
  final chickenUrl = 'https://development.mkscportal.co.tz/api/v2/chickenHouse';
  final chickenToDayUrl =
      'https://development.mkscportal.co.tz/api/v2/chicken/House/today/';
  final alldataurl =
      'https://development.mkscportal.co.tz/api/v2/chickenHouse/all';
  final getchickendata =
      'https://development.mkscportal.co.tz/api/v2/chickenHouse/';
  final getcampurl = 'https://development.mkscportal.co.tz/api/v2/camps';
  final getcamptypeurl =
      'https://development.mkscportal.co.tz/api/v2/menu_type_by_camp_name/';
  final getMenurl =
      'https://development.mkscportal.co.tz/api/v2/menu_by_day_type_camp';
  final getMenutetails =
      "https://development.mkscportal.co.tz/api/v2/menu_details";
  final getVideoURL = "https://development.mkscportal.co.tz/api/v2/dish_video";
  final vegetableUrl =
      "https://development.mkscportal.co.tz/api/v2/vegetable-list";
  final availablevegetableUrl =
      "https://development.mkscportal.co.tz/api/v2/vegetable-today";
  final vegetabledataurl =
      "https://development.mkscportal.co.tz/api/v2/vegetable";
  final savevegetableUrl =
      "https://development.mkscportal.co.tz/api/v2/vegetable";
  final getbydishesurl =
      "https://development.mkscportal.co.tz/api/v2/dish_details";

  final machineSize =
      'https://development.mkscportal.co.tz/api/v2/laundryMachine';

  final storeLaundryDataUrl =
      'https://development.mkscportal.co.tz/api/v2/laundryData';
  final getLaundryTodayDataUrl =
      'https://development.mkscportal.co.tz/api/v2/laundryData/today';

  final String updateLaundryDataUrl =
      'https://development.mkscportal.co.tz/api/v2/laundryData/';

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
      print(responseData);
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

  Future<bool> login(password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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

      if (responseData['token'] != null) {
        String formattedTime = DateTime.now().toIso8601String();
        await prefs.setString('token', responseData['token']);
        await prefs.setString('currentTime', formattedTime);
        print("token saved..................");
        return true;
      }
      return false;
    } catch (error) {
      throw error;
    }
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
              : "laundry@laundry.com",
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

  Future<List<String>> getMachineSize() async {
    var url = Uri.parse(machineSize);
    var camp = await getSelectedCampPreference();

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'camp': camp,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => item['machineSize'] as String).toList();
    } else {
      throw Exception('Failed to load machine sizes');
    }
  }

  Future<bool> storeLaundryData(int? circle, String machineType) async {
    var url = Uri.parse(storeLaundryDataUrl);
    var camp = await getSelectedCampPreference();
    var token = await getSharedString('token');
    print('Token: $token');

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'camp': camp,
        'circle': circle,
        'machineType': machineType,
        'token': token
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      print('sucess Response body laundry: ${response.body}');
      return true;
    } else {
      print('Request failed with status laundry: ${response.statusCode}.');
      return false;
    }
  }

  Future<bool> updateLaundryData(
      int? circle, String machineType, int? id) async {
    var url = Uri.parse(updateLaundryDataUrl + id.toString());
    var camp = await getSelectedCampPreference();
    var token = await getSharedString('token');
    print('Token: $token');

    var response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'camp': camp,
        'circle': circle,
        'machineType': machineType,
        'token': token
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      print('sucess update Response body laundry: ${response.body}');
      return true;
    } else {
      print(
          'Request update failed with status laundry: ${response.statusCode}.');
      return false;
    }
  }

  Future<String> getSelectedCampPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedCamp = prefs.getString('selectedCamp') ?? '';
    return selectedCamp;
  }

  Future<String> getSharedString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key) ?? '';
    return value;
  }

  Future<List<Map<String, dynamic>>> getLaundryTodayData(
      String? campType) async {
    var url = Uri.parse(getLaundryTodayDataUrl);

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'camp': campType!,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      List<Map<String, dynamic>> result = [];
      for (var item in data) {
        result.add({
          'machineType': item['machineType'],
          'circle': item['circle'],
          'id': item['id']
        });
      }
      return result;
    } else {
      print('Request failed with status laundry: ${response.statusCode}.');
      return [];
    }
  }
}
