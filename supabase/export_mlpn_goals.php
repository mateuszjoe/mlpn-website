<?php
/**
 * MLPN - Eksport danych JoomSport z WordPress
 *
 * Użycie:
 *   ?token=mlpn2025export&mode=tables   → lista tabel JoomSport + struktura
 *   ?token=mlpn2025export&mode=export   → pełny eksport danych (JSON)
 *
 * WAŻNE: Usuń ten plik z serwera po użyciu!
 */

// === Zabezpieczenie tokenem ===
$SECRET_TOKEN = 'mlpn2025export';

if (!isset($_GET['token']) || $_GET['token'] !== $SECRET_TOKEN) {
    http_response_code(403);
    die('Brak dostepu');
}

$mode = isset($_GET['mode']) ? $_GET['mode'] : 'tables';

// === Połączenie z bazą WordPress ===
// Wczytaj wp-config.php żeby pobrać dane logowania do bazy
$wp_config = dirname(__FILE__) . '/wp-config.php';
if (!file_exists($wp_config)) {
    // Spróbuj w katalogu wyżej
    $wp_config = dirname(dirname(__FILE__)) . '/wp-config.php';
}
if (!file_exists($wp_config)) {
    die(json_encode(['error' => 'Nie znaleziono wp-config.php']));
}

// Wyciągnij dane logowania z wp-config.php
$config_content = file_get_contents($wp_config);

function extract_wp_define($content, $name) {
    if (preg_match("/define\s*\(\s*['\"]" . $name . "['\"]\s*,\s*['\"]([^'\"]*)['\"]/" , $content, $m)) {
        return $m[1];
    }
    return null;
}

$db_name = extract_wp_define($config_content, 'DB_NAME');
$db_user = extract_wp_define($config_content, 'DB_USER');
$db_pass = extract_wp_define($config_content, 'DB_PASSWORD');
$db_host = extract_wp_define($config_content, 'DB_HOST');

// Wyciągnij prefix tabel
$table_prefix = 'wp_';
if (preg_match('/\$table_prefix\s*=\s*[\'"]([^\'"]*)[\'"]/', $config_content, $m)) {
    $table_prefix = $m[1];
}

if (!$db_name || !$db_user) {
    die(json_encode(['error' => 'Nie udalo sie odczytac danych z wp-config.php']));
}

// Połącz z bazą
$conn = new mysqli($db_host, $db_user, $db_pass, $db_name);
if ($conn->connect_error) {
    die(json_encode(['error' => 'Blad polaczenia: ' . $conn->connect_error]));
}
$conn->set_charset('utf8mb4');

header('Content-Type: application/json; charset=utf-8');

// ============================================
// TRYB: DISCOVERY — lista tabel + struktura
// ============================================
if ($mode === 'tables') {
    $result = [];

    // Znajdź wszystkie tabele joomsport
    $tables_query = $conn->query("SHOW TABLES LIKE '%joomsport%'");
    $tables = [];
    while ($row = $tables_query->fetch_row()) {
        $tables[] = $row[0];
    }
    $result['joomsport_tables'] = $tables;
    $result['table_prefix'] = $table_prefix;
    $result['tables_count'] = count($tables);

    // Dla każdej tabeli pokaż kolumny + liczbę wierszy
    $result['table_details'] = [];
    foreach ($tables as $table) {
        $detail = ['name' => $table, 'columns' => [], 'row_count' => 0];

        // Kolumny
        $cols = $conn->query("DESCRIBE `$table`");
        while ($col = $cols->fetch_assoc()) {
            $detail['columns'][] = [
                'name' => $col['Field'],
                'type' => $col['Type'],
                'key' => $col['Key']
            ];
        }

        // Liczba wierszy
        $count = $conn->query("SELECT COUNT(*) as c FROM `$table`");
        if ($count) {
            $detail['row_count'] = $count->fetch_assoc()['c'];
        }

        $result['table_details'][] = $detail;
    }

    // Pokaż też próbkę z kluczowych tabel (jeśli istnieją)
    $sample_tables = [
        $table_prefix . 'joomsport_match_events',
        $table_prefix . 'joomsport_match_event_types',
        $table_prefix . 'joomsport_seasons'
    ];

    $result['samples'] = [];
    foreach ($sample_tables as $st) {
        if (in_array($st, $tables)) {
            $sample = $conn->query("SELECT * FROM `$st` LIMIT 5");
            $rows = [];
            while ($row = $sample->fetch_assoc()) {
                $rows[] = $row;
            }
            $result['samples'][$st] = $rows;
        }
    }

    echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
}

