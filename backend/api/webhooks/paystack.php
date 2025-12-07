<?php

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../models/Order.php';
require_once __DIR__ . '/../../models/Member.php';

// Paystack Webhook Handler

// Paystack secret key for webhook verification
define('PAYSTACK_MODE', 'sandbox'); // Change to 'live' for production

if (PAYSTACK_MODE === 'sandbox') {
    define('PAYSTACK_SECRET_KEY', 'sk_test_5f79120f4146ba60fc5c8782f5631dba65d8778d');
} else {
    define('PAYSTACK_SECRET_KEY', 'sk_live_bac439f8efd73af9e24a6ddf8488dba7702fb51a');
}

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

if ($method !== 'POST') {
    http_response_code(405);
    exit();
}

// Verify Paystack signature
$input = file_get_contents('php://input');
$signature = $_SERVER['HTTP_X_PAYSTACK_SIGNATURE'] ?? '';

if ($signature !== hash_hmac('sha512', $input, PAYSTACK_SECRET_KEY)) {
    error_log('Invalid Paystack signature');
    http_response_code(401);
    exit();
}

// Get webhook data
$webhookData = json_decode($input, true);

// Log webhook for debugging
error_log('Paystack Webhook: ' . json_encode($webhookData));

try {
    $event = $webhookData['event'] ?? null;
    
    // Handle successful payment
    if ($event === 'charge.success') {
        $data = $webhookData['data'] ?? null;
        
        if (!$data) {
            http_response_code(400);
            exit();
        }
        
        $reference = $data['reference'] ?? null;
        $status = $data['status'] ?? null;
        
        if (!$reference || $status !== 'success') {
            http_response_code(400);
            exit();
        }
        
        // Update order status
        $orderModel = new Order();
        $order = $orderModel->findById($reference);
        
        if (!$order) {
            error_log('Order not found: ' . $reference);
            http_response_code(404);
            exit();
        }
        
        // Check if already processed
        if ($order['status'] === 'paid') {
            http_response_code(200);
            echo json_encode(['success' => true, 'message' => 'Already processed']);
            exit();
        }
        
        // Update order to paid
        $orderModel->updateStatus($reference, 'paid');
        
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
    error_log('Paystack Webhook Error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
