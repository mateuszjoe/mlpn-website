const WALKOVER_HOME = "walkover_home";
const WALKOVER_AWAY = "walkover_away";

function isValidGoalValue(value) {
  return Number.isFinite(value) && value >= 0;
}

export function getWalkoverDirectionError(status, homeGoals, awayGoals) {
  if (status !== WALKOVER_HOME && status !== WALKOVER_AWAY) return null;

  if (!isValidGoalValue(homeGoals) || !isValidGoalValue(awayGoals)) {
    return "Walkower wymaga wpisania wyniku obu druzyn.";
  }

  if (homeGoals === awayGoals) {
    return "Walkower nie moze zakonczyc sie remisem.";
  }

  if (status === WALKOVER_HOME && homeGoals < awayGoals) {
    return "Wynik wskazuje wygrana gosci. Zmien kierunek na Walkower (gosc).";
  }

  if (status === WALKOVER_AWAY && awayGoals < homeGoals) {
    return "Wynik wskazuje wygrana gospodarzy. Zmien kierunek na Walkower (gosp.).";
  }

  return null;
}
