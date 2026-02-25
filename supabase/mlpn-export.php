<?php
/**
 * Plugin Name: MLPN Export
 * Description: Eksport danych JoomSport (bramki, mecze) do JSON
 * Version: 1.0
 *
 * To jest mu-plugin — wrzuć do wp-content/mu-plugins/
 * Po użyciu USUŃ z serwera!
 */

// Dodaj stronę w panelu admina
add_action('admin_menu', function() {
    add_management_page(
        'MLPN Export',
        'MLPN Export',
        'manage_options',
        'mlpn-export',
        'mlpn_export_page'
    );
});

function mlpn_export_page() {
    global $wpdb;

    $mode = isset($_GET['export_mode']) ? $_GET['export_mode'] : 'info';

    echo '<div class="wrap">';
    echo '<h1>MLPN Export - Eksport danych JoomSport</h1>';

    // === Nawigacja ===
    echo '<h2 class="nav-tab-wrapper">';
    $tabs = ['info' => 'Info', 'tables' => 'Tabele JoomSport', 'export' => 'Eksport JSON'];
    foreach ($tabs as $key => $label) {
        $active = ($mode === $key) ? ' nav-tab-active' : '';
        echo '<a class="nav-tab' . $active . '" href="?page=mlpn-export&export_mode=' . $key . '">' . $label . '</a>';
    }
    echo '</h2>';

    // =============================================
    // TRYB: INFO
    // =============================================
    if ($mode === 'info') {
        echo '<div class="card" style="max-width:800px;padding:20px;margin-top:20px">';
        echo '<h3>Jak to działa:</h3>';
        echo '<ol>';
        echo '<li><strong>Tabele JoomSport</strong> — pokaże listę tabel w bazie danych i ich strukturę</li>';
        echo '<li><strong>Eksport JSON</strong> — wyeksportuje bramki, mecze, graczy do pliku JSON</li>';
        echo '</ol>';
        echo '<p>Kliknij zakładkę <strong>"Tabele JoomSport"</strong> żeby zacząć.</p>';
        echo '</div>';
    }

    // =============================================
    // TRYB: TABLES — discovery
    // =============================================
    elseif ($mode === 'tables') {
        $prefix = $wpdb->prefix;

        // Znajdź tabele joomsport
        $tables = $wpdb->get_results(
            "SHOW TABLES LIKE '%joomsport%'",
            ARRAY_N
        );

        echo '<div class="card" style="max-width:1200px;padding:20px;margin-top:20px">';
        echo '<h3>Tabele JoomSport (' . count($tables) . ' znalezionych)</h3>';
        echo '<p>Prefix: <code>' . esc_html($prefix) . '</code></p>';

        echo '<table class="widefat striped" style="margin-top:10px">';
        echo '<thead><tr><th>Tabela</th><th>Wiersze</th><th>Kolumny</th></tr></thead><tbody>';

        foreach ($tables as $t) {
            $table_name = $t[0];
            $count = $wpdb->get_var("SELECT COUNT(*) FROM `$table_name`");

            // Kolumny
            $cols = $wpdb->get_results("DESCRIBE `$table_name`", ARRAY_A);
            $col_names = array_map(function($c) { return $c['Field'] . ' (' . $c['Type'] . ')'; }, $cols);

            echo '<tr>';
            echo '<td><strong>' . esc_html($table_name) . '</strong></td>';
            echo '<td>' . intval($count) . '</td>';
            echo '<td style="font-size:12px">' . esc_html(implode(', ', $col_names)) . '</td>';
            echo '</tr>';
        }
        echo '</tbody></table>';

        // Próbki z kluczowych tabel
        $sample_tables = [
            $prefix . 'joomsport_match_events' => 'Zdarzenia meczowe (bramki, kartki)',
            $prefix . 'joomsport_match_event_types' => 'Typy zdarzeń',
            $prefix . 'joomsport_seasons' => 'Sezony'
        ];

        foreach ($sample_tables as $st => $desc) {
            // Sprawdź czy tabela istnieje
            $exists = $wpdb->get_var($wpdb->prepare(
                "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = %s AND table_name = %s",
                DB_NAME, $st
            ));
            if ($exists) {
                $rows = $wpdb->get_results("SELECT * FROM `$st` LIMIT 10", ARRAY_A);
                if ($rows) {
                    echo '<h3 style="margin-top:20px">' . esc_html($desc) . ' — próbka z ' . esc_html($st) . '</h3>';
                    echo '<pre style="background:#f0f0f0;padding:10px;overflow-x:auto;max-height:300px">';
                    echo esc_html(json_encode($rows, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
                    echo '</pre>';
                }
            }
        }

        // Pokaż JSON do skopiowania
        echo '<h3 style="margin-top:20px">Dane do skopiowania (JSON)</h3>';
        echo '<p>Zaznacz tekst poniżej (Ctrl+A w polu), skopiuj (Ctrl+C) i wklej w czacie:</p>';

        $discovery = [
            'prefix' => $prefix,
            'tables' => [],
            'samples' => []
        ];

        foreach ($tables as $t) {
            $table_name = $t[0];
            $count = $wpdb->get_var("SELECT COUNT(*) FROM `$table_name`");
            $cols = $wpdb->get_results("DESCRIBE `$table_name`", ARRAY_A);
            $discovery['tables'][] = [
                'name' => $table_name,
                'rows' => intval($count),
                'columns' => array_map(function($c) { return $c['Field']; }, $cols)
            ];
        }

        foreach ($sample_tables as $st => $desc) {
            $exists = $wpdb->get_var($wpdb->prepare(
                "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = %s AND table_name = %s",
                DB_NAME, $st
            ));
            if ($exists) {
                $rows = $wpdb->get_results("SELECT * FROM `$st` LIMIT 5", ARRAY_A);
                $discovery['samples'][$st] = $rows;
            }
        }

        echo '<textarea style="width:100%;height:300px;font-family:monospace;font-size:12px" readonly onclick="this.select()">';
        echo esc_textarea(json_encode($discovery, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
        echo '</textarea>';

        echo '</div>';
    }

    // =============================================
    // TRYB: EXPORT — pełny eksport JSON
    // =============================================
    elseif ($mode === 'export') {
        $prefix = $wpdb->prefix;

        // Sprawdź czy tabela match_events istnieje
        $events_table = $prefix . 'joomsport_match_events';
        $events_exist = $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = %s AND table_name = %s",
            DB_NAME, $events_table
        ));

        if (!$events_exist) {
            echo '<div class="notice notice-error"><p>Tabela <code>' . esc_html($events_table) . '</code> nie istnieje!</p></div>';
            echo '</div>';
            return;
        }

        // Pobierz wszystkie zdarzenia
        $events = $wpdb->get_results("SELECT * FROM `$events_table`", ARRAY_A);

        // Typy zdarzeń
        $event_types_table = $prefix . 'joomsport_match_event_types';
        $event_types = [];
        $et_exist = $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = %s AND table_name = %s",
            DB_NAME, $event_types_table
        ));
        if ($et_exist) {
            $event_types = $wpdb->get_results("SELECT * FROM `$event_types_table`", ARRAY_A);
        }

        // Mecze (z meta danymi)
        $matches = $wpdb->get_results(
            "SELECT p.ID, p.post_title, p.post_date, p.post_status
             FROM `{$prefix}posts` p
             WHERE p.post_type = 'joomsport_match'
               AND p.post_status IN ('publish', 'private', 'draft')
             ORDER BY p.post_date",
            ARRAY_A
        );

        // Meta danych meczów
        $match_meta = [];
        if ($matches) {
            $match_ids = array_column($matches, 'ID');
            // Podziel na partie po 500
            $chunks = array_chunk($match_ids, 500);
            foreach ($chunks as $chunk) {
                $ids_str = implode(',', array_map('intval', $chunk));
                $meta = $wpdb->get_results(
                    "SELECT post_id, meta_key, meta_value
                     FROM `{$prefix}postmeta`
                     WHERE post_id IN ($ids_str)
                       AND meta_key IN (
                         '_joomsport_home_team', '_joomsport_away_team',
                         '_joomsport_home_score', '_joomsport_away_score',
                         '_joomsport_match_date', '_joomsport_match_time',
                         '_joomsport_seasonid', '_joomsport_groupID',
                         '_joomsport_match_played'
                       )",
                    ARRAY_A
                );
                $match_meta = array_merge($match_meta, $meta);
            }
        }

        // Drużyny
        $teams = $wpdb->get_results(
            "SELECT p.ID, p.post_title
             FROM `{$prefix}posts` p
             WHERE p.post_type = 'joomsport_team'
               AND p.post_status IN ('publish', 'private', 'draft')",
            ARRAY_A
        );

        // Gracze
        $players = $wpdb->get_results(
            "SELECT p.ID, p.post_title
             FROM `{$prefix}posts` p
             WHERE p.post_type = 'joomsport_player'
               AND p.post_status IN ('publish', 'private', 'draft')",
            ARRAY_A
        );

        // Sezony
        $seasons_table = $prefix . 'joomsport_seasons';
        $seasons = [];
        $s_exist = $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = %s AND table_name = %s",
            DB_NAME, $seasons_table
        ));
        if ($s_exist) {
            $seasons = $wpdb->get_results("SELECT * FROM `$seasons_table`", ARRAY_A);
        }

        // Sezony WP (post type)
        $wp_seasons = $wpdb->get_results(
            "SELECT p.ID, p.post_title
             FROM `{$prefix}posts` p
             WHERE p.post_type = 'joomsport_season'
               AND p.post_status IN ('publish', 'private', 'draft')",
            ARRAY_A
        );

        $export = [
            'exported_at' => current_time('Y-m-d H:i:s'),
            'match_events' => $events,
            'match_events_count' => count($events),
            'event_types' => $event_types,
            'matches' => $matches,
            'matches_count' => count($matches),
            'match_meta' => $match_meta,
            'match_meta_count' => count($match_meta),
            'teams' => $teams,
            'teams_count' => count($teams),
            'players' => $players,
            'players_count' => count($players),
            'joomsport_seasons' => $seasons,
            'wp_seasons' => $wp_seasons
        ];

        $json = json_encode($export, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

        echo '<div class="card" style="max-width:1200px;padding:20px;margin-top:20px">';
        echo '<h3>Eksport danych</h3>';

        echo '<table class="widefat" style="margin-bottom:20px">';
        echo '<tr><td>Zdarzenia meczowe</td><td><strong>' . count($events) . '</strong></td></tr>';
        echo '<tr><td>Typy zdarzeń</td><td><strong>' . count($event_types) . '</strong></td></tr>';
        echo '<tr><td>Mecze</td><td><strong>' . count($matches) . '</strong></td></tr>';
        echo '<tr><td>Meta meczów</td><td><strong>' . count($match_meta) . '</strong></td></tr>';
        echo '<tr><td>Drużyny</td><td><strong>' . count($teams) . '</strong></td></tr>';
        echo '<tr><td>Gracze</td><td><strong>' . count($players) . '</strong></td></tr>';
        echo '<tr><td>Rozmiar JSON</td><td><strong>' . number_format(strlen($json) / 1024, 0) . ' KB</strong></td></tr>';
        echo '</table>';

        // Przycisk do pobrania jako plik
        echo '<p><strong>Opcja 1:</strong> Kliknij przycisk żeby pobrać jako plik:</p>';
        echo '<form method="post">';
        wp_nonce_field('mlpn_download', 'mlpn_nonce');
        echo '<input type="hidden" name="mlpn_action" value="download_json">';
        echo '<button type="submit" class="button button-primary button-hero">Pobierz JSON</button>';
        echo '</form>';

        echo '<p style="margin-top:20px"><strong>Opcja 2:</strong> Skopiuj tekst (Ctrl+A w polu, potem Ctrl+C):</p>';
        echo '<textarea style="width:100%;height:400px;font-family:monospace;font-size:11px" readonly onclick="this.select()">';
        echo esc_textarea($json);
        echo '</textarea>';

        echo '</div>';
    }

    echo '</div>';
}

