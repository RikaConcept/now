<?php

require_once __DIR__ . '/../config/database.php';

class User {
    private $db;
    
    public function __construct() {
        $this->db = Database::getInstance();
    }
    
    public function create($email, $password) {
        $hashedPassword = password_hash($password, PASSWORD_BCRYPT);
        $userId = UUID::v4();
        
        $sql = "INSERT INTO users (id, email, password, created_at) VALUES (?, ?, ?, NOW())";
        $this->db->query($sql, [$userId, $email, $hashedPassword]);
        
        return $userId;
    }
    
    public function findByEmail($email) {
        $sql = "SELECT * FROM users WHERE email = ?";
        $stmt = $this->db->query($sql, [$email]);
        return $stmt->fetch();
    }
    
    public function findById($id) {
        $sql = "SELECT * FROM users WHERE id = ?";
        $stmt = $this->db->query($sql, [$id]);
        return $stmt->fetch();
    }
    
    public function verifyPassword($password, $hashedPassword) {
        return password_verify($password, $hashedPassword);
    }
    
    public function isAdmin($userId) {
        $sql = "SELECT * FROM admin_users WHERE user_id = ?";
        $stmt = $this->db->query($sql, [$userId]);
        return $stmt->fetch() !== false;
    }
}
