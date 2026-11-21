import React, { useId, useMemo, useRef, useState } from 'react';
import { ArrowDown, ArrowUpRight, BookOpen, ChevronDown, Search, Trophy } from 'lucide-react';
import { mlpnBookData } from '../data/mlpnBookData';
import './MLPNBookPage.css';

const TABS = [
  { id: 'records', label: 'Rekordy' },
  { id: 'clubs', label: 'Kluby' },
  { id: 'medals', label: 'Medaliści' },
  { id: 'stories', label: 'Historie' },
  { id: 'seasons', label: 'Sezony' },
];
const GROUPS = { players: 'Zawodnicy', teams: 'Drużyny', matches: 'Mecze', streaks: 'Serie' };
const LEAGUES = { '1st': 'I liga', '2nd': 'II liga', '3rd': 'III liga', all: 'I–III liga' };
const STATUS = { verified: 'Potwierdzone', archive: 'Dane archiwalne', partial: 'Niepełne archiwum' };
const number = value => typeof value === 'number' ? new Intl.NumberFormat('pl-PL').format(value) : value;
const normalize = value => String(value ?? '').toLocaleLowerCase('pl').normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/ł/g, 'l');
const scopeLabel = record => record.scope || (record.season ? `Sezon ${record.season}` : 'Archiwum MLPN');
const yearLabel = year => typeof year === 'object' ? year.year : year;

function SourceLink({ url, children, className = '' }) {
  if (!url) return <span className={className}>{children}</span>;
  const external = /^https?:\/\//.test(url);
  return <a className={`mlpn-book-source ${className}`} href={url} {...(external ? { target: '_blank', rel: 'noopener noreferrer' } : {})}>
    {children}<ArrowUpRight size={14} aria-hidden="true" />
  </a>;
}

function RecordRow({ record }) {
  return <details className="mlpn-book-record">
    <summary>
      <span className="mlpn-book-record-copy">
        <span className="mlpn-book-eyebrow">{GROUPS[record.group] || 'Rekord'}</span>
        <span className="mlpn-book-record-label">{record.label}</span>
        <span className="mlpn-book-holder">{record.holder}</span>
      </span>
      <span className="mlpn-book-record-number">
        <strong>{number(record.value)}</strong>
        {record.unit && <span>{record.unit}</span>}
      </span>
      <span className="mlpn-book-record-context">
        <span className="mlpn-book-scope">{scopeLabel(record)}</span>
        {record.season && !scopeLabel(record).includes(String(record.season)) && <span>Sezon {record.season}</span>}
        {record.leagueCode && <span>{LEAGUES[record.leagueCode] || record.leagueCode}</span>}
        <span className={`mlpn-book-status mlpn-book-status--${record.status || 'archive'}`}>{STATUS[record.status] || 'Dane archiwalne'}</span>
      </span>
      <ChevronDown className="mlpn-book-record-chevron" size={19} aria-hidden="true" />
    </summary>
    <div className="mlpn-book-record-detail">
      {record.detail && <p>{record.detail}</p>}
      {!!record.ranking?.length && <div className="mlpn-book-ranking" aria-label={`Ranking: ${record.label}`}>
        <div className="mlpn-book-ranking-heading"><span>Zestawienie</span><span>Wynik</span></div>
        <ol>
          {record.ranking.map((entry, index) => <li key={`${entry.holder}-${index}`}>
            <span className="mlpn-book-ranking-position">{entry.rank ?? index + 1}</span>
            <span className="mlpn-book-ranking-person"><SourceLink url={entry.sourceUrl}>{entry.holder}</SourceLink>{entry.detail && <small>{entry.detail}</small>}</span>
            <strong>{number(entry.value)}</strong>
          </li>)}
        </ol>
      </div>}
      <div className="mlpn-book-record-footnote">
        {record.sourceNote && <p><strong>Jak liczymy:</strong> {record.sourceNote}</p>}
        <span>Źródło: <SourceLink url={record.sourceUrl}>{record.sourceLabel || 'Archiwum MLPN'}</SourceLink></span>
      </div>
    </div>
  </details>;
}

