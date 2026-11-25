import corrections from './tournamentCorrections.json';
import { getMatchWinner } from '../lib/tournamentEngine';

const normalizedName = value => String(value || '').normalize('NFC').trim().replace(/\s+/g, ' ').toLocaleLowerCase('pl');
const sameEvent = (first, second) => ['type', 'teamId', 'playerId', 'minute'].every(key => first[key] === second[key]);
const sameValue = (first, second) => (first ?? null) === (second ?? null);
const matchFields = ['homeScore', 'awayScore', 'homePenalties', 'awayPenalties', 'reportedWinnerId', 'status', 'sourceScoreMissing', 'outcomeNote'];

function applyCorrection(tournament, correction) {
  for (const expected of correction.teams || []) {
    const matches = tournament.teams.filter(team => team.id === expected.id && normalizedName(team.name) === normalizedName(expected.name));
    if (matches.length !== 1) throw new Error('Nie można przypisać korekty turnieju: ' + expected.name + '.');
  }

  const playerIds = new Map();
  let teams = tournament.teams;
  for (const supplied of correction.players || []) {
    if (!correction.teams?.some(team => team.id === supplied.teamId)) throw new Error('Niepotwierdzona drużyna zawodnika: ' + supplied.name + '.');
    const rosterMatches = teams.flatMap(team => (team.players || []).filter(player =>
      player.id === supplied.id || normalizedName(player.name) === normalizedName(supplied.name))
      .map(player => ({ teamId: team.id, player })));
    const unassigned = (tournament.unassignedPlayers || []).some(player =>
      player.id === supplied.id || normalizedName(player.name) === normalizedName(supplied.name));
    const existing = rosterMatches[0]?.player;
    const acceptedName = existing && [supplied.name, supplied.expectedName].filter(Boolean)
      .some(name => normalizedName(existing.name) === normalizedName(name));
    if (unassigned || rosterMatches.length > 1 || (existing &&
      (rosterMatches[0].teamId !== supplied.teamId || !acceptedName)) ||
      (supplied.expectedName && (!existing || existing.id !== supplied.id))) {
      throw new Error('Niejednoznaczny zawodnik w korekcie: ' + supplied.name + '.');
    }
    playerIds.set(supplied.id, existing?.id || supplied.id);
    teams = teams.map(team => team.id !== supplied.teamId ? team : {
      ...team,
      players: existing ? (team.players || []).map(player => player.id !== existing.id ? player : {
        ...player, name: supplied.name, correctionId: correction.id,
      }) : [...(team.players || []), { id: supplied.id, name: supplied.name, correctionId: correction.id }],
    });
  }

  // Keep the original final-only correction applicable to already saved documents.
  const patches = [
    ...(correction.final ? [{
      ...correction.final, stage: 'final', homePenalties: null, awayPenalties: null,
      reportedWinnerId: null, status: 'finished', sourceScoreMissing: false, outcomeNote: null,
    }] : []),
    ...(correction.matches || []),
  ];
  let matches = tournament.matches;
  let championTeamId = tournament.championTeamId;
  for (const supplied of patches) {
    const found = matches.filter(match => match.id === supplied.id);
    const original = found[0];
    if (found.length !== 1 || original.stage !== supplied.stage ||
      original.homeTeamId !== supplied.homeTeamId || original.awayTeamId !== supplied.awayTeamId) {
      throw new Error(supplied.stage === 'final' ? 'Uczestnicy finału nie pasują do potwierdzonej korekty.' : 'Uczestnicy meczu nie pasują do potwierdzonej korekty.');
    }
    for (const [key, expected] of Object.entries(supplied.expected || {})) {
      if (!sameValue(original[key], expected) &&
        !(Object.prototype.hasOwnProperty.call(supplied, key) && sameValue(original[key], supplied[key]))) {
        throw new Error('Bieżący wynik meczu różni się od potwierdzonej korekty.');
      }
    }
    const changed = { ...original, correctionId: correction.id };
    for (const key of matchFields) if (Object.prototype.hasOwnProperty.call(supplied, key)) changed[key] = supplied[key];
    if (supplied.events) {
      const events = supplied.events.map(event => ({
        ...event, playerId: playerIds.get(event.playerId) || event.playerId, correctionId: correction.id,
      }));
      for (const event of events) {
        const conflicting = (original.events || []).find(previous => previous.id === event.id && !sameEvent(previous, event));
        if (conflicting) throw new Error('Zdarzenie meczu różni się od potwierdzonej korekty.');
      }
      changed.events = [...(original.events || []).filter(event => !events.some(next => next.id === event.id || sameEvent(event, next))), ...events];
    }
    for (const [teamId, total] of [[changed.homeTeamId, changed.homeScore], [changed.awayTeamId, changed.awayScore]]) {
      if ((changed.events || []).filter(event => event.type === 'goal' && event.teamId === teamId).length > total) {
        throw new Error('Zdarzenia meczu nie pasują do potwierdzonego wyniku.');
      }
    }
    matches = matches.map(match => match.id === changed.id ? changed : match);
    if (changed.stage === 'final') championTeamId = getMatchWinner(changed);
  }

  let date = tournament.date;
  let matchDates = tournament.matchDates;
  if (correction.date) {
    const { expected, value } = correction.date;
    const replaceDate = current => {
      if (current !== expected && current !== value) throw new Error('Data turnieju różni się od potwierdzonej korekty.');
      return value;
    };
    date = replaceDate(date);
    if (matchDates) matchDates = matchDates.map(replaceDate);
    matches = matches.map(match => {
      if (!match.kickoff) return match;
      return { ...match, kickoff: replaceDate(match.kickoff.slice(0, 10)) + match.kickoff.slice(10) };
    });
  }

  const awards = (correction.awards || []).map(award => {
    const supplied = { ...award, ...(award.playerId ? { playerId: playerIds.get(award.playerId) || award.playerId } : {}), correctionId: correction.id };
    if (!teams.some(team => team.id === supplied.teamId && (!supplied.playerId || (team.players || []).some(player => player.id === supplied.playerId)))) {
      throw new Error('Nie można przypisać wyróżnienia: ' + supplied.playerName + '.');
    }
    const previous = (tournament.awards || []).filter(item => item.id === supplied.id);
    if (previous.length > 1 || previous.some(item =>
      ['type', 'teamId', 'value', 'unit'].some(key => !sameValue(item[key], supplied[key])) ||
      normalizedName(item.playerName) !== normalizedName(supplied.playerName) ||
      (item.playerId && supplied.playerId && item.playerId !== supplied.playerId))) {
      throw new Error('Wyróżnienie różni się od potwierdzonej korekty: ' + supplied.playerName + '.');
    }
    return supplied;
  });
  return {
    ...tournament, date, ...(matchDates ? { matchDates } : {}), teams, matches, championTeamId,
    ...(patches.some(patch => patch.events?.length) ? { individualStatsComplete: false } : {}),
    awards: [...(tournament.awards || []).filter(award => !awards.some(supplied => supplied.id === award.id)), ...awards],
    corrections: [...(tournament.corrections || []).filter(item => item.id !== correction.id), { id: correction.id, source: { ...correction.source } }],
  };
}

/** Merge verified facts without mutating an archive or persisted document.
 * Names, participants and previous values must still match the documented source. */
export function applyTournamentCorrections(tournament) {
  return corrections.filter(item => item.tournamentSlug === tournament.slug).reduce(applyCorrection, tournament);
}