// ============================================
// TRYB: EXPORT — pełny eksport danych
// ============================================
elseif ($mode === 'export') {
    $result = ['exported_at' => date('Y-m-d H:i:s'), 'data' => []];

    // 1. Zdarzenia meczowe (bramki, kartki)
    $events_table = $table_prefix . 'joomsport_match_events';
    $events_query = $conn->query("SELECT * FROM `$events_table`");
    $events = [];
    if ($events_query) {
        while ($row = $events_query->fetch_assoc()) {
            $events[] = $row;
        }
    }
    $result['data']['match_events'] = $events;
    $result['data']['match_events_count'] = count($events);

    // 2. Typy zdarzeń (żeby wiedzieć co jest bramką, co kartką)
    $event_types_table = $table_prefix . 'joomsport_match_event_types';
    $types_query = $conn->query("SELECT * FROM `$event_types_table`");
    $types = [];
    if ($types_query) {
        while ($row = $types_query->fetch_assoc()) {
            $types[] = $row;
        }
    }
    $result['data']['event_types'] = $types;

    // 3. Mecze — z WordPress posts (JoomSport matches to custom post type)
    //    Szukamy postów typu 'joomsport_match' lub podobnego
    $matches_query = $conn->query("
        SELECT p.ID, p.post_title, p.post_date, p.post_status,
               p.post_name, p.post_parent
        FROM `{$table_prefix}posts` p
        WHERE p.post_type LIKE '%match%'
          AND p.post_status IN ('publish', 'private', 'draft')
        ORDER BY p.post_date
    ");
    $matches = [];
    if ($matches_query) {
        while ($row = $matches_query->fetch_assoc()) {
            $matches[] = $row;
        }
    }
    $result['data']['matches'] = $matches;
    $result['data']['matches_count'] = count($matches);

    // 4. Meta danych meczów (drużyny, wynik)
    if (count($matches) > 0) {
        $match_ids = array_map(function($m) { return $m['ID']; }, $matches);
        $ids_str = implode(',', $match_ids);

        $meta_query = $conn->query("
            SELECT post_id, meta_key, meta_value
            FROM `{$table_prefix}postmeta`
            WHERE post_id IN ($ids_str)
              AND meta_key IN (
                '_joomsport_team1', '_joomsport_team2',
                '_joomsport_score1', '_joomsport_score2',
                '_joomsport_matchday', '_joomsport_matchdate',
                '_joomsport_season', '_joomsport_league',
                '_joomsport_round', '_joomsport_matchevents'
              )
        ");
        $meta = [];
        if ($meta_query) {
            while ($row = $meta_query->fetch_assoc()) {
                $meta[] = $row;
            }
        }
        $result['data']['match_meta'] = $meta;
        $result['data']['match_meta_count'] = count($meta);
    }

    // 5. Drużyny (custom post type)
    $teams_query = $conn->query("
        SELECT p.ID, p.post_title, p.post_name
        FROM `{$table_prefix}posts` p
        WHERE p.post_type LIKE '%team%'
          AND p.post_status IN ('publish', 'private', 'draft')
    ");
    $teams = [];
    if ($teams_query) {
        while ($row = $teams_query->fetch_assoc()) {
            $teams[] = $row;
        }
    }
    $result['data']['teams'] = $teams;
    $result['data']['teams_count'] = count($teams);

    // 6. Gracze (custom post type)
    $players_query = $conn->query("
        SELECT p.ID, p.post_title, p.post_name
        FROM `{$table_prefix}posts` p
        WHERE p.post_type LIKE '%player%'
          AND p.post_status IN ('publish', 'private', 'draft')
    ");
    $players = [];
    if ($players_query) {
        while ($row = $players_query->fetch_assoc()) {
            $players[] = $row;
        }
    }
    $result['data']['players'] = $players;
    $result['data']['players_count'] = count($players);

    // 7. Sezony JoomSport (jeśli istnieje tabela)
    $seasons_table = $table_prefix . 'joomsport_seasons';
    $seasons_query = $conn->query("SELECT * FROM `$seasons_table`");
    $seasons = [];
    if ($seasons_query) {
        while ($row = $seasons_query->fetch_assoc()) {
            $seasons[] = $row;
        }
    }
    $result['data']['seasons'] = $seasons;

    echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
}

else {
    echo json_encode(['error' => 'Nieznany tryb. Uzyj mode=tables lub mode=export']);
}

$conn->close();
?>
