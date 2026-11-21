import React from 'react';
import { Award, Crosshair, Goal, ShieldCheck, Trophy } from 'lucide-react';
import './LeagueSeasonSummary.css';

const POSITION_LABELS = {
  'Bramkarz': 'BR',
  'Środkowy obrońca': 'ŚO',
  'Prawy obrońca': 'PO',
  'Lewy obrońca': 'LO',
  'Boczny pomocnik': 'BP',
  'Środkowy pomocnik': 'ŚP',
  'Prawy pomocnik': 'PP',
  'Lewy pomocnik': 'LP',
  'Prawy skrzydłowy': 'PS',
  'Lewy skrzydłowy': 'LS',
  'Napastnik': 'NAP',
};

const AWARD_ICONS = {
  'Najlepszy zawodnik': Trophy,
  'Najlepszy strzelec': Goal,
  'Najlepszy asystent': Crosshair,
  'Najlepszy bramkarz': ShieldCheck,
};

function shortName(name) {
  const [first, ...surname] = name.trim().split(/\s+/);
  return surname.length ? `${first[0]}. ${surname.join(' ')}` : first;
}

// Data follows the gala's order: goalkeeper, defence, midfield, attack.
// Rotate the gala's left-facing pitch so attack is at the top.
function pitchRows(summary) {
  let offset = 0;
  return summary.formation.split('-').map(Number).map(count => {
    const row = summary.bestEight.slice(offset, offset + count);
    offset += count;
    return row.reverse();
  }).reverse();
}

export default function LeagueSeasonSummary({ summary, leagueName, darkMode, TeamLogo, openTeam }) {
  const titleId = `season-honours-${summary.year}`;
  const pitchTitleId = `season-eight-${summary.year}`;

  return (
    <section className={`season-honours${darkMode ? ' season-honours--dark' : ''}`} aria-labelledby={titleId}>
      <header className="season-honours__header">
        <span className="season-honours__eyebrow">{leagueName} · sezon {summary.year}</span>
        <h2 id={titleId}>Wyróżnienia sezonu</h2>
      </header>

      <div className="season-honours__layout">
        <div className="season-honours__awards">
          {summary.awards.map(award => {
            const Icon = AWARD_ICONS[award.category] || Award;
            return (
              <article className="season-honours__award" key={award.category}>
                <div className="season-honours__award-heading">
                  <Icon size={20} aria-hidden="true" />
                  <h3>{award.category}</h3>
                </div>
                <div className="season-honours__award-crest">
                  <TeamLogo team={award.team} darkMode={darkMode} size={56} onClick={() => openTeam(award.team)} />
                </div>
                <div className="season-honours__winner">{award.name}</div>
                <button type="button" className="season-honours__club" onClick={() => openTeam(award.team)}>{award.team}</button>
                {award.stat && <span className="season-honours__stat">{award.stat}</span>}
              </article>
            );
          })}
        </div>

        <section className="season-honours__eight" aria-labelledby={pitchTitleId}>
          <header className="season-honours__eight-heading">
            <h3 id={pitchTitleId}>Najlepsza ósemka</h3>
            <span>{summary.formation}</span>
          </header>
          <div className="season-honours__pitch">
            <div className="season-honours__pitch-lines" aria-hidden="true">
              <span className="season-honours__halfway" />
              <span className="season-honours__circle" />
              <span className="season-honours__penalty season-honours__penalty--top" />
              <span className="season-honours__penalty season-honours__penalty--bottom" />
            </div>
            {pitchRows(summary).map((row, rowIndex) => (
              <div className="season-honours__pitch-row" key={rowIndex} style={{ gridTemplateColumns: `repeat(${row.length}, minmax(0, 1fr))` }}>
                {row.map(player => (
                  <div className="season-honours__player" key={player.name}>
                    <abbr className="season-honours__position" title={player.position}>{POSITION_LABELS[player.position] || player.position}</abbr>
                    <TeamLogo team={player.team} darkMode={true} size={40} onClick={() => openTeam(player.team)} />
                    <span className="season-honours__player-name" title={`${player.name} · ${player.team}`}>{shortName(player.name)}</span>
                  </div>
                ))}
              </div>
            ))}
          </div>
        </section>
      </div>
    </section>
  );
}
