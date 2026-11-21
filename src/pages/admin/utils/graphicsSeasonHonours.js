import { season2026Honours } from '../../../data/season2026Honours';

const POSITION_LABELS = {
  Bramkarz: 'BR',
  'Lewy obrońca': 'LO',
  'Środkowy obrońca': 'ŚO',
  'Prawy obrońca': 'PO',
  'Lewy pomocnik': 'LP',
  'Środkowy pomocnik': 'ŚP',
  'Prawy pomocnik': 'PP',
  'Lewy napastnik': 'LN',
  'Środkowy napastnik': 'ŚN',
  'Prawy napastnik': 'PN',
};

const normalizeName = (value) => String(value || '').trim().toLocaleLowerCase('pl');

// Official gala selections are deliberately independent of calculated rankings.
// A different season must not silently inherit the 2026 winners.
export function getGraphicsSeasonHonours(seasonYear, leagueCode, teams = []) {
  if (Number(seasonYear) !== 2026 || !Object.prototype.hasOwnProperty.call(season2026Honours, leagueCode)) {
    return null;
  }

  const source = season2026Honours[leagueCode];
  const teamIndex = new Map(
    (Array.isArray(teams) ? teams : [])
      .filter((team) => !team.leagueCode || team.leagueCode === leagueCode)
      .map((team) => [normalizeName(team.name), team])
  );
  const findTeam = (player) => teamIndex.get(normalizeName(player.teamRouteName || player.team));
  const decoratePlayer = (player) => {
    const team = findTeam(player);
    return { ...player, teamId: team?.id || '', logoUrl: team?.logo_url || '' };
  };

  // Gala rows run right to left; canvas formation slots run left to right.
  // Keep the rows themselves in goalkeeper → defence → midfield → attack order.
  let offset = 0;
  const lineup = source.formation.split('-').flatMap((count) => {
    const row = source.bestEight.slice(offset, offset + Number(count));
    offset += Number(count);
    return row.reverse().map((player) => ({
      ...decoratePlayer(player),
      positionLabel: POSITION_LABELS[player.position],
    }));
  });

  return {
    year: source.year,
    champion: source.champion,
    championLogo: teamIndex.get(normalizeName(source.champion))?.logo_url || '',
    formation: source.formation.replace(/^1-/, ''),
    awards: source.awards.map(decoratePlayer),
    lineup,
  };
}
