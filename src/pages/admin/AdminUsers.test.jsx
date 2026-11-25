import React from 'react';
import { createRoot } from 'react-dom/client';
import { act, Simulate } from 'react-dom/test-utils';
import AdminUsers from './AdminUsers';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import { hasPermission, hasAnyPermission } from '../../lib/adminPermissions';

jest.mock('../../lib/supabase', () => ({ supabase: { from: jest.fn() } }));
jest.mock('../../contexts/AuthContext', () => ({ useAuth: jest.fn() }));
jest.mock('@supabase/supabase-js', () => ({ createClient: jest.fn() }));

const account = (id, name, extra = {}) => ({ id, display_name: name, first_name: '', last_name: '',
  email: id + '@example.test', role: 'viewer', account_status: 'active', permissions: {}, ...extra });
const fixtureUsers = [
  account('member', 'Łukasz Wiśniewski'),
  account('player', 'Zawodnik', { role: 'player' }),
  account('banned-user', 'Użytkownik zbanowany', { account_status: 'banned' }),
  account('admin', 'Administrator główny', { role: 'admin' }),
  account('editor', 'Redaktor ligi', { role: 'editor' }),
  account('duty', 'Dyżurny meczu', { permissions: { results: { enter: true } } }),
  account('suspended-staff', 'Zawieszona obsługa', { account_status: 'suspended', permissions: { schedule: { edit: 'true' } } }),
];
const admin = account('actor', 'Zarządzający', { role: 'admin' });
let host, root, users, query, update, remove;
function actor(profile = admin) {
  useAuth.mockReturnValue({ profile,
    can: key => hasPermission(profile.permissions, key, profile.role),
    canAny: keys => hasAnyPermission(profile.permissions, keys, profile.role) });
}
beforeEach(() => {
  global.IS_REACT_ACT_ENVIRONMENT = true;
  host = document.createElement('div'); document.body.appendChild(host); root = createRoot(host);
  users = fixtureUsers.map(user => ({ ...user }));
  actor();
  update = jest.fn(); remove = jest.fn();
  query = {
    select: jest.fn(() => query),
    limit: jest.fn(async () => ({ data: [], error: null })),
    order: jest.fn(async () => ({ data: users, error: null })),
    update, delete: remove,
  };
  supabase.from.mockReset().mockReturnValue(query);
});
afterEach(async () => { await act(async () => root.unmount()); host.remove(); jest.restoreAllMocks(); });
const render = async () => act(async () => root.render(<AdminUsers darkMode={false} />));
const tabs = () => [...host.querySelectorAll('[role="tab"]')];
const tab = name => tabs().find(element => element.textContent.startsWith(name));
const rows = () => [...host.querySelectorAll('[data-account-id]')];
const ids = () => rows().map(element => element.getAttribute('data-account-id'));
const click = async element => act(async () => Simulate.click(element));
const change = async (element, value) => act(async () => Simulate.change(element, { target: { value } }));
const newAccountButton = () => [...host.querySelectorAll('button')].find(element => /Now(e|y|a) (konto|użytkownik)/i.test(element.textContent));

test('ordinary users and staff have separate lists and accurate unfiltered counts', async () => {
  await render();
  expect(tabs()).toHaveLength(2);
  expect(tab('Użytkownicy').textContent).toContain('3');
  expect(tab('Obsługa MLPN').textContent).toContain('4');
  expect(tab('Użytkownicy').getAttribute('aria-selected')).toBe('true');
  expect(ids()).toEqual(['member', 'player', 'banned-user']);
  for (const row of rows()) {
    expect(row.textContent).toContain('Użytkownik');
    expect(row.textContent).not.toContain('Własne uprawnienia');
  }
  await click(tab('Obsługa MLPN'));
  expect(ids()).toEqual(['admin', 'editor', 'duty', 'suspended-staff']);
  expect(tab('Obsługa MLPN').getAttribute('aria-selected')).toBe('true');
  expect(host.querySelector('[data-account-id="admin"]').textContent).toContain('Administrator');
  expect(host.querySelector('[data-account-id="editor"]').textContent).toContain('Redaktor');
  expect(host.querySelector('[data-account-id="duty"]').textContent).toContain('Własne uprawnienia');
  expect(host.querySelector('[data-account-id="suspended-staff"]').textContent).toContain('Zawieszone');
  expect(update).not.toHaveBeenCalled(); expect(remove).not.toHaveBeenCalled();
});

