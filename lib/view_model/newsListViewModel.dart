import '../model/allNewsModel.dart';
import '../model/bBcNewsModel.dart';
import '../services/services.dart';

class NewsListViewModel {
  final service = MyService();
  Future<AllNewsModel> fetchNews(String category) async {
    final myApiResult = await MyService().fetchAllNews(category);
    return myApiResult;
  }

  Future<BbcNewsModel> fetchBBcNews() async {
    final bbcApi = await service.fetchBBCNews();
    return bbcApi;
  }
}
