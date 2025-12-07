<?php

require_once __DIR__ . '/../../middleware/cors.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../utils/Response.php';

// Admin dashboard endpoint

try {
    $admin = requireAdmin();
    $db = Database::getInstance();
    
    $method = $_SERVER['REQUEST_METHOD'];
    $action = $_GET['action'] ?? 'stats';
    
    if ($method === 'GET') {
        if ($action === 'stats') {
            // Get dashboard statistics
            
            // Total members
            $stmt = $db->query("SELECT COUNT(*) as total FROM members");
            $totalMembers = $stmt->fetch()['total'];
            
            // Active members
            $stmt = $db->query("SELECT COUNT(*) as total FROM members WHERE status = 'active'");
            $activeMembers = $stmt->fetch()['total'];
            
            // Total orders
            $stmt = $db->query("SELECT COUNT(*) as total, SUM(amount) as revenue FROM orders WHERE status = 'paid'");
            $ordersData = $stmt->fetch();
            
            // Product requests
            $stmt = $db->query("SELECT COUNT(*) as total FROM product_requests WHERE status = 'pending'");
            $pendingRequests = $stmt->fetch()['total'];
            
            // Recent members
            $stmt = $db->query("SELECT m.*, l.name as locality_name FROM members m LEFT JOIN localities l ON m.locality_id = l.id ORDER BY m.created_at DESC LIMIT 10");
            $recentMembers = $stmt->fetchAll();
            
            Response::success([
                'total_members' => $totalMembers,
                'active_members' => $activeMembers,
                'total_orders' => $ordersData['total'],
                'total_revenue' => $ordersData['revenue'] ?? 0,
                'pending_requests' => $pendingRequests,
                'recent_members' => $recentMembers
            ]);
            
        } else if ($action === 'members') {
            // Get all members with filters
            $status = $_GET['status'] ?? null;
            $search = $_GET['search'] ?? null;
            $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 50;
            $offset = isset($_GET['offset']) ? (int)$_GET['offset'] : 0;
            
            $sql = "SELECT m.*, ml.name as level_name, l.name as locality_name 
                    FROM members m 
                    LEFT JOIN membership_levels ml ON m.membership_level_id = ml.id 
                    LEFT JOIN localities l ON m.locality_id = l.id 
                    WHERE 1=1";
            $params = [];
            
            if ($status) {
                $sql .= " AND m.status = ?";
                $params[] = $status;
            }
            
            if ($search) {
                $sql .= " AND (m.email LIKE ? OR m.code LIKE ?)";
                $params[] = "%$search%";
                $params[] = "%$search%";
            }
            
            $sql .= " ORDER BY m.created_at DESC LIMIT ? OFFSET ?";
            $params[] = $limit;
            $params[] = $offset;
            
            $stmt = $db->query($sql, $params);
            $members = $stmt->fetchAll();
            
            Response::success($members);
            
        } else if ($action === 'orders') {
            // Get all orders
            $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 50;
            $offset = isset($_GET['offset']) ? (int)$_GET['offset'] : 0;
            
            $sql = "SELECT o.*, m.email as member_email, m.code as member_code 
                    FROM orders o 
                    LEFT JOIN members m ON o.member_id = m.id 
                    ORDER BY o.created_at DESC 
                    LIMIT ? OFFSET ?";
            
            $stmt = $db->query($sql, [$limit, $offset]);
            $orders = $stmt->fetchAll();
            
            Response::success($orders);
            
        } else if ($action === 'product-requests') {
            // Get product requests
            $status = $_GET['status'] ?? null;
            $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 50;
            $offset = isset($_GET['offset']) ? (int)$_GET['offset'] : 0;
            
            $sql = "SELECT * FROM product_requests WHERE 1=1";
            $params = [];
            
            if ($status) {
                $sql .= " AND status = ?";
                $params[] = $status;
            }
            
            $sql .= " ORDER BY created_at DESC LIMIT ? OFFSET ?";
            $params[] = $limit;
            $params[] = $offset;
            
            $stmt = $db->query($sql, $params);
            $requests = $stmt->fetchAll();
            
            Response::success($requests);
        }
    }
    
} catch (Exception $e) {
    Response::serverError($e->getMessage());
}
