import 'package:anandham_user/app/theme/app_colors.dart';
import 'package:anandham_user/presentation/blocs/home/home_state.dart';
import 'package:flutter/material.dart';

class HomeContentCard extends StatelessWidget {
  final HomeContentTypeItem item;
  final VoidCallback? onTap;

  const HomeContentCard({super.key, required this.item, required this.onTap});

  Color _hexToColor(BuildContext context, String? hex) {
    if (hex == null || hex.trim().isEmpty) {
      return Theme.of(context).colorScheme.primary;
    }

    final normalized = hex.replaceAll('#', '');
    final withAlpha = normalized.length == 6 ? 'FF$normalized' : normalized;
    return Color(int.parse(withAlpha, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _hexToColor(context, item.colorHex);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isDark ? accent.withValues(alpha: 0.16) : Colors.white,
                isDark
                    ? accent.withValues(alpha: 0.08)
                    : accent.withValues(alpha: 0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: accent.withValues(alpha: isDark ? 0.28 : 0.34),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: isDark ? 0.12 : 0.10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: accent.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    item.displayIcon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.localizedTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? accent : AppColors.textPrimaryLight,
                        ),
                      ),
                      if (item.localizedDescription.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.localizedDescription,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: isDark
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant
                                    : AppColors.textSecondaryLight,
                                height: 1.3,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? accent : accent.withValues(alpha: 0.95),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
