import { ImageResponse } from "next/og";

export const runtime = "edge";

export const size = {
  width: 1200,
  height: 630,
};

export const contentType = "image/png";

export default function OpenGraphImage() {
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
          fontFamily: "system-ui, sans-serif",
        }}
      >
        <div
          style={{
            fontSize: 72,
            fontWeight: 700,
            color: "#2C1810",
            marginBottom: 20,
          }}
        >
          ഗുരുസ്മൃതി
        </div>
        <div
          style={{
            fontSize: 32,
            fontWeight: 500,
            color: "#C9A84C",
            marginBottom: 40,
          }}
        >
          ശ്രീ നാരായണ ഗുരുദേവ കൃതികൾ
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
            fontSize: 20,
            color: "#888",
          }}
        >
          gurusmruthi.abijithcb.com
        </div>
      </div>
    ),
    {
      ...size,
    }
  );
}
