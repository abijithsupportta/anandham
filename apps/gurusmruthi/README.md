# Gurusmruthi - Anandham Frontend Website

This is the frontend website for Gurusmruthi, built with Next.js 16+ and powered by the Anandham backend API and Supabase.

## Tech Stack

- **Next.js 16.1.6** - React framework with React Compiler
- **React 19.2.3** - UI library
- **TypeScript 5** - Type safety
- **Tailwind CSS 4** - Styling
- **Supabase (@supabase/ssr)** - Backend and database with SSR support
- **AWS SDK S3** - Cloudflare R2 storage integration

## Getting Started

### Prerequisites

- Node.js 18+ installed
- Supabase project configured
- Cloudflare R2 account configured (for image storage)

### Installation

1. Install dependencies:
```bash
npm install
```

2. Set up environment variables:
```bash
cp .env.example .env.local
```

3. Update `.env.local` with your Supabase and R2 credentials:
```
NEXT_PUBLIC_SUPABASE_URL=https://vksqkmtdysbzomrhlcqv.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
R2_BUCKET_NAME=anandham-photos
R2_ACCOUNT_ID=your_account_id
R2_ACCESS_KEY_ID=your_access_key
R2_SECRET_ACCESS_KEY=your_secret_key
R2_ENDPOINT=https://your_account_id.r2.cloudflarestorage.com
R2_PUBLIC_URL=https://your_public_url.r2.dev
```

### Development

Run the development server:
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Build

Build for production:
```bash
npm run build
```

### Start Production Server

```bash
npm start
```

## Project Structure

```
src/
├── app/              # Next.js app directory
│   ├── layout.tsx    # Root layout
│   ├── page.tsx      # Home page
│   └── globals.css   # Global styles
├── lib/              # Utility libraries
│   ├── supabase/     # Supabase client configuration
│   │   ├── client.ts # Browser client
│   │   └── server.ts # Server client
│   ├── r2.ts         # Cloudflare R2 storage utilities
│   └── utils.ts      # Utility functions (cn helper)
├── services/         # API service layer
│   ├── base.ts       # Base service utilities
│   ├── guru-photo.service.ts
│   ├── krithi.service.ts
│   ├── dharma.service.ts
│   ├── keerthanam.service.ts
│   ├── blog.service.ts
│   ├── guru-story.service.ts
│   ├── sponsor.service.ts
│   └── author.service.ts
└── types/            # TypeScript types
    └── database.ts   # Database types from Supabase
```

## API Integration

This frontend connects to the Anandham Supabase database and displays published content:

### Available Content Types

- **Guru Photos** - Photo galleries with categories
- **Krithis** - Musical compositions with slokas
- **Dharmas** - Dharma teachings with items and words
- **Guru Keerthanams** - Devotional songs
- **Blogs** - Blog posts with categories
- **Guru Stories** - Stories about the Guru
- **Sponsors** - Sponsor information
- **Authors** - Author profiles

### Service Layer

All data fetching is done through the service layer in `src/services/`. Each service provides:

- `getAll()` - Fetch all published items
- `getById(id)` - Fetch by ID
- `getBySlug(slug)` - Fetch by slug
- `getByCategory(categoryId)` - Filter by category (where applicable)

Example usage:
```typescript
import { guruPhotoService } from '@/services';

const { data, error } = await guruPhotoService.getAll();
```

## Supabase Integration

This project uses Supabase for:
- Database queries (published content only)
- Server-side rendering with `@supabase/ssr`
- Cookie-based session management

The Supabase client is configured in `src/lib/supabase/` with separate browser and server clients for optimal SSR support.

## R2 Storage Integration

Cloudflare R2 is used for image storage. The R2 utilities in `src/lib/r2.ts` provide:

- `uploadToR2()` - Upload files to R2
- `deleteFromR2()` - Delete files from R2
- `getKeyFromUrl()` - Extract key from public URL
- `generateKey()` - Generate unique upload keys

## Database Schema

The database types are defined in `src/types/database.ts` and match the Anandham Supabase schema. Key entities:

- `profiles` - User profiles
- `content_types` - Content type definitions
- `content_categories` - Content categories
- `authors` - Author information
- `krithis`, `dharmas`, `guru_photos`, `guru_keerthanams`, `blogs` - Content tables
- `sponsors` - Sponsor information

## Learn More

- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Cloudflare R2 Documentation](https://developers.cloudflare.com/r2/)
