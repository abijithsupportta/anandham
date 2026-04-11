import JsonLd from "@/components/JsonLd";
import { SITE_URL, GURU_PERSON } from "@/lib/seo";
import type { Krithi } from "@/types/database";

interface KrithiSchemaProps {
  krithi: Krithi;
}

export default function KrithiSchema({ krithi }: KrithiSchemaProps) {
  const schema = {
    "@context": "https://schema.org",
    "@type": "CreativeWork",
    "additionalType": "https://schema.org/Poem",
    "name": krithi.title,
    "text": krithi.description || "",
    "inLanguage": "ml",
    "author": GURU_PERSON,
    "genre": ["Spiritual Poetry", "Malayalam Literature", "Devotional", "Kerala Classical"],
    "about": GURU_PERSON,
    "keywords": `${krithi.title}, sree narayana guru, ഗുരുദേവകൃതി, malayalam spiritual poetry`,
    "isPartOf": {
      "@type": "CollectionPage",
      "name": "Gurusmruthi",
      "url": SITE_URL
    },
    "url": `${SITE_URL}/guru_krithis/${krithi.id}`,
    "datePublished": krithi.published_at,
    "dateModified": krithi.updated_at,
    "publisher": {
      "@type": "Organization",
      "name": "Gurusmruthi",
      "url": SITE_URL
    },
    ...(krithi.youtube_url && {
      "associatedMedia": {
        "@type": "VideoObject",
        "url": krithi.youtube_url,
        "name": `${krithi.title} | Sree Narayana Guru Krithi`
      }
    })
  };

  return <JsonLd data={schema} />;
}