function Medals({ medals, champions }) {
  const standings = [...medals].sort((a, b) => b.gold - a.gold || b.silver - a.silver || b.bronze - a.bronze || a.team.localeCompare(b.team, 'pl'));
  return <div className="mlpn-book-medals-layout">
    <section>
      <div className="mlpn-book-section-heading"><div><span className="mlpn-book-eyebrow">Historia podium</span><h2>Klasyfikacja medalowa</h2></div><span className="mlpn-book-small-note">I liga · według złotych medali</span></div>
      <div className="mlpn-book-medal-table" role="table" aria-label="Klasyfikacja medalowa I ligi">
        <div className="mlpn-book-medal-head" role="row"><span role="columnheader">Klub</span><span role="columnheader" title="Złote medale">Złoto</span><span role="columnheader" title="Srebrne medale">Srebro</span><span role="columnheader" title="Brązowe medale">Brąz</span><span role="columnheader">Razem</span></div>
        {standings.map((club, index) => <div className="mlpn-book-medal-row" role="row" key={club.team}>
          <span className="mlpn-book-medal-team" role="cell"><span>{index + 1}</span><span><strong>{club.team}</strong>{!!club.years?.length && <small>Mistrz: {club.years.map(yearLabel).join(', ')}</small>}</span></span>
          <strong className="mlpn-book-medal-gold" role="cell">{club.gold}</strong><span role="cell">{club.silver}</span><span role="cell">{club.bronze}</span><strong role="cell">{club.total ?? club.gold + club.silver + club.bronze}</strong>
        </div>)}
      </div>
    </section>
    <section className="mlpn-book-podium-section">
      <div className="mlpn-book-section-heading"><div><span className="mlpn-book-eyebrow">Sezon po sezonie</span><h2>Podium I ligi</h2></div></div>
      <div className="mlpn-book-podium-list">{[...champions].sort((a, b) => b.year - a.year).map(podium => <details key={podium.year}>
        <summary><span>{podium.year}</span><strong>{podium.gold}</strong><ChevronDown size={16} aria-hidden="true" /></summary>
        <ol><li><span className="mlpn-book-podium-place is-gold">1</span>{podium.gold}</li><li><span className="mlpn-book-podium-place is-silver">2</span>{podium.silver}</li><li><span className="mlpn-book-podium-place is-bronze">3</span>{podium.bronze}</li></ol>
      </details>)}</div>
    </section>
  </div>;
}

