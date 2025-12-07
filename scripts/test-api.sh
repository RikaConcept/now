#!/bin/bash

# Script de test de l'API Nowlover
# Teste tous les endpoints principaux

API_URL="https://arnowconcept.com/api"
EMAIL="test_$(date +%s)@example.com"
PASSWORD="Test123456!"
TOKEN=""

echo "======================================"
echo "  Tests API Nowlover"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test function
test_endpoint() {
    local name=$1
    local method=$2
    local endpoint=$3
    local data=$4
    local expect_success=${5:-true}
    
    echo -n "Testing $name... "
    
    if [ -z "$data" ]; then
        if [ -z "$TOKEN" ]; then
            response=$(curl -s -X $method "$API_URL$endpoint")
        else
            response=$(curl -s -X $method "$API_URL$endpoint" \
                -H "Authorization: Bearer $TOKEN")
        fi
    else
        if [ -z "$TOKEN" ]; then
            response=$(curl -s -X $method "$API_URL$endpoint" \
                -H "Content-Type: application/json" \
                -d "$data")
        else
            response=$(curl -s -X $method "$API_URL$endpoint" \
                -H "Content-Type: application/json" \
                -H "Authorization: Bearer $TOKEN" \
                -d "$data")
        fi
    fi
    
    success=$(echo $response | grep -o '"success":true' | head -1)
    
    if [ "$expect_success" = true ]; then
        if [ -n "$success" ]; then
            echo -e "${GREEN}✓ PASS${NC}"
            return 0
        else
            echo -e "${RED}✗ FAIL${NC}"
            echo "Response: $response"
            return 1
        fi
    else
        if [ -z "$success" ]; then
            echo -e "${GREEN}✓ PASS (expected failure)${NC}"
            return 0
        else
            echo -e "${RED}✗ FAIL (expected failure but succeeded)${NC}"
            return 1
        fi
    fi
}

echo "1. Testing Public Endpoints"
echo "----------------------------"

test_endpoint "Get Localities" "GET" "/localities"
test_endpoint "Get Membership Levels" "GET" "/membership-levels"
test_endpoint "Get Partner Shops" "GET" "/partner-shops"
test_endpoint "Get Products" "GET" "/products"

echo ""
echo "2. Testing Authentication"
echo "-------------------------"

# Register
test_endpoint "Register User" "POST" "/auth/register" \
    "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}"

if [ $? -eq 0 ]; then
    # Extract token
    TOKEN=$(curl -s -X POST "$API_URL/auth/login" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}" | \
        grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    
    if [ -n "$TOKEN" ]; then
        echo -e "${GREEN}Token obtained successfully${NC}"
    else
        echo -e "${RED}Failed to obtain token${NC}"
    fi
fi

# Login
test_endpoint "Login User" "POST" "/auth/login" \
    "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}"

# Get current user
test_endpoint "Get Current User" "GET" "/auth/user"

echo ""
echo "3. Testing Member Endpoints (Authenticated)"
echo "--------------------------------------------"

test_endpoint "Get Member Info" "GET" "/members"

echo ""
echo "4. Testing Order Creation (Authenticated)"
echo "------------------------------------------"

test_endpoint "Create Order" "POST" "/orders" \
    "{\"amount\":50.00,\"payment_method\":\"test\"}"

test_endpoint "Get User Orders" "GET" "/orders"

echo ""
echo "5. Testing Product Request (Public)"
echo "------------------------------------"

test_endpoint "Create Product Request" "POST" "/product-requests" \
    "{\"email\":\"test@example.com\",\"product_name\":\"Test Product\",\"best_price_found\":100,\"price_source\":\"Test Source\",\"user_budget\":120,\"is_member\":false}"

echo ""
echo "6. Testing Admin Login"
echo "----------------------"

# Login as admin
ADMIN_TOKEN=$(curl -s -X POST "$API_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"email":"rikaconcept@gmail.com","password":"AdminNow25#"}' | \
    grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -n "$ADMIN_TOKEN" ]; then
    echo -e "${GREEN}✓ Admin login successful${NC}"
    TOKEN=$ADMIN_TOKEN
    
    echo ""
    echo "7. Testing Admin Endpoints"
    echo "--------------------------"
    
    test_endpoint "Get Admin Stats" "GET" "/admin?action=stats"
    test_endpoint "Get All Members (Admin)" "GET" "/admin?action=members&limit=10"
    test_endpoint "Get All Orders (Admin)" "GET" "/admin?action=orders&limit=10"
else
    echo -e "${RED}✗ Admin login failed${NC}"
fi

echo ""
echo "======================================"
echo "  Tests Complete"
echo "======================================"
echo ""
echo "Note: Some tests may fail if the database is not initialized."
echo "Run 'php scripts/init-database.php' first."
