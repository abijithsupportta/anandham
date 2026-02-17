import 'package:flutter/material.dart';
import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_admin/app/app.dart';
import 'package:anandham_admin/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize dependency injection
  await di.init();

  runApp(const AnandhamAdminApp());
}
