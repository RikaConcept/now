<?php

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../models/Order.php';
require_once __DIR__ . '/../../models/Member.php';

// PayPal Webhook Handler

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

if ($method !== 'POST') {
    http_response_code(405);
    exit();
}

// Get webhook data
$webhookData = json_decode(file_get_contents('php://input'), true);

// Log webhook for debugging
error_log('PayPal Webhook: ' . json_encode($webhookData));

try {
    $eventType = $webhookData['event_type'] ?? null;
    
    // Handle order approval/capture
    if ($eventType === 'CHECKOUT.ORDER.APPROVED' || $eventType === 'PAYMENT.CAPTURE.COMPLETED') {
        $resource = $webhookData['resource'] ?? null;
        
        if (!$resource) {
            http_response_code(400);
            exit();
        }
        
        // Get order ID from purchase units
        $purchaseUnits = $resource['purchase_units'] ?? [];
        if (empty($purchaseUnits)) {
            http_response_code(400);
            exit();
        }
        
        $referenceId = $purchaseUnits[0]['reference_id'] ?? null;
        
        if (!$referenceId) {
            http_response_code(400);
            exit();
        }
        
        // Update order status
        $orderModel = new Order();
        $order = $orderModel->findById($referenceId);
        
        if (!$order) {
            error_log('Order not found: ' . $referenceId);
            http_response_code(404);
            exit();
        }
        
        // Update order to paid
        $orderModel->updateStatus($referenceId, 'paid');
        
        // Update member's total spent and activate if pending
        $memberModel = new Member();
        $memberModel->updateTotalSpent($order['member_id'], $order['amount']);
        
        $member = $memberModel->findById($order['member_id']);
        if ($member['status'] === 'pending') {
            $memberModel->update($order['member_id'], [
                'status' => 'active',
                'activated_at' => date('Y-m-d H:i:s')
            ]);
        }
        
        // TODO: Send confirmation email/notification
        
        http_response_code(200);
        echo json_encode(['success' => true]);
    } else {
        // Other webhook events
        http_response_code(200);
        echo json_encode(['success' => true, 'message' => 'Event received']);
    }
    
} catch (Exception $e) {
    error_log('PayPal Webhook Error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