// Obsługa pobierania pliku JSON
add_action('admin_init', function() {
    if (isset($_POST['mlpn_action']) && $_POST['mlpn_action'] === 'download_json') {
        if (!current_user_can('manage_options')) return;
        if (!wp_verify_nonce($_POST['mlpn_nonce'], 'mlpn_download')) return;

        global $wpdb;
        $prefix = $wpdb->prefix;

        // Pobierz dane (identycznie jak w trybie export)
        $events_table = $prefix . 'joomsport_match_events';
        $events = $wpdb->get_results("SELECT * FROM `$events_table`", ARRAY_A);

        $event_types_table = $prefix . 'joomsport_match_event_types';
        $event_types = $wpdb->get_results("SELECT * FROM `$event_types_table`", ARRAY_A);

        $matches = $wpdb->get_results(
            "SELECT p.ID, p.post_title, p.post_date, p.post_status
             FROM `{$prefix}posts` p
             WHERE p.post_type = 'joomsport_match' AND p.post_status IN ('publish','private','draft')
             ORDER BY p.post_date", ARRAY_A
        );

        $match_meta = [];
        if ($matches) {
            $match_ids = array_column($matches, 'ID');
            $chunks = array_chunk($match_ids, 500);
            foreach ($chunks as $chunk) {
                $ids_str = implode(',', array_map('intval', $chunk));
                $meta = $wpdb->get_results(
                    "SELECT post_id, meta_key, meta_value
                     FROM `{$prefix}postmeta`
                     WHERE post_id IN ($ids_str)
                       AND meta_key IN (
                         '_joomsport_home_team','_joomsport_away_team',
                         '_joomsport_home_score','_joomsport_away_score',
                         '_joomsport_match_date','_joomsport_match_time',
                         '_joomsport_seasonid','_joomsport_groupID',
                         '_joomsport_match_played'
                       )", ARRAY_A
                );
                $match_meta = array_merge($match_meta, $meta);
            }
        }

        $teams = $wpdb->get_results(
            "SELECT ID, post_title FROM `{$prefix}posts`
             WHERE post_type='joomsport_team' AND post_status IN ('publish','private','draft')", ARRAY_A
        );

        $players = $wpdb->get_results(
            "SELECT ID, post_title FROM `{$prefix}posts`
             WHERE post_type='joomsport_player' AND post_status IN ('publish','private','draft')", ARRAY_A
        );

        $seasons_table = $prefix . 'joomsport_seasons';
        $seasons = $wpdb->get_results("SELECT * FROM `$seasons_table`", ARRAY_A);

        $wp_seasons = $wpdb->get_results(
            "SELECT ID, post_title FROM `{$prefix}posts`
             WHERE post_type='joomsport_season' AND post_status IN ('publish','private','draft')", ARRAY_A
        );

        $export = [
            'exported_at' => current_time('Y-m-d H:i:s'),
            'match_events' => $events,
            'match_events_count' => count($events),
            'event_types' => $event_types,
            'matches' => $matches,
            'matches_count' => count($matches),
            'match_meta' => $match_meta,
            'match_meta_count' => count($match_meta),
            'teams' => $teams,
            'teams_count' => count($teams),
            'players' => $players,
            'players_count' => count($players),
            'joomsport_seasons' => $seasons,
            'wp_seasons' => $wp_seasons
        ];

        header('Content-Type: application/json; charset=utf-8');
        header('Content-Disposition: attachment; filename="mlpn_joomsport_export.json"');
        echo json_encode($export, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit;
    }
});
?>
