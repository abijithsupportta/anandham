import { ImageResponse } from "next/og";
import { krithiService } from "@/services";

export const runtime = "edge";

export const size = {
  width: 1200,
  height: 630,
};

export const contentType = "image/png";

interface Props {
  params: { id: string };
}

export default async function OpenGraphImage({ params }: Props) {
  const krithi = await krithiService.getById(params.id);
  
  const title = krithi.data?.title || "ഗുരുസ്മൃതി";

  return new ImageResponse(
    (
      <div
        style={{
          fontSize: 128,
          background: "#FDF8F0",
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          fontFamily: "Noto Sans Malayalam, system-ui, sans-serif",
          padding: 60,
        }}
      >
        <div
          style={{
            fontSize: 64,
            fontWeight: 700,
            color: "#C9A84C",
            marginBottom: 20,
            textAlign: "center",
          }}
        >
          {title}
        </div>
        <div
          style={{
            fontSize: 28,
            fontWeight: 500,
            color: "#333",
            marginBottom: 40,
          }}
        >
          ശ്രീ നാരായണ ഗുരുദേവ കൃതി
        </div>
        <div
          style={{
            width: 200,
            height: 2,
            backgroundColor: "#C9A84C",
            marginBottom: 40,
          }}
        />
        <div
          style={{
            fontSize: 24,
            color: "#666",
            position: "absolute",
            bottom: 40,
            right: 60,
          }}
        >
          gurusmruthi.com
        </div>
      </div>
    ),
    {
      ...size,
    }
  );
}
