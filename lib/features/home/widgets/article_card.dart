import 'package:flutter/material.dart';
import 'package:mvm_flutter_test/features/home/models/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final bool isCompact;

  const ArticleCard({super.key, required this.article, this.isCompact = false});


  String _formatDateLong(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = _getMonthName(date.month);
    final year = date.year.toString();
    return '$day $month $year';
  }

  // String _formatDate(DateTime date) {
  //   final now = DateTime.now();
  //   final difference = now.difference(date);

  //   if (difference.inDays < 1) {
  //     if (difference.inHours < 1) {
  //       return '${difference.inMinutes}m ago';
  //     }
  //     return '${difference.inHours}h ago';
  //   } else if (difference.inDays < 7) {
  //     return '${difference.inDays}d ago';
  //   } else {
  //     final day = date.day.toString().padLeft(2, '0');
  //     final month = _getMonthName(date.month);
  //     final year = date.year.toString();
  //     return '$day $month $year';
  //   }
  // }

  String _getMonthName(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article image
          if (article.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: isCompact ? 80 : 120,
                height: isCompact ? 80 : 120,
                child: Image.network(
                  article.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          const SizedBox(width: 16),
          // Article content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                

                const SizedBox(width: 8),
                Text(
                  article.series.name.toUpperCase(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600],  ),
                ),
                // Title
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: isCompact ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isCompact) ...[
                  const SizedBox(height: 8),
                  // Content
                  Text(
                    article.content,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                // Author and Series
                Row(
                  children: [
                    Text(
                      article.author.name,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                     const SizedBox(width: 8),
                Text('•', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(width: 8),
                Text(
                  _formatDateLong(article.createdAt),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                ),
                    // const SizedBox(width: 8),
                    // Text('•', style: TextStyle(color: Colors.grey[600])),
                    
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
