import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

/// Provides authentication operations backed by Supabase Auth.
///
/// All methods return the raw Supabase response so each app can
/// map it to its own domain layer.
class SupabaseAuthService {
  SupabaseAuthService._();

  static GoTrueClient get _auth => SupabaseConfig.auth;

  // ── Listeners ──────────────────────────────────────────────────────────

  /// Stream of auth state changes (sign-in, sign-out, token refresh, etc.).
  static Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  // ── Email / Password ──────────────────────────────────────────────────

  /// Sign up with email and password.
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _auth.signUp(email: email, password: password, data: data);
    } catch (e) {
      debugPrint('[SupabaseAuthService] signUp error: $e');
      rethrow;
    }
  }

  /// Sign in with email and password.
  static Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      debugPrint('[SupabaseAuthService] signIn error: $e');
      rethrow;
    }
  }

  // ── OAuth ──────────────────────────────────────────────────────────────

  /// Sign in with an OAuth provider (Google, Apple, etc.).
  static Future<bool> signInWithOAuth(
    OAuthProvider provider, {
    String? redirectTo,
    String? scopes,
  }) async {
    try {
      return await _auth.signInWithOAuth(
        provider,
        redirectTo: redirectTo,
        scopes: scopes,
      );
    } catch (e) {
      debugPrint('[SupabaseAuthService] OAuth error: $e');
      rethrow;
    }
  }

  // ── OTP / Magic Link ──────────────────────────────────────────────────

  /// Send a magic link / OTP to the given email.
  static Future<void> signInWithOtp({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await _auth.signInWithOtp(email: email, emailRedirectTo: redirectTo);
    } catch (e) {
      debugPrint('[SupabaseAuthService] OTP error: $e');
      rethrow;
    }
  }

  /// Verify an OTP token (e.g. from email or SMS).
  static Future<AuthResponse> verifyOtp({
    required String email,
    required String token,
    OtpType type = OtpType.email,
  }) async {
    try {
      return await _auth.verifyOTP(email: email, token: token, type: type);
    } catch (e) {
      debugPrint('[SupabaseAuthService] verifyOtp error: $e');
      rethrow;
    }
  }

  // ── Password Reset ────────────────────────────────────────────────────

  /// Send a password-reset email.
  static Future<void> resetPassword({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await _auth.resetPasswordForEmail(email, redirectTo: redirectTo);
    } catch (e) {
      debugPrint('[SupabaseAuthService] resetPassword error: $e');
      rethrow;
    }
  }

  /// Update the password for the currently signed-in user.
  static Future<UserResponse> updatePassword(String newPassword) async {
    try {
      return await _auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      debugPrint('[SupabaseAuthService] updatePassword error: $e');
      rethrow;
    }
  }

  // ── Profile Update ────────────────────────────────────────────────────

  /// Update user metadata (display name, avatar, etc.).
  static Future<UserResponse> updateUserMetadata(
    Map<String, dynamic> data,
  ) async {
    try {
      return await _auth.updateUser(UserAttributes(data: data));
    } catch (e) {
      debugPrint('[SupabaseAuthService] updateUser error: $e');
      rethrow;
    }
  }

  // ── Session ────────────────────────────────────────────────────────────

  /// Refresh the current session.
  static Future<AuthResponse> refreshSession() async {
    try {
      return await _auth.refreshSession();
    } catch (e) {
      debugPrint('[SupabaseAuthService] refreshSession error: $e');
      rethrow;
    }
  }

  /// Sign out the current user.
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('[SupabaseAuthService] signOut error: $e');
      rethrow;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  /// The current user's ID, or `null`.
  static String? get currentUserId => _auth.currentUser?.id;

  /// Whether the current user's email is confirmed.
  static bool get isEmailConfirmed =>
      _auth.currentUser?.emailConfirmedAt != null;

  /// The current access token, or `null`.
  static String? get accessToken => _auth.currentSession?.accessToken;
}
