import { MetadataRoute } from "next";
import { krithiService } from "@/services";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://gurusmruthi.abijithcb.com";

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const staticRoutes: MetadataRoute.Sitemap = [
    {
      url: SITE_URL,
      lastModified: new Date(),
      changeFrequency: "daily",
      priority: 1,
    },
    {
      url: `${SITE_URL}/guru_krithis`,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.9,
    },
    {
      url: `${SITE_URL}/guru_keerthanams`,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.9,
    },
    {
      url: `${SITE_URL}/guru_dharmas`,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.9,
    },
    {
      url: `${SITE_URL}/guru_stories`,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.8,
    },
    {
      url: `${SITE_URL}/guru_photos`,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.7,
    },
    {
      url: `${SITE_URL}/blogs`,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.7,
    },
    {
      url: `${SITE_URL}/sponsors`,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.7,
    },
    {
      url: `${SITE_URL}/authors`,
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.7,
    },
  ];

  try {
    const result = await krithiService.getAll();
    if (result.data) {
      const krithiRoutes: MetadataRoute.Sitemap = result.data.map((krithi) => ({
        url: `${SITE_URL}/guru_krithis/${krithi.id}`,
        lastModified: new Date(krithi.updated_at),
        changeFrequency: "monthly" as const,
        priority: 0.8,
      }));
      return [...staticRoutes, ...krithiRoutes];
    }
  } catch (error) {
    console.error("Error generating sitemap:", error);
  }

  return staticRoutes;
}
