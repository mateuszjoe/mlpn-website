import { season2026Honours } from '../../../data/season2026Honours';
import { getGraphicsSeasonHonours } from './graphicsSeasonHonours';

describe('official season graphics data', () => {
  test.each([
    ['1st', '2-3-2', ['Maciej Wronka', 'Radosław Tkaczyk', 'Patryk Wódkowski', 'Damian Bąk', 'Adam Wosiek', 'Damian Zajdowski', 'Karol Sochocki', 'Mateusz Trąbiński'], ['BR', 'ŚO', 'ŚO', 'LP', 'ŚP', 'PP', 'LN', 'PN']],
    ['2nd', '3-3-1', ['Marcin Komorowski', 'Damian Juszyński', 'Dominik Turlej', 'Rafał Charkiewicz', 'Maks Kardas', 'Mateusz Skowroński', 'Maciej Boguszewski', 'Olaf Orełko'], ['BR', 'LO', 'ŚO', 'PO', 'LP', 'ŚP', 'PP', 'ŚN']],
    ['3rd', '3-3-1', ['Tomasz Bajur', 'Patryk Halaburda', 'Adam Jakubowicz', 'Michał Zimolużyński', 'Szymon Tomaszewski', 'Piotr Wąsowski', 'Kacper Kucharek', 'Sebastian Orzoł'], ['BR', 'LO', 'ŚO', 'PO', 'LP', 'ŚP', 'PP', 'ŚN']],
  ])('maps the %s gala selection to canvas slots', (league, formation, names, positions) => {
    const result = getGraphicsSeasonHonours('2026', league);
    expect(result.formation).toBe(formation);
    expect(result.lineup.map((player) => player.name)).toEqual(names);
    expect(result.lineup.map((player) => player.positionLabel)).toEqual(positions);
    expect(result.awards).toHaveLength(4);
    expect(result.champion).toBe(season2026Honours[league].champion);
    result.lineup.forEach((player) => {
      const official = season2026Honours[league].bestEight.find((entry) => entry.name === player.name);
      expect(player.playerId).toBe(official.playerId);
      expect(player.logoUrl).toBe('');
    });
  });

  test.each([
    [2025, '1st'], [2027, '1st'], ['', '1st'], [undefined, '1st'],
    ['2026oops', '1st'], [2026, '4th'], [2026, undefined], [2026, 'toString'],
  ])('does not substitute winners for unsupported selection %s / %s', (year, league) => {
    expect(getGraphicsSeasonHonours(year, league)).toBeNull();
  });

  test('resolves canonical route names and case without changing the displayed club name', () => {
    const teams = [
      { id: 'kss', name: 'Fc KSS', logo_url: '/kss.png', leagueCode: '3rd' },
      { id: 'faworyt', name: ' FC FAWORYT ', logo_url: '/faworyt.png', leagueCode: '3rd' },
      { id: 'other-season-league', name: 'FC Faworyt', logo_url: '/wrong.png', leagueCode: '2nd' },
    ];
    const result = getGraphicsSeasonHonours(2026, '3rd', teams);
    expect(result.lineup[1]).toMatchObject({
      name: 'Patryk Halaburda', team: 'FC KSS', teamRouteName: 'Fc KSS', teamId: 'kss', logoUrl: '/kss.png',
    });
    expect(result.championLogo).toBe('/faworyt.png');
    expect(result.awards[0]).toMatchObject({ name: 'Sebastian Orzoł', teamId: 'faworyt', logoUrl: '/faworyt.png' });
  });

  test('preserves official awards and IDs without recomputing statistics', () => {
    const result = getGraphicsSeasonHonours(2026, '2nd', [
      { id: 'pjm', name: 'PJM', logo_url: '/pjm.png', assists: 999 },
    ]);
    expect(result.awards[2]).toMatchObject({
      category: 'Najlepszy asystent', name: 'Karol Bujalski', stat: '14 asyst',
      playerId: 'af068b66-25aa-464c-9d08-586347cf69d6', logoUrl: '/pjm.png',
    });
  });

  test('does not mutate the official source when reordering or editing generated data', () => {
    const before = JSON.stringify(season2026Honours);
    for (const league of ['1st', '2nd', '3rd']) {
      const result = getGraphicsSeasonHonours(2026, league);
      result.lineup[0].name = 'Changed draft';
      result.awards[0].stat = 'Changed draft';
      result.lineup.reverse();
      result.awards.reverse();
    }
    expect(JSON.stringify(season2026Honours)).toBe(before);
  });
});
