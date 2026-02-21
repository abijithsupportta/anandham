# anandham_user

Flutter app for Anandham end users.

## Run with environment config

Use `dart-define` for all environment values (no hardcoded secrets):

```bash
flutter run \
	--dart-define=SUPABASE_URL=https://your-project.supabase.co \
	--dart-define=SUPABASE_ANON_KEY=your_anon_key
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

## Android release signing (Play Store)

1. Copy `android/key.properties.example` to `android/key.properties`.
2. Set real values in `android/key.properties`:
	- `storeFile`
	- `storePassword`
	- `keyAlias`
	- `keyPassword`
3. Ensure the keystore file path in `storeFile` exists on your machine.
4. Build signed AAB:

```bash
cd apps/mobile_user
flutter build appbundle
```

Output AAB:
- `build/app/outputs/bundle/release/app-release.aab`
