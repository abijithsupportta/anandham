import { contentTypeService } from "@/services";
import type { ContentType } from "@/types/database";
import Link from "next/link";

async function getContentTypes() {
  try {
    const { data, error } = await contentTypeService.getAll();
    if (error) {
      console.error("Error fetching content types:", error);
      return null;
    }
    return data || [];
  } catch (err) {
    console.error("Unexpected error fetching content types:", err);
    return null;
  }
}

function getIconForContentType(name: string): string {
  const iconMap: Record<string, string> = {
    guru_krithis: "📜",
    guru_keerthanams: "🎵",
    guru_dharmas: "📖",
    guru_photos: "🖼️",
    guru_stories: "📚",
    blogs: "✍️",
    sponsors: "💝",
    authors: "✒️",
  };
  return iconMap[name] || "📄";
}

function getDisplayName(displayName: string): string {
  const malayalamMap: Record<string, string> = {
    "Sree Narayana Guru Krithis": "ഗുരുദേവകൃതികൾ",
    "Sree Narayana Guru Keerthanams": "ശ്രീ നാരായണ ഗുരുകീർത്തനങ്ങൾ",
    "Sree Narayana Guru Dharmas": "ശ്രീ നാരായണ ധർമം",
    "Sree Narayana Guru Photos": "ശ്രീ നാരായണ ഗുരുചിത്രങ്ങൾ",
    "Sree Narayana Guru Stories": "ശ്രീ നാരായണ ഗുരുകഥകൾ",
    "Blogs": "ബ്ലോഗുകൾ",
    "Sponsors": "സ്പോൺസർമാർ",
    "Authors": "രചയിതാക്കൾ",
  };
  return malayalamMap[displayName] || displayName;
}

export default async function Home() {
  const contentTypes = await getContentTypes();

  // Fallback content types if database fetch fails
  const fallbackContentTypes: ContentType[] = [
    {
      id: "1",
      name: "guru_krithis",
      display_name: "Sree Narayana Guru Krithis",
      description: "Sacred musical compositions and verses",
      icon: "📜",
      color: "bg-purple-100",
      table_name: "krithis",
      display_order: 1,
      is_active: true,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
    {
      id: "2",
      name: "guru_keerthanams",
      display_name: "Sree Narayana Guru Keerthanams",
      description: "Devotional songs and hymns",
      icon: "🎵",
      color: "bg-yellow-100",
      table_name: "guru_keerthanams",
      display_order: 2,
      is_active: true,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
    {
      id: "3",
      name: "guru_dharmas",
      display_name: "Sree Narayana Guru Dharmas",
      description: "Teachings on dharma and righteousness",
      icon: "📖",
      color: "bg-amber-100",
      table_name: "dharmas",
      display_order: 3,
      is_active: true,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
    {
      id: "4",
      name: "guru_photos",
      display_name: "Sree Narayana Guru Photos",
      description: "Photo galleries and memories",
      icon: "🖼️",
      color: "bg-blue-100",
      table_name: "guru_photos",
      display_order: 4,
      is_active: true,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
    {
      id: "5",
      name: "guru_stories",
      display_name: "Sree Narayana Guru Stories",
      description: "Inspirational stories and anecdotes",
      icon: "📚",
      color: "bg-green-100",
      table_name: "guru_stories",
      display_order: 5,
      is_active: true,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
    {
      id: "6",
      name: "blogs",
      display_name: "Blogs",
      description: "Articles and blog posts",
      icon: "✍️",
      color: "bg-rose-100",
      table_name: "blogs",
      display_order: 6,
      is_active: true,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
  ];

  const displayContentTypes = contentTypes || fallbackContentTypes;

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-12">
      {/* Hero Section */}
      <div className="flex flex-col items-center mb-16 sm:mb-20">
        {/* Guru photo in circular frame */}
        <div className="relative mb-8">
          <img
            src="https://vksqkmtdysbzomrhlcqv.supabase.co/storage/v1/object/public/guru/guru_01.jpg"
            alt="Sree Narayana Guru"
            className="w-48 h-48 sm:w-64 sm:h-64 md:w-80 md:h-80 rounded-full object-cover object-top"
            style={{ borderColor: 'var(--color-gold)', borderWidth: '4px' }}
          />
          {/* Outer ring */}
          <div
            className="absolute inset-0 rounded-full pointer-events-none"
            style={{
              borderColor: 'var(--color-gold)',
              borderWidth: '1px',
              opacity: 0.4,
              margin: '-8px'
            }}
          />
        </div>

        {/* Site title */}
        <h1 className="font-heading text-2xl sm:text-3xl md:text-4xl font-bold mb-2" style={{ color: 'var(--color-gold)' }}>
          Gurusmruthi
        </h1>

        {/* Malayalam subtitle */}
        <p className="font-malayalam text-sm sm:text-base" style={{ color: 'var(--color-text)', opacity: 0.7 }}>
          ഡിജിറ്റൽ ലൈബ്രറി
        </p>
      </div>

      {!contentTypes && (
        <div className="mb-6 p-4 rounded-lg" style={{ backgroundColor: 'var(--color-card-bg)', borderColor: 'var(--color-border)', borderWidth: '1px' }}>
          <p className="text-sm" style={{ color: 'var(--color-text)', opacity: 0.7 }}>
            Showing default content types. Unable to connect to database.
          </p>
        </div>
      )}

      {/* Content Grid Section */}
      <div>
        {/* Section heading with gold left border */}
        <h2 className="font-heading text-xl sm:text-2xl font-bold mb-8 pl-4" style={{ color: 'var(--color-text)', borderLeftWidth: '3px', borderLeftColor: 'var(--color-gold)' }}>
          Sacred Texts
        </h2>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {displayContentTypes.map((contentType, index) => (
            <Link
              key={contentType.id}
              href={`/${contentType.name}`}
              className="group"
            >
              <div
                className="rounded-2xl p-6 transition-all duration-200 hover:translate-y-[-4px] hover:border-[var(--color-gold)] cursor-pointer card-animate"
                style={{
                  backgroundColor: 'var(--color-card-bg)',
                  borderColor: 'var(--color-border)',
                  borderWidth: '1px',
                  animationDelay: `${index * 60}ms`
                }}
              >
                {/* Icon */}
                <div className="text-4xl mb-4">
                  {getIconForContentType(contentType.name)}
                </div>

                {/* English name */}
                <h3 className="font-heading text-lg font-bold mb-1" style={{ color: 'var(--color-text)' }}>
                  {contentType.display_name}
                </h3>

                {/* Malayalam name */}
                <p className="font-malayalam text-sm mb-3" style={{ color: 'var(--color-text)', opacity: 0.6 }}>
                  {getDisplayName(contentType.display_name)}
                </p>

                {/* Description */}
                <p className="text-sm line-clamp-2" style={{ color: 'var(--color-text)', opacity: 0.7 }}>
                  {contentType.description}
                </p>
              </div>
            </Link>
          ))}
        </div>
      </div>

      {/* Developed by */}
      <div className="text-center py-8">
        <a
          href="https://abijithcb.com"
          target="_blank"
          rel="noopener noreferrer"
          className="inline-block px-4 py-2 rounded-lg transition-colors"
          style={{
            backgroundColor: 'var(--color-card-bg)',
            border: '1px solid var(--color-border)',
            color: 'var(--color-text)',
            fontSize: '12px'
          }}
        >
          Developed by abijithcb.com
        </a>
      </div>
    </div>
  );
}
