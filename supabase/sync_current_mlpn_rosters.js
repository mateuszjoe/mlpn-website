const fs = require("fs");
const path = require("path");
const { createClient } = require("@supabase/supabase-js");

const CURRENT_SITE_URL = "http://mlpn.pl";
const CURRENT_LEAGUE_BY_SID = {
  "11546": "1st",
  "11551": "2nd",
  "11552": "3rd",
};
const TEAM_NAME_ALIASES = {
  [normalizeText("Huragan")]: normalizeText("Huragan Poręby Nowe"),
};
const APPLY = process.argv.includes("--apply");
const PAGE_SIZE = 1000;

function loadEnv() {
  const envPath = path.join(process.cwd(), ".env.local");
  const envText = fs.readFileSync(envPath, "utf8");
  for (const line of envText.split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) continue;
    const eq = trimmed.indexOf("=");
    if (eq === -1) continue;
    process.env[trimmed.slice(0, eq)] = trimmed.slice(eq + 1);
  }
}

function normalizeText(value) {
  return String(value || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[\u0142\u0141]/g, "l")
    .toLowerCase()
    .replace(/\s+/g, " ")
    .trim();
}

function nameKey(value) {
  return normalizeText(value);
}

function reversedNameKey(value) {
  const parts = String(value || "").split(/\s+/).filter(Boolean);
  if (parts.length < 2) return nameKey(value);
  return normalizeText(parts.slice().reverse().join(" "));
}

function splitFullName(fullName) {
  const parts = String(fullName || "").split(/\s+/).filter(Boolean);
  if (parts.length < 2) return null;
  return {
    firstName: parts.slice(0, -1).join(" "),
    lastName: parts[parts.length - 1],
  };
}

async function fetchHtml(url) {
  const response = await fetch(url, {
    headers: {
      "user-agent": "MLPN roster sync/1.0",
    },
  });
  if (!response.ok) {
    throw new Error(`Nie udało się pobrać ${url}: ${response.status}`);
  }
  return response.text();
}

function uniqueStrings(values) {
  return Array.from(new Set(values));
}

async function fetchAllRows(queryFactory) {
  const rows = [];
  let from = 0;

  while (true) {
    const to = from + PAGE_SIZE - 1;
    const { data, error } = await queryFactory(from, to);
    if (error) throw error;
    const chunk = data || [];
    rows.push(...chunk);
    if (chunk.length < PAGE_SIZE) break;
    from += PAGE_SIZE;
  }

  return rows;
}

function chooseBestCandidate(candidates, usageCount) {
  return candidates
    .slice()
    .sort((a, b) => {
      const usageDiff = (usageCount[b.id] || 0) - (usageCount[a.id] || 0);
      if (usageDiff !== 0) return usageDiff;
      if (a.is_active !== b.is_active) return a.is_active === true ? -1 : 1;
      return String(a.id).localeCompare(String(b.id));
    })[0];
}

