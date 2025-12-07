<?php

require_once __DIR__ . '/../../middleware/cors.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../models/Order.php';
require_once __DIR__ . '/../../utils/Response.php';

// Paystack configuration
define('PAYSTACK_MODE', 'sandbox'); // Change to 'live' for production

if (PAYSTACK_MODE === 'sandbox') {
    define('PAYSTACK_PUBLIC_KEY', 'pk_test_dbc05099f0b45babd6e11ccaaa8d6f8b36755990');
    define('PAYSTACK_SECRET_KEY', 'sk_test_5f79120f4146ba60fc5c8782f5631dba65d8778d');
} else {
    define('PAYSTACK_PUBLIC_KEY', 'pk_live_90f58d3f14be1af90fc5d3d8e9884d8c637fa918');
    define('PAYSTACK_SECRET_KEY', 'sk_live_bac439f8efd73af9e24a6ddf8488dba7702fb51a');
}

define('PAYSTACK_API_URL', 'https://api.paystack.co');

$method = $_SERVER['REQUEST_METHOD'];

if ($method !== 'POST') {
    Response::error('Method not allowed', 405);
}

try {
    $user = authenticate();
    $data = json_decode(file_get_contents('php://input'), true);
    
    $amount = $data['amount'] ?? null;
    $email = $data['email'] ?? $user['email'];
    
    if (!$amount || $amount <= 0) {
        Response::error('Invalid amount', 400);
    }
    
    // Create order in our database
    $orderModel = new Order();
    $orderId = $orderModel->create($user['user_id'], $amount, 'paystack');
    
    // Paystack expects amount in kobo (multiply by 100)
    $amountInKobo = $amount * 100;
    
    // Initialize Paystack transaction
    $initData = [
        'email' => $email,
        'amount' => $amountInKobo,
        'reference' => $orderId,
        'callback_url' => 'https://arnowconcept.com/checkout/success',
        'metadata' => [
            'order_id' => $orderId,
            'user_id' => $user['user_id']
        ]
    ];
    
    $ch = curl_init(PAYSTACK_API_URL . '/transaction/initialize');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Authorization: Bearer ' . PAYSTACK_SECRET_KEY
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($initData));
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    if ($httpCode !== 200) {
        Response::error('Failed to initialize Paystack transaction', 500);
    }
    
    $paystackResponse = json_decode($response, true);
    
    if (!$paystackResponse['status']) {
        Response::error($paystackResponse['message'] ?? 'Failed to initialize payment', 500);
    }
    
    // Update our order with Paystack reference
    $db = Database::getInstance();
    $db->query(
        "UPDATE orders SET payment_id = ?, payment_provider = 'paystack' WHERE id = ?",
        [$paystackResponse['data']['reference'], $orderId]
    );
    
    Response::success([
        'order_id' => $orderId,
        'authorization_url' => $paystackResponse['data']['authorization_url'],
        'access_code' => $paystackResponse['data']['access_code'],
        'reference' => $paystackResponse['data']['reference']
    ]);
    
} catch (Exception $e) {
    Response::serverError($e->getMessage());
}
