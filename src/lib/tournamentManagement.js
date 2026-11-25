import { resolveTournamentMatches, updateTournamentMatch } from './tournamentEngine';

const own = (value, key) => Object.prototype.hasOwnProperty.call(value, key);
const fail = message => { throw new Error(message); };
const idPattern = /^[A-Za-z0-9][A-Za-z0-9_-]{0,119}$/;
const settingsFields = new Set(['name', 'slug', 'date', 'location', 'description', 'timezone', 'matchMinutes', 'rules', 'status']);
const criteriaIds = ['points', 'headToHead', 'goalDifference', 'goalsScored'];
const active = match => match.status !== 'scheduled' || match.homeScore != null || match.awayScore != null || match.homePenalties != null || match.awayPenalties != null || !!match.events?.length;
const clone = value => {
  if (typeof value === 'number' && !Number.isFinite(value)) fail('Dane zawierają nieprawidłową liczbę.');
  if (Array.isArray(value)) return value.map(clone);
  if (value && typeof value === 'object') return Object.fromEntries(Object.entries(value).map(([key, item]) => {
    if (['__proto__', 'constructor', 'prototype'].includes(key)) fail('Nieprawidłowe pole danych.');
    return [key, clone(item)];
  }));
  return value;
};
const text = (value, label, required = true, max = 200) => {
  if (typeof value !== 'string' || value.trim().length > max || (required && !value.trim())) fail(`Podaj prawidłowe pole: ${label}.`);
  return value.trim();
};
const identifier = value => typeof value === 'string' && idPattern.test(value) ? value : fail('Nieprawidłowy identyfikator.');
const integer = (value, label, min, max) => {
  if (!['number', 'string'].includes(typeof value) || String(value).trim() === '' || !Number.isInteger(Number(value)) || Number(value) < min || Number(value) > max) fail(`${label}: podaj liczbę całkowitą od ${min} do ${max}.`);
  return Number(value);
};
const unique = (items, label) => { if (new Set(items).size !== items.length) fail(`${label}: znaleziono duplikaty.`); };
const slugify = value => String(value).toLowerCase().normalize('NFKD').replace(/[\u0300-\u036f]/g, '').replace(/ł/g, 'l').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '').slice(0, 90);
const nextId = (prefix, existing) => { let number = 1; while (existing.includes(`${prefix}-${number}`)) number += 1; return `${prefix}-${number}`; };
const same = (a, b) => JSON.stringify(a) === JSON.stringify(b);
const checkedDate = value => {
  if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value) || !Number.isFinite(Date.parse(`${value}T12:00:00Z`)) || new Date(`${value}T12:00:00Z`).toISOString().slice(0, 10) !== value) fail('Podaj prawidłową datę turnieju.');
  return value;
};
const checkedKickoff = value => {
  if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(?::\d{2}(?:\.\d+)?)?(?:Z|[+-]\d{2}:\d{2})$/.test(value) || !Number.isFinite(Date.parse(value))) fail('Podaj datę i godzinę ze strefą czasową.');
  checkedDate(value.slice(0, 10));
  return value;
};

function normalizeRules(input = {}) {
  if (!input || typeof input !== 'object' || Array.isArray(input)) fail('Nieprawidłowe zasady punktacji.');
  const rules = { ...clone(input), pointsWin: integer(input.pointsWin ?? 3, 'Punkty za zwycięstwo', 0, 99),
    pointsDraw: integer(input.pointsDraw ?? 1, 'Punkty za remis', 0, 99), pointsLoss: integer(input.pointsLoss ?? 0, 'Punkty za porażkę', 0, 99) };
  const source = input.tiebreakers ?? [{ id: 'points' }, { id: 'headToHead', applyRecursively: true }, { id: 'goalDifference' }, { id: 'goalsScored' }];
  if (!Array.isArray(source) || !source.length) fail('Wybierz kolejność kryteriów tabeli.');
  rules.tiebreakers = source.map(item => {
    const criterion = typeof item === 'string' ? { id: item } : item;
    if (!criterion || !criteriaIds.includes(criterion.id)) fail('Nieobsługiwane kryterium tabeli.');
    if (criterion.id !== 'headToHead') return { id: criterion.id };
    const subCriteria = criterion.subCriteria ?? [{ id: 'points' }, { id: 'goalDifference' }, { id: 'goalsScored' }];
    if (!Array.isArray(subCriteria) || !subCriteria.length || subCriteria.some(sub => !['points', 'goalDifference', 'goalsScored'].includes(sub.id))) fail('Nieprawidłowe kryteria meczów bezpośrednich.');
    unique(subCriteria.map(sub => sub.id), 'Kryteria meczów bezpośrednich');
    return { id: criterion.id, applyRecursively: criterion.applyRecursively === true, subCriteria: subCriteria.map(sub => ({ id: sub.id })) };
  });
  unique(rules.tiebreakers.map(item => item.id), 'Kryteria tabeli');
  if (rules.tiebreakers[0].id !== 'points') fail('Pierwszym kryterium tabeli muszą być punkty.');
  if (input.advancing != null) rules.advancing = integer(input.advancing, 'Liczba awansujących drużyn', 1, 64);
  return rules;
}

