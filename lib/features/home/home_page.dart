import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/utils/responsive.dart';
import '../../../features/home/models/article.dart';
import '../../../features/home/models/category.dart';
import '../../../features/home/widgets/article_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../widgets/categories.dart';
import 'widgets/categories.dart';
import 'widgets/sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSidebarVisible = false;
  List<Article> _articles = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;
  late ApiService _apiService;
  String? _selectedCategory;

  Widget _buildMainContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 16 : 24,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mobile header
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        setState(() {
                          _isSidebarVisible = true;
                        });
                      },
                    ),
                    const Spacer(),
                    const Text(
                      'BREACH',
                      style: TextStyle(
                        color: Color(0xFF7F00FF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Handle search
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              Categories(loadArticles: _loadArticles),
              const SizedBox(height: 32),
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
                        onPressed: () {
                          _loadArticles(null);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (_articles.isEmpty)
                const Center(child: Text('No articles found'))
              else ...[
                // Top Picks section
                Text(
                  'Top Picks',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Experience the best of Breach',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                // Featured article
                InkWell(
                  onTap: () {
                    // Handle article tap
                  },
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(
                            _articles[0].imageUrl ??
                                'https://via.placeholder.com/800x450',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7F00FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'FEATURED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _articles[0].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _articles[0].content,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Rest of the articles
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _articles.length - 1,
                  itemBuilder: (context, index) {
                    return ArticleCard(
                      article: _articles[index + 1],
                      isCompact: false,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initApiService();
  }

  Future<void> _initApiService() async {
    final prefs = await SharedPreferences.getInstance();
    _apiService = ApiService(prefs: prefs);
    _loadArticles(null);
    _loadCategories();
  }

  Future<void> _loadArticles(id) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (id != null) {
        final articlesData = await _apiService.getBlogPosts(
          context,
          categoryId: id,
        );

        if (mounted) {
          setState(() {
            _articles = articlesData
                .map((data) => Article.fromJson(data))
                .toList();
          });
        }
      } else {
        final articlesData = await _apiService.getBlogPosts(
          context,
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

  Future<void> _loadCategories() async {
    try {
      final categories = await _apiService.getCategories(context);
      if (mounted) {
        setState(() {
          _categories = categories
              .map((data) => CategoryModel.fromJson(data))
              .toList();
        });
      }
      // Handle categories as needed
    } catch (e) {
      // Handle error
    }
  }

    void _closeSidebar() {
    setState(() {
      _isSidebarVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content with permanent sidebar for desktop
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!Responsive.isMobile(context))
                Sidebar(onClose: _closeSidebar),
              Expanded(child: _buildMainContent()),
            ],
          ),
          // Overlay sidebar for mobile and tablet
         if (_isSidebarVisible &&
              (Responsive.isMobile(context) || Responsive.isTablet(context)))
            if (_isSidebarVisible) Sidebar(onClose: _closeSidebar),
        ],
      ),
    );
  }
}
