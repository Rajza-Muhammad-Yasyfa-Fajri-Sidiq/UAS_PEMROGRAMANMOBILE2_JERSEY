// seed.js
const baseUrl = "https://6970e6dd78fec16a63ff6981.mockapi.io/jerseys";

// Nama tim dari seed -> nama display
const TEAM_NAME = {
  barcelona: "Barcelona",
  realmadrid: "Real Madrid",
  arsenal: "Arsenal",
  inter: "Inter",
  manutd: "Manchester United",
  liverpool: "Liverpool",
  acmilan: "AC Milan",
  juventus: "Juventus",
  mancity: "Manchester City",
  chelsea: "Chelsea",
  psg: "PSG",
  bayern: "Bayern Munich",
};

// Warna background placeholder biar “kerasa” temanya
// (hex tanpa #)
const TEAM_THEME = {
  barcelona: { bg: "A50044", fg: "FFFFFF" },
  realmadrid: { bg: "111827", fg: "FFFFFF" },
  arsenal: { bg: "EF0107", fg: "FFFFFF" },
  inter: { bg: "00529F", fg: "FFFFFF" },
  manutd: { bg: "DA291C", fg: "FFFFFF" },
  liverpool: { bg: "C8102E", fg: "FFFFFF" },
  acmilan: { bg: "000000", fg: "FFFFFF" },
  juventus: { bg: "111111", fg: "FFFFFF" },
  mancity: { bg: "6CABDD", fg: "FFFFFF" },
  chelsea: { bg: "034694", fg: "FFFFFF" },
  psg: { bg: "004170", fg: "FFFFFF" },
  bayern: { bg: "DC052D", fg: "FFFFFF" },
};

const VARIANT_NAME = {
  home: "Home",
  away: "Away",
  third: "Third",
};

// ubah "2324" -> "2023/2024"
function toSeasonLabel(seasonPart) {
  if (!seasonPart || typeof seasonPart !== "string") return "";
  // ex: "2324"
  if (/^\d{4}$/.test(seasonPart)) {
    const start = 2000 + parseInt(seasonPart.slice(0, 2), 10);
    const end = 2000 + parseInt(seasonPart.slice(2, 4), 10);
    return `${start}/${end}`;
  }
  return seasonPart; // fallback kalau format beda
}

// parse seed: "barcelona-home-2324"
function parseSeed(seed) {
  const s = String(seed || "")
    .toLowerCase()
    .trim();
  const parts = s.split("-").filter(Boolean);

  const teamKey = parts[0] || "unknown";
  const variantKey = parts[1] || "";
  const seasonKey = parts[2] || "";

  const team = TEAM_NAME[teamKey] || teamKey.toUpperCase();
  const variant =
    VARIANT_NAME[variantKey] || (variantKey ? variantKey.toUpperCase() : "");
  const season = toSeasonLabel(seasonKey);

  // teks 1 baris biar aman tampilnya
  const label = ["Jersey", team, variant, season].filter(Boolean).join(" ");

  const theme = TEAM_THEME[teamKey] || { bg: "0F172A", fg: "FFFFFF" };
  return { label, theme };
}

// helper biar URL gambar konsisten & “sesuai jersey”
const img = (seed) => {
  const { label, theme } = parseSeed(seed);
  const w = 600;
  const h = 800;
  return `https://placehold.co/${w}x${h}/${theme.bg}/${theme.fg}/png?text=${encodeURIComponent(
    label,
  )}`;
};

