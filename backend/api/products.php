<?php

require_once __DIR__ . '/../middleware/cors.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/Product.php';
require_once __DIR__ . '/../utils/Response.php';
require_once __DIR__ . '/../utils/UUID.php';

$method = $_SERVER['REQUEST_METHOD'];

try {
    $productModel = new Product();
    
    if ($method === 'GET') {
        $id = $_GET['id'] ?? null;
        
        if ($id) {
            $product = $productModel->findById($id);
            if (!$product) {
                Response::notFound('Product not found');
            }
            Response::success($product);
        } else {
            $category = $_GET['category'] ?? null;
            $products = $productModel->getAll($category, true);
            Response::success($products);
        }
        
    } else if ($method === 'POST') {
        // Create product - Admin only
        require_once __DIR__ . '/../middleware/auth.php';
        requireAdmin();
        
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!isset($data['name']) || !isset($data['price']) || !isset($data['category'])) {
            Response::error('Name, price and category are required', 400);
        }
        
        $productId = $productModel->create($data);
        Response::success(['id' => $productId], 'Product created successfully', 201);
        
    } else if ($method === 'PUT') {
        // Update product - Admin only
        require_once __DIR__ . '/../middleware/auth.php';
        requireAdmin();
        
        $id = $_GET['id'] ?? null;
        if (!$id) {
            Response::error('Product ID is required', 400);
        }
        
        $data = json_decode(file_get_contents('php://input'), true);
        
        $allowedFields = ['name', 'description', 'price', 'image_url', 'category', 'stock', 'is_active', 'purchase_link'];
        $updateData = [];
        
        foreach ($allowedFields as $field) {
            if (isset($data[$field])) {
                $updateData[$field] = $data[$field];
            }
        }
        
        if (empty($updateData)) {
            Response::error('No valid fields to update', 400);
        }
        
        $productModel->update($id, $updateData);
        Response::success(null, 'Product updated successfully');
        
    } else if ($method === 'DELETE') {
        // Delete product - Admin only
        require_once __DIR__ . '/../middleware/auth.php';
        requireAdmin();
        
        $id = $_GET['id'] ?? null;
        if (!$id) {
            Response::error('Product ID is required', 400);
        }
        
        $productModel->delete($id);
        Response::success(null, 'Product deleted successfully');
        
    } else {
        Response::error('Method not allowed', 405);
    }
    
} catch (Exception $e) {
    Response::serverError($e->getMessage());
}
