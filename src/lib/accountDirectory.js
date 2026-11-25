import { hasGrantedPermissions, normalizePermissions } from './adminPermissions';

export function getAccountGroup(user) {
  return ['admin', 'editor'].includes(user?.role) || hasGrantedPermissions(normalizePermissions(user?.permissions))
    ? 'staff' : 'users';
}

export function getAccountRoleLabel(user) {
  if (user?.role === 'admin') return 'Administrator';
  if (user?.role === 'editor') return 'Redaktor';
  return getAccountGroup(user) === 'staff' ? 'Własne uprawnienia' : 'Użytkownik';
}

const normalizeSearch = value => String(value || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '')
  .replace(/[łŁ]/g, 'l').toLocaleLowerCase('pl').replace(/\s+/g, ' ').trim();

export function filterAccountDirectory(users = [], { group = 'users', query = '', status = 'all' } = {}) {
  const terms = normalizeSearch(query).split(' ').filter(Boolean);
  return users.filter(user => {
    if (!user || getAccountGroup(user) !== group) return false;
    if (status !== 'all' && (user.account_status || 'active') !== status) return false;
    const searchable = normalizeSearch([user.display_name, user.first_name, user.last_name, user.email].filter(Boolean).join(' '));
    return terms.every(term => searchable.includes(term));
  });
}

export function countAccountGroups(users = []) {
  return users.reduce((counts, user) => {
    if (user) counts[getAccountGroup(user)] += 1;
    return counts;
  }, { users: 0, staff: 0 });
}
