# Sample Products for Firestore
# Run these curl commands to add sample products to your Firestore database

# First, set your environment variables
export PROJECT_ID="ecom-36e16"
export API_KEY="AIzaSyBiii0QJoqAHM_c3nX9z3x5hX_c4jRaXTw"

# Add Categories
echo "Adding categories..."

# Electronics Category
curl -X POST \
  "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/categories/electronics" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "name": {"stringValue": "Electronics"},
      "description": {"stringValue": "Electronic devices and gadgets"},
      "productCount": {"integerValue": "0"},
      "createdAt": {"timestampValue": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}
    }
  }'

# Clothing Category
curl -X POST \
  "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/categories/clothing" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "name": {"stringValue": "Clothing"},
      "description": {"stringValue": "Fashion and apparel"},
      "productCount": {"integerValue": "0"},
      "createdAt": {"timestampValue": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}
    }
  }'

echo "Adding products..."

# iPhone 15 Pro
curl -X POST \
  "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/products/product-1" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "name": {"stringValue": "iPhone 15 Pro"},
      "description": {"stringValue": "Latest iPhone with titanium design and A17 Pro chip"},
      "price": {"doubleValue": 999.99},
      "imageUrl": {"stringValue": "https://images.unsplash.com/photo-1592899677977-9c6c0b8b9b8b?w=500"},
      "category": {"stringValue": "electronics"},
      "stock": {"integerValue": "50"},
      "rating": {"doubleValue": 4.8},
      "reviewCount": {"integerValue": "1250"},
      "isFavorite": {"booleanValue": false},
      "createdAt": {"timestampValue": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}
    }
  }'

# MacBook Pro
curl -X POST \
  "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/products/product-2" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "name": {"stringValue": "MacBook Pro 16\""},
      "description": {"stringValue": "Powerful laptop with M3 Pro chip"},
      "price": {"doubleValue": 2499.99},
      "imageUrl": {"stringValue": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500"},
      "category": {"stringValue": "electronics"},
      "stock": {"integerValue": "25"},
      "rating": {"doubleValue": 4.9},
      "reviewCount": {"integerValue": "890"},
      "isFavorite": {"booleanValue": false},
      "createdAt": {"timestampValue": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}
    }
  }'

# Nike Shoes
curl -X POST \
  "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/products/product-3" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "name": {"stringValue": "Nike Air Max 270"},
      "description": {"stringValue": "Comfortable running shoes with Max Air cushioning"},
      "price": {"doubleValue": 150.00},
      "imageUrl": {"stringValue": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500"},
      "category": {"stringValue": "clothing"},
      "stock": {"integerValue": "75"},
      "rating": {"doubleValue": 4.5},
      "reviewCount": {"integerValue": "650"},
      "isFavorite": {"booleanValue": false},
      "createdAt": {"timestampValue": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"}
    }
  }'

echo "Sample data added successfully!"
