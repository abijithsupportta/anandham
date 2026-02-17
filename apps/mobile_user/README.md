# anandham_user

Flutter app for Anandham end users.

## Run with environment config

Use `dart-define` for all environment values (no hardcoded secrets):

```bash
flutter run \
	--dart-define=SUPABASE_URL=https://your-project.supabase.co \
	--dart-define=SUPABASE_ANON_KEY=your_anon_key \
	--dart-define=API_BASE_URL=https://api.anandham.com/v1
```

## Authentication flow

- Splash checks current session.
- If signed in, app navigates to Home shell.
- If signed out, app navigates to Login.
- Create Account and Login both use Supabase email/password auth.

## Main app navigation

- Home
- Saved
- Blogs
- Profile
