<?php

require_once __DIR__ . '/../../middleware/cors.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../models/Order.php';
require_once __DIR__ . '/../../utils/Response.php';

// PayPal configuration
define('PAYPAL_MODE', 'sandbox'); // Change to 'live' for production

if (PAYPAL_MODE === 'sandbox') {
    define('PAYPAL_CLIENT_ID', 'AV7kpXgErYvZHnzkYNd3U4sf-xW-toyMi1u-UAHYYb9bB8HLbS2BiORDZU5H2YkK_Byz-myElL9pK7g-');
    define('PAYPAL_SECRET', 'EKO_ybdAZK0FSLh2Aq3GzGsneqcVBVxU5a_bhvsXv3mgHeOsFjHJbEeUSwz8lak070k9XynIZgGdns92');
    define('PAYPAL_API_URL', 'https://api-m.sandbox.paypal.com');
} else {
    define('PAYPAL_CLIENT_ID', 'AXvswzslLf5AkJt5opS8QXLBit74g5blW-1Wvzbqu6jCVAjxEGIbv07-lz1a76gg5XtokHAl1nuP2B81');
    define('PAYPAL_SECRET', 'YOUR_LIVE_SECRET_HERE'); // To be provided
    define('PAYPAL_API_URL', 'https://api-m.paypal.com');
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method !== 'POST') {
    Response::error('Method not allowed', 405);
}

try {
    $user = authenticate();
    $data = json_decode(file_get_contents('php://input'), true);
    
    $amount = $data['amount'] ?? null;
    $currency = $data['currency'] ?? 'EUR';
    
    if (!$amount || $amount <= 0) {
        Response::error('Invalid amount', 400);
    }
    
    // Get PayPal access token
    $ch = curl_init(PAYPAL_API_URL . '/v1/oauth2/token');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_USERPWD, PAYPAL_CLIENT_ID . ':' . PAYPAL_SECRET);
    curl_setopt($ch, CURLOPT_POSTFIELDS, 'grant_type=client_credentials');
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    if ($httpCode !== 200) {
        Response::error('Failed to authenticate with PayPal', 500);
    }
    
    $tokenData = json_decode($response, true);
    $accessToken = $tokenData['access_token'];
    
    // Create order in our database
    $orderModel = new Order();
    $orderId = $orderModel->create($user['user_id'], $amount, 'paypal');
    
    // Create PayPal order
    $orderData = [
        'intent' => 'CAPTURE',
        'purchase_units' => [[
            'reference_id' => $orderId,
            'amount' => [
                'currency_code' => $currency,
                'value' => number_format($amount, 2, '.', '')
            ],
            'description' => 'Nowlover Order #' . $orderId
        ]],
        'application_context' => [
            'return_url' => 'https://arnowconcept.com/checkout/success',
            'cancel_url' => 'https://arnowconcept.com/checkout/cancel'
        ]
    ];
    
    $ch = curl_init(PAYPAL_API_URL . '/v2/checkout/orders');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Authorization: Bearer ' . $accessToken
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($orderData));
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    if ($httpCode !== 201) {
        Response::error('Failed to create PayPal order', 500);
    }
    
    $paypalOrder = json_decode($response, true);
    
    // Update our order with PayPal order ID
    $db = Database::getInstance();
    $db->query(
        "UPDATE orders SET payment_id = ?, payment_provider = 'paypal' WHERE id = ?",
        [$paypalOrder['id'], $orderId]
    );
    
    // Get approval URL
    $approvalUrl = null;
    foreach ($paypalOrder['links'] as $link) {
        if ($link['rel'] === 'approve') {
            $approvalUrl = $link['href'];
            break;
        }
    }
    
    Response::success([
        'order_id' => $orderId,
        'paypal_order_id' => $paypalOrder['id'],
        'approval_url' => $approvalUrl
    ]);
    
} catch (Exception $e) {
    Response::serverError($e->getMessage());
}
