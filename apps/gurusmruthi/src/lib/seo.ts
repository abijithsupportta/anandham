import type { Metadata } from "next";
import type { Krithi } from "@/types/database";

export const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://gurusmruthi.abijithcb.com";

export const GURU_PERSON = {
  "@type": "Person",
  "name": "Sree Narayana Guru",
  "alternateName": ["ശ്രീ നാരായണ ഗുരു", "Narayana Guru", "ശ്രീനാരായണ ഗുരു", "Sree Narayana Gurudevan"],
  "description": "Hindu saint, philosopher and social reformer from Kerala, India. Author of Atmopadesa Satakam and numerous krithis in Malayalam and Sanskrit.",
  "birthDate": "1856-08-22",
  "deathDate": "1928-09-20",
  "birthPlace": {
    "@type": "Place",
    "name": "Chempazhanthy, Thiruvananthapuram, Kerala, India"
  },
  "nationality": "Indian",
  "sameAs": [
    "https://en.wikipedia.org/wiki/Sree_Narayana_Guru",
    "https://www.wikidata.org/wiki/Q314610"
  ]
};

export function getKrithiMetadata(krithi: Krithi): Metadata {
  const description = krithi.description
    ? krithi.description.replace(/\s+/g, ' ').trim().substring(0, 155)
    : `ശ്രീ നാരായണ ഗുരുദേവന്റെ കൃതി: ${krithi.title}`;
  
  const categoryName = krithi.category?.name || "കൃതി";
  
  const keywords = [
    krithi.title,
    "sree narayana guru",
    "ഗുരുദേവകൃതികൾ",
    "narayana guru krithi",
    "malayalam spiritual",
    categoryName
  ];

  return {
    title: krithi.title,
    description: `${description} | ശ്രീ നാരായണ ഗുരുദേവ കൃതി | Gurusmruthi`,
    keywords,
    openGraph: {
      title: krithi.title,
      description: `${description} | ശ്രീ നാരായണ ഗുരുദേവ കൃതി | Gurusmruthi`,
      type: "article",
      locale: "ml_IN",
      alternateLocale: ["en_IN"],
      siteName: "Gurusmruthi",
      ...(krithi.published_at && { publishedTime: krithi.published_at }),
      url: `${SITE_URL}/guru_krithis/${krithi.id}`,
    },
    twitter: {
      card: "summary",
      title: krithi.title,
      description: `${description} | ശ്രീ നാരായണ ഗുരുദേവ കൃതി | Gurusmruthi`,
    },
    alternates: {
      canonical: `${SITE_URL}/guru_krithis/${krithi.id}`,
    },
  };
}

export function getListMetadata(pageName: string, malayalamName: string, count: number): Metadata {
  return {
    title: `${malayalamName} - ശ്രീ നാരായണ ഗുരു കൃതികൾ`,
    description: `ശ്രീ നാരായണ ഗുരുദേവന്റെ ${count} കൃതികൾ വായിക്കുക. Complete collection of Sree Narayana Guru krithis in Malayalam.`,
    openGraph: {
      title: `${malayalamName} - ശ്രീ നാരായണ ഗുരു കൃതികൾ`,
      description: `ശ്രീ നാരായണ ഗുരുദേവന്റെ ${count} കൃതികൾ വായിക്കുക. Complete collection of Sree Narayana Guru krithis in Malayalam.`,
      type: "website",
      locale: "ml_IN",
      siteName: "Gurusmruthi",
      url: `${SITE_URL}/${pageName}`,
    },
    alternates: {
      canonical: `${SITE_URL}/${pageName}`,
    },
  };
}
