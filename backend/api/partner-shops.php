<?php

require_once __DIR__ . '/../middleware/cors.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/Response.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    try {
        $db = Database::getInstance();
        
        $sql = "SELECT * FROM partner_shops WHERE is_active = 1 ORDER BY name ASC";
        $stmt = $db->query($sql);
        $shops = $stmt->fetchAll();
        
        // Convert numeric strings to numbers
        foreach ($shops as &$shop) {
            $shop['discount_percentage'] = floatval($shop['discount_percentage']);
            $shop['is_active'] = (bool)$shop['is_active'];
        }
        
        Response::success($shops);
        
    } catch (Exception $e) {
        Response::serverError($e->getMessage());
    }
} else {
    Response::error('Method not allowed', 405);
}
