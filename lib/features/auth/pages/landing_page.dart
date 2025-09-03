import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../features/auth/pages/join_breach_page.dart';
import '../../../features/auth/pages/login_page.dart';
import '../../../features/home/widgets/articles.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 20 : 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Header with logo and login button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'BREACH',
                      style: TextStyle(
                        color: Color(0xFF7F00FF),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Color(0xFF7F00FF),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                // Main content
                SizedBox(height: Responsive.isMobile(context) ? 40 : 80),
                if (!Responsive.isMobile(context))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildContent(context)),
                      const SizedBox(width: 40),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildContent(context),
                      const SizedBox(height: 40),
                    ],
                  ),

                Articles(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find Great',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: Responsive.isMobile(context) ? 32 : 48,
          ),
        ),
        Text(
          'Ideas',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: Responsive.isMobile(context) ? 32 : 48,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Subscribe to your favorite creators and discover support work that matters',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: Responsive.isMobile(context) ? 16 : 18,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JoinBreachPage()),
            );
          },
          child: const Text('Join Breach'),
        ),
      ],
    );
  }
}