const data = [
  // Barcelona
  {
    name: "Jersey Barcelona Home",
    team: "Barcelona",
    league: "La Liga",
    season: "2023/2024",
    price: 299000,
    rating: 4.8,
    imageUrl: img("barcelona-home-2324"),
    description:
      "Jersey home warna klasik, bahan dry-fit nyaman untuk olahraga dan casual.",
  },
  {
    name: "Jersey Barcelona Away",
    team: "Barcelona",
    league: "La Liga",
    season: "2023/2024",
    price: 289000,
    rating: 4.6,
    imageUrl: img("barcelona-away-2324"),
    description: "Jersey away desain modern, ringan dan cepat kering.",
  },
  {
    name: "Jersey Barcelona Third",
    team: "Barcelona",
    league: "La Liga",
    season: "2023/2024",
    price: 285000,
    rating: 4.5,
    imageUrl: img("barcelona-third-2324"),
    description: "Jersey third dengan warna alternatif, cocok buat koleksi.",
  },
  {
    name: "Jersey Barcelona Home",
    team: "Barcelona",
    league: "La Liga",
    season: "2024/2025",
    price: 319000,
    rating: 4.7,
    imageUrl: img("barcelona-home-2425"),
    description: "Update musim terbaru dengan bahan lebih breathable.",
  },

  // Real Madrid
  {
    name: "Jersey Real Madrid Home",
    team: "Real Madrid",
    league: "La Liga",
    season: "2023/2024",
    price: 315000,
    rating: 4.9,
    imageUrl: img("realmadrid-home-2324"),
    description: "Jersey home dominan putih, jahitan rapi dan nyaman dipakai.",
  },
  {
    name: "Jersey Real Madrid Away",
    team: "Real Madrid",
    league: "La Liga",
    season: "2023/2024",
    price: 305000,
    rating: 4.7,
    imageUrl: img("realmadrid-away-2324"),
    description: "Jersey away warna gelap elegan, bahan adem.",
  },
  {
    name: "Jersey Real Madrid Third",
    team: "Real Madrid",
    league: "La Liga",
    season: "2023/2024",
    price: 299000,
    rating: 4.6,
    imageUrl: img("realmadrid-third-2324"),
    description: "Jersey third edisi alternatif, cocok untuk koleksi.",
  },
  {
    name: "Jersey Real Madrid Home",
    team: "Real Madrid",
    league: "La Liga",
    season: "2024/2025",
    price: 329000,
    rating: 4.8,
    imageUrl: img("realmadrid-home-2425"),
    description: "Musim terbaru dengan detail premium.",
  },

  // Arsenal
  {
    name: "Jersey Arsenal Home",
    team: "Arsenal",
    league: "Premier League",
    season: "2023/2024",
    price: 279000,
    rating: 4.7,
    imageUrl: img("arsenal-home-2324"),
    description: "Jersey home merah khas Arsenal, bahan elastis nyaman.",
  },
  {
    name: "Jersey Arsenal Away",
    team: "Arsenal",
    league: "Premier League",
    season: "2023/2024",
    price: 269000,
    rating: 4.5,
    imageUrl: img("arsenal-away-2324"),
    description: "Jersey away desain clean, cocok untuk gaya casual.",
  },
  {
    name: "Jersey Arsenal Third",
    team: "Arsenal",
    league: "Premier League",
    season: "2023/2024",
    price: 265000,
    rating: 4.4,
    imageUrl: img("arsenal-third-2324"),
    description: "Jersey third warna alternatif, nyaman dipakai harian.",
  },
  {
    name: "Jersey Arsenal Home",
    team: "Arsenal",
    league: "Premier League",
    season: "2024/2025",
    price: 289000,
    rating: 4.6,
    imageUrl: img("arsenal-home-2425"),
    description: "Update musim baru dengan bahan lebih ringan.",
  },

  // Inter
  {
    name: "Jersey Inter Milan Home",
    team: "Inter",
    league: "Serie A",
    season: "2023/2024",
    price: 289000,
    rating: 4.6,
    imageUrl: img("inter-home-2324"),
    description: "Jersey home garis khas Inter, breathable dan nyaman.",
  },
  {
    name: "Jersey Inter Milan Away",
    team: "Inter",
    league: "Serie A",
    season: "2023/2024",
    price: 279000,
    rating: 4.4,
    imageUrl: img("inter-away-2324"),
    description: "Jersey away ringan, cocok dipakai harian.",
  },
  {
    name: "Jersey Inter Milan Third",
    team: "Inter",
    league: "Serie A",
    season: "2023/2024",
    price: 275000,
    rating: 4.3,
    imageUrl: img("inter-third-2324"),
    description: "Jersey third edisi alternatif untuk koleksi.",
  },
  {
    name: "Jersey Inter Milan Home",
    team: "Inter",
    league: "Serie A",
    season: "2024/2025",
    price: 299000,
    rating: 4.5,
    imageUrl: img("inter-home-2425"),
    description: "Musim baru dengan detail garis lebih modern.",
  },

  // Tambahan katalog
  {
    name: "Jersey Manchester United Home",
    team: "Manchester United",
    league: "Premier League",
    season: "2023/2024",
    price: 309000,
    rating: 4.7,
    imageUrl: img("manutd-home-2324"),
    description: "Jersey home MU, bahan dry-fit premium dan nyaman.",
  },
  {
    name: "Jersey Liverpool Home",
    team: "Liverpool",
    league: "Premier League",
    season: "2023/2024",
    price: 299000,
    rating: 4.8,
    imageUrl: img("liverpool-home-2324"),
    description: "Jersey home Liverpool, ringan dan adem dipakai.",
  },
  {
    name: "Jersey AC Milan Home",
    team: "AC Milan",
    league: "Serie A",
    season: "2023/2024",
    price: 289000,
    rating: 4.6,
    imageUrl: img("acmilan-home-2324"),
    description: "Jersey home AC Milan, garis merah-hitam klasik.",
  },
  {
    name: "Jersey Juventus Home",
    team: "Juventus",
    league: "Serie A",
    season: "2023/2024",
    price: 295000,
    rating: 4.5,
    imageUrl: img("juventus-home-2324"),
    description: "Jersey home Juventus, bahan elastis dan nyaman.",
  },

  // Bonus (biar rame)
  {
    name: "Jersey Barcelona Away",
    team: "Barcelona",
    league: "La Liga",
    season: "2024/2025",
    price: 309000,
    rating: 4.6,
    imageUrl: img("barcelona-away-2425"),
    description: "Away season terbaru, bahan cepat kering.",
  },
  {
    name: "Jersey Real Madrid Away",
    team: "Real Madrid",
    league: "La Liga",
    season: "2024/2025",
    price: 319000,
    rating: 4.7,
    imageUrl: img("realmadrid-away-2425"),
    description: "Away terbaru dengan desain minimalis.",
  },
  {
    name: "Jersey Arsenal Away",
    team: "Arsenal",
    league: "Premier League",
    season: "2024/2025",
    price: 279000,
    rating: 4.5,
    imageUrl: img("arsenal-away-2425"),
    description: "Away terbaru, cocok dipakai casual.",
  },
  {
    name: "Jersey Inter Milan Away",
    team: "Inter",
    league: "Serie A",
    season: "2024/2025",
    price: 289000,
    rating: 4.4,
    imageUrl: img("inter-away-2425"),
    description: "Away terbaru dengan bahan lebih adem.",
  },
  {
    name: "Jersey Manchester City Home",
    team: "Manchester City",
    league: "Premier League",
    season: "2023/2024",
    price: 305000,
    rating: 4.6,
    imageUrl: img("mancity-home-2324"),
    description: "Jersey home Man City, nyaman dipakai.",
  },
  {
    name: "Jersey Chelsea Home",
    team: "Chelsea",
    league: "Premier League",
    season: "2023/2024",
    price: 295000,
    rating: 4.4,
    imageUrl: img("chelsea-home-2324"),
    description: "Jersey home Chelsea, bahan ringan.",
  },
  {
    name: "Jersey PSG Home",
    team: "PSG",
    league: "Ligue 1",
    season: "2023/2024",
    price: 319000,
    rating: 4.7,
    imageUrl: img("psg-home-2324"),
    description: "Jersey home PSG, desain modern.",
  },
  {
    name: "Jersey Bayern Munich Home",
    team: "Bayern Munich",
    league: "Bundesliga",
    season: "2023/2024",
    price: 315000,
    rating: 4.8,
    imageUrl: img("bayern-home-2324"),
    description: "Jersey home Bayern, bahan premium.",
  },
];

async function run() {
  console.log("Fetching existing...");
  const existingRes = await fetch(baseUrl);
  const existingText = await existingRes.text();

  // kalau endpoint salah, dia bukan JSON -> stop dengan pesan jelas
  let existing = [];
  try {
    existing = JSON.parse(existingText);
  } catch (e) {
    console.error("Base URL response is not JSON. Check baseUrl/resource!");
    console.error("Response:", existingText);
    process.exit(1);
  }

  console.log("Deleting old items:", existing.length);
  for (const item of existing) {
    await fetch(`${baseUrl}/${item.id}`, { method: "DELETE" });
  }

  console.log("Inserting new items:", data.length);
  for (const item of data) {
    const res = await fetch(baseUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(item),
    });
    console.log("POST:", res.status, item.name);
  }

  console.log("SEED DONE:", data.length, "items");
}

run().catch(console.error);
