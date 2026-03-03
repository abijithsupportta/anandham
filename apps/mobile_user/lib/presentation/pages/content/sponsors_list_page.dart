import 'package:anandham_user/core/utils/helpers.dart';
import 'package:anandham_user/presentation/blocs/sponsors/sponsors_list_cubit.dart';
import 'package:anandham_user/presentation/blocs/sponsors/sponsors_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SponsorsListPage extends StatelessWidget {
  const SponsorsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SponsorsListCubit()..loadSponsors(),
      child: const _SponsorsListView(),
    );
  }
}

class _SponsorsListView extends StatefulWidget {
  const _SponsorsListView();

  @override
  State<_SponsorsListView> createState() => _SponsorsListViewState();
}

class _SponsorsListViewState extends State<_SponsorsListView> {
  double _amountValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  bool _isAmountVisible(Map<String, dynamic> sponsor) {
    final raw = sponsor['amount_visible'];
    if (raw is bool) {
      return raw;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Sponsors')),
      body: SafeArea(
        child: BlocBuilder<SponsorsListCubit, SponsorsListState>(
          builder: (context, state) {
            if (state.isLoading && state.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Failed to load sponsors'),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () =>
                            context.read<SponsorsListCubit>().loadSponsors(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final filtered = state.items;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.18),
                          colorScheme.tertiary.withValues(alpha: 0.14),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.30),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Premium Sponsors',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Text(
                          '${filtered.length} sponsors',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('No sponsors available'))
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final sponsor = filtered[index];
                            final rank = index + 1;
                            final sponsorName =
                                (sponsor['sponsor_name'] as String? ?? '')
                                    .trim();
                            final houseName =
                                (sponsor['house_name'] as String? ?? '').trim();
                            final photoUrl =
                                (sponsor['photo_url'] as String? ?? '').trim();
                            final amount = _amountValue(
                              sponsor['donated_amount'],
                            );
                            final amountVisible = _isAmountVisible(sponsor);

                            return Container(
                              decoration: BoxDecoration(
                                color: isLight
                                    ? colorScheme.surfaceContainerLow
                                    : colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isLight
                                      ? colorScheme.primary.withValues(
                                          alpha: 0.26,
                                        )
                                      : colorScheme.outline.withValues(
                                          alpha: 0.55,
                                        ),
                                ),
                                boxShadow: isLight
                                    ? [
                                        BoxShadow(
                                          color: colorScheme.primary.withValues(
                                            alpha: 0.08,
                                          ),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ]
                                    : const [],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary.withValues(
                                          alpha: 0.14,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: colorScheme.primary.withValues(
                                            alpha: 0.36,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        '$rank',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 64,
                                        height: 64,
                                        color:
                                            colorScheme.surfaceContainerHighest,
                                        child: photoUrl.isEmpty
                                            ? Icon(
                                                Icons.person_rounded,
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              )
                                            : Image.network(
                                                photoUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Icon(
                                                      Icons.person_rounded,
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sponsorName.isEmpty
                                                ? 'Unknown Sponsor'
                                                : sponsorName,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            houseName.isEmpty
                                                ? 'House: Not provided'
                                                : 'House: $houseName',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: amountVisible
                                                  ? colorScheme.primary
                                                        .withValues(alpha: 0.14)
                                                  : colorScheme
                                                        .surfaceContainerHighest,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              border: Border.all(
                                                color: amountVisible
                                                    ? colorScheme.primary
                                                          .withValues(
                                                            alpha: 0.32,
                                                          )
                                                    : colorScheme
                                                          .outlineVariant,
                                              ),
                                            ),
                                            child: Text(
                                              amountVisible
                                                  ? 'Amount: ${Helpers.formatCurrency(amount)}'
                                                  : 'Amount: Hidden',
                                              style: theme.textTheme.labelMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color: amountVisible
                                                        ? colorScheme.primary
                                                        : colorScheme
                                                              .onSurfaceVariant,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
