<?php

require_once __DIR__ . '/../middleware/cors.php';
require_once __DIR__ . '/../middleware/auth.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/Order.php';
require_once __DIR__ . '/../models/Member.php';
require_once __DIR__ . '/../utils/Response.php';
require_once __DIR__ . '/../utils/UUID.php';

$method = $_SERVER['REQUEST_METHOD'];

try {
    $user = authenticate();
    $orderModel = new Order();
    
    if ($method === 'GET') {
        $action = $_GET['action'] ?? 'user';
        
        if ($action === 'all' && ($user['is_admin'] ?? false)) {
            // Admin: Get all orders
            $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 100;
            $offset = isset($_GET['offset']) ? (int)$_GET['offset'] : 0;
            
            $orders = $orderModel->getAll($limit, $offset);
            Response::success($orders);
            
        } else if ($action === 'single') {
            // Get single order
            $orderId = $_GET['id'] ?? null;
            if (!$orderId) {
                Response::error('Order ID is required', 400);
            }
            
            $order = $orderModel->findById($orderId);
            if (!$order) {
                Response::notFound('Order not found');
            }
            
            // Check permission
            if ($order['member_id'] !== $user['user_id'] && !($user['is_admin'] ?? false)) {
                Response::forbidden('You do not have permission to view this order');
            }
            
            Response::success($order);
            
        } else {
            // Get user's orders
            $orders = $orderModel->getByMember($user['user_id']);
            Response::success($orders);
        }
        
    } else if ($method === 'POST') {
        // Create order
        $data = json_decode(file_get_contents('php://input'), true);
        
        $amount = $data['amount'] ?? null;
        $paymentMethod = $data['payment_method'] ?? null;
        
        if (!$amount || $amount <= 0) {
            Response::error('Valid amount is required', 400);
        }
        
        $orderId = $orderModel->create($user['user_id'], $amount, $paymentMethod);
        
        Response::success([
            'order_id' => $orderId
        ], 'Order created successfully', 201);
        
    } else if ($method === 'PUT') {
        // Update order status
        $orderId = $_GET['id'] ?? null;
        if (!$orderId) {
            Response::error('Order ID is required', 400);
        }
        
        $data = json_decode(file_get_contents('php://input'), true);
        $status = $data['status'] ?? null;
        
        if (!$status || !in_array($status, ['pending', 'paid', 'cancelled'])) {
            Response::error('Valid status is required', 400);
        }
        
        $order = $orderModel->findById($orderId);
        if (!$order) {
            Response::notFound('Order not found');
        }
        
        // Check permission
        if ($order['member_id'] !== $user['user_id'] && !($user['is_admin'] ?? false)) {
            Response::forbidden('You do not have permission to update this order');
        }
        
        $orderModel->updateStatus($orderId, $status);
        
        // If order is paid, update member's total spent and activate if needed
        if ($status === 'paid') {
            $memberModel = new Member();
            $memberModel->updateTotalSpent($order['member_id'], $order['amount']);
            
            // Check if member should be activated
            $member = $memberModel->findById($order['member_id']);
            if ($member['status'] === 'pending') {
                $memberModel->update($order['member_id'], [
                    'status' => 'active',
                    'activated_at' => date('Y-m-d H:i:s')
                ]);
            }
        }
        
        Response::success(null, 'Order updated successfully');
        
    } else {
        Response::error('Method not allowed', 405);
    }
    
} catch (Exception $e) {
    Response::serverError($e->getMessage());
}
