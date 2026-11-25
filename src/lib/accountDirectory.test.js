import { countAccountGroups, filterAccountDirectory, getAccountGroup, getAccountRoleLabel } from './accountDirectory';
import { createEmptyPermissions } from './adminPermissions';

const ordinary = { id: 'regular', role: 'viewer', display_name: 'Łukasz Żółć', first_name: 'Łukasz', last_name: 'Żółć', email: 'lukasz@example.com', account_status: 'active', permissions: {} };
const player = { ...ordinary, id: 'player', role: 'player', display_name: 'Piłkarz', account_status: 'banned' };
const admin = { ...ordinary, id: 'admin', role: 'admin', account_status: 'suspended' };
const editor = { ...ordinary, id: 'editor', role: 'editor', account_status: 'banned' };
const duty = { ...ordinary, id: 'duty', display_name: 'Dyżurny', permissions: { results: { enter: true } } };
const organizer = { ...ordinary, id: 'organizer', display_name: 'Organizator', permissions: { schedule: { edit: 'true' } }, account_status: 'suspended' };
const accounts = [ordinary, player, admin, editor, duty, organizer];

test('separates ordinary viewer/player accounts from roles and explicit staff permissions independently of status', () => {
  expect(accounts.map(getAccountGroup)).toEqual(['users', 'users', 'staff', 'staff', 'staff', 'staff']);
  expect(countAccountGroups(accounts)).toEqual({ users: 2, staff: 4 });
  expect(filterAccountDirectory(accounts).map(user => user.id)).toEqual(['regular', 'player']);
  expect(filterAccountDirectory(accounts, { group: 'staff' }).map(user => user.id)).toEqual(['admin', 'editor', 'duty', 'organizer']);
});

test.each([undefined, null, {}, [], createEmptyPermissions(), { results: { enter: false, edit: 'false' } },
  { results: { enter: 1, edit: 'TRUE' } }, { typo: { edit: true } }, { results: true }])('empty, false or unknown permissions do not classify users as staff (%p)', permissions => {
  expect(getAccountGroup({ ...ordinary, permissions })).toBe('users');
  expect(getAccountRoleLabel({ ...ordinary, permissions })).toBe('Użytkownik');
});

test.each([true, 'true'])('recognized grants classify viewer and player as staff (%p)', value => {
  for (const role of ['viewer', 'player']) {
    expect(getAccountGroup({ ...ordinary, role, permissions: { users: { permissions: { grant: value } } } })).toBe('staff');
  }
});

test('labels reflect existing authority without inventing permanent organizer or duty roles', () => {
  expect(accounts.map(getAccountRoleLabel)).toEqual(['Użytkownik', 'Użytkownik', 'Administrator', 'Redaktor', 'Własne uprawnienia', 'Własne uprawnienia']);
});

test('search matches names and email regardless of accents or letter case but never technical IDs', () => {
  expect(filterAccountDirectory(accounts, { query: '  LUKASZ  ZOLC  ' }).map(user => user.id)).toEqual(['regular', 'player']);
  expect(filterAccountDirectory(accounts, { query: 'PIŁKARZ' }).map(user => user.id)).toEqual(['player']);
  expect(filterAccountDirectory(accounts, { query: 'LUKASZ@EXAMPLE.COM' }).map(user => user.id)).toEqual(['regular', 'player']);
  expect(filterAccountDirectory(accounts, { query: 'regular' })).toEqual([]);
  expect(filterAccountDirectory(accounts, { group: 'staff', query: 'dyzurny' }).map(user => user.id)).toEqual(['duty']);
});

test('status filtering preserves group membership, defaults missing status to active and never mixes groups', () => {
  expect(filterAccountDirectory(accounts, { group: 'staff', status: 'suspended' }).map(user => user.id)).toEqual(['admin', 'organizer']);
  expect(filterAccountDirectory(accounts, { group: 'staff', status: 'banned' }).map(user => user.id)).toEqual(['editor']);
  expect(filterAccountDirectory(accounts, { status: 'banned' }).map(user => user.id)).toEqual(['player']);
  expect(filterAccountDirectory([{ ...ordinary, account_status: undefined }], { status: 'active' })).toHaveLength(1);
  expect(filterAccountDirectory(accounts, { group: 'staff', query: 'dyżurny', status: 'banned' })).toEqual([]);
});

test('empty and nullable entries are harmless and all operations preserve account data', () => {
  expect(countAccountGroups([null, undefined])).toEqual({ users: 0, staff: 0 });
  expect(countAccountGroups()).toEqual({ users: 0, staff: 0 });
  expect(filterAccountDirectory([null, undefined])).toEqual([]);
  expect(filterAccountDirectory()).toEqual([]);
  const before = JSON.stringify(accounts);
  const filtered = filterAccountDirectory(accounts, { group: 'staff' });
  filtered.forEach(user => expect(accounts).toContain(user));
  countAccountGroups(accounts); accounts.forEach(getAccountRoleLabel);
  expect(JSON.stringify(accounts)).toBe(before);
});