test('search ignores Polish accents and status filtering does not change group counts', async () => {
  await render();
  await change(host.querySelector('[aria-label="Szukaj konta"]'), 'lukasz wisniewski');
  expect(ids()).toEqual(['member']);
  expect(tab('Użytkownicy').textContent).toContain('3');
  await change(host.querySelector('[aria-label="Szukaj konta"]'), '');
  await change(host.querySelector('[aria-label="Status kont"]'), 'banned');
  expect(ids()).toEqual(['banned-user']);
  expect(tab('Obsługa MLPN').textContent).toContain('4');
  expect(update).not.toHaveBeenCalled(); expect(remove).not.toHaveBeenCalled();
});

test('searches contact email only inside the selected group and provides an empty result state', async () => {
  await render();
  await change(host.querySelector('[aria-label="Szukaj konta"]'), 'admin@example.test');
  expect(ids()).toEqual([]);
  expect(host.textContent).toMatch(/Brak|Nie znaleziono/);
  await click(tab('Obsługa MLPN'));
  await change(host.querySelector('[aria-label="Szukaj konta"]'), 'admin@example.test');
  expect(ids()).toEqual(['admin']);
  expect(host.querySelector('[data-account-id="member"]')).toBeNull();
  expect(supabase.from.mock.calls.every(([table]) => table === 'profiles')).toBe(true);
  expect(update).not.toHaveBeenCalled(); expect(remove).not.toHaveBeenCalled();
});

test('revoked last staff permission moves an account to ordinary users on the next load', async () => {
  await render();
  await click(tab('Obsługa MLPN'));
  expect(ids()).toContain('duty');
  await act(async () => root.render(null));
  users = users.map(user => user.id === 'duty' ? { ...user, permissions: { results: { enter: false } } } : user);
  await render();
  expect(ids()).toContain('duty');
  expect(tab('Użytkownicy').textContent).toContain('4');
  expect(tab('Obsługa MLPN').textContent).toContain('3');
  expect(update).not.toHaveBeenCalled();
});

test('new account starts without any selected permissions and switching groups closes its draft', async () => {
  await render();
  await click(newAccountButton());
  expect(host.querySelector('form')).not.toBeNull();
  expect([...host.querySelectorAll('form input[type="checkbox"]')].some(input => input.checked)).toBe(false);
  expect(host.querySelector('select[name="access_mode"]')?.value).not.toBe('admin');
  await click(tab('Obsługa MLPN'));
  expect(host.querySelector('form')).toBeNull();
  expect(update).not.toHaveBeenCalled(); expect(remove).not.toHaveBeenCalled();
});

test('an account without account-management permissions cannot fetch or browse accounts', async () => {
  actor(account('ordinary', 'Użytkownik'));
  await render();
  expect(supabase.from).not.toHaveBeenCalled();
  expect(rows()).toHaveLength(0);
  expect(host.textContent).toMatch(/Brak uprawnień|Brak uprawnien/);
  expect(newAccountButton()).toBeUndefined();
});

test('a limited account editor can browse staff but cannot edit or delete administrator accounts', async () => {
  actor(account('limited', 'Edytor kont', { permissions: { users: { edit: true, delete: true } } }));
  await render();
  await click(tab('Obsługa MLPN'));
  for (const id of ['admin', 'editor']) {
    const row = host.querySelector('[data-account-id="' + id + '"]');
    expect(row).not.toBeNull();
    expect(row.querySelector('button[title="Edytuj konto"]')).toBeNull();
    expect(row.querySelector('button[title="Usun konto z panelu"]')).toBeNull();
  }
  expect(host.querySelector('[data-account-id="duty"] button[title="Edytuj konto"]')).not.toBeNull();
  expect(update).not.toHaveBeenCalled(); expect(remove).not.toHaveBeenCalled();
});

test('editing an ordinary player without changes preserves the player role and never writes a viewer downgrade', async () => {
  users = [account('player', 'Jan Nowak', { role: 'player', first_name: 'Jan', last_name: 'Nowak' })];
  await render();
  await click(host.querySelector('[data-account-id="player"] button[title="Edytuj konto"]'));
  expect(host.querySelector('form')).not.toBeNull();
  await act(async () => Simulate.submit(host.querySelector('form'), { preventDefault: jest.fn() }));
  expect(host.querySelector('form')).toBeNull();
  expect(host.textContent).toContain('Konto zostalo zaktualizowane.');
  expect(update).not.toHaveBeenCalled();
  expect(remove).not.toHaveBeenCalled();
  expect(ids()).toEqual(['player']);
  expect(tab('Użytkownicy').getAttribute('aria-selected')).toBe('true');
});
