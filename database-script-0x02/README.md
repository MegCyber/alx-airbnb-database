# AirBnB Sample Data Documentation

A comprehensive dataset for testing and demonstrating the AirBnB database system, featuring realistic data that mirrors real-world usage patterns and business scenarios.

## 📋 Table of Contents

- [Overview](#overview)
- [Dataset Statistics](#dataset-statistics)
- [Data Structure](#data-structure)
- [Installation](#installation)
- [Usage Examples](#usage-examples)
- [Data Scenarios](#data-scenarios)
- [Testing Queries](#testing-queries)
- [Data Validation](#data-validation)
- [Extending the Dataset](#extending-the-dataset)

## 🎯 Overview

This sample dataset provides a complete, realistic foundation for testing the AirBnB database system. The data reflects authentic rental platform scenarios, including seasonal booking patterns, diverse property types, varied user interactions, and real-world business complexities.

### Key Design Principles

- **Realistic Relationships**: All foreign keys and business relationships are properly maintained
- **Geographic Accuracy**: Real cities, addresses, and GPS coordinates
- **Temporal Logic**: Proper date sequences (bookings → stays → reviews → payments)
- **Business Scenarios**: Common platform situations including cancellations, disputes, and seasonal patterns
- **Multi-Currency Support**: USD, CAD, and GBP transactions
- **Diverse User Behaviors**: Different user types with varied interaction patterns

## 📊 Dataset Statistics

### Data Volume
```
Countries:        8
States/Provinces: 12
Cities:          15
Addresses:       18
Users:           20
Properties:      18
Bookings:        18
Payments:        16
Reviews:         12
Messages:        20
```

### Geographic Distribution
```
🇺🇸 United States: 10 properties across 6 states
🇨🇦 Canada:        2 properties (Toronto, Vancouver)
🇬🇧 United Kingdom: 2 properties (London, Edinburgh)
🌍 Other Countries: Ready for expansion
```

### Business Metrics
```
Total Booking Value: ~$17,000 USD
Average Booking:     ~$945 USD
Property Range:      $125 - $750 per night
Occupancy Scenarios: High, medium, and low demand properties
Review Average:      4.2/5 stars
```

## 🗂️ Data Structure

### Location Hierarchy (3NF Normalized)
```
Country → State → City → Address → Property
```

**Example**: United States → California → San Francisco → 123 Market Street → Cozy Downtown Loft

### Core Business Entities

| Entity | Count | Key Features |
|--------|-------|--------------|
| **Users** | 20 | 2 admins, 8 hosts, 10 guests with realistic profiles |
| **Properties** | 18 | 6 property types across major cities with detailed descriptions |
| **Bookings** | 18 | Mix of completed (28%), confirmed (28%), pending (17%), cancelled (11%) |
| **Payments** | 16 | 4 payment methods, 3 currencies, various statuses |
| **Reviews** | 12 | Detailed feedback with sub-ratings and realistic content |
| **Messages** | 20 | Pre-booking inquiries, support, and follow-up communications |

### Property Types Distribution
```
Apartments: 9 (50%)
Houses:     3 (17%)
Lofts:      3 (17%)
Studios:    2 (11%)
Villas:     1 (5%)
```

### Price Ranges by City
```
San Francisco: $125 - $225/night
Los Angeles:   $350 - $750/night
New York:      $165 - $485/night
Miami:         $285 - $425/night
Austin:        $145 - $275/night
Seattle:       $175 - $195/night
Toronto:       $165/night
Vancouver:     $145/night
London:        $125/night
Edinburgh:     $185/night
```

## 🚀 Installation

### Prerequisites
- PostgreSQL 12+ with UUID extension
- Existing AirBnB database schema (from schema.sql)

### Quick Installation
```bash
# 1. Ensure your database is set up
psql your_database -c "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"

# 2. Load the main schema first
psql your_database -f schema.sql

# 3. Load sample data
psql your_database -f sample_data.sql

# 4. Verify installation
psql your_database -c "SELECT COUNT(*) FROM \"User\";"
```

### Docker Installation
```bash
# Using Docker Compose
docker-compose up -d
docker exec -i airbnb_db psql -U airbnb -d airbnb_dev < sample_data.sql
```

### Verification Queries
```sql
-- Check data integrity
SELECT 'Users' as table_name, COUNT(*) as count FROM "User"
UNION ALL
SELECT 'Properties', COUNT(*) FROM Property
UNION ALL  
SELECT 'Bookings', COUNT(*) FROM Booking
UNION ALL
SELECT 'Reviews', COUNT(*) FROM Review;
```

## 📖 Usage Examples

### Property Search Queries

#### Find Available Properties in San Francisco
```sql
SELECT p.name, p.price_per_night, c.city_name
FROM PropertyWithAddress p
WHERE p.city_name = 'San Francisco'
  AND p.is_available = TRUE
  AND NOT EXISTS (
    SELECT 1 FROM Booking b 
    WHERE b.property_id = p.property_id 
      AND b.status IN ('confirmed', 'pending')
      AND (b.start_date, b.end_date) OVERLAPS ('2024-04-01', '2024-04-05')
  );
```

#### Properties Under $200/night
```sql
SELECT name, price_per_night, property_type
FROM PropertyWithAddress
WHERE price_per_night < 200
ORDER BY price_per_night;
```

### Booking Analysis

#### Revenue by Host
```sql
SELECT 
    host_name,
    COUNT(booking_id) as total_bookings,
    SUM(total_price) as total_revenue,
    AVG(rating) as avg_rating
FROM BookingDetails bd
LEFT JOIN Review r ON bd.property_id = r.property_id
WHERE status = 'completed'
GROUP BY host_name
ORDER BY total_revenue DESC;
```

#### Monthly Booking Trends
```sql
SELECT 
    DATE_TRUNC('month', start_date) as month,
    COUNT(*) as bookings,
    SUM(total_price) as revenue
FROM Booking
WHERE status IN ('confirmed', 'completed')
GROUP BY DATE_TRUNC('month', start_date)
ORDER BY month;
```

### User Engagement Analysis

#### Communication Patterns
```sql
SELECT 
    sender.role as sender_role,
    recipient.role as recipient_role,
    COUNT(*) as message_count
FROM Message m
JOIN "User" sender ON m.sender_id = sender.user_id
JOIN "User" recipient ON m.recipient_id = recipient.user_id
GROUP BY sender.role, recipient.role;
```

## 🎭 Data Scenarios

### Realistic Business Scenarios Included

#### 1. **Seasonal Booking Patterns**
- Winter bookings in ski areas
- Summer beach destinations
- Festival and conference bookings

#### 2. **User Journey Examples**
- **Amanda Davis**: First-time guest → Repeat customer → Positive reviewer
- **Sarah Johnson**: New host → Growing portfolio → High ratings
- **Michael Chen**: Luxury property owner → Premium pricing → Selective bookings

#### 3. **Problem Resolution Cases**
- WiFi issues with host response and resolution
- Booking cancellations with different reasons
- Payment processing delays and recovery

#### 4. **Communication Threads**
- Pre-booking property inquiries
- Check-in instruction exchanges  
- Post-stay follow-up and review requests
- Support ticket escalations

#### 5. **Review Scenarios**
- Glowing 5-star reviews with detailed praise
- Constructive 4-star feedback with improvement suggestions
- Critical 3-star reviews highlighting real issues
- Host responses and problem resolution

### Edge Cases and Testing Scenarios

#### Booking Conflicts
```sql
-- Properties with overlapping booking attempts
SELECT property_id, COUNT(*) 
FROM Booking 
WHERE status IN ('confirmed', 'pending')
GROUP BY property_id, start_date, end_date 
HAVING COUNT(*) > 1;
```

#### Payment Failures
```sql
-- Failed payments requiring follow-up
SELECT b.booking_id, p.payment_status, b.status
FROM Booking b
LEFT JOIN Payment p ON b.booking_id = p.booking_id
WHERE p.payment_status = 'failed' OR p.payment_id IS NULL;
```

## 🧪 Testing Queries

### Data Integrity Tests

#### Foreign Key Validation
```sql
-- Orphaned records check
SELECT 'Properties without valid addresses' as issue,
       COUNT(*) as count
FROM Property p
LEFT JOIN Address a ON p.address_id = a.address_id
WHERE a.address_id IS NULL

UNION ALL

SELECT 'Bookings without valid properties',
       COUNT(*)
FROM Booking b
LEFT JOIN Property p ON b.property_id = p.property_id
WHERE p.property_id IS NULL;
```

#### Business Rule Validation
```sql
-- Reviews created before booking end date
SELECT COUNT(*) as invalid_reviews
FROM Review r
JOIN Booking b ON r.booking_id = b.booking_id
WHERE r.created_at < b.end_date;

-- Negative prices or ratings
SELECT COUNT(*) as invalid_prices FROM Property WHERE price_per_night <= 0
UNION ALL
SELECT COUNT(*) FROM Review WHERE rating < 1 OR rating > 5;
```

### Performance Testing

#### Complex Join Performance
```sql
EXPLAIN ANALYZE
SELECT p.name, AVG(r.rating), COUNT(b.booking_id)
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id  
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name;
```

#### Index Usage Analysis
```sql
-- Check if indexes are being used
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM Property 
WHERE price_per_night BETWEEN 100 AND 300
  AND is_available = TRUE;
```

## ✅ Data Validation

### Automated Validation Queries

Run these queries to ensure data consistency:

```sql
-- 1. Check all foreign key relationships
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN 
        SELECT conname, conrelid::regclass, confrelid::regclass
        FROM pg_constraint 
        WHERE contype = 'f'
    LOOP
        RAISE NOTICE 'Checking FK: %', rec.conname;
    END LOOP;
END $$;

-- 2. Verify business rules
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '✅ All bookings have valid date ranges'
        ELSE '❌ ' || COUNT(*) || ' bookings have invalid dates'
    END as date_validation
FROM Booking 
WHERE start_date >= end_date;

-- 3. Check data completeness
SELECT 
    table_name,
    total_records,
    CASE 
        WHEN total_records > 0 THEN '✅ Has data'
        ELSE '❌ Empty table'
    END as status
FROM (
    SELECT 'Users' as table_name, COUNT(*) as total_records FROM "User"
    UNION ALL SELECT 'Properties', COUNT(*) FROM Property
    UNION ALL SELECT 'Bookings', COUNT(*) FROM Booking
    UNION ALL SELECT 'Reviews', COUNT(*) FROM Review
    UNION ALL SELECT 'Messages', COUNT(*) FROM Message
) data_check;
```

### Expected Validation Results
```
✅ 20 users across all roles
✅ 18 properties in 10+ cities
✅ 18 bookings with valid date ranges
✅ 16 payments matching bookings
✅ 12 reviews with valid ratings (1-5)
✅ 20 messages with valid user relationships
✅ All foreign keys properly connected
✅ All business rules enforced
```

## 📈 Analytics Examples

### Business Intelligence Queries

#### Host Performance Dashboard
```sql
SELECT 
    host_name,
    properties_count,
    total_bookings,
    completed_revenue,
    ROUND(avg_rating, 2) as avg_rating,
    CASE 
        WHEN avg_rating >= 4.5 THEN '🌟 Superhost'
        WHEN avg_rating >= 4.0 THEN '⭐ Great Host'
        ELSE '📈 Growing Host'
    END as host_status
FROM (
    SELECT 
        u.first_name || ' ' || u.last_name as host_name,
        COUNT(DISTINCT p.property_id) as properties_count,
        COUNT(b.booking_id) as total_bookings,
        SUM(CASE WHEN b.status = 'completed' THEN b.total_price ELSE 0 END) as completed_revenue,
        AVG(r.rating) as avg_rating
    FROM "User" u
    JOIN Property p ON u.user_id = p.host_id
    LEFT JOIN Booking b ON p.property_id = b.property_id
    LEFT JOIN Review r ON p.property_id = r.property_id
    WHERE u.role = 'host'
    GROUP BY u.user_id, u.first_name, u.last_name
) host_stats
ORDER BY completed_revenue DESC;
```

#### Market Analysis by City
```sql
SELECT 
    city_name,
    property_count,
    ROUND(avg_price, 2) as avg_nightly_rate,
    ROUND(avg_rating, 2) as avg_rating,
    total_bookings,
    ROUND(occupancy_rate * 100, 1) || '%' as occupancy_rate
FROM (
    SELECT 
        c.city_name,
        COUNT(DISTINCT p.property_id) as property_count,
        AVG(p.price_per_night) as avg_price,
        AVG(r.rating) as avg_rating,
        COUNT(b.booking_id) as total_bookings,
        COUNT(b.booking_id)::float / NULLIF(COUNT(DISTINCT p.property_id), 0) / 30 as occupancy_rate
    FROM City c
    JOIN Address a ON c.city_id = a.city_id
    JOIN Property p ON a.address_id = p.address_id
    LEFT JOIN Review r ON p.property_id = r.property_id
    LEFT JOIN Booking b ON p.property_id = b.property_id AND b.status = 'completed'
    GROUP BY c.city_name
) city_stats
ORDER BY property_count DESC;
```

## 🔄 Extending the Dataset

### Adding More Data

#### Generate Additional Users
```sql
-- Template for adding more guest users
INSERT INTO "User" (first_name, last_name, email, password_hash, phone_number, role) VALUES
('Jane', 'Smith', 'jane.smith@example.com', '$2b$12$...', '+1-555-0201', 'guest'),
('Robert', 'Johnson', 'robert.j@example.com', '$2b$12$...', '+1-555-0202', 'guest');
```

#### Expand Geographic Coverage
```sql
-- Add new cities
INSERT INTO City (state_id, city_name, postal_code) VALUES
((SELECT state_id FROM State WHERE state_name = 'California'), 'San Diego', '92101'),
((SELECT state_id FROM State WHERE state_name = 'Florida'), 'Tampa', '33602');
```

#### Create Seasonal Booking Patterns
```sql
-- Generate summer bookings
INSERT INTO Booking (property_id, user_id, start_date, end_date, total_price, status)
SELECT 
    property_id,
    (SELECT user_id FROM "User" WHERE role = 'guest' ORDER BY RANDOM() LIMIT 1),
    DATE '2024-07-01' + (RANDOM() * 60)::int,
    DATE '2024-07-01' + (RANDOM() * 60)::int + (RANDOM() * 7 + 2)::int,
    price_per_night * (RANDOM() * 5 + 2)::int,
    'pending'
FROM Property
WHERE RANDOM() < 0.7;  -- 70% of properties get summer bookings
```

### Data Scenarios to Add

1. **Seasonal Events**: Add bookings around holidays and festivals
2. **Long-term Stays**: Monthly bookings with discounted rates
3. **Group Bookings**: Large properties for events and gatherings
4. **International Expansion**: Properties in European and Asian cities
5. **Customer Support**: More complex support ticket scenarios
6. **Loyalty Program**: Repeat guest data and rewards
7. **Dynamic Pricing**: Time-based pricing variations
8. **Property Management**: Maintenance schedules and availability gaps

## 🛠️ Development Workflow

### Using Sample Data for Development

1. **Feature Development**: Use realistic data to test new features
2. **Performance Testing**: Analyze query performance with varied data
3. **UI/UX Testing**: Populate interfaces with realistic content
4. **Integration Testing**: Validate API responses with real scenarios
5. **User Acceptance Testing**: Demonstrate features with believable data

### Data Refresh Process

```bash
# Reset and reload sample data
psql your_database << EOF
TRUNCATE TABLE Message, Review, Payment, Booking, Property, Address, City, State, Country, "User" CASCADE;
\i sample_data.sql
EOF
```

## 📞 Support and Maintenance

### Common Issues and Solutions

#### Issue: Foreign Key Violations
```sql
-- Solution: Check constraint dependencies
SELECT conname, confrelid::regclass, conrelid::regclass
FROM pg_constraint 
WHERE contype = 'f' AND NOT convalidated;
```

#### Issue: Inconsistent Dates
```sql
-- Solution: Identify and fix date inconsistencies
UPDATE Booking 
SET end_date = start_date + interval '1 day'
WHERE end_date <= start_date;
```

#### Issue: Missing Sample Data
```sql
-- Solution: Verify all tables populated
SELECT schemaname, tablename, n_tup_ins as inserts
FROM pg_stat_user_tables 
WHERE schemaname = 'public'
ORDER BY n_tup_ins DESC;
```

## 📋 Changelog

### Version 1.0 (Current)
- Initial comprehensive dataset
- 20 users, 18 properties, 18 bookings
- Multi-currency support (USD, CAD, GBP)
- Realistic communication threads
- Geographic data across North America and UK

---
