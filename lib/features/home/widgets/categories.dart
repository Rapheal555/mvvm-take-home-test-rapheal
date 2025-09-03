import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_service.dart';
import '../../../core/utils/responsive.dart';
import '../models/category.dart';

class Categories extends StatefulWidget {
  const Categories({super.key, this.loadArticles});
  final Function(dynamic)? loadArticles;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<CategoryModel> _categories = [];
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
    // _loadArticles();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      // _error = null;
    });
    try {
      final categories = await _apiService.getCategories(context);
      // if (mounted) {
      setState(() {
        _categories = categories
            .map((data) => CategoryModel.fromJson(data))
            .toList();
        _isLoading = false;
      });
      // }
      // Handle categories as needed
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Text(
          'Categories',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        if (_categories.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 20 : 40,
            ),
            child: Wrap(
              clipBehavior: Clip.antiAlias,
              spacing: 12,
              runSpacing: 12,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category.name;

                return InkWell(
                  onTap: () {
                    widget.loadArticles!(category.id.toString());
                    setState(() {
                      _selectedCategory = category.name;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF7F00FF)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${category.icon} ${category.name}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 20),
        // if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
