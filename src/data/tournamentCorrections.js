import corrections from './tournamentCorrections.json';
import { getMatchWinner } from '../lib/tournamentEngine';

const normalizedName = value => String(value || '').normalize('NFC').trim().replace(/\s+/g, ' ').toLocaleLowerCase('pl');
const sameEvent = (first, second) => ['type', 'teamId', 'playerId', 'minute'].every(key => first[key] === second[key]);

/** Apply documented additions without changing the original Tournify export.
 * Award totals are independent of the incomplete match-event statistics. */
export function applyTournamentCorrections(tournament) {
  const correction = corrections.find(item => item.tournamentSlug === tournament.slug);
  if (!correction) return tournament;

  for (const expected of correction.teams) {
    const matches = tournament.teams.filter(team => team.id === expected.id && normalizedName(team.name) === normalizedName(expected.name));
    if (matches.length !== 1) throw new Error(`Nie można przypisać korekty turnieju: ${expected.name}.`);
  }
  const finals = tournament.matches.filter(match => match.id === correction.final.id && match.stage === 'final');
  const originalFinal = finals[0];
  if (finals.length !== 1 || originalFinal.homeTeamId !== correction.final.homeTeamId || originalFinal.awayTeamId !== correction.final.awayTeamId) {
    throw new Error('Uczestnicy finału nie pasują do potwierdzonej korekty.');
  }

  const playerIds = new Map();
  let teams = tournament.teams;
  for (const supplied of correction.players) {
    const rosterMatches = teams.flatMap(team => (team.players || []).filter(player =>
      player.id === supplied.id || normalizedName(player.name) === normalizedName(supplied.name))
      .map(player => ({ teamId: team.id, player })));
    if (rosterMatches.length > 1 || (rosterMatches.length === 1 &&
      (rosterMatches[0].teamId !== supplied.teamId || normalizedName(rosterMatches[0].player.name) !== normalizedName(supplied.name)))) {
      throw new Error(`Niejednoznaczny zawodnik w korekcie: ${supplied.name}.`);
    }
    const existing = rosterMatches[0]?.player;
    playerIds.set(supplied.id, existing?.id || supplied.id);
    if (!existing) teams = teams.map(team => team.id === supplied.teamId ? {
      ...team, players: [...(team.players || []), { id: supplied.id, name: supplied.name, correctionId: correction.id }],
    } : team);
  }

  const suppliedEvents = correction.final.events.map(event => ({ ...event, playerId: playerIds.get(event.playerId) || event.playerId, correctionId: correction.id }));
  const events = [...(originalFinal.events || []).filter(event => !suppliedEvents.some(supplied => supplied.id === event.id || sameEvent(event, supplied))), ...suppliedEvents];
  const final = {
    ...originalFinal,
    homeScore: correction.final.homeScore, awayScore: correction.final.awayScore,
    homePenalties: null, awayPenalties: null, reportedWinnerId: null,
    status: 'finished', sourceScoreMissing: false, outcomeNote: null,
    events, correctionId: correction.id,
  };
  for (const [teamId, total] of [[final.homeTeamId, final.homeScore], [final.awayTeamId, final.awayScore]]) {
    if (events.filter(event => event.type === 'goal' && event.teamId === teamId).length > total) {
      throw new Error('Zdarzenia finału nie pasują do potwierdzonego wyniku.');
    }
  }
  const awards = correction.awards.map(award => ({
    ...award, ...(award.playerId ? { playerId: playerIds.get(award.playerId) || award.playerId } : {}), correctionId: correction.id,
  }));
  return {
    ...tournament, teams,
    matches: tournament.matches.map(match => match.id === final.id ? final : match),
    championTeamId: getMatchWinner(final),
    individualStatsComplete: false,
    awards: [...(tournament.awards || []).filter(award => !awards.some(supplied => supplied.id === award.id)), ...awards],
    corrections: [...(tournament.corrections || []).filter(item => item.id !== correction.id), { id: correction.id, source: { ...correction.source } }],
  };
}