function normalizePlayer(player) {
  if (!player || typeof player !== 'object') fail('Nieprawidłowe dane zawodnika.');
  return { ...clone(player), id: identifier(player.id), name: text(player.name, 'imię i nazwisko', true, 150),
    number: player.number == null || player.number === '' ? null : integer(player.number, 'Numer zawodnika', 0, 999) };
}

function normalizeTeam(team) {
  if (!team || typeof team !== 'object' || !Array.isArray(team.players ?? [])) fail('Nieprawidłowe dane drużyny.');
  const logo = text(team.logo ?? '', 'logo', false, 2000);
  if (logo && !(/^https:\/\//i.test(logo) || /^\/(?!\/)/.test(logo))) fail('Logo musi mieć adres HTTPS lub ścieżkę na stronie.');
  const players = (team.players || []).map(normalizePlayer);
  if (players.length > 100) fail('Drużyna może zgłosić najwyżej 100 zawodników.');
  unique(players.map(player => player.id), 'Zawodnicy');
  unique(players.filter(player => player.number != null).map(player => player.number), 'Numery zawodników w drużynie');
  return { ...clone(team), id: identifier(team.id), name: text(team.name, 'nazwa drużyny', true, 120),
    shortName: text(team.shortName ?? team.name, 'krótka nazwa drużyny', true, 150), logo, players };
}

/** Validates the whole JSON document without altering imported phases or scores. */
export function validateManagedTournament(input) {
  if (!input || typeof input !== 'object' || Array.isArray(input)) fail('Nieprawidłowe dane turnieju.');
  const tournament = clone(input);
  tournament.id = identifier(tournament.id);
  tournament.slug = text(tournament.slug, 'adres turnieju', true, 100);
  if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(tournament.slug)) fail('Adres turnieju może zawierać małe litery, cyfry i myślniki.');
  tournament.name = text(tournament.name, 'nazwa turnieju', true, 180);
  tournament.date = checkedDate(tournament.date);
  tournament.location = text(tournament.location ?? '', 'miejsce turnieju', false, 250);
  tournament.description = text(tournament.description ?? '', 'opis turnieju', false, 10000);
  tournament.timezone = tournament.timezone || 'Europe/Warsaw';
  try { new Intl.DateTimeFormat('pl', { timeZone: tournament.timezone }).format(new Date()); } catch { fail('Nieprawidłowa strefa czasowa.'); }
  if (!['upcoming', 'live', 'completed', 'archived'].includes(tournament.status)) fail('Nieprawidłowy status turnieju.');
  if (tournament.matchMinutes != null) tournament.matchMinutes = integer(tournament.matchMinutes, 'Długość meczu', 1, 180);
  tournament.rules = normalizeRules(tournament.rules);
  if (![tournament.teams, tournament.groups, tournament.matches].every(Array.isArray)) fail('Drużyny, grupy i mecze muszą być listami.');
  if (tournament.teams.length > 128 || tournament.groups.length > 64 || tournament.matches.length > 2000) fail('Przekroczono maksymalny rozmiar turnieju.');
  tournament.teams = tournament.teams.map(normalizeTeam);
  unique(tournament.teams.map(team => team.id), 'Drużyny');
  unique(tournament.teams.flatMap(team => team.players.map(player => player.id)), 'Identyfikatory zawodników');
  const teams = new Map(tournament.teams.map(team => [team.id, team]));
  const assigned = new Set();
  tournament.groups = tournament.groups.map(group => {
    if (!group || !Array.isArray(group.teamIds)) fail('Nieprawidłowy skład grupy.');
    const phase = integer(group.phase ?? 0, 'Faza grupowa', 0, 100);
    const teamIds = group.teamIds.map(identifier);
    unique(teamIds, 'Skład grupy');
    for (const id of teamIds) {
      if (!teams.has(id)) fail('Grupa zawiera nieistniejącą drużynę.');
      const key = `${phase}:${id}`;
      if (assigned.has(key)) fail('Drużyna może należeć tylko do jednej grupy w tej samej fazie.');
      assigned.add(key);
    }
    const result = { ...group, id: identifier(group.id), name: text(group.name, 'nazwa grupy', true, 100), phase, teamIds,
      numEncounters: integer(group.numEncounters ?? 1, 'Liczba spotkań każdej pary', 1, 2) };
    if (group.advancing != null) result.advancing = integer(group.advancing, 'Liczba awansów z grupy', 0, Math.max(0, teamIds.length));
    return result;
  });
  unique(tournament.groups.map(group => group.id), 'Grupy');
  const groups = new Map(tournament.groups.map(group => [group.id, group]));
  unique(tournament.matches.map(match => identifier(match.id)), 'Mecze');
  const matches = new Map(tournament.matches.map(match => [match.id, match]));
  for (const match of tournament.matches) {
    if (!['group', 'round16', 'quarterfinal', 'semifinal', 'third', 'final', 'playoff'].includes(match.stage)) fail('Nieprawidłowy etap meczu.');
    if (!['scheduled', 'live', 'finished'].includes(match.status)) fail('Nieprawidłowy status meczu.');
    if (!Array.isArray(match.events)) fail('Protokół meczu musi być listą.');
    for (const field of ['homeScore', 'awayScore', 'homePenalties', 'awayPenalties']) {
      if (match[field] == null) match[field] = null;
      else if (typeof match[field] !== 'number' || !Number.isInteger(match[field]) || match[field] < 0 || match[field] > 999) fail('Wynik musi być liczbą całkowitą od 0 do 999.');
    }
    if (match.kickoff) checkedKickoff(match.kickoff);
    match.court = text(match.court ?? '', 'boisko', false, 100);
    if (match.status === 'scheduled' && active(match)) fail('Mecz nadchodzący nie może mieć wyniku ani zdarzeń. Zmień jego status.');
    if (match.homeTeamId && !teams.has(match.homeTeamId)) fail('Mecz zawiera nieistniejącą drużynę.');
    if (match.awayTeamId && !teams.has(match.awayTeamId)) fail('Mecz zawiera nieistniejącą drużynę.');
    if (match.homeTeamId && match.homeTeamId === match.awayTeamId) fail('Drużyna nie może grać sama ze sobą.');
    if (match.stage === 'group') {
      const group = groups.get(match.groupId);
      if (!group || !group.teamIds.includes(match.homeTeamId) || !group.teamIds.includes(match.awayTeamId)) fail('Uczestnicy meczu nie należą do jego grupy.');
    }
    for (const source of [match.homeSource, match.awaySource].filter(Boolean)) {
      if (source.type === 'group') {
        const group = groups.get(source.groupId);
        if (!group) fail('Awans wskazuje nieistniejącą grupę.');
        source.position = integer(source.position, 'Miejsce w grupie', 1, group.teamIds.length);
      } else if (!['winner', 'loser'].includes(source.type) || !matches.has(source.matchId)) fail('Awans wskazuje nieistniejący mecz.');
    }
  }
  const visited = new Set(); const visiting = new Set();
  function visit(id) {
    if (visiting.has(id)) fail('Drabinka zawiera cykliczne awanse.');
    if (visited.has(id)) return;
    visiting.add(id);
    const match = matches.get(id);
    for (const source of [match.homeSource, match.awaySource]) if (source?.matchId) visit(source.matchId);
    visiting.delete(id); visited.add(id);
  }
  matches.forEach(match => visit(match.id));
  const resolved = resolveTournamentMatches(tournament);
  resolved.forEach((match, index) => {
    const original = tournament.matches[index];
    if (active(original)) {
      if (match.homeTeamId !== original.homeTeamId || match.awayTeamId !== original.awayTeamId) fail('Uczestnicy rozegranego meczu nie pasują do awansów.');
      updateTournamentMatch(tournament, match.id, {});
    }
  });
  return tournament;
}

export function createManagedTournament(fields) {
  if (!fields || typeof fields !== 'object') fail('Podaj dane turnieju.');
  const slug = fields.slug || slugify(fields.name || '');
  return validateManagedTournament({ ...clone(fields), id: fields.id || `tournament-${slug}`, slug, status: 'upcoming',
    isManaged: true, isImported: false, isLocalCopy: false, isDemo: false,
    description: fields.description || '', location: fields.location || '', timezone: fields.timezone || 'Europe/Warsaw',
    rules: fields.rules || {}, teams: [], groups: [], matches: [] });
}

export function updateTournamentSettings(input, patch) {
  const tournament = validateManagedTournament(input);
  if (!patch || Object.keys(patch).some(key => !settingsFields.has(key))) fail('Nieprawidłowe pola ustawień turnieju.');
  const rules = own(patch, 'rules') ? normalizeRules({ ...tournament.rules, ...patch.rules }) : tournament.rules;
  if (!same(rules, tournament.rules) && tournament.matches.some(active)) fail('Nie można zmienić punktacji ani kryteriów po rozpoczęciu meczów.');
  if (patch.status === 'completed' && (!tournament.matches.length || tournament.matches.some(match => match.status !== 'finished'))) fail('Najpierw zakończ wszystkie mecze turnieju.');
  if (patch.status === 'upcoming' && tournament.matches.some(active)) fail('Turniej ma rozpoczęte mecze i nie może być oznaczony jako nadchodzący.');
  if (patch.status === 'live' && !tournament.matches.some(active)) fail('Najpierw rozpocznij przynajmniej jeden mecz.');
  return validateManagedTournament({ ...tournament, ...clone(patch), rules });
}

export function upsertTournamentTeam(input, values) {
  const tournament = validateManagedTournament(input);
  if (!values || typeof values !== 'object') fail('Podaj drużynę.');
  const id = values.id || nextId('team', tournament.teams.map(team => team.id));
  const existing = tournament.teams.find(team => team.id === id);
  if (existing && own(values, 'players') && !same(values.players, existing.players)) fail('Skład zmieniaj przez edycję zawodników.');
  const team = normalizeTeam({ ...existing, ...clone(values), id, players: existing?.players || values.players || [] });
  return validateManagedTournament({ ...tournament, teams: existing ? tournament.teams.map(item => item.id === id ? team : item) : [...tournament.teams, team] });
}

export function removeTournamentTeam(input, id) {
  const tournament = validateManagedTournament(input);
  if (!tournament.teams.some(team => team.id === id)) fail('Nie znaleziono drużyny.');
  if (tournament.groups.some(group => group.teamIds.includes(id)) || tournament.matches.some(match => [match.homeTeamId, match.awayTeamId].includes(id))) fail('Najpierw usuń drużynę z grup i nierozpoczętych meczów. Rozegranych spotkań nie można usunąć.');
  return validateManagedTournament({ ...tournament, teams: tournament.teams.filter(team => team.id !== id) });
}

export function upsertTournamentPlayer(input, teamId, values) {
  const tournament = validateManagedTournament(input);
  const team = tournament.teams.find(item => item.id === teamId);
  if (!team || !values || typeof values !== 'object') fail('Nie znaleziono drużyny lub zawodnika.');
  const id = values.id || nextId('player', tournament.teams.flatMap(item => item.players.map(player => player.id)));
  const previous = team.players.find(player => player.id === id);
  const player = normalizePlayer({ ...previous, ...clone(values), id });
  team.players = previous ? team.players.map(item => item.id === id ? player : item) : [...team.players, player];
  return validateManagedTournament(tournament);
}

export function removeTournamentPlayer(input, teamId, playerId) {
  const tournament = validateManagedTournament(input);
  const team = tournament.teams.find(item => item.id === teamId);
  if (!team?.players.some(player => player.id === playerId)) fail('Nie znaleziono zawodnika.');
  if (tournament.matches.some(match => match.events.some(event => event.playerId === playerId))) fail('Zawodnik ma zapisane zdarzenia meczowe. Nie można usunąć jego historii.');
  team.players = team.players.filter(player => player.id !== playerId);
  return validateManagedTournament(tournament);
}

function affectedMatchIds(tournament, groupIds) {
  const affected = new Set(tournament.matches.filter(match => groupIds.has(match.groupId)).map(match => match.id));
  let changed = true;
  while (changed) {
    changed = false;
    for (const match of tournament.matches) if (!affected.has(match.id) && [match.homeSource, match.awaySource].some(source =>
      source?.type === 'group' ? groupIds.has(source.groupId) : source?.matchId && affected.has(source.matchId))) { affected.add(match.id); changed = true; }
  }
  return affected;
}

export function setTournamentGroups(input, groups) {
  const tournament = validateManagedTournament(input);
  if (!Array.isArray(groups)) fail('Podaj listę grup.');
  const reservedIds = [...tournament.groups.map(group => group.id), ...groups.map(group => group.id).filter(Boolean)];
  const nextGroups = groups.map((group, index) => {
    const old = tournament.groups.find(item => item.id === group.id);
    const id = group.id || nextId('group', reservedIds); reservedIds.push(id);
    return { ...old, ...clone(group), id, name: group.name || old?.name || `Grupa ${index + 1}`,
      phase: group.phase ?? old?.phase ?? 0, teamIds: group.teamIds || old?.teamIds || [] };
  });
  const changed = new Set([...tournament.groups, ...nextGroups].filter(group => {
    const old = tournament.groups.find(item => item.id === group.id); const next = nextGroups.find(item => item.id === group.id);
    return !old || !next || !same([old.phase, old.teamIds, old.advancing, old.numEncounters], [next.phase, next.teamIds, next.advancing, next.numEncounters]);
  }).map(group => group.id));
  if (changed.size && tournament.isImported && new Set(tournament.groups.map(group => group.phase)).size > 1) fail('Zachowaj oryginalne fazy grupowe importowanego turnieju.');
  const affected = affectedMatchIds(tournament, changed);
  if (tournament.matches.some(match => affected.has(match.id) && active(match))) fail('Zmiana grup naruszyłaby rozpoczęte lub rozegrane mecze.');
  return validateManagedTournament({ ...tournament, groups: nextGroups, matches: tournament.matches.filter(match => !affected.has(match.id)) });
}

function schedulingOptions(tournament, options = {}, fallbackStart) {
  const startTime = checkedKickoff(options.startTime || fallbackStart);
  const durationMinutes = integer(options.durationMinutes ?? tournament.matchMinutes ?? 12, 'Długość meczu', 1, 180);
  const breakMinutes = integer(options.breakMinutes ?? 3, 'Przerwa między meczami', 0, 120);
  if (!Array.isArray(options.courts || ['Boisko 1']) || !(options.courts || ['Boisko 1']).length) fail('Podaj co najmniej jedno boisko.');
  const courts = (options.courts || ['Boisko 1']).map(court => text(court, 'nazwa boiska', true, 100));
  unique(courts, 'Boiska');
  if (courts.length > 16) fail('Można zaplanować najwyżej 16 boisk.');
  return { startTime, durationMinutes, breakMinutes, courts, slot: (durationMinutes + breakMinutes) * 60000 };
}

function roundRobin(teamIds) {
  const rotation = [...teamIds];
  if (rotation.length % 2) rotation.push(null);
  const rounds = [];
  for (let round = 0; round < rotation.length - 1; round += 1) {
    const pairs = [];
    for (let index = 0; index < rotation.length / 2; index += 1) {
      const home = rotation[index]; const away = rotation[rotation.length - index - 1];
      if (home && away) pairs.push(round % 2 ? [away, home] : [home, away]);
    }
    rounds.push(pairs);
    rotation.splice(1, 0, rotation.pop());
  }
  return rounds;
}

const emptyMatch = (id, stage) => ({ id, stage, groupId: null, homeTeamId: null, awayTeamId: null, homeScore: null, awayScore: null,
  homePenalties: null, awayPenalties: null, status: 'scheduled', events: [] });

function checkScheduleCollisions(generated, preserved, defaultDuration) {
  for (const match of generated) for (const other of preserved) {
    if (!match.kickoff || !other.kickoff) continue;
    const starts = Date.parse(match.kickoff); const otherStarts = Date.parse(other.kickoff);
    const ends = starts + (match.durationMinutes ?? defaultDuration) * 60000;
    const otherEnds = otherStarts + (other.durationMinutes ?? defaultDuration) * 60000;
    if (starts >= otherEnds || otherStarts >= ends) continue;
    const sameCourt = match.court && match.court === other.court;
    const sameTeam = [match.homeTeamId, match.awayTeamId].filter(Boolean).some(id => [other.homeTeamId, other.awayTeamId].includes(id));
    if (sameCourt || sameTeam) fail('Nowy terminarz koliduje z zachowanym meczem: boisko lub drużyna są już zajęte.');
  }
}

export function generateTournamentSchedule(input, options = {}) {
  const tournament = validateManagedTournament(input);
  const groupIds = options.groupIds || tournament.groups.map(group => group.id);
  if (!Array.isArray(groupIds) || !groupIds.length) fail('Najpierw utwórz grupy i przypisz drużyny.');
  unique(groupIds, 'Wybrane grupy');
  const groups = groupIds.map(id => tournament.groups.find(group => group.id === id));
  if (groups.some(group => !group || group.teamIds.length < 2)) fail('Każda wybrana grupa musi mieć co najmniej dwie drużyny.');
  if (new Set(groups.map(group => group.phase)).size > 1) fail('Generuj terminarz dla jednej fazy grupowej naraz.');
  const affected = affectedMatchIds(tournament, new Set(groupIds));
  if (tournament.matches.some(match => affected.has(match.id) && active(match))) fail('Nie można zastąpić terminarza po rozpoczęciu jego meczów lub zależnych rund.');
  const config = schedulingOptions(tournament, options);
  const rounds = groups.map(group => {
    const encounters = integer(options.numEncounters ?? options.rounds ?? group.numEncounters ?? 1, 'Liczba spotkań każdej pary', 1, 2);
    const firstLeg = roundRobin(group.teamIds);
    return { group: { ...group, numEncounters: encounters }, rounds: encounters === 2 ? [...firstLeg, ...firstLeg.map(round => round.map(([home, away]) => [away, home]))] : firstLeg };
  });
  const generated = []; let slot = 0;
  for (let round = 0; round < Math.max(...rounds.map(item => item.rounds.length)); round += 1) {
    const fixtures = rounds.flatMap(item => (item.rounds[round] || []).map((pair, index) => ({ group: item.group, pair, index })));
    fixtures.forEach(({ group, pair, index }, position) => generated.push({ ...emptyMatch(`rr-${group.id}-${round + 1}-${index + 1}`, 'group'),
      groupId: group.id, phase: group.phase, phaseName: group.phaseName || 'Faza grupowa', round: round + 1,
      homeTeamId: pair[0], awayTeamId: pair[1], kickoff: new Date(Date.parse(config.startTime) + (slot + Math.floor(position / config.courts.length)) * config.slot).toISOString(),
      court: config.courts[position % config.courts.length], durationMinutes: config.durationMinutes }));
    slot += Math.ceil(fixtures.length / config.courts.length);
  }
  const preserved = tournament.matches.filter(match => !(match.stage === 'group' && groupIds.includes(match.groupId)));
  checkScheduleCollisions(generated, preserved, tournament.matchMinutes || config.durationMinutes);
  return validateManagedTournament({ ...tournament, matchMinutes: config.durationMinutes,
    groups: tournament.groups.map(group => rounds.find(item => item.group.id === group.id)?.group || group), matches: [...preserved, ...generated] });
}

function groupSeeds(groups, count) {
  if (groups.length === 1 && groups[0].teamIds.length >= count) {
    const seedOrder = size => size === 2 ? [1, 2] : seedOrder(size / 2).flatMap(seed => [seed, size + 1 - seed]);
    return seedOrder(count).map(position => ({ type: 'group', groupId: groups[0].id, position }));
  }
  if (groups.length === count) return groups.map(group => ({ type: 'group', groupId: group.id, position: 1 }));
  if (groups.length * 2 === count && groups.every(group => group.teamIds.length >= 2)) {
    const upper = []; const lower = [];
    for (let index = 0; index < groups.length; index += 2) {
      upper.push({ type: 'group', groupId: groups[index].id, position: 1 }, { type: 'group', groupId: groups[index + 1].id, position: 2 });
      lower.push({ type: 'group', groupId: groups[index + 1].id, position: 1 }, { type: 'group', groupId: groups[index].id, position: 2 });
    }
    return [...upper, ...lower];
  }
  fail('Ten układ wymaga jednej grupy, zwycięzców wszystkich grup albo dwóch awansujących z każdej grupy.');
}

export function generateTournamentBracket(input, options = {}) {
  const tournament = validateManagedTournament(input);
  const count = integer(options.qualifiers ?? 8, 'Liczba drużyn w drabince', 2, 16);
  if (![2, 4, 8, 16].includes(count)) fail('Drabinka musi mieć 2, 4, 8 lub 16 drużyn.');
  if (tournament.matches.some(match => match.stage !== 'group' && active(match))) fail('Nie można zastąpić rozpoczętej drabinki.');
  if (tournament.isImported && tournament.matches.some(match => match.stage !== 'group')) fail('Zachowaj oryginalną drabinkę importowanego turnieju.');
  const groupIds = options.groupIds || tournament.groups.filter(group => group.phase === Math.max(...tournament.groups.map(item => item.phase))).map(group => group.id);
  if (!Array.isArray(groupIds) || !groupIds.length) fail('Najpierw wybierz grupy do awansu.');
  unique(groupIds, 'Wybrane grupy');
  const groups = groupIds.map(id => tournament.groups.find(group => group.id === id));
  if (groups.some(group => !group || group.teamIds.length < 2) || new Set(groups.map(group => group.phase)).size > 1) fail('Wybierz prawidłowe grupy z jednej fazy.');
  let seeds = groupSeeds(groups, count);
  const qualifiersByGroup = new Map(groups.map(group => [group.id, seeds.filter(source => source.groupId === group.id).map(source => source.position).sort((a, b) => a - b)]));
  const duration = integer(options.durationMinutes ?? tournament.matchMinutes ?? 12, 'Długość meczu', 1, 180);
  const interval = integer(options.breakMinutes ?? 3, 'Przerwa między meczami', 0, 120);
  const groupEnd = Math.max(...tournament.matches.filter(match => match.stage === 'group' && match.kickoff).map(match =>
    Date.parse(match.kickoff) + (match.durationMinutes ?? tournament.matchMinutes ?? duration) * 60000));
  const fallbackStart = Number.isFinite(groupEnd) ? new Date(groupEnd + interval * 60000).toISOString() : null;
  const config = schedulingOptions(tournament, options, fallbackStart);
  if (Number.isFinite(groupEnd) && Date.parse(config.startTime) < groupEnd + interval * 60000) fail('Faza pucharowa musi zaczynać się po meczach grupowych i przerwie.');
  const generated = []; let slot = 0; let semifinals = [];
  for (let size = count; size >= 2; size /= 2) {
    const stage = { 16: 'round16', 8: 'quarterfinal', 4: 'semifinal', 2: 'final' }[size];
    const ids = [];
    for (let index = 0; index < seeds.length; index += 2) {
      const id = `ko-${stage}-${index / 2 + 1}`; ids.push(id);
      generated.push({ ...emptyMatch(id, stage), homeSource: seeds[index], awaySource: seeds[index + 1],
        kickoff: new Date(Date.parse(config.startTime) + (slot + Math.floor(index / 2 / config.courts.length)) * config.slot).toISOString(),
        court: config.courts[index / 2 % config.courts.length], durationMinutes: config.durationMinutes });
    }
    if (size === 4) semifinals = ids;
    slot += Math.ceil(ids.length / config.courts.length);
    seeds = ids.map(matchId => ({ type: 'winner', matchId }));
  }
  if (options.includeThirdPlace && semifinals.length === 2) {
    const final = generated.find(match => match.stage === 'final');
    const third = { ...emptyMatch('ko-third-1', 'third'), homeSource: { type: 'loser', matchId: semifinals[0] }, awaySource: { type: 'loser', matchId: semifinals[1] },
      kickoff: final.kickoff, court: config.courts[0], durationMinutes: config.durationMinutes };
    final.kickoff = new Date(Date.parse(final.kickoff) + config.slot).toISOString();
    generated.push(third);
  }
  const next = { ...tournament, groups: tournament.groups.map(group => qualifiersByGroup.has(group.id) ?
    { ...group, advancing: qualifiersByGroup.get(group.id).length, qualifiedPositions: qualifiersByGroup.get(group.id), playoffPositions: [] } : group),
    matches: [...tournament.matches.filter(match => match.stage === 'group'), ...generated] };
  next.matches = resolveTournamentMatches(next);
  return validateManagedTournament(next);
}
