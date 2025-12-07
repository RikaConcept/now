<?php

class Database {
    private static $instance = null;
    private $connection;
    
    private $host = 'pz3qp7.myd.infomaniak.com';
    private $database = 'pz3qp7_arnowc1225';
    private $username = 'pz3qp7_arnowcu';
    private $password = '1wG50S?z4R$#mn';
    private $port = 3306;
    private $charset = 'utf8mb4';

    private function __construct() {
        try {
            $dsn = "mysql:host={$this->host};port={$this->port};dbname={$this->database};charset={$this->charset}";
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES {$this->charset} COLLATE utf8mb4_unicode_ci"
            ];
            $this->connection = new PDO($dsn, $this->username, $this->password, $options);
        } catch (PDOException $e) {
            error_log('Database connection error: ' . $e->getMessage());
            throw new Exception('Database connection failed');
        }
    }

    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getConnection() {
        return $this->connection;
    }

    public function query($sql, $params = []) {
        try {
            $stmt = $this->connection->prepare($sql);
            $stmt->execute($params);
            return $stmt;
        } catch (PDOException $e) {
            error_log('Query error: ' . $e->getMessage());
            throw new Exception('Query execution failed');
        }
    }

    public function lastInsertId() {
        return $this->connection->lastInsertId();
    }
}
