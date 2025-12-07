<?php

require_once __DIR__ . '/../middleware/cors.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/Response.php';

$method = $_SERVER['REQUEST_METHOD'];

try {
    $db = Database::getInstance();
    
    if ($method === 'GET') {
        // Get all site settings
        $sql = "SELECT * FROM site_settings ORDER BY setting_key ASC";
        $stmt = $db->query($sql);
        $settings = $stmt->fetchAll();
        
        // Convert to key-value pairs
        $settingsMap = [];
        foreach ($settings as $setting) {
            $settingsMap[$setting['setting_key']] = $setting['setting_value'];
        }
        
        Response::success($settingsMap);
        
    } else if ($method === 'POST' || $method === 'PUT') {
        // Update site settings (admin only)
        require_once __DIR__ . '/../middleware/auth.php';
        requireAdmin();
        
        $data = json_decode(file_get_contents('php://input'), true);
        
        foreach ($data as $key => $value) {
            $id = UUID::v4();
            $sql = "INSERT INTO site_settings (id, setting_key, setting_value, updated_at) 
                    VALUES (?, ?, ?, NOW()) 
                    ON DUPLICATE KEY UPDATE setting_value = ?, updated_at = NOW()";
            $db->query($sql, [$id, $key, $value, $value]);
        }
        
        Response::success(null, 'Settings updated successfully');
        
    } else {
        Response::error('Method not allowed', 405);
    }
    
} catch (Exception $e) {
    Response::serverError($e->getMessage());
}
