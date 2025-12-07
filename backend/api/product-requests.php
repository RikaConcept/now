<?php

require_once __DIR__ . '/../middleware/cors.php';
require_once __DIR__ . '/../middleware/auth.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/Response.php';
require_once __DIR__ . '/../utils/UUID.php';

$method = $_SERVER['REQUEST_METHOD'];

try {
    if ($method === 'POST') {
        // Create product request (public or authenticated)
        $data = json_decode(file_get_contents('php://input'), true);
        
        $email = $data['email'] ?? null;
        $phone = $data['phone'] ?? null;
        $productName = $data['product_name'] ?? null;
        $bestPriceFound = $data['best_price_found'] ?? null;
        $priceSource = $data['price_source'] ?? null;
        $userBudget = $data['user_budget'] ?? null;
        $isMember = $data['is_member'] ?? false;
        $marginDonation = $data['margin_donation'] ?? null;
        $imageUrl = $data['image_url'] ?? null;
        
        if (!$email || !$productName || !$bestPriceFound || !$priceSource || !$userBudget) {
            Response::error('Required fields missing', 400);
        }
        
        $userId = null;
        try {
            $user = authenticate();
            $userId = $user['user_id'];
        } catch (Exception $e) {
            // Anonymous user
        }
        
        $id = UUID::v4();
        $db = Database::getInstance();
        
        $sql = "INSERT INTO product_requests (id, user_id, email, phone, product_name, best_price_found, price_source, user_budget, is_member, margin_donation, image_url, status, created_at, updated_at) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', NOW(), NOW())";
        
        $db->query($sql, [
            $id,
            $userId,
            $email,
            $phone,
            $productName,
            $bestPriceFound,
            $priceSource,
            $userBudget,
            $isMember ? 1 : 0,
            $marginDonation,
            $imageUrl
        ]);
        
        Response::success(['id' => $id], 'Product request submitted successfully', 201);
        
    } else if ($method === 'GET') {
        // Get product requests
        $user = authenticate();
        $db = Database::getInstance();
        
        if ($user['is_admin'] ?? false) {
            // Admin: Get all requests
            $sql = "SELECT * FROM product_requests ORDER BY created_at DESC LIMIT 100";
            $stmt = $db->query($sql);
        } else {
            // User: Get own requests
            $sql = "SELECT * FROM product_requests WHERE user_id = ? ORDER BY created_at DESC";
            $stmt = $db->query($sql, [$user['user_id']]);
        }
        
        $requests = $stmt->fetchAll();
        Response::success($requests);
        
    } else if ($method === 'PUT') {
        // Update product request (admin only)
        requireAdmin();
        
        $id = $_GET['id'] ?? null;
        if (!$id) {
            Response::error('Request ID is required', 400);
        }
        
        $data = json_decode(file_get_contents('php://input'), true);
        $status = $data['status'] ?? null;
        
        if (!$status || !in_array($status, ['pending', 'processing', 'completed', 'cancelled'])) {
            Response::error('Valid status is required', 400);
        }
        
        $db = Database::getInstance();
        $sql = "UPDATE product_requests SET status = ?, updated_at = NOW() WHERE id = ?";
        $db->query($sql, [$status, $id]);
        
        Response::success(null, 'Product request updated successfully');
        
    } else {
        Response::error('Method not allowed', 405);
    }
    
} catch (Exception $e) {
    Response::serverError($e->getMessage());
}
