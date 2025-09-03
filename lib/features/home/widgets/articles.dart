import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_service.dart';
import '../models/article.dart';
import 'article_card.dart';
import 'categories.dart';

class Articles extends StatefulWidget {
  const Articles({Key? key}) : super(key: key);

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
    int _selectedIndex = 0;
  List<Article> _articles = [];
  bool _isLoading = false;
  String? _error;
  late ApiService _apiService;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _initApiService();
  }

  Future<void> _initApiService() async {
    final prefs = await SharedPreferences.getInstance();
    _apiService = ApiService(prefs: prefs);
    _loadArticles(null);
  }

  Future<void> _loadArticles(id) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (id != null) {
        // _selectedCategory = id;
        
      final articlesData = await _apiService.getBlogPosts(context,
        categoryId: id,
      );
      if (mounted) {
        setState(() {
          _articles = articlesData
              .map((data) => Article.fromJson(data))
              .toList();
        });
      }
      } else{

      final articlesData = await _apiService.getBlogPosts(context,
        categoryId: _selectedCategory,
      );
      if (mounted) {
        setState(() {
          _articles = articlesData
              .map((data) => Article.fromJson(data))
              .toList();
        });
      }
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Categories(loadArticles: _loadArticles),
            //  Expanded(
            // flex: 2,
            // child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter tabs
                DefaultTabController(
                  length: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TabBar(
                        isScrollable: true,
                        tabs: [
                          Tab(text: 'Featured'),
                          Tab(text: 'Popular'),
                          Tab(text: 'Recent'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (_error != null)
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Error: $_error',
                                style: const TextStyle(color: Colors.red),
                              ),
                              ElevatedButton(
                                onPressed:(){

                                 _loadArticles(null);
                                },
                                  
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      else if (_articles.isEmpty)
                        const Center(child: Text('No articles found'))
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _articles.length,
                          itemBuilder: (context, index) {
                            return ArticleCard(article: _articles[index]);
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          // ),


        ],
      ),
    );
  }
}