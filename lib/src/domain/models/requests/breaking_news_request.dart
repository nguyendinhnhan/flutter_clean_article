import '../../../utils/constants/nums.dart';
import '../../../utils/constants/strings.dart';

// https://newsapi.org/v2/top-headlines?country=us&apiKey=YOUR_API_KEY
// https://newsapi.org/v2/top-headlines?apiKey=058dc1d8f0564d6387c3f1889ebbb977&sources=bbc-news%2C+abc-news&page=1&pageSize=20

class BreakingNewsRequest {
  final String apiKey;
  final String sources;
  final int page;
  final int pageSize;

  BreakingNewsRequest({
    this.apiKey = defaultApiKey,
    this.sources = 'bbc-news, abc-news',
    this.page = 1,
    this.pageSize = defaultPageSize,
  });
}
