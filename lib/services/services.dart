import 'dart:convert';

import 'package:http/http.dart' as http;

import '../common/const.dart';
import '../model/allNewsModel.dart';
import '../model/bBcNewsModel.dart';

class MyService {
  Future<AllNewsModel> fetchAllNews(String category) async {
    String newsUrl =
        'https://newsapi.org/v2/everything?q=$category&apiKey=$API_KEY';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final jsonResponce = jsonDecode(response.body);

      return AllNewsModel.fromJson(jsonResponce);
    } else {
      throw Exception('Error');
    }
  }

  Future<BbcNewsModel> fetchBBCNews() async {
    String newsUrl =
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=$API_KEY';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final jsonResponce = jsonDecode(response.body);

      return BbcNewsModel.fromJson(jsonResponce);
    } else {
      throw Exception('Error');
    }
  }
}
