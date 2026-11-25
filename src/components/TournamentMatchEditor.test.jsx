import React from 'react';
import { createRoot } from 'react-dom/client';
import { act, Simulate } from 'react-dom/test-utils';
import TournamentMatchEditor from './TournamentMatchEditor';
import { createManagedTournament, upsertTournamentTeam, upsertTournamentPlayer, setTournamentGroups, generateTournamentSchedule, generateTournamentBracket } from '../lib/tournamentManagement';
import { updateTournamentMatch, resolveTournamentMatches } from '../lib/tournamentEngine';

let host;
let root;
function scheduledTournament() {
  let tournament = createManagedTournament({ name: 'Puchar', date: '2026-12-20', location: 'Halinów' });
  ['Alfa', 'Beta', 'Gamma', 'Delta'].forEach(name => { tournament = upsertTournamentTeam(tournament, { name }); });
  tournament.teams.forEach(team => { tournament = upsertTournamentPlayer(tournament, team.id, { name: 'Zawodnik ' + team.name, number: 7 }); });
  tournament = setTournamentGroups(tournament, [{ name: 'A', teamIds: tournament.teams.slice(0, 2).map(team => team.id), advancing: 2 }, { name: 'B', teamIds: tournament.teams.slice(2).map(team => team.id), advancing: 2 }]);
  return generateTournamentSchedule(tournament, { startTime: '2026-12-20T09:00:00+01:00', durationMinutes: 10, breakMinutes: 2, courts: ['Boisko 1'] });
}
function completedTournament() {
  let tournament = scheduledTournament();
  tournament.matches.forEach(match => { tournament = updateTournamentMatch(tournament, match.id, { status: 'finished', homeScore: 2, awayScore: 0 }); });
  tournament = generateTournamentBracket(tournament, { qualifiers: 4, includeThirdPlace: false });
  tournament.matches.filter(match => match.stage === 'semifinal').forEach(match => { tournament = updateTournamentMatch(tournament, match.id, { status: 'finished', homeScore: 1, awayScore: 0 }); });
  const final = tournament.matches.find(match => match.stage === 'final');
  return updateTournamentMatch(tournament, final.id, { status: 'finished', homeScore: 3, awayScore: 1 });
}
beforeEach(() => { global.IS_REACT_ACT_ENVIRONMENT = true; host = document.createElement('div'); document.body.appendChild(host); root = createRoot(host); });
afterEach(async () => { await act(async () => root.unmount()); host.remove(); });
const render = async (tournament, matchId, onSave) => act(async () => root.render(<TournamentMatchEditor tournament={tournament} match={resolveTournamentMatches(tournament).find(match => match.id === matchId)} onSave={onSave} />));
const change = async (element, value) => act(async () => Simulate.change(element, { target: { value } }));
const click = async element => act(async () => Simulate.click(element, { button: 0 }));
const submit = async () => act(async () => Simulate.submit(host.querySelector('form')));
const button = text => [...host.querySelectorAll('button')].find(element => element.textContent.trim() === text);
const scores = () => host.querySelectorAll('.tc-editor-score input');
const confirmLabel = 'Zmień wynik i wyczyść kolejne mecze';

test('changing a semifinal winner requires confirmation before a completed final can be cleared', async () => {
  const tournament = completedTournament();
  const semifinal = tournament.matches.find(match => match.stage === 'semifinal');
  const final = tournament.matches.find(match => match.stage === 'final');
  const onSave = jest.fn(async () => {});
  await render(tournament, semifinal.id, onSave);
  await change(scores()[1], '2');
  await submit();
  expect(onSave).not.toHaveBeenCalled();
  expect(host.querySelector('[role=alert]').textContent).toContain('kolejnych meczów: 1');
  expect(final).toMatchObject({ status: 'finished', homeScore: 3, awayScore: 1 });
  await click(button(confirmLabel));
  expect(onSave).toHaveBeenCalledTimes(1);
  expect(onSave.mock.calls[0][0]).toBe(semifinal.id);
  expect(onSave.mock.calls[0][1]).toMatchObject({ homeScore: 1, awayScore: 2, status: 'finished' });
  const updated = updateTournamentMatch(tournament, ...onSave.mock.calls[0]);
  expect(updated.matches.find(match => match.id === final.id)).toMatchObject({ status: 'scheduled', homeScore: null, awayScore: null });
  expect(button(confirmLabel)).toBeUndefined();
});

