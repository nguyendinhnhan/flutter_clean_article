import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/article.dart';
import '../../../domain/models/requests/breaking_news_request.dart';
import '../../../domain/repositories/api_repository.dart';
import '../../../utils/constants/strings.dart';
import '../../../utils/resources/data_state.dart';
import '../base/base_cubit.dart';

part 'remote_articles_state.dart';

class RemoteArticlesCubit
    extends BaseCubit<RemoteArticlesState, List<Article>> {
  final ApiRepository _apiRepository;

  RemoteArticlesCubit(this._apiRepository)
      : super(const RemoteArticlesLoading(), []);

  int _page = 1;
  bool noMoreData = false;

  void resetPage() {
    _page = 1;
    noMoreData = false;
  }

  Future<void> getBreakingNewsArticles(
      {String? source = defaultSource, String? query}) async {
    if (isBusy || noMoreData) return;

    await run(() async {
      emit(const RemoteArticlesLoading());

      if (_page == 1) {
        data.clear();
      }
      final response = await _apiRepository.getBreakingNewsArticles(
        request: BreakingNewsRequest(
            page: _page, source: source!, q: query), // Pass the query here
      );

      if (response is DataSuccess) {
        final articles = response.data!.articles;

        noMoreData = articles.length >= response.data!.totalResults;

        data.addAll(articles);
        _page++;

        emit(RemoteArticlesSuccess(articles: data, noMoreData: noMoreData));
      } else if (response is DataFailed) {
        emit(RemoteArticlesFailed(error: response.error));
      }
    });
  }
}
