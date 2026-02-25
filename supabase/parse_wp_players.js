/**
 * Parser WordPress XML → SQL do importu zawodników
 * Wyciąga joomsport_player z eksportu WordPress i generuje plik SQL
 *
 * Uruchomienie: node supabase/parse_wp_players.js
 * Wynik: supabase/import/players_import.sql
 */

const fs = require("fs");
const path = require("path");

const XML_PATH = path.join(
  __dirname, "..", "baza, wytyczne", "Baza ze starej strony",
  "miejskaligapikinonejwsulejwku.WordPress.2026-01-24.xml"
);

const OUTPUT_PATH = path.join(__dirname, "import", "players_import.sql");

// Mapowanie pozycji JoomSport → Supabase
const POSITION_MAP = { "1": "BR", "2": "OBR", "3": "POM", "4": "NAP" };
const DEFAULT_POSITION = "POM";

// ── Prosty parser PHP serialize ──
// Obsługuje: a:N:{...}, s:N:"...";, i:N;
function parsePhpSerialize(str) {
  if (!str || typeof str !== "string") return {};
  const result = {};

  // Strategia: wyciągaj pary klucz→wartość
  // Klucz może być: i:NUM; lub s:NUM:"STR";
  // Wartość: s:NUM:"STR"; lub i:NUM;
  const tokens = [];
  let pos = 0;

  // Przeskocz nagłówek a:N:{
  const headerMatch = str.match(/^a:\d+:\{/);
  if (headerMatch) pos = headerMatch[0].length;

  while (pos < str.length) {
    // Spróbuj string: s:NUM:"...";
    const sMatch = str.substring(pos).match(/^s:(\d+):"([\s\S]*?)";/);
    if (sMatch) {
      tokens.push(sMatch[2]);
      pos += sMatch[0].length;
      continue;
    }
    // Spróbuj int: i:NUM;
    const iMatch = str.substring(pos).match(/^i:(-?\d+);/);
    if (iMatch) {
      tokens.push(iMatch[1]);
      pos += iMatch[0].length;
      continue;
    }
    pos++; // przeskocz nierozpoznany znak
  }

  // Tokeny parami: [key, value, key, value, ...]
  for (let i = 0; i + 1 < tokens.length; i += 2) {
    result[tokens[i]] = tokens[i + 1];
  }

  return result;
}

// ── Wyciągnij zawartość CDATA ──
function extractCdata(str) {
  const m = str.match(/<!\[CDATA\[([\s\S]*?)\]\]>/);
  return m ? m[1] : str.replace(/<[^>]+>/g, "").trim();
}

// ── Oczyść imię/nazwisko (usuń "---") ──
function cleanName(name) {
  if (!name) return "";
  return name.replace(/^-{2,}/, "").replace(/-{2,}$/, "").trim();
}

// ── SQL escape ──
function esc(str) {
  if (str === null || str === undefined) return "NULL";
  return "'" + String(str).replace(/'/g, "''") + "'";
}

// ── Główna funkcja ──
function main() {
  console.log("Wczytywanie XML...");
  if (!fs.existsSync(XML_PATH)) {
    console.error("Nie znaleziono pliku:", XML_PATH);
    process.exit(1);
  }

  const xml = fs.readFileSync(XML_PATH, "utf-8");
  console.log(`Plik: ${(xml.length / 1024 / 1024).toFixed(1)} MB`);

  // Podziel na <item>...</item>
  const items = xml.split("<item>");
  console.log(`Znaleziono ${items.length - 1} itemów (wszystkie typy)`);

  const players = [];
  let skippedNonPlayer = 0;
  let skippedNoName = 0;
  let markedInactive = 0;
  let hasEfField = 0;
  let hasPositionInEf = 0;

  for (let i = 1; i < items.length; i++) {
    const block = items[i].split("</item>")[0];

    // Tylko joomsport_player (post_type)
    if (!block.includes("<wp:post_type><![CDATA[joomsport_player]]></wp:post_type>")) {
      skippedNonPlayer++;
      continue;
    }

    // Wyciągnij title
    const titleMatch = block.match(/<title>([\s\S]*?)<\/title>/);
    const title = titleMatch ? extractCdata(titleMatch[1]) : "";

    // Wyciągnij wp:status
    const statusMatch = block.match(/<wp:status>([\s\S]*?)<\/wp:status>/);
    const wpStatus = statusMatch ? extractCdata(statusMatch[1]) : "publish";

    // Wyciągnij metadane
    const metaBlocks = block.split("<wp:postmeta>");
    const meta = {};
    for (const mb of metaBlocks) {
      const keyMatch = mb.match(/<wp:meta_key>([\s\S]*?)<\/wp:meta_key>/);
      const valMatch = mb.match(/<wp:meta_value>([\s\S]*?)<\/wp:meta_value>/);
      if (keyMatch && valMatch) {
        meta[extractCdata(keyMatch[1])] = extractCdata(valMatch[1]);
      }
    }

    // Parsuj _joomsport_player_personal
    const personal = parsePhpSerialize(meta["_joomsport_player_personal"] || "");

    // Parsuj _joomsport_player_ef (extra fields)
    const efRaw = meta["_joomsport_player_ef"] || "";
    const ef = parsePhpSerialize(efRaw);
    if (efRaw) hasEfField++;
    if (ef["10"]) hasPositionInEf++;

    // Imię i nazwisko — preferuj title (czyste), personal jako fallback
    let firstName, lastName;

    if (title && title.includes(" ")) {
      const parts = title.split(/\s+/);
      firstName = parts[0];
      lastName = parts.slice(1).join(" ");
    } else if (personal.first_name && personal.last_name) {
      firstName = cleanName(personal.first_name);
      lastName = cleanName(personal.last_name);
    } else {
      skippedNoName++;
      continue;
    }

    firstName = cleanName(firstName);
    lastName = cleanName(lastName);

    if (!firstName || !lastName) {
      skippedNoName++;
      continue;
    }

    // Czy oznaczony jako nieaktywny?
    const hasTripleDash = (personal.first_name || "").includes("---") || (personal.last_name || "").includes("---");
    const isActive = wpStatus === "publish" && !hasTripleDash;
    if (hasTripleDash) markedInactive++;

    // Pozycja
    const posCode = ef["10"] || "";
    const position = POSITION_MAP[posCode] || DEFAULT_POSITION;

    // Rok urodzenia
    let birthYear = null;
    const dob = ef["11"] || "";
    if (dob && dob.match(/^\d{4}/)) {
      birthYear = parseInt(dob.substring(0, 4));
      if (birthYear < 1940 || birthYear > 2015) birthYear = null;
    }

    players.push({
      first_name: firstName,
      last_name: lastName,
      position,
      birth_year: birthYear,
      is_active: isActive,
    });
  }

  console.log(`\n=== Statystyki parsowania ===`);
  console.log(`Zawodników znalezionych: ${players.length}`);
  console.log(`Pominięto (nie-player): ${skippedNonPlayer}`);
  console.log(`Pominięto (brak imienia): ${skippedNoName}`);
  console.log(`Oznaczonych jako nieaktywni (---): ${markedInactive}`);
  console.log(`Ma pole _joomsport_player_ef: ${hasEfField}`);
  console.log(`Ma pozycję w ef[10]: ${hasPositionInEf}`);

  // Deduplikacja po (first_name, last_name) — bierze ostatni wpis
  const deduped = new Map();
  for (const p of players) {
    const key = `${p.first_name.toLowerCase()}|${p.last_name.toLowerCase()}`;
    deduped.set(key, p);
  }

  const unique = [...deduped.values()];
  console.log(`\nPo deduplikacji: ${unique.length} unikalnych`);
  console.log(`Duplikatów: ${players.length - unique.length}`);

  // Rozkład pozycji
  const posCounts = {};
  for (const p of unique) {
    posCounts[p.position] = (posCounts[p.position] || 0) + 1;
  }
  console.log(`\nRozkład pozycji:`);
  for (const [pos, count] of Object.entries(posCounts).sort()) {
    console.log(`  ${pos}: ${count}`);
  }

  const activePlayers = unique.filter(p => p.is_active).length;
  console.log(`\nAktywnych: ${activePlayers}, Nieaktywnych: ${unique.length - activePlayers}`);

  // ── Generowanie SQL ──
  console.log(`\n=== Generowanie SQL ===`);

  const lines = [
    `-- Import zawodników z WordPress XML (JoomSport)`,
    `-- Wygenerowano: ${new Date().toISOString()}`,
    `-- ${unique.length} unikalnych zawodników (z ${players.length} wpisów)`,
    `-- Uruchom w Supabase Dashboard > SQL Editor`,
    ``,
  ];

  for (const p of unique) {
    const by = p.birth_year ? String(p.birth_year) : "NULL";
    lines.push(
      `INSERT INTO players (first_name, last_name, position, birth_year, is_active) ` +
      `VALUES (${esc(p.first_name)}, ${esc(p.last_name)}, ${esc(p.position)}, ${by}, ${p.is_active}) ` +
      `ON CONFLICT DO NOTHING;`
    );
  }

  // Upewnij się że folder istnieje
  const dir = path.dirname(OUTPUT_PATH);
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

  fs.writeFileSync(OUTPUT_PATH, lines.join("\n"), "utf-8");
  console.log(`Zapisano: ${OUTPUT_PATH}`);
  console.log(`Rozmiar: ${(fs.statSync(OUTPUT_PATH).size / 1024).toFixed(1)} KB`);
  console.log(`\nSkopiuj zawartość pliku i wklej w Supabase Dashboard > SQL Editor > Run`);
}

main();
