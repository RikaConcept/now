<?php

require_once __DIR__ . '/../config/database.php';

class Member {
    private $db;
    
    public function __construct() {
        $this->db = Database::getInstance();
    }
    
    public function create($userId, $email, $phone, $localityId, $code) {
        $sql = "INSERT INTO members (id, email, phone, locality_id, code, status, created_at, updated_at) 
                VALUES (?, ?, ?, ?, ?, 'pending', NOW(), NOW())";
        $this->db->query($sql, [$userId, $email, $phone, $localityId, $code]);
        
        return $userId;
    }
    
    public function findById($id) {
        $sql = "SELECT m.*, ml.name as level_name, ml.discount_percentage as level_discount, l.name as locality_name 
                FROM members m 
                LEFT JOIN membership_levels ml ON m.membership_level_id = ml.id 
                LEFT JOIN localities l ON m.locality_id = l.id 
                WHERE m.id = ?";
        $stmt = $this->db->query($sql, [$id]);
        return $stmt->fetch();
    }
    
    public function findByCode($code) {
        $sql = "SELECT * FROM members WHERE code = ?";
        $stmt = $this->db->query($sql, [$code]);
        return $stmt->fetch();
    }
    
    public function update($id, $data) {
        $fields = [];
        $values = [];
        
        foreach ($data as $key => $value) {
            $fields[] = "$key = ?";
            $values[] = $value;
        }
        
        $values[] = $id;
        $sql = "UPDATE members SET " . implode(', ', $fields) . ", updated_at = NOW() WHERE id = ?";
        $this->db->query($sql, $values);
    }
    
    public function getAll($limit = 100, $offset = 0) {
        $sql = "SELECT m.*, ml.name as level_name, l.name as locality_name 
                FROM members m 
                LEFT JOIN membership_levels ml ON m.membership_level_id = ml.id 
                LEFT JOIN localities l ON m.locality_id = l.id 
                ORDER BY m.created_at DESC 
                LIMIT ? OFFSET ?";
        $stmt = $this->db->query($sql, [$limit, $offset]);
        return $stmt->fetchAll();
    }
    
    public function updateTotalSpent($memberId, $amount) {
        $sql = "UPDATE members SET total_spent = total_spent + ?, updated_at = NOW() WHERE id = ?";
        $this->db->query($sql, [$amount, $memberId]);
    }
}
