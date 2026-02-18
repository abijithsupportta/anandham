import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/presentation/blocs/profile/profile_completion_cubit.dart';
import 'package:anandham_user/presentation/blocs/profile/profile_completion_state.dart';

class ProfileCompletionPage extends StatefulWidget {
  const ProfileCompletionPage({super.key});

  @override
  State<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  late ProfileCompletionCubit _cubit;
  final _fullNameController = TextEditingController();
  final _phoneCountryCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _houseNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  bool _isSndpMember = false;
  final _sndpUnionController = TextEditingController();
  final _sndpBranchController = TextEditingController();
  final _sndpTempleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProfileCompletionCubit>();
    _cubit.loadProfileCompletion();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneCountryCodeController.dispose();
    _phoneNumberController.dispose();
    _houseNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _sndpUnionController.dispose();
    _sndpBranchController.dispose();
    _sndpTempleController.dispose();
    super.dispose();
  }

  void _populateFields() {
    final data = _cubit.state.profileData;
    _fullNameController.text = data['full_name'] as String? ?? '';
    _phoneCountryCodeController.text =
        data['phone_country_code'] as String? ?? '+91';
    _phoneNumberController.text = data['phone_number'] as String? ?? '';
    _houseNameController.text = data['house_name'] as String? ?? '';
    _addressController.text = data['address'] as String? ?? '';
    _cityController.text = data['city'] as String? ?? '';
    _stateController.text = data['state'] as String? ?? '';
    _pincodeController.text = data['pincode'] as String? ?? '';
    _isSndpMember = data['is_sndp_member'] as bool? ?? false;
    _sndpUnionController.text = data['sndp_union_name'] as String? ?? '';
    _sndpBranchController.text = data['sndp_branch_number'] as String? ?? '';
    _sndpTempleController.text = data['sndp_temple_name'] as String? ?? '';
  }

  Future<void> _saveProfile() async {
    await _cubit.updateProfile(
      fullName: _fullNameController.text.trim(),
      phoneCountryCode: _phoneCountryCodeController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      houseName: _houseNameController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      stateName: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
      isSndpMember: _isSndpMember,
      sndpUnionName: _isSndpMember ? _sndpUnionController.text.trim() : null,
      sndpBranchNumber: _isSndpMember
          ? _sndpBranchController.text.trim()
          : null,
      sndpTempleName: _isSndpMember ? _sndpTempleController.text.trim() : null,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: BlocBuilder<ProfileCompletionCubit, ProfileCompletionState>(
        builder: (context, state) {
          if (state.isLoading && state.profileData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!state.isLoading && state.profileData.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _populateFields();
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Completion Header
                  _buildCompletionHeader(context, state),
                  const SizedBox(height: 24),

                  // Form Fields
                  Text(
                    'Personal Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _phoneCountryCodeController,
                          decoration: const InputDecoration(
                            labelText: 'Code',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Address Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _houseNameController,
                    decoration: const InputDecoration(
                      labelText: 'House Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pincodeController,
                    decoration: const InputDecoration(
                      labelText: 'Pincode',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'SNDP Details (Optional)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    value: _isSndpMember,
                    title: const Text('Are you a member of SNDP Yogam?'),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        _isSndpMember = value;
                      });
                    },
                  ),
                  if (_isSndpMember) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _sndpUnionController,
                      decoration: const InputDecoration(
                        labelText: 'Union Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _sndpBranchController,
                      decoration: const InputDecoration(
                        labelText: 'Branch Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _sndpTempleController,
                      decoration: const InputDecoration(
                        labelText: 'Temple Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _saveProfile,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Profile'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompletionHeader(
    BuildContext context,
    ProfileCompletionState state,
  ) {
    final isComplete = state.completionPercentage >= 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Completion',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${state.completionPercentage.toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(width: 8),
                      if (isComplete)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Complete',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: state.completionPercentage / 100,
              minHeight: 8,
              backgroundColor: Theme.of(context).dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete
                    ? Colors.green
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (state.missingFields.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Missing Fields (${state.missingFields.length}):',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.missingFields
                  .map(
                    (field) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _formatFieldName(field),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatFieldName(String field) {
    final parts = field.split('_');
    return parts.map((p) => '${p[0].toUpperCase()}${p.substring(1)}').join(' ');
  }
}
