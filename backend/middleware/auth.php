<?php

require_once __DIR__ . '/../utils/JWT.php';
require_once __DIR__ . '/../utils/Response.php';

function authenticate() {
    $headers = getallheaders();
    
    if (!isset($headers['Authorization'])) {
        Response::unauthorized('No authorization token provided');
    }
    
    $authHeader = $headers['Authorization'];
    
    if (!preg_match('/Bearer\s+(\S+)/', $authHeader, $matches)) {
        Response::unauthorized('Invalid authorization header format');
    }
    
    $token = $matches[1];
    
    try {
        $payload = JWT::decode($token);
        return $payload;
    } catch (Exception $e) {
        Response::unauthorized('Invalid or expired token: ' . $e->getMessage());
    }
}

function requireAdmin() {
    $user = authenticate();
    
    if (!isset($user['is_admin']) || !$user['is_admin']) {
        Response::forbidden('Admin access required');
    }
    
    return $user;
}
