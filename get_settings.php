<?php
header('Content-Type: application/json');
require_once 'class.Database.php';

try {
    $database = new Database();
    $db = $database->getConnection();

    if (!$db) {
        echo json_encode(['error' => 'Database connection failed']);
        exit;
    }

    $stmt = $db->query("SELECT setting_key, setting_value FROM site_settings");
    $settings = [];
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $settings[$row['setting_key']] = $row['setting_value'];
    }

    echo json_encode($settings);
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
