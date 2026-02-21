import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/core/di/injection_container.dart';
import 'package:anandham_user/core/utils/validators.dart';
import 'package:anandham_user/domain/usecases/get_profile_usecase.dart';
import 'package:anandham_user/domain/usecases/update_profile_usecase.dart';
import 'package:anandham_user/presentation/blocs/theme/theme_cubit.dart';

class ProfilePage extends StatefulWidget {
  final Future<void> Function() onLogout;

  const ProfilePage({super.key, required this.onLogout});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _houseNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _sndpUnionController = TextEditingController();
  final _sndpBranchController = TextEditingController();
  final _sndpTempleController = TextEditingController();

  String _selectedCountry = 'India';
  String _selectedCountryCode = '+91';
  bool _isSndpMember = false;
  bool _isLoading = true;
  bool _isSaving = false;
  late final GetProfileUseCase _getProfileUseCase;
  late final UpdateProfileUseCase _updateProfileUseCase;

  static const Map<String, String> _countryCodeMap = {
    'India': '+91',
    'UAE': '+971',
    'USA': '+1',
    'Saudi Arabia': '+966',
    'UK': '+44',
    'Oman': '+968',
  };
  static const List<String> _countries = [
    'India',
    'UAE',
    'USA',
    'Saudi Arabia',
    'UK',
    'Oman',
  ];

  @override
  void initState() {
    super.initState();
    _getProfileUseCase = sl<GetProfileUseCase>();
    _updateProfileUseCase = sl<UpdateProfileUseCase>();
    _loadProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _houseNameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _sndpUnionController.dispose();
    _sndpBranchController.dispose();
    _sndpTempleController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await _getProfileUseCase();

      _fullNameController.text = (profile['full_name'] as String?) ?? '';
      _selectedCountryCode =
          (profile['phone_country_code'] as String?) ?? '+91';
      if (!_countryCodeMap.values.contains(_selectedCountryCode)) {
        _selectedCountryCode = '+91';
      }
      _selectedCountry = _countryCodeMap.entries
          .firstWhere(
            (entry) => entry.value == _selectedCountryCode,
            orElse: () => const MapEntry('India', '+91'),
          )
          .key;

      _phoneController.text = (profile['phone_number'] as String?) ?? '';
      _houseNameController.text = (profile['house_name'] as String?) ?? '';
      _cityController.text = (profile['city'] as String?) ?? '';
      _stateController.text = (profile['state'] as String?) ?? '';
      _isSndpMember = (profile['is_sndp_member'] as bool?) ?? false;
      _sndpUnionController.text = (profile['sndp_union_name'] as String?) ?? '';
      _sndpBranchController.text =
          (profile['sndp_branch_number'] as String?) ?? '';
      _sndpTempleController.text =
          (profile['sndp_temple_name'] as String?) ?? '';
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load profile details')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final payload = <String, dynamic>{
        'full_name': _fullNameController.text.trim(),
        'phone_country_code': _selectedCountryCode,
        'phone_number': _phoneController.text.trim(),
        'house_name': _houseNameController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'is_sndp_member': _isSndpMember,
        'sndp_union_name': _isSndpMember
            ? _sndpUnionController.text.trim()
            : null,
        'sndp_branch_number': _isSndpMember
            ? _sndpBranchController.text.trim()
            : null,
        'sndp_temple_name': _isSndpMember
            ? _sndpTempleController.text.trim()
            : null,
      };

      await _updateProfileUseCase(payload);

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update profile')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _confirmAndLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text(
            'Are you sure you want to sign out from your account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sign out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await widget.onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Update your basic details',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ExpansionTile(
                title: const Text('Basic details'),
                initiallyExpanded: true,
                textColor: Theme.of(context).colorScheme.onSurface,
                collapsedTextColor: Theme.of(context).colorScheme.onSurface,
                iconColor: Theme.of(context).colorScheme.onSurface,
                collapsedIconColor: Theme.of(context).colorScheme.onSurface,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                children: [
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: Validators.fullName,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCountryCode,
                          decoration: const InputDecoration(labelText: 'Code'),
                          items: _countryCodeMap.values
                              .map(
                                (code) => DropdownMenuItem<String>(
                                  value: code,
                                  child: Text(code),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCountryCode = value;
                              _selectedCountry = _countryCodeMap.entries
                                  .firstWhere(
                                    (entry) => entry.value == value,
                                    orElse: () =>
                                        const MapEntry('India', '+91'),
                                  )
                                  .key;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Phone number',
                          ),
                          validator: Validators.phoneLocal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _houseNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'House name'),
                    validator: (value) =>
                        Validators.required(value, 'House name'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Location'),
                childrenPadding: const EdgeInsets.only(bottom: 8),
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCountry,
                    decoration: const InputDecoration(labelText: 'Country'),
                    items: _countries
                        .map(
                          (country) => DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCountry = value;
                        _selectedCountryCode =
                            _countryCodeMap[value] ?? _selectedCountryCode;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cityController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'City'),
                    validator: (value) => Validators.required(value, 'City'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _stateController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'State'),
                    validator: (value) => Validators.required(value, 'State'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('SNDP Yogam'),
                childrenPadding: const EdgeInsets.only(bottom: 8),
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _isSndpMember,
                    title: const Text('Member of SNDP Yogam'),
                    onChanged: (value) {
                      setState(() {
                        _isSndpMember = value;
                      });
                    },
                  ),
                  if (_isSndpMember) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _sndpUnionController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Union name',
                      ),
                      validator: (value) => _isSndpMember
                          ? Validators.required(value, 'Union name')
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _sndpBranchController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Branch number',
                      ),
                      validator: (value) => _isSndpMember
                          ? Validators.required(value, 'Branch number')
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _sndpTempleController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Temple name',
                      ),
                      validator: (value) => _isSndpMember
                          ? Validators.required(value, 'Temple name')
                          : null,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveProfile,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_isSaving ? 'Saving...' : 'Save changes'),
              ),
              const SizedBox(height: 12),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  final isDarkMode = themeMode == ThemeMode.dark;

                  return Card(
                    child: SwitchListTile.adaptive(
                      value: isDarkMode,
                      title: const Text('Dark mode'),
                      subtitle: const Text('Light mode is default'),
                      secondary: Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      ),
                      onChanged: (enabled) {
                        context.read<ThemeCubit>().setThemeMode(
                          enabled ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _confirmAndLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
