import React, { useState } from 'react';
import { createRoot } from 'react-dom/client';
import { act, Simulate } from 'react-dom/test-utils';
import TournamentAdmin from './TournamentAdmin';
import { createManagedTournament, upsertTournamentTeam, upsertTournamentPlayer, setTournamentGroups, generateTournamentSchedule } from '../lib/tournamentManagement';
import { updateTournamentMatch } from '../lib/tournamentEngine';

let host;
let root;
let latest;
const create = () => createManagedTournament({ name: 'Puchar testowy', date: '2026-12-20', location: 'Halinów' });
function prepared() {
  let tournament = create();
  ['Alfa', 'Beta', 'Gamma', 'Delta'].forEach(name => { tournament = upsertTournamentTeam(tournament, { name }); });
  tournament = upsertTournamentPlayer(tournament, tournament.teams[0].id, { name: 'Jan Kowalski', number: 7 });
  return setTournamentGroups(tournament, [{ name: 'Grupa A', teamIds: tournament.teams.slice(0, 2).map(team => team.id), advancing: 1 }, { name: 'Grupa B', teamIds: tournament.teams.slice(2).map(team => team.id), advancing: 1 }]);
}
const scheduled = () => generateTournamentSchedule(prepared(), { startTime: '2026-12-20T09:00:00+01:00', durationMinutes: 10, breakMinutes: 2, courts: ['Boisko 1'] });
function Harness({ initial = create(), save = async () => {} }) {
  const [tournament, setTournament] = useState(initial); const [revision, setRevision] = useState(0);
  latest = tournament;
  return <TournamentAdmin tournament={tournament} revision={revision} onSave={async next => { await save(next); setTournament(next); setRevision(value => value + 1); }} />;
}
beforeEach(() => { global.IS_REACT_ACT_ENVIRONMENT = true; host = document.createElement('div'); document.body.appendChild(host); root = createRoot(host); });
afterEach(async () => { await act(async () => root.unmount()); host.remove(); });
const render = async (initial, save) => act(async () => root.render(<Harness initial={initial} save={save} />));
const click = async element => act(async () => Simulate.click(element, { button: 0 }));
const change = async (element, value) => act(async () => Simulate.change(element, { target: { value } }));
const check = async (element, checked) => act(async () => Simulate.change(element, { target: { checked } }));
const submit = async form => act(async () => Simulate.submit(form));
const button = (text, scope = host) => [...scope.querySelectorAll('button')].find(element => element.textContent.trim() === text);
const field = (text, scope = host) => [...scope.querySelectorAll('label')].find(element => [...element.childNodes].filter(node => node.nodeType === 3).map(node => node.textContent).join('').trim() === text)?.querySelector('input,select');

test('save waits for persistence, prevents duplicate requests and preserves a rejected draft', async () => {
  let reject;
  const save = jest.fn(() => new Promise((resolve, rejectPromise) => { reject = rejectPromise; }));
  await render(create(), save);
  await change(field('Nazwa turnieju'), 'Poprawiona nazwa');
  await submit(host.querySelector('form'));
  await submit(host.querySelector('form'));
  expect(save).toHaveBeenCalledTimes(1);
  expect(host.querySelector('.ta-body').disabled).toBe(true);
  expect(host.querySelector('[role=status]')).toBeNull();
  await act(async () => reject(new Error('Brak połączenia')));
  expect(host.querySelector('[role=alert]').textContent).toContain('Brak połączenia');
  expect(field('Nazwa turnieju').value).toBe('Poprawiona nazwa');
  expect(latest.name).toBe('Puchar testowy');
  save.mockResolvedValueOnce(undefined);
  await submit(host.querySelector('form'));
  expect(latest.name).toBe('Poprawiona nazwa');
  expect(host.querySelector('[role=status]').textContent).toContain('Zapisano zmiany');
});

test('adding a team with optional fields empty and managing its roster persists valid data', async () => {
  const save = jest.fn(async () => {});
  await render(create(), save);
  await click(button('Drużyny'));
  await change(field('Nazwa drużyny'), 'Nowa Drużyna');
  await submit(host.querySelector('form'));
  expect(latest.teams).toHaveLength(1);
  expect(latest.teams[0].shortName).toBe('Nowa Drużyna');
  await change(field('Imię i nazwisko'), 'Jan Kowalski');
  await change(field('Numer'), '7');
  await submit(host.querySelector('.ta-player-form'));
  expect(latest.teams[0].players[0]).toMatchObject({ name: 'Jan Kowalski', number: 7 });
  await change(field('Imię i nazwisko'), 'Piotr Nowak');
  await change(field('Numer'), '7');
  await submit(host.querySelector('.ta-player-form'));
  expect(host.querySelector('[role=alert]').textContent).toContain('Numery zawodników');
  expect(save).toHaveBeenCalledTimes(2);
  expect(field('Imię i nazwisko').value).toBe('Piotr Nowak');
  await click(button('Edytuj', host.querySelector('.ta-person-list')));
  await change(field('Imię i nazwisko'), 'Jan Nowak');
  await submit(host.querySelector('.ta-player-form'));
  expect(latest.teams[0].players[0].name).toBe('Jan Nowak');
});

