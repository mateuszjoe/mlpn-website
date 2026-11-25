// Local interaction fixture, not an imported or historical competition. No team,
// result, format or start time below is a confirmed entry for Halinów 2026.
export const demoTournamentSlug = "turniej-testowy-2025";

const teamDefinitions = [
  ["almar", "Al Mar Wołomin", "ALM", "almar wolomin.png"],
  ["rebelianci", "Rebelianci", "REB", "Rebelianci.png"],
  ["starszaki", "Starszaki", "STA", "starszaki.png"],
  ["legioholicy", "Legioholicy", "LEG", "legioholicy.png"],
  ["faludza", "Faludża", "FAL", "faludza.png"],
  ["detox", "Detox", "DTX", "detox.png"],
  ["pjm", "PJM", "PJM", "pjm.png"],
  ["stm", "STM FC", "STM", "STM FC.png"],
  ["faworyt", "FC Faworyt", "FAW", "fc faworyt.png"],
  ["rmb", "RMB Bulls", "RMB", "team-logos/rmb-bulls.png"],
  ["alchemia", "Alchemia Futbolu", "ALC", "alchemia futbolu.png"],
  ["kss", "FC KSS", "KSS", "fc kss.png"],
  ["alkomat", "AL-Komat", "ALK", "Al-Komat.png"],
  ["halinow", "SC Halinów", "HAL", "sc halinow.png"],
  ["pendrachy", "RKS Pendrachy", "RKS", "team-logos/rks-pendrachy.png"],
  ["zakapiory", "Sportowe Zakapiory", "ZAK", "sportowe zakapiory.png"],
];
const firstNames = ["Adam", "Michał", "Piotr", "Kamil", "Paweł", "Tomasz", "Jakub", "Marcin"];
const surnames = ["Lis", "Kowalski", "Nowak", "Malinowski", "Zieliński", "Kamiński", "Wróbel", "Wiśniewski"];
const teams = teamDefinitions.map(([id, name, shortName, logo], teamIndex) => ({
  id: `demo-${id}`, name, shortName, logo: `/${logo}`,
  players: Array.from({ length: 5 }, (_, index) => ({ id: `demo-${id}-p${index + 1}`,
    name: `${firstNames[(teamIndex + index) % firstNames.length]} ${surnames[(teamIndex * 3 + index) % surnames.length]}`,
    number: index === 0 ? 1 : index + 6 })),
}));
const groups = ["A", "B", "C", "D"].map((id, index) => ({ id, name: `Grupa ${id}`, teamIds: teams.slice(index * 4, index * 4 + 4).map(team => team.id) }));
const atTime = minutes => `2025-12-14T${String(9 + Math.floor(minutes / 60)).padStart(2, "0")}:${String(minutes % 60).padStart(2, "0")}:00+01:00`;

function eventsFor(match, index) {
  const events = [];
  for (const [side, teamId, goals] of [["h", match.homeTeamId, match.homeScore], ["a", match.awayTeamId, match.awayScore]]) {
    const team = teams.find(item => item.id === teamId);
    if (!team || goals == null) continue;
    for (let goal = 0; goal < goals; goal += 1) {
      const minute = Math.min(10, 2 + goal * 3);
      events.push({ id: `${match.id}-${side}-g${goal}`, type: "goal", teamId, playerId: team.players[(index + goal + 1) % 5].id, minute });
      if (goal % 2 === 0) events.push({ id: `${match.id}-${side}-a${goal}`, type: "assist", teamId, playerId: team.players[(index + goal + 2) % 5].id, minute });
    }
  }
  if (index % 5 === 0 && match.homeTeamId) events.push({ id: `${match.id}-yellow`, type: "yellow", teamId: match.homeTeamId,
    playerId: teams.find(team => team.id === match.homeTeamId).players[3].id, minute: 7 });
  return events.sort((a, b) => a.minute - b.minute);
}

const pairs = [[0, 1], [2, 3], [0, 2], [1, 3], [0, 3], [1, 2]];
const scores = [[2, 0], [1, 1], [3, 1], [2, 1], [0, 2], [1, 0]];
const groupMatches = pairs.flatMap(([home, away], round) => groups.map((group, groupIndex) => {
  const order = round * 4 + groupIndex;
  const match = { id: `demo-${group.id}-${round + 1}`, stage: "group", groupId: group.id,
    homeTeamId: group.teamIds[home], awayTeamId: group.teamIds[away], homeScore: scores[round][0] + (round === 0 ? groupIndex % 2 : 0),
    awayScore: scores[round][1], homePenalties: null, awayPenalties: null, status: "finished", kickoff: atTime(order * 12), court: "Boisko 1" };
  return { ...match, events: eventsFor(match, order) };
}));
const groupSource = (groupId, position) => ({ type: "group", groupId, position });
const resultSource = (type, matchId) => ({ type, matchId });
const knockout = (id, stage, minutes, homeSource, awaySource, homeTeamId = null, awayTeamId = null, extra = {}) => ({
  id, stage, groupId: null, homeSource, awaySource, homeTeamId, awayTeamId, homeScore: null, awayScore: null,
  homePenalties: null, awayPenalties: null, status: "scheduled", kickoff: atTime(minutes), court: "Boisko 1", events: [], ...extra,
});
const playoffs = [
  knockout("demo-qf1", "quarterfinal", 300, groupSource("A", 1), groupSource("B", 2), teams[0].id, teams[5].id, { homeScore: 2, awayScore: 1, status: "finished" }),
  knockout("demo-qf2", "quarterfinal", 314, groupSource("B", 1), groupSource("A", 2), teams[4].id, teams[1].id, { homeScore: 1, awayScore: 1, homePenalties: 3, awayPenalties: 2, status: "finished" }),
  knockout("demo-qf3", "quarterfinal", 328, groupSource("C", 1), groupSource("D", 2), teams[8].id, teams[13].id, { homeScore: 1, awayScore: 0, status: "live" }),
  knockout("demo-qf4", "quarterfinal", 342, groupSource("D", 1), groupSource("C", 2)),
  knockout("demo-sf1", "semifinal", 370, resultSource("winner", "demo-qf1"), resultSource("winner", "demo-qf2")),
  knockout("demo-sf2", "semifinal", 386, resultSource("winner", "demo-qf3"), resultSource("winner", "demo-qf4")),
  knockout("demo-third", "third", 408, resultSource("loser", "demo-sf1"), resultSource("loser", "demo-sf2")),
  knockout("demo-final", "final", 425, resultSource("winner", "demo-sf1"), resultSource("winner", "demo-sf2")),
].map((match, index) => ({ ...match, events: ["finished", "live"].includes(match.status) ? eventsFor(match, 24 + index) : [] }));

export const demoTournament = { id: "demo-2025", slug: demoTournamentSlug, name: "Turniej testowy MLPN", date: "2025-12-14", location: "Hala testowa · Halinów", status: "live", isDemo: true,
    description: "Przykładowe drużyny, zawodnicy i wyniki do sprawdzania działania. To symulacja, nie archiwalna edycja turnieju ani lista zgłoszeń na 2026.",
    formatLabel: "16 drużyn · 4 grupy · faza pucharowa", matchMinutes: 10,
    rules: { pointsWin: 3, pointsDraw: 1, advancing: 2, tieBreakers: ["head-to-head", "goal-difference", "goals-for"] },
    groups, teams, matches: [...groupMatches, ...playoffs], rulesConfirmed: false };
