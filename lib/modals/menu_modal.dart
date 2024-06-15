import 'package:flutter/foundation.dart';

class MenuModel extends ChangeNotifier {
  String? _menuID;
  String? _videourl;
  Map<String, dynamic> _data = {};
  bool _isLoading = true;
  List<dynamic> _videos = [];

  String? get menuID => _menuID;
  Map<String, dynamic> get data => _data;
  bool get isLoading => _isLoading;
  String? get videourl => _videourl;
  List<dynamic> get videos => _videos;

  void setMenuID(String? menuID) {
    _menuID = menuID;
    notifyListeners();
  }

  void setData(Map<String, dynamic> data) {
    _data = data;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setVideos(List<dynamic> videos) {
    _videos = videos;
    notifyListeners();
  }
  void setVideosUrl(String videourl) {
    _videourl = videourl;
    notifyListeners();
  }
}




// class MenuModel with ChangeNotifier {
//   String? menuID;
//   Map<String, dynamic> data = {};
//   bool isLoading = true;
//   String? selectedDish;
//   int selectedPortion = 1;

//   void setData(Map<String, dynamic> newData) {
//     data = newData;
//     notifyListeners();
//   }

//   void setLoading(bool loading) {
//     isLoading = loading;
//     notifyListeners();
//   }

//   void setSelectedDish(String dish) {
//     selectedDish = dish;
//     notifyListeners();
//   }

//   void setSelectedPortion(int portion) {
//     selectedPortion = portion;
//     notifyListeners();
//   }
// }