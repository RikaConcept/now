<?php

require_once __DIR__ . '/../middleware/cors.php';
require_once __DIR__ . '/../middleware/auth.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/Member.php';
require_once __DIR__ . '/../utils/Response.php';

$method = $_SERVER['REQUEST_METHOD'];

try {
    if ($method === 'GET') {
        $action = $_GET['action'] ?? 'current';
        
        if ($action === 'all') {
            // Admin only - get all members
            requireAdmin();
            
            $memberModel = new Member();
            $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 100;
            $offset = isset($_GET['offset']) ? (int)$_GET['offset'] : 0;
            
            $members = $memberModel->getAll($limit, $offset);
            Response::success($members);
            
        } else if ($action === 'by-code') {
            // Get member by code
            $code = $_GET['code'] ?? null;
            if (!$code) {
                Response::error('Code is required', 400);
            }
            
            $memberModel = new Member();
            $member = $memberModel->findByCode($code);
            
            if (!$member) {
                Response::notFound('Member not found');
            }
            
            Response::success($member);
            
        } else {
            // Get current user's member info
            $user = authenticate();
            
            $memberModel = new Member();
            $member = $memberModel->findById($user['user_id']);
            
            if (!$member) {
                Response::notFound('Member not found');
            }
            
            Response::success($member);
        }
        
    } else if ($method === 'PUT') {
        // Update member info
        $user = authenticate();
        $data = json_decode(file_get_contents('php://input'), true);
        
        $memberId = $_GET['id'] ?? $user['user_id'];
        
        // Only admin can update other members
        if ($memberId !== $user['user_id'] && !($user['is_admin'] ?? false)) {
            Response::forbidden('You can only update your own profile');
        }
        
        $allowedFields = ['phone', 'locality_id', 'status'];
        $updateData = [];
        
        foreach ($allowedFields as $field) {
            if (isset($data[$field])) {
                $updateData[$field] = $data[$field];
            }
        }
        
        if (empty($updateData)) {
            Response::error('No valid fields to update', 400);
        }
        
        $memberModel = new Member();
        $memberModel->update($memberId, $updateData);
        
        Response::success(null, 'Member updated successfully');
        
    } else {
        Response::error('Method not allowed', 405);
    }
    
} catch (Exception $e) {
    Response::serverError($e->getMessage());
}
