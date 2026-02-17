/// Anandham Core — shared package for the Anandham platform.
///
/// Provides constants, models, networking, services, utilities, and widgets
/// used across all Anandham applications (user, author, admin).
library;

// ── Constants ──────────────────────────────────────────────────────────────
export 'src/constants/api_constants.dart';
export 'src/constants/app_constants.dart';
export 'src/constants/color_constants.dart';

// ── Models ─────────────────────────────────────────────────────────────────
export 'src/models/user_model.dart';
export 'src/models/api_response.dart';
export 'src/models/pagination_model.dart';

// ── Network ────────────────────────────────────────────────────────────────
export 'src/network/api_client.dart';
export 'src/network/api_exceptions.dart';
export 'src/network/interceptors/auth_interceptor.dart';
export 'src/network/interceptors/logging_interceptor.dart';

// ── Services ───────────────────────────────────────────────────────────────
export 'src/services/storage_service.dart';
export 'src/services/connectivity_service.dart';

// ── Utilities ──────────────────────────────────────────────────────────────
export 'src/utils/validators.dart';
export 'src/utils/date_utils.dart';
export 'src/utils/string_extensions.dart';

// ── Widgets ────────────────────────────────────────────────────────────────
export 'src/widgets/app_button.dart';
export 'src/widgets/app_text_field.dart';
export 'src/widgets/loading_widget.dart';
export 'src/widgets/error_widget.dart';

// ── Supabase ───────────────────────────────────────────────────────────────
export 'src/supabase/supabase_config.dart';
export 'src/supabase/supabase_auth_service.dart';
export 'src/supabase/supabase_db_service.dart';
export 'src/supabase/supabase_storage_service.dart';

// ── Re-export key Supabase types so apps don't need direct dependency ──────
export 'package:supabase_flutter/supabase_flutter.dart'
    show
        AuthChangeEvent,
        AuthState,
        AuthResponse,
        OAuthProvider,
        OtpType,
        Session,
        User,
        UserResponse;
