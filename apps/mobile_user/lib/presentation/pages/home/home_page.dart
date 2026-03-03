import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/core/utils/helpers.dart';
import 'package:anandham_user/presentation/blocs/home/home_cubit.dart';
import 'package:anandham_user/presentation/blocs/home/home_state.dart';
import 'package:anandham_user/presentation/pages/home/widgets/home_content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String? _routeForContent(String name) {
    switch (name) {
      case 'guru_krithis':
        return RouteNames.krithisList;
      case 'guru_dharmas':
        return RouteNames.dharmasList;
      case 'guru_keerthanams':
        return RouteNames.keerthanamsList;
      case 'guru_stories':
        return RouteNames.guruStoriesList;
      case 'guru_photos':
        return RouteNames.photosList;
      case 'sponsors':
        return RouteNames.sponsorsList;
      default:
        return null;
    }
  }

  Future<void> _openCreatorWebsite(BuildContext context) async {
    final uri = Uri.parse('https://abijithcb.com');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open website'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..loadInitial(),
      child: Builder(
        builder: (innerContext) {
          return SafeArea(
            child: RefreshIndicator(
              color: Theme.of(innerContext).colorScheme.primary,
              backgroundColor: Theme.of(innerContext).colorScheme.surface,
              onRefresh: () => innerContext.read<HomeCubit>().refresh(),
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.isLoading && state.contentTypes.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      children: const [
                        SizedBox(height: 260),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }

                  if (state.errorMessage != null &&
                      state.contentTypes.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      children: [
                        SizedBox(
                          height: 360,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Theme.of(context).colorScheme.error,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    state.errorMessage!,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  final profileName = state.profileName?.trim();
                  final greetingText =
                      (profileName != null && profileName.isNotEmpty)
                      ? '${Helpers.getGreeting()}, $profileName!'
                      : '${Helpers.getGreeting()}!';

                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/web-logo.png',
                                height: 64,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Anandham',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                greetingText,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (state.contentTypes.isEmpty)
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(
                                'No content types available',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList.separated(
                            itemCount: state.contentTypes.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final item = state.contentTypes[index];
                              final targetRoute = _routeForContent(item.name);

                              return HomeContentCard(
                                item: item,
                                onTap: targetRoute == null
                                    ? null
                                    : () => Navigator.pushNamed(
                                        context,
                                        targetRoute,
                                      ),
                              );
                            },
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                          child: Center(
                            child: Column(
                              children: [
                                TextButton.icon(
                                  onPressed: () => _openCreatorWebsite(context),
                                  icon: const Icon(
                                    Icons.public_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('abijithcb.com'),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Created by ❤️ Abi',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
