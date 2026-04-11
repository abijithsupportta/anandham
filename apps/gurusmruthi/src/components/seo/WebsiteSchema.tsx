import JsonLd from "@/components/JsonLd";
import { SITE_URL, GURU_PERSON } from "@/lib/seo";

export default function WebsiteSchema() {
  const schema = {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "name": "Gurusmruthi",
    "alternateName": "ഗുരുസ്മൃതി",
    "url": SITE_URL,
    "description": "Complete digital archive of Sree Narayana Guru's spiritual works in Malayalam",
    "inLanguage": ["ml", "en"],
    "about": GURU_PERSON,
    "potentialAction": {
      "@type": "SearchAction",
      "target": {
        "@type": "EntryPoint",
        "urlTemplate": `${SITE_URL}/guru_krithis?search={search_term_string}`
      },
      "query-input": "required name=search_term_string"
    }
  };

  return <JsonLd data={schema} />;
}
