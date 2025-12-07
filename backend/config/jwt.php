<?php

class JWTConfig {
    // Secret key for JWT - CHANGE THIS IN PRODUCTION
    public static $secret = 'arnowconcept_jwt_secret_key_2025_secure_random_string';
    public static $algorithm = 'HS256';
    public static $expiration = 86400; // 24 hours
}
