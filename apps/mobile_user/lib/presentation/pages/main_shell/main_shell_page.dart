import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/core/di/injection_container.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_cubit.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_state.dart';
import 'package:anandham_user/presentation/blocs/keerthanams/keerthanam_saved_cubit.dart';
import 'package:anandham_user/presentation/blocs/saved/saved_cubit.dart';
import 'package:anandham_user/presentation/pages/blogs/blogs_page.dart';
import 'package:anandham_user/presentation/pages/home/home_page.dart';
import 'package:anandham_user/presentation/pages/profile/profile_page.dart';
import 'package:anandham_user/presentation/pages/saved/saved_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<SavedCubit>().loadSaved();
    context.read<KeerthanamSavedCubit>().loadSaved();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>()..checkSession(),
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated ||
              state.status == AuthStatus.unauthenticated) {
            context.read<SavedCubit>().loadSaved();
            context.read<KeerthanamSavedCubit>().loadSaved();
          }

          if (state.status == AuthStatus.unauthenticated) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.login,
              (route) => false,
            );
            return;
          }

          if (state.status == AuthStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              const HomePage(),
              const SavedPage(),
              const BlogsPage(),
              Builder(
                builder: (innerContext) => ProfilePage(
                  onLogout: () async {
                    await innerContext.read<AuthCubit>().signOut();

                    if (!innerContext.mounted) {
                      return;
                    }

                    if (innerContext.read<AuthCubit>().state.status ==
                        AuthStatus.unauthenticated) {
                      await Navigator.pushNamedAndRemoveUntil(
                        innerContext,
                        RouteNames.login,
                        (route) => false,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_outline),
                selectedIcon: Icon(Icons.bookmark),
                label: 'Saved',
              ),
              NavigationDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(Icons.article),
                label: 'Blogs',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
