<?php

require_once __DIR__ . '/../config/database.php';

class Product {
    private $db;
    
    public function __construct() {
        $this->db = Database::getInstance();
    }
    
    public function create($data) {
        $id = UUID::v4();
        $sql = "INSERT INTO products (id, name, description, price, image_url, category, stock, is_active, created_at, updated_at) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        $this->db->query($sql, [
            $id,
            $data['name'],
            $data['description'] ?? null,
            $data['price'],
            $data['image_url'] ?? null,
            $data['category'],
            $data['stock'] ?? 0,
            $data['is_active'] ?? true
        ]);
        return $id;
    }
    
    public function findById($id) {
        $sql = "SELECT * FROM products WHERE id = ?";
        $stmt = $this->db->query($sql, [$id]);
        return $stmt->fetch();
    }
    
    public function getAll($category = null, $activeOnly = true) {
        $sql = "SELECT * FROM products WHERE 1=1";
        $params = [];
        
        if ($activeOnly) {
            $sql .= " AND is_active = 1";
        }
        
        if ($category) {
            $sql .= " AND category = ?";
            $params[] = $category;
        }
        
        $sql .= " ORDER BY created_at DESC";
        
        $stmt = $this->db->query($sql, $params);
        $products = $stmt->fetchAll();
        
        // Convert numeric strings to numbers
        foreach ($products as &$product) {
            $product['price'] = floatval($product['price']);
            $product['stock'] = intval($product['stock']);
            $product['is_active'] = (bool)$product['is_active'];
        }
        
        return $products;
    }
    
    public function update($id, $data) {
        $fields = [];
        $values = [];
        
        foreach ($data as $key => $value) {
            $fields[] = "$key = ?";
            $values[] = $value;
        }
        
        $values[] = $id;
        $sql = "UPDATE products SET " . implode(', ', $fields) . ", updated_at = NOW() WHERE id = ?";
        $this->db->query($sql, $values);
    }
    
    public function delete($id) {
        $sql = "DELETE FROM products WHERE id = ?";
        $this->db->query($sql, [$id]);
    }
    
    public function updateStock($id, $quantity) {
        $sql = "UPDATE products SET stock = stock + ?, updated_at = NOW() WHERE id = ?";
        $this->db->query($sql, [$quantity, $id]);
    }
}
