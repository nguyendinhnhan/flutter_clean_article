import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../domain/models/responses/breaking_news_response.dart';
import '../../../utils/constants/strings.dart';

part 'news_api_service.g.dart';

@RestApi(baseUrl: baseUrl, parser: Parser.MapSerializable)
abstract class NewsApiService {
  factory NewsApiService(Dio dio, {String baseUrl = baseUrl}) {
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.sendTimeout = const Duration(seconds: 10);
    return _NewsApiService(dio, baseUrl: baseUrl);
  }

  @GET('/top-headlines')
  Future<HttpResponse<BreakingNewsResponse>> getBreakingNewsArticles({
    @Query("apiKey") String? apiKey,
    @Query("sources") String? sources,
    @Query("page") int? page,
    @Query("pageSize") int? pageSize,
    @Query("q") String? q,
  });
}
