import { hasPermission, hasGrantedPermissions, normalizePermissions } from './adminPermissions';

describe('profile permission values use the database authorization semantics', () => {
  test.each([false, 'false', 1, '1', [], {}, null, undefined])('does not grant access from %j', value => {
    const permissions = { contact: { read: value } };
    expect(hasPermission(permissions, 'contact.read')).toBe(false);
    expect(hasGrantedPermissions(permissions)).toBe(false);
    expect(normalizePermissions(permissions).contact.read).toBe(false);
  });
  test.each([true, 'true'])('preserves an existing explicit grant %j', value => {
    const permissions = { contact: { read: value } };
    expect(hasPermission(permissions, 'contact.read')).toBe(true);
    expect(hasGrantedPermissions(permissions)).toBe(true);
    expect(normalizePermissions(permissions).contact.read).toBe(true);
  });
  test('editing another permission cannot promote a truthy attacker field into a grant', () => {
    const permissions = normalizePermissions({ contact: { read: 'false' }, schedule: { edit: true } });
    permissions.schedule.edit = false;
    expect(permissions.contact.read).toBe(false);
    expect(hasGrantedPermissions(permissions)).toBe(false);
  });
});
