import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subText;
  final int alertLevel; // 0 = normal, 1 = warning, 2 = alert
  final VoidCallback? onTap;
  final bool showChevron; // New parameter to control chevron visibility
  final double borderRadius; 
  final bool isDarkMode;

  const StatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subText,
    required this.isDarkMode,
    this.alertLevel = 0,
    this.onTap,
    this.showChevron = true, // Default to true
    this.borderRadius = 15.0, // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: onTap != null ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors['background'],
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: colors['border']!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon with background and tooltip
              Tooltip(
                message: title,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors['iconBackground'],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: colors['icon'], size: 28),
                ),
              ),
              const SizedBox(width: 16),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors['title'],
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors['value'],
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subText,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colors['subText']),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              // Optional Chevron icon with tooltip
              if (showChevron && onTap != null)
                Tooltip(
                  message: 'More details',
                  child: Icon(
                    Icons.chevron_right,
                    color: colors['icon'],
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, Color> _getColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colorSchemes = {
      1: {
        // Warning
        'background': isDark ? Colors.orange[900]! : Colors.orange[50]!,
        'border': isDark ? Colors.orange[800]! : Colors.orange[200]!,
        'iconBackground': isDark ? Colors.orange[800]! : Colors.orange[100]!,
        'icon': Colors.orange,
        'title': isDark ? Colors.orange[100]! : Colors.orange[900]!,
        'value': isDark ? Colors.orange : Colors.orange[800]!,
        'subText': isDark ? Colors.orange[300]! : Colors.orange[600]!,
      },
      2: {
        // Alert
        'background': isDark ? Colors.red[900]! : Colors.red[50]!,
        'border': isDark ? Colors.red[800]! : Colors.red[200]!,
        'iconBackground': isDark ? Colors.red[800]! : Colors.red[100]!,
        'icon': Colors.red,
        'title': isDark ? Colors.red[100]! : Colors.red[900]!,
        'value': isDark ? Colors.red : Colors.red[800]!,
        'subText': isDark ? Colors.red[300]! : Colors.red[600]!,
      },
      0: {
        // Normal
        'background': isDark ? Colors.blueGrey[800]! : Colors.grey[50]!,
        'border': isDark ? Colors.blueGrey[600]! : Colors.grey[200]!,
        'iconBackground': isDark ? Colors.blueGrey[700]! : Colors.grey[100]!,
        'icon': isDark ? Colors.blueGrey[300]! : Colors.grey[600]!,
        'title': isDark ? Colors.blueGrey[100]! : Colors.grey[800]!,
        'value': isDark ? Colors.white : Colors.black,
        'subText': isDark ? Colors.blueGrey[300]! : Colors.grey[600]!,
      },
    };

    return colorSchemes[alertLevel]!;
  }
}
