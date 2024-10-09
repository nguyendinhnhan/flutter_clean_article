import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

import '../../config/router/app_router.dart';
import '../../domain/models/article.dart';
import '../../domain/models/source.dart';
import '../../utils/constants/lists.dart';
import '../../utils/constants/strings.dart';
import '../../utils/extensions/scroll_controller.dart';
import '../cubits/remote_articles/remote_articles_cubit.dart';
import '../widgets/article_widget.dart';

class BreakingNewsView extends HookWidget {
  const BreakingNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteArticlesCubit = BlocProvider.of<RemoteArticlesCubit>(context);
    final scrollController = useScrollController();
    final selectedSource = useState<String>(defaultSource);
    final searchQuery = useState<String>('');

    useEffect(() {
      scrollController.onScrollEndsListener(() {
        remoteArticlesCubit.getBreakingNewsArticles(
            source: selectedSource.value);
      });

      return scrollController.dispose;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily News',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          DropdownButton<String>(
            value: selectedSource.value,
            icon: const Icon(Ionicons.chevron_down, color: Colors.black),
            dropdownColor: Colors.white,
            focusColor: Colors.transparent,
            onChanged: (String? newValue) {
              if (newValue != null) {
                selectedSource.value = newValue;
                remoteArticlesCubit.resetPage();
                remoteArticlesCubit.getBreakingNewsArticles(
                    source: selectedSource.value);
              }
            },
            items: sourceNews.map<DropdownMenuItem<String>>((Source source) {
              return DropdownMenuItem<String>(
                value: source.id,
                child: Text(source.name),
              );
            }).toList(),
          ),
          GestureDetector(
            onTap: () => appRouter.push(const SavedArticlesViewRoute()),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Icon(Ionicons.bookmark, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                searchQuery.value = value;
              },
              decoration: InputDecoration(
                hintText: 'Search articles...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.6)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<RemoteArticlesCubit, RemoteArticlesState>(
              builder: (_, state) {
                switch (state.runtimeType) {
                  case const (RemoteArticlesLoading):
                    return const Center(child: CupertinoActivityIndicator());
                  case const (RemoteArticlesFailed):
                    return const Center(child: Icon(Ionicons.refresh));
                  case const (RemoteArticlesSuccess):
                    final filteredArticles = state.articles.where((article) {
                      return article.title
                              ?.toLowerCase()
                              .contains(searchQuery.value.toLowerCase()) ??
                          false;
                    }).toList();
                    return _buildArticles(
                      scrollController,
                      filteredArticles,
                      state.noMoreData,
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticles(
    ScrollController scrollController,
    List<Article> articles,
    bool noMoreData,
  ) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ArticleWidget(
              article: articles[index],
              onArticlePressed: (e) => appRouter.push(
                ArticleDetailsViewRoute(article: e),
              ),
            ),
            childCount: articles.length,
          ),
        ),
        if (!noMoreData)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 14, bottom: 32),
              child: CupertinoActivityIndicator(),
            ),
          )
      ],
    );
  }
}