function ClubHistory({ clubs = [] }) {
  const [query, setQuery] = useState('');
  const [sort, setSort] = useState('goals');
  const rows = useMemo(() => clubs.filter(club => normalize([club.team, ...(club.sourceNames || [])].join(' ')).includes(normalize(query.trim())))
    .sort((a, b) => (sort === 'seasons' ? b.seasons - a.seasons : b.goalsFor - a.goalsFor) || a.team.localeCompare(b.team, 'pl')), [clubs, query, sort]);
  return <>
    <div className="mlpn-book-section-heading"><div><span className="mlpn-book-eyebrow">Wszystkie dostępne edycje · 2003–2026</span><h2>Tabela wszech czasów</h2></div><span className="mlpn-book-small-note">Rozwiń klub, aby sprawdzić sezony i dawne nazwy.</span></div>
    <p className="mlpn-book-archive-note">Bramki z końcowych tabel, wraz z wynikami administracyjnymi. Potwierdzone zmiany nazwy łączymy; zespoły rezerw i nieustalone następstwa pozostają osobno. Liczba wpisów nie oznacza liczby odrębnych klubów.</p>
    <div className="mlpn-book-club-filters"><label><span>Szukaj klubu lub dawnej nazwy</span><input aria-label="Szukaj klubu lub dawnej nazwy" type="search" value={query} onChange={event => setQuery(event.target.value)} placeholder="Np. Dziadki, PKKL, Miśko…" /></label><label><span>Sortowanie klubów</span><select aria-label="Sortowanie klubów" value={sort} onChange={event => setSort(event.target.value)}><option value="goals">Najwięcej goli</option><option value="seasons">Najwięcej sezonów</option></select></label></div>
    <div className="mlpn-book-record-list-heading"><span>Pozycje archiwum: <strong>{rows.length}</strong></span><span>Gole i sezony w ligach I–III</span></div>
    <div className="mlpn-book-club-head"><span>Drużyna</span><span>Sezony</span><span>Gole</span><span /></div>
    {rows.map(club => <details key={club.team} className="mlpn-book-club">
      <summary><span><strong>{club.team}</strong><small>{club.firstYear}–{club.lastYear}{club.incomplete ? ' · niepełne archiwum' : ''}{club.mixedIdentity ? ' · zmiana drużyny w sezonie' : ''}</small></span><span>{club.seasons}</span><strong>{number(club.goalsFor)}</strong><ChevronDown size={14} aria-hidden="true" /></summary>
      <div className="mlpn-book-club-detail">
        {!!club.sourceNames?.length && <p><strong>Nazwy w źródłach:</strong> {club.sourceNames.join(' · ')}</p>}
        <p><strong>Bilans bramek:</strong> {number(club.goalsFor)}:{number(club.goalsAgainst)}. {club.sourceNote || 'Suma zachowanych tabel sezonowych; to nie jest liczba wyłącznie goli zdobytych na boisku.'}</p>
        <div className="mlpn-book-club-seasons">{[...(club.seasonRows || [])].sort((a,b) => b.year - a.year).map((season,index) => <div key={`${season.year}-${season.league}-${index}`}><strong>{season.year}</strong><span>{LEAGUES[season.league] || season.league}</span><span>{season.goalsFor}:{season.goalsAgainst}</span></div>)}</div>
      </div>
    </details>)}
    {!rows.length && <p className="mlpn-book-archive-note">Nie znaleziono klubu pod tą nazwą.</p>}
  </>;
}

