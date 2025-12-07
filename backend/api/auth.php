<?php

require_once __DIR__ . '/../middleware/cors.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../models/Member.php';
require_once __DIR__ . '/../utils/JWT.php';
require_once __DIR__ . '/../utils/Response.php';
require_once __DIR__ . '/../utils/UUID.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $action = $_GET['action'] ?? 'login';
    
    try {
        $userModel = new User();
        
        if ($action === 'register') {
            // Registration
            $email = $data['email'] ?? null;
            $password = $data['password'] ?? null;
            $phone = $data['phone'] ?? null;
            $localityId = $data['locality_id'] ?? null;
            
            if (!$email || !$password) {
                Response::error('Email and password are required', 400);
            }
            
            // Check if user already exists
            $existing = $userModel->findByEmail($email);
            if ($existing) {
                Response::error('User already exists', 400);
            }
            
            // Create user
            $userId = $userModel->create($email, $password);
            
            // Generate member code
            $db = Database::getInstance();
            
            // Get locality info
            if ($localityId) {
                $stmt = $db->query("SELECT code_prefix, member_count FROM localities WHERE id = ?", [$localityId]);
                $locality = $stmt->fetch();
                
                if ($locality) {
                    $code = $locality['code_prefix'] . str_pad($locality['member_count'] + 1, 5, '0', STR_PAD_LEFT);
                    
                    // Update locality member count
                    $db->query("UPDATE localities SET member_count = member_count + 1 WHERE id = ?", [$localityId]);
                } else {
                    $code = 'NOW' . str_pad(rand(1, 99999), 5, '0', STR_PAD_LEFT);
                }
            } else {
                $code = 'NOW' . str_pad(rand(1, 99999), 5, '0', STR_PAD_LEFT);
            }
            
            // Generate referral code
            $referralCode = strtoupper(substr(md5($userId . time()), 0, 8));
            
            // Create member record
            $memberModel = new Member();
            $memberModel->create($userId, $email, $phone, $localityId, $code);
            
            // Update member with referral code
            $memberModel->update($userId, ['referral_code' => $referralCode]);
            
            // Get default membership level (Bronze)
            $stmt = $db->query("SELECT id FROM membership_levels WHERE name = 'Bronze' LIMIT 1");
            $level = $stmt->fetch();
            if ($level) {
                $memberModel->update($userId, ['membership_level_id' => $level['id']]);
            }
            
            // Generate JWT token
            $token = JWT::encode([
                'user_id' => $userId,
                'email' => $email,
                'is_admin' => false
            ]);
            
            Response::success([
                'token' => $token,
                'user' => [
                    'id' => $userId,
                    'email' => $email,
                    'code' => $code
                ]
            ], 'Registration successful');
            
        } else {
            // Login
            $email = $data['email'] ?? null;
            $password = $data['password'] ?? null;
            
            if (!$email || !$password) {
                Response::error('Email and password are required', 400);
            }
            
            $user = $userModel->findByEmail($email);
            
            if (!$user || !$userModel->verifyPassword($password, $user['password'])) {
                Response::error('Invalid credentials', 401);
            }
            
            // Check if admin
            $isAdmin = $userModel->isAdmin($user['id']);
            
            // Generate JWT token
            $token = JWT::encode([
                'user_id' => $user['id'],
                'email' => $user['email'],
                'is_admin' => $isAdmin
            ]);
            
            Response::success([
                'token' => $token,
                'user' => [
                    'id' => $user['id'],
                    'email' => $user['email'],
                    'is_admin' => $isAdmin
                ]
            ], 'Login successful');
        }
        
    } catch (Exception $e) {
        Response::serverError($e->getMessage());
    }
    
} else if ($method === 'GET') {
    // Get current user info
    require_once __DIR__ . '/../middleware/auth.php';
    
    try {
        $user = authenticate();
        
        $userModel = new User();
        $memberModel = new Member();
        
        $userInfo = $userModel->findById($user['user_id']);
        $memberInfo = $memberModel->findById($user['user_id']);
        
        Response::success([
            'user' => [
                'id' => $userInfo['id'],
                'email' => $userInfo['email'],
                'is_admin' => $user['is_admin'] ?? false
            ],
            'member' => $memberInfo
        ]);
        
    } catch (Exception $e) {
        Response::unauthorized($e->getMessage());
    }
    
} else {
    Response::error('Method not allowed', 405);
}