async function main() {
  loadEnv();

  const supabase = createClient(
    process.env.REACT_APP_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_KEY,
    { auth: { persistSession: false } }
  );

  const homeHtml = await fetchHtml(CURRENT_SITE_URL);
  const detectedSeasonYears = Array.from(
    homeHtml.matchAll(/sezon-(20\d{2})/g)
  ).map((match) => Number(match[1]));
  const currentSeasonYear = detectedSeasonYears.length
    ? Math.max(...detectedSeasonYears)
    : Number(process.argv.find((arg) => arg.startsWith("--year="))?.split("=")[1] || 0);

  const [allPlayers, allTeamPlayers, allTeams, allLeagues, allSeasons] = await Promise.all([
    fetchAllRows((from, to) =>
      supabase
        .from("players")
        .select("id, first_name, last_name, display_name, is_active")
        .range(from, to)
        .order("created_at", { ascending: true })
    ),
    fetchAllRows((from, to) =>
      supabase
        .from("team_players")
        .select("id, player_id, team_id, season_id, league_id")
        .range(from, to)
        .order("id", { ascending: true })
    ),
    fetchAllRows((from, to) =>
      supabase
        .from("teams")
        .select("id, name")
        .range(from, to)
        .order("name", { ascending: true })
    ),
    supabase.from("leagues").select("id, code, name"),
    supabase.from("seasons").select("id, year").order("year", { ascending: false }),
  ]);

  if (allLeagues.error) throw allLeagues.error;
  if (allSeasons.error) throw allSeasons.error;

  const targetSeason =
    (allSeasons.data || []).find((season) => season.year === currentSeasonYear) ||
    (allSeasons.data || [])[0];
  if (!targetSeason) throw new Error("Brak sezonów w bazie.");

  const seasonId = targetSeason.id;
  const seasonYear = targetSeason.year;
  const usageCount = {};
  for (const row of allTeamPlayers || []) {
    usageCount[row.player_id] = (usageCount[row.player_id] || 0) + 1;
  }

  const playerCandidatesByKey = {};
  for (const player of allPlayers || []) {
    const display = player.display_name || [player.first_name, player.last_name].filter(Boolean).join(" ").trim();
    if (!display) continue;
    for (const key of new Set([nameKey(display), reversedNameKey(display)])) {
      if (!playerCandidatesByKey[key]) playerCandidatesByKey[key] = [];
      playerCandidatesByKey[key].push(player);
    }
  }

  const teamByKey = {};
  for (const team of allTeams || []) {
    teamByKey[nameKey(team.name)] = team;
  }

  const leagueByCode = Object.fromEntries((allLeagues.data || []).map((league) => [league.code, league]));
  const existingRosterKeys = new Set(
    (allTeamPlayers || [])
      .filter((row) => row.season_id === seasonId)
      .map((row) => `${row.team_id}|${row.player_id}`)
  );

  const teamLinkMatches = Array.from(
    homeHtml.matchAll(/<a href="(http:\/\/mlpn\.pl\/joomsport_team\/[^"]+\?sid=(11546|11551|11552))">([^<]+)<\/a>/g)
  );
  const currentTeams = [];
  const seenTeams = new Set();
  for (const match of teamLinkMatches) {
    const entry = {
      url: match[1],
      sid: match[2],
      name: match[3].trim(),
    };
    const dedupeKey = `${entry.url}|${entry.name}`;
    if (seenTeams.has(dedupeKey)) continue;
    seenTeams.add(dedupeKey);
    currentTeams.push(entry);
  }

  const inserts = [];
  const createdPlayers = [];
  const linkedPlayers = [];
  const skippedPlayers = [];

  for (const team of currentTeams) {
    const normalizedTeamName = TEAM_NAME_ALIASES[nameKey(team.name)] || nameKey(team.name);
    if (normalizedTeamName.includes("wolne miejsce")) continue;

    const dbTeam = teamByKey[normalizedTeamName];
    const league = leagueByCode[CURRENT_LEAGUE_BY_SID[team.sid]];
    if (!dbTeam || !league) {
      skippedPlayers.push({
        team: team.name,
        name: null,
        reason: "Brak dopasowania drużyny lub ligi w bazie.",
      });
      continue;
    }

    const rosterHtml = await fetchHtml(team.url);
    const rosterNames = uniqueStrings(
      Array.from(
        rosterHtml.matchAll(/joomsport_player\/[^"]+\?sid=\d+"[^>]*>([^<]+)<\/a>/g)
      )
        .map((match) => match[1].trim())
        .filter(Boolean)
    );

    for (const rosterName of rosterNames) {
      const key = nameKey(rosterName);
      const reverseKey = reversedNameKey(rosterName);
      const alreadyLinked = (allTeamPlayers || []).some((row) => {
        if (row.team_id !== dbTeam.id || row.season_id !== seasonId) return false;
        const player = (allPlayers || []).find((candidate) => candidate.id === row.player_id);
        if (!player) return false;
        const playerDisplay =
          player.display_name ||
          [player.first_name, player.last_name].filter(Boolean).join(" ").trim();
        const playerKey = nameKey(playerDisplay);
        return playerKey === key || playerKey === reverseKey;
      });
      if (alreadyLinked) continue;

      const tokens = rosterName.split(/\s+/).filter(Boolean);
      if (tokens.length < 2) {
        skippedPlayers.push({
          team: team.name,
          name: rosterName,
          reason: "Niepelne dane na mlpn.pl (brak pełnego imienia i nazwiska).",
        });
        continue;
      }

      const candidates = uniqueStrings([key, reverseKey])
        .flatMap((candidateKey) => playerCandidatesByKey[candidateKey] || []);
      const chosen = candidates.length ? chooseBestCandidate(candidates, usageCount) : null;

      let playerId = chosen?.id || null;
      if (!playerId) {
        const split = splitFullName(rosterName);
        if (!split) {
          skippedPlayers.push({
            team: team.name,
            name: rosterName,
            reason: "Nie udalo sie rozdzielic imienia i nazwiska.",
          });
          continue;
        }

        if (APPLY) {
          const { data: insertedPlayer, error: insertPlayerError } = await supabase
            .from("players")
            .insert({
              first_name: split.firstName,
              last_name: split.lastName,
              is_active: true,
            })
            .select("id, first_name, last_name, display_name, is_active")
            .single();
          if (insertPlayerError) throw insertPlayerError;

          playerId = insertedPlayer.id;
          createdPlayers.push({
            team: team.name,
            name: rosterName,
            playerId,
          });
          allPlayers.push(insertedPlayer);
          usageCount[playerId] = usageCount[playerId] || 0;
          for (const candidateKey of new Set([nameKey(insertedPlayer.display_name), reversedNameKey(insertedPlayer.display_name)])) {
            if (!playerCandidatesByKey[candidateKey]) playerCandidatesByKey[candidateKey] = [];
            playerCandidatesByKey[candidateKey].push(insertedPlayer);
          }
        } else {
          createdPlayers.push({
            team: team.name,
            name: rosterName,
            playerId: "(dry-run)",
          });
        }
      } else {
        linkedPlayers.push({
          team: team.name,
          name: rosterName,
          playerId,
        });
      }

      if (!playerId) continue;
      const rosterKey = `${dbTeam.id}|${playerId}`;
      if (existingRosterKeys.has(rosterKey)) continue;

      inserts.push({
        team_id: dbTeam.id,
        player_id: playerId,
        season_id: seasonId,
        league_id: league.id,
        joined_date: `${seasonYear}-01-01`,
        left_date: null,
        is_captain: false,
        shirt_number: null,
      });
      existingRosterKeys.add(rosterKey);
    }
  }

  if (APPLY && inserts.length) {
    const { error: insertRosterError } = await supabase
      .from("team_players")
      .upsert(inserts, {
        onConflict: "player_id,season_id,league_id,team_id",
        ignoreDuplicates: true,
      });
    if (insertRosterError) throw insertRosterError;
  }

  console.log(
    JSON.stringify(
      {
        seasonYear,
        apply: APPLY,
        rosterRowsToInsert: inserts.length,
        linkedExistingPlayers: linkedPlayers,
        createdPlayers,
        skippedPlayers,
      },
      null,
      2
    )
  );
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
