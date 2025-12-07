<?php

require_once __DIR__ . '/../middleware/cors.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/Response.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    try {
        $db = Database::getInstance();
        
        $sql = "SELECT * FROM membership_levels WHERE is_active = 1 ORDER BY `order` ASC";
        $stmt = $db->query($sql);
        $levels = $stmt->fetchAll();
        
        Response::success($levels);
        
    } catch (Exception $e) {
        Response::serverError($e->getMessage());
    }
} else {
    Response::error('Method not allowed', 405);
}
