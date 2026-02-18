import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/core/utils/validators.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_cubit.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _houseNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _sndpUnionController = TextEditingController();
  final _sndpBranchController = TextEditingController();
  final _sndpTempleController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String _selectedCountryCode = '+91';
  bool _isSndpMember = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static const List<String> _countryCodes = [
    '+91',
    '+971',
    '+1',
    '+966',
    '+44',
    '+968',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _houseNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _sndpUnionController.dispose();
    _sndpBranchController.dispose();
    _sndpTempleController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submitSignUp() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    String? optionalValue(String value) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    final phoneNumber = optionalValue(_phoneController.text);
    final address = optionalValue(_addressController.text);
    final houseName = optionalValue(_houseNameController.text);
    final city = optionalValue(_cityController.text);
    final stateName = optionalValue(_stateController.text);
    final pincode = optionalValue(_pincodeController.text);

    await context.read<AuthCubit>().signUp(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phoneCountryCode: phoneNumber == null ? null : _selectedCountryCode,
      phoneNumber: phoneNumber,
      address: address,
      houseName: houseName,
      city: city,
      stateName: stateName,
      pincode: pincode,
      isSndpMember: _isSndpMember,
      sndpUnionName: _isSndpMember ? _sndpUnionController.text.trim() : null,
      sndpBranchNumber: _isSndpMember
          ? _sndpBranchController.text.trim()
          : null,
      sndpTempleName: _isSndpMember ? _sndpTempleController.text.trim() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.home,
            (route) => false,
          );
        }

        if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Create your account',
                    style: GoogleFonts.sourceSerif4(
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Join and start reading with a calm, focused experience.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Personal Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: Validators.fullName,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('register_email'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'you@example.com',
                    ),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCountryCode,
                          decoration: const InputDecoration(labelText: 'Code'),
                          items: _countryCodes
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
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }
                            return Validators.phoneLocal(value);
                          },
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
                  TextFormField(
                    controller: _houseNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'House name'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    textInputAction: TextInputAction.next,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cityController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _stateController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'State'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pincodeController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Pincode / Postal code',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }
                      return Validators.pincode(
                        value,
                        countryCode: _selectedCountryCode,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'SNDP Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
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
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Temple name',
                      ),
                      validator: (value) => _isSndpMember
                          ? Validators.required(value, 'Temple name')
                          : null,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'Security',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('register_password'),
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'Minimum 6 characters',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    key: const Key('register_confirm_password'),
                    controller: _confirmController,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submitSignUp(),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state.status == AuthStatus.loading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _submitSignUp,
                        child: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Get started'),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RouteNames.login);
                    },
                    child: const Text('Already have an account? Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
