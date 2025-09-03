import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/models/category.dart';
import '../../home/home_page.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<CategoryModel> _categories = [];
  final List<int> selectedInterests = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _initApiService();
  }

  Future<void> _initApiService() async {
    final prefs = await SharedPreferences.getInstance();
    _apiService = ApiService(prefs: prefs);
    _loadCategories();
    // _loadInterests();
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

  Future<void> _saveInterests() async {
    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      await _apiService.updateInterests(context, selectedInterests.toList());
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // _error = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? 20 : 40,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                      child: const Text(
                        'Skip for later',
                        style: TextStyle(color: Color(0xFF7F00FF)),
                      ),
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Avatar and title
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/avatar.png',
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'What are your interests?',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Select your interests and I'll recommend some series I'm certain you'll enjoy!",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Interests grid
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (!_isLoading)
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isMobile(context) ? 20 : 40,
                  ),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _categories.map((category) {
                      final isSelected = selectedInterests.contains(
                        category.id,
                      );
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedInterests.remove(category.id);
                            } else {
                              selectedInterests.add(category.id);
                            }
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
              ),
            // Next button
            Padding(
              padding: EdgeInsets.all(Responsive.isMobile(context) ? 20 : 40),
              child: ElevatedButton(
                onPressed: selectedInterests.isNotEmpty
                    ? () async {
                        await _saveInterests();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    : null,
                child: _isSaving
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InterestCategory {
  final String name;
  final IconData icon;

  InterestCategory(this.name, this.icon);
}
