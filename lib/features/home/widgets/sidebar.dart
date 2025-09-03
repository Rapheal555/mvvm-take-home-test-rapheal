import 'package:flutter/material.dart';

import '../../../core/utils/responsive.dart';

class Sidebar extends StatefulWidget {
  final VoidCallback onClose;
  final bool isOverlay;

  const Sidebar({super.key, required this.onClose, this.isOverlay = false});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  Widget _buildSidebar() {
    return Container(
      width: Responsive.isDesktop(context) ? 240 : 72,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: Responsive.isDesktop(context) ? 24 : 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BREACH',
                  style: TextStyle(
                    color: const Color(0xFF7F00FF),
                    fontSize: Responsive.isDesktop(context) ? 24 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle start writing
              },
              icon: const Icon(Icons.edit, size: 20),
              label: const Text('Start writing'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildNavigationItem(Icons.home, 'Home', true),
          _buildNavigationItem(Icons.dashboard, 'Dashboard', false),
          _buildNavigationItem(Icons.book, 'Publications', false),
          _buildNavigationItem(Icons.settings, 'Settings', false),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(IconData icon, String label, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Handle navigation
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: isSelected ? Colors.grey[100] : Colors.transparent,
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF7F00FF) : Colors.grey,
              ),
              // if (Responsive.isDesktop(context)) ...[
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF7F00FF) : Colors.grey,
                ),
              ),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                widget.onClose();
                // setState(() {
                //   widget.isSidebarVisible = false;
                // });
              },
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),
          // Sidebar
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx < -5) {
                widget.onClose();

                  // setState(() {
                  //   widget.isSidebarVisible = false;
                  // });
                }
              },
              child: Container(
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: _buildSidebar(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