test('cancelling downstream changes leaves the original final and the entered draft intact', async () => {
  const tournament = completedTournament();
  const semifinal = tournament.matches.find(match => match.stage === 'semifinal');
  const onSave = jest.fn();
  await render(tournament, semifinal.id, onSave);
  await change(scores()[1], '2');
  await submit();
  await click(button('Anuluj'));
  expect(onSave).not.toHaveBeenCalled();
  expect(scores()[1].value).toBe('2');
  expect(tournament.matches.find(match => match.stage === 'final').status).toBe('finished');
  expect(button(confirmLabel)).toBeUndefined();
  await submit();
  expect(button(confirmLabel)).toBeDefined();
  expect(onSave).not.toHaveBeenCalled();
});

test('editing the result invalidates an earlier destructive confirmation', async () => {
  const tournament = completedTournament();
  const semifinal = tournament.matches.find(match => match.stage === 'semifinal');
  const onSave = jest.fn(async () => {});
  await render(tournament, semifinal.id, onSave);
  await change(scores()[1], '2');
  await submit();
  await change(scores()[1], '0');
  expect(button(confirmLabel)).toBeUndefined();
  await submit();
  expect(onSave).toHaveBeenCalledTimes(1);
  expect(onSave.mock.calls[0][1].awayScore).toBe(0);
  expect(tournament.matches.find(match => match.stage === 'final').status).toBe('finished');
});

test('a rejected save preserves entered scores and allows retry', async () => {
  const tournament = completedTournament();
  const final = tournament.matches.find(match => match.stage === 'final');
  const onSave = jest.fn().mockRejectedValueOnce(new Error('Nie udało się zapisać')).mockResolvedValueOnce(undefined);
  await render(tournament, final.id, onSave);
  await change(scores()[0], '4');
  await submit();
  expect(host.querySelector('.tc-error').textContent).toContain('Nie udało się zapisać');
  expect(scores()[0].value).toBe('4');
  expect(final.homeScore).toBe(3);
  expect(host.querySelector('fieldset').disabled).toBe(false);
  await submit();
  expect(onSave).toHaveBeenCalledTimes(2);
  expect(onSave.mock.calls[1][1].homeScore).toBe(4);
  expect(host.querySelector('.tc-error')).toBeNull();
});

test('a scheduled match cannot silently discard an entered result', async () => {
  const tournament = scheduledTournament();
  const match = tournament.matches[0];
  const onSave = jest.fn(async () => {});
  await render(tournament, match.id, onSave);
  await change(scores()[0], '2');
  await change(scores()[1], '1');
  await submit();
  expect(onSave).not.toHaveBeenCalled();
  expect(host.querySelector('.tc-error').textContent).toContain('Zmień status na Na żywo lub Zakończony');
  expect(scores()[0].value).toBe('2');
  await change(host.querySelector('.tc-editor-score select'), 'finished');
  await submit();
  expect(onSave).toHaveBeenCalledWith(match.id, expect.objectContaining({ status: 'finished', homeScore: 2, awayScore: 1 }));
});

test('adding protocol events invalidates pending confirmation so the saved patch includes them', async () => {
  const tournament = completedTournament();
  const semifinal = tournament.matches.find(match => match.stage === 'semifinal');
  const onSave = jest.fn(async () => {});
  await render(tournament, semifinal.id, onSave);
  await change(scores()[1], '2');
  await submit();
  await click(button('Dodaj zdarzenie'));
  expect(host.querySelectorAll('.tc-editor-event-list li')).toHaveLength(1);
  expect(button(confirmLabel)).toBeUndefined();
  await submit();
  await click(button(confirmLabel));
  expect(onSave.mock.calls[0][1].events).toHaveLength(1);
});