test('unused player removal requires confirmation while players with goals remain protected', async () => {
  let initial = scheduled();
  const match = initial.matches[0];
  initial = updateTournamentMatch(initial, match.id, { status: 'finished', homeScore: 1, awayScore: 0, events: [{ id: 'goal-1', type: 'goal', teamId: initial.teams[0].id, playerId: initial.teams[0].players[0].id, minute: 2 }] });
  initial = upsertTournamentPlayer(initial, initial.teams[0].id, { name: 'Rezerwowy Testowy', number: 9 });
  await render(initial);
  await click(button('Drużyny'));
  await click(host.querySelector('.ta-team-name'));
  expect(host.querySelector('button[aria-label="Usuń zawodnika Jan Kowalski"]').disabled).toBe(true);
  await click(host.querySelector('button[aria-label="Usuń zawodnika Rezerwowy Testowy"]'));
  expect(latest.teams[0].players).toHaveLength(2);
  await click(button('Usuń', host.querySelector('.ta-person-list')));
  expect(latest.teams[0].players).toHaveLength(1);
  expect(host.querySelector('button[aria-label="Usuń drużynę Alfa"]').disabled).toBe(true);
});

test('groups assign each team once and generate a home-and-away schedule after confirmation', async () => {
  await render(prepared());
  await click(button('Grupy'));
  const groups = host.querySelectorAll('.ta-group-editor>section');
  const betaInB = [...groups[1].querySelectorAll('label')].find(label => label.textContent === 'Beta').querySelector('input');
  expect(betaInB.disabled).toBe(true);
  await click(button('Mecze', host.querySelector('.ta-tabs')));
  const scheduleForm = host.querySelector('.ta-generators details:first-child form');
  await change(field('System rozgrywek', scheduleForm), '2');
  await submit(scheduleForm);
  expect(latest.matches).toHaveLength(4);
  expect(latest.groups.every(group => group.numEncounters === 2)).toBe(true);
  expect(latest.matches[0].kickoff).toBe('2026-12-20T08:00:00.000Z');
  await change(field('System rozgrywek', scheduleForm), '1');
  await submit(scheduleForm);
  expect(latest.matches).toHaveLength(4);
  expect(button('Zastąp terminarz')).toBeDefined();
  await submit(scheduleForm);
  expect(latest.matches).toHaveLength(2);
});

test('group edits confirm removal of affected unplayed fixtures', async () => {
  await render(scheduled());
  await click(button('Grupy'));
  const group = host.querySelector('.ta-group-editor>section');
  const checkbox = [...group.querySelectorAll('label')].find(label => label.textContent === 'Beta').querySelector('input');
  await check(checkbox, false);
  await submit(host.querySelector('form'));
  expect(latest.matches).toHaveLength(2);
  expect(button('Potwierdź podział')).toBeDefined();
  await submit(host.querySelector('form'));
  expect(latest.groups[0].teamIds).toHaveLength(1);
  expect(latest.matches).toHaveLength(1);
});

test('knockout generation preserves group results and protects a started knockout', async () => {
  let initial = scheduled();
  initial.matches.forEach(match => { initial = updateTournamentMatch(initial, match.id, { status: 'finished', homeScore: 1, awayScore: 0 }); });
  await render(initial);
  await click(button('Mecze', host.querySelector('.ta-tabs')));
  const form = host.querySelector('.ta-generators details:nth-child(2) form');
  await change(field('Liczba drużyn', form), '2');
  await check(field('Mecz o 3. miejsce', form), false);
  await submit(form);
  expect(latest.matches.filter(match => match.stage === 'final')).toHaveLength(1);
  expect(latest.matches.filter(match => match.stage === 'group').every(match => match.homeScore === 1)).toBe(true);
  const final = latest.matches.find(match => match.stage === 'final');
  const playing = updateTournamentMatch(latest, final.id, { status: 'live', homeScore: 0, awayScore: 0 });
  await act(async () => root.render(<TournamentAdmin tournament={playing} onSave={async () => {}} />));
  await click(button('Mecze', host.querySelector('.ta-tabs')));
  expect(host.querySelector('.ta-generators details:nth-child(2) form')).toBeNull();
  expect(host.textContent).toContain('Nie można zastąpić rozegranej drabinki');
});

test('editing match time keeps scores and failed result saves keep entered values', async () => {
  const save = jest.fn(async () => {});
  await render(scheduled(), save);
  await click(button('Mecze', host.querySelector('.ta-tabs')));
  await change(field('Termin meczu'), '2026-12-20T13:45');
  await change(field('Boisko'), 'Hala 2');
  await submit(host.querySelector('.ta-timing form'));
  expect(latest.matches[0]).toMatchObject({ kickoff: '2026-12-20T12:45:00.000Z', court: 'Hala 2', homeScore: null });
  await change(field('Status meczu'), 'finished');
  await change(field('Gole: Alfa'), '2');
  await change(field('Gole: Beta'), '1');
  save.mockRejectedValueOnce(new Error('Nie zapisano wyniku'));
  await submit(host.querySelector('.tc-editor'));
  expect(host.querySelector('.tc-error').textContent).toContain('Nie zapisano wyniku');
  expect(field('Gole: Alfa').value).toBe('2');
  expect(latest.matches[0].homeScore).toBeNull();
  await submit(host.querySelector('.tc-editor'));
  expect(latest.matches[0]).toMatchObject({ homeScore: 2, awayScore: 1, status: 'finished', court: 'Hala 2' });
});

test('imported phases cannot be rebuilt while team details and rosters remain editable', async () => {
  const initial = { ...scheduled(), isImported: true };
  await render(initial);
  await click(button('Grupy'));
  expect(host.querySelector('.ta-group-editor')).toBeNull();
  expect(host.querySelectorAll('.ta-group-readonly section')).toHaveLength(2);
  await click(button('Mecze', host.querySelector('.ta-tabs')));
  expect(host.querySelector('.ta-generators form')).toBeNull();
  await click(button('Drużyny'));
  await click(host.querySelector('.ta-team-name'));
  await change(field('Nazwa drużyny'), 'Alfa poprawiona');
  await submit(host.querySelector('form'));
  expect(latest.teams[0].name).toBe('Alfa poprawiona');
  expect(latest.groups).toEqual(initial.groups);
  expect(latest.matches).toEqual(initial.matches);
});
