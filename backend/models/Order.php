<?php

require_once __DIR__ . '/../config/database.php';

class Order {
    private $db;
    
    public function __construct() {
        $this->db = Database::getInstance();
    }
    
    public function create($memberId, $amount, $paymentMethod = null) {
        $id = UUID::v4();
        $sql = "INSERT INTO orders (id, member_id, amount, status, payment_method, created_at) 
                VALUES (?, ?, ?, 'pending', ?, NOW())";
        $this->db->query($sql, [$id, $memberId, $amount, $paymentMethod]);
        return $id;
    }
    
    public function findById($id) {
        $sql = "SELECT o.*, m.email as member_email, m.code as member_code 
                FROM orders o 
                LEFT JOIN members m ON o.member_id = m.id 
                WHERE o.id = ?";
        $stmt = $this->db->query($sql, [$id]);
        return $stmt->fetch();
    }
    
    public function getByMember($memberId, $limit = 50) {
        $sql = "SELECT * FROM orders WHERE member_id = ? ORDER BY created_at DESC LIMIT ?";
        $stmt = $this->db->query($sql, [$memberId, $limit]);
        $orders = $stmt->fetchAll();
        
        // Convert numeric strings to numbers
        foreach ($orders as &$order) {
            $order['amount'] = floatval($order['amount']);
        }
        
        return $orders;
    }
    
    public function getAll($limit = 100, $offset = 0) {
        $sql = "SELECT o.*, m.email as member_email, m.code as member_code 
                FROM orders o 
                LEFT JOIN members m ON o.member_id = m.id 
                ORDER BY o.created_at DESC 
                LIMIT ? OFFSET ?";
        $stmt = $this->db->query($sql, [$limit, $offset]);
        $orders = $stmt->fetchAll();
        
        // Convert numeric strings to numbers
        foreach ($orders as &$order) {
            $order['amount'] = floatval($order['amount']);
        }
        
        return $orders;
    }
    
    public function updateStatus($id, $status) {
        $sql = "UPDATE orders SET status = ?";
        $params = [$status];
        
        if ($status === 'paid') {
            $sql .= ", paid_at = NOW()";
        }
        
        $sql .= " WHERE id = ?";
        $params[] = $id;
        
        $this->db->query($sql, $params);
    }
}
