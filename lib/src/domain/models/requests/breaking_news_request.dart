import '../../../utils/constants/nums.dart';
import '../../../utils/constants/strings.dart';

// https://newsapi.org/v2/top-headlines?country=us&apiKey=YOUR_API_KEY

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