export default function MLPNBookPage({ darkMode = false }) {
  const uid = useId();
  const contentRef = useRef(null);
  const [tab, setTab] = useState('records');
  const [search, setSearch] = useState('');
  const [group, setGroup] = useState('all');
  const [scope, setScope] = useState('all');
  const [period, setPeriod] = useState('history');
  const { records = [], clubs = [], medals = [], champions = [], stories = [], seasons = [], methodology = [], asOf } = mlpnBookData;
  const periodRecords = useMemo(() => records.filter(record => period === 'all' || (record.period || 'history') === period), [records, period]);
  const scopes = useMemo(() => [...new Set(periodRecords.map(scopeLabel))], [periodRecords]);
  const filtered = useMemo(() => periodRecords.filter(record => (
    (group === 'all' || record.group === group) &&
    (scope === 'all' || scopeLabel(record) === scope) &&
    normalize([record.label, record.holder, record.detail, record.season, LEAGUES[record.leagueCode], record.scope,
      ...(record.ranking || []).map(entry => `${entry.holder} ${entry.detail || ''}`),
    ].join(' ')).includes(normalize(search.trim()))
  )), [periodRecords, search, group, scope]);
  const dziadki = medals.find(club => normalize(club.team) === 'dziadki');
  const firstYear = [...seasons.map(season => Number(season.year)), ...champions.map(season => Number(season.year))].filter(Number.isFinite).sort((a, b) => a - b)[0];
  const updated = asOf && !Number.isNaN(Date.parse(asOf)) ? new Intl.DateTimeFormat('pl-PL', { day: 'numeric', month: 'long', year: 'numeric' }).format(new Date(asOf)) : asOf;
  function switchTab(next) { setTab(next); }
  function browseBook() {
    contentRef.current?.scrollIntoView({ behavior: window.matchMedia?.('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth', block: 'start' });
  }
  function navigateTabs(event, index) {
    const nextIndex = event.key === 'ArrowRight' ? (index + 1) % TABS.length : event.key === 'ArrowLeft' ? (index + TABS.length - 1) % TABS.length : event.key === 'Home' ? 0 : event.key === 'End' ? TABS.length - 1 : null;
    if (nextIndex === null) return;
    event.preventDefault();
    switchTab(TABS[nextIndex].id);
    document.getElementById(`${uid}-tab-${TABS[nextIndex].id}`)?.focus();
  }

  return <section aria-label="Księga MLPN" className={`mlpn-book${darkMode ? ' is-dark' : ''}`}>
    <header className="mlpn-book-hero">
      <div className="mlpn-book-hero-copy">
        <div className="mlpn-book-hero-kicker"><BookOpen size={17} aria-hidden="true" /><span>Historia zapisana na boisku{firstYear ? ` · od ${firstYear}` : ''}</span></div>
        <h1>Księga <span>MLPN</span></h1>
        <p>Ludzie, kluby i wyniki, które tworzą naszą ligę. Odkrywaj rekordy i wracaj do najważniejszych sezonów.</p>
        <button type="button" onClick={browseBook} className="mlpn-book-hero-anchor">Przeglądaj księgę <ArrowDown size={15} aria-hidden="true" /></button>
      </div>
      {dziadki && <button type="button" className="mlpn-book-hero-story" onClick={() => { switchTab('medals'); browseBook(); }}>
        <span className="mlpn-book-eyebrow"><Trophy size={15} aria-hidden="true" /> Z kart historii</span>
        <span className="mlpn-book-hero-story-title"><strong>{dziadki.gold}</strong><span>tytuły mistrzowskie<br /><b>{dziadki.team}</b></span></span>
        {!!dziadki.years?.length && <span className="mlpn-book-hero-years">{dziadki.years.map(yearLabel).sort((a, b) => a - b).join(' / ')}</span>}
        <span className="mlpn-book-hero-story-link">Poznaj medalistów ligi <ArrowUpRight size={16} aria-hidden="true" /></span>
      </button>}
    </header>

    <div className="mlpn-book-body" id={`${uid}-content`} ref={contentRef}>
      <div className="mlpn-book-navigation"><div className="mlpn-book-tabs" role="tablist" aria-label="Rozdziały Księgi MLPN">{TABS.map((item, index) => <button type="button" key={item.id} id={`${uid}-tab-${item.id}`} role="tab" aria-selected={tab === item.id} aria-controls={`${uid}-panel-${item.id}`} tabIndex={tab === item.id ? 0 : -1} onKeyDown={event => navigateTabs(event, index)} onClick={() => switchTab(item.id)}>{item.label}</button>)}</div><span className="mlpn-book-edition">Archiwum ligi</span></div>

      <section className="mlpn-book-panel" role="tabpanel" id={`${uid}-panel-${tab}`} aria-labelledby={`${uid}-tab-${tab}`} tabIndex={0}>
        {tab === 'records' && <>
          <div className="mlpn-book-section-heading"><div><span className="mlpn-book-eyebrow">Liczby mówią same za siebie</span><h2>Rekordy i najlepsze wyniki</h2></div><span className="mlpn-book-small-note">Rozwiń rekord, aby zobaczyć szczegóły i źródło.</span></div>
          <div className="mlpn-book-period" role="group" aria-label="Okres porównania">{[['history','Historia 2003–2026'],['2026','Sezon 2026'],['all','Wszystkie']].map(([value,label]) => <button type="button" key={value} aria-pressed={period === value} onClick={() => { setPeriod(value); setScope('all'); }}>{label}</button>)}</div>
          {period === 'history' && <p className="mlpn-book-archive-note">Porównujemy dostępne sezony całej historii ligi. Niepełne protokoły i nieustalone rekordy są oznaczone przy wynikach. Pełne zestawienie klubów znajdziesz w zakładce „Kluby”.</p>}
          <div className="mlpn-book-filters">
            <label className="mlpn-book-search"><span>Szukaj w rekordach</span><span className="mlpn-book-search-field"><Search size={17} aria-hidden="true" /><input type="search" value={search} onChange={event => setSearch(event.target.value)} placeholder="Zawodnik, drużyna, rekord…" /></span></label>
            <label><span>Kategoria</span><select aria-label="Kategoria" value={group} onChange={event => setGroup(event.target.value)}><option value="all">Wszystkie kategorie</option>{Object.entries(GROUPS).map(([value, label]) => <option key={value} value={value}>{label}</option>)}</select></label>
            <label><span>Zakres danych</span><select aria-label="Zakres danych" value={scope} onChange={event => setScope(event.target.value)}><option value="all">Wszystkie zakresy</option>{scopes.map(label => <option key={label} value={label}>{label}</option>)}</select></label>
          </div>
          <div className="mlpn-book-record-list-heading"><span aria-live="polite">Wyniki: <strong>{filtered.length}</strong></span><span>Każdy rekord ma własny zakres danych.</span></div>
          <div className="mlpn-book-record-list">{filtered.map(record => <RecordRow key={record.id} record={record} />)}</div>
          {!filtered.length && <div className="mlpn-book-empty"><BookOpen size={32} aria-hidden="true" /><h3>Brak pasujących rekordów</h3><p>Spróbuj innej nazwy lub poszerz zakres danych.</p><button type="button" onClick={() => { setSearch(''); setGroup('all'); setScope('all'); }}>Wyczyść filtry</button></div>}
        </>}
        {tab === 'clubs' && <ClubHistory clubs={clubs} />}
        {tab === 'medals' && <Medals medals={medals} champions={champions} />}
        {tab === 'stories' && <>
          <div className="mlpn-book-section-heading"><div><span className="mlpn-book-eyebrow">Za wynikiem stoi historia</span><h2>Z kart MLPN</h2></div></div>
          <div className="mlpn-book-stories">{stories.map((story, index) => <article key={story.id} className="mlpn-book-story"><span className="mlpn-book-story-index">{String(index + 1).padStart(2, '0')}</span><div><span className="mlpn-book-eyebrow">{story.kicker}</span><h3>{story.title}</h3><p>{story.text}</p>{(story.team || story.years) && <div className="mlpn-book-story-meta">{story.team && <span>{story.team}</span>}{story.years && <span>{Array.isArray(story.years) ? story.years.map(yearLabel).join(' · ') : story.years}</span>}</div>}<SourceLink url={story.sourceUrl}>{story.sourceLabel || 'Zobacz źródło'}</SourceLink></div></article>)}</div>
        </>}
        {tab === 'seasons' && <>
          <div className="mlpn-book-section-heading"><div><span className="mlpn-book-eyebrow">Wróć do rozgrywek</span><h2>Archiwum sezonów</h2></div><span className="mlpn-book-small-note">Tabele, wyniki i podsumowania.</span></div>
          <div className="mlpn-book-seasons">{[...seasons].sort((a, b) => b.year - a.year).map(season => <article key={season.year}><h3>{season.year}</h3><div><p>{season.description}</p>{Number(season.year) === 2026 && <div className="mlpn-book-season-leagues">{['I liga', 'II liga', 'III liga'].map((label, index) => <a key={label} href={`/${index + 1}-liga?sezon=2026`}>Podsumowanie: {label}<ArrowUpRight size={14} aria-hidden="true" /></a>)}</div>}</div><SourceLink url={season.url}>Zobacz sezon</SourceLink></article>)}</div>
        </>}
      </section>

      <footer className="mlpn-book-methodology"><details><summary><span>O danych i sposobie liczenia</span><ChevronDown size={17} aria-hidden="true" /></summary><div className="mlpn-book-methodology-content">{methodology.map((item, index) => <section key={index}><h3>{item.title}</h3><p>{item.text}</p></section>)}<section><h3>Co oznaczają etykiety?</h3><p>„Potwierdzone” oznacza wynik zweryfikowany w podanym źródle. „Dane archiwalne” pochodzą z historycznych zestawień. „Niepełne archiwum” wskazuje rekord w dostępnych danych — brakujące sezony lub protokoły mogą zmienić ranking.</p></section></div></details>{updated && <p>Stan danych: {updated}</p>}</footer>
    </div>
  </section>;
}
