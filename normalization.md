# Database Normalization Analysis - AirBnB Project

## Objective
Apply normalization principles to ensure the database is in Third Normal Form (3NF) by identifying and eliminating redundancies and normalization violations.

## Current Schema Analysis

### 1. First Normal Form (1NF) Compliance
** All tables are already in 1NF**

**Requirements for 1NF:**
- Each column contains atomic (indivisible) values
- Each row is unique
- No repeating groups

**Analysis:**
- All attributes contain atomic values (no multi-valued attributes)
- Primary keys ensure unique rows
- No repeating groups present

### 2. Second Normal Form (2NF) Analysis
** Most tables comply with 2NF, with one potential issue**

**Requirements for 2NF:**
- Must be in 1NF
- All non-key attributes must be fully functionally dependent on the primary key

**Current Analysis:**

| Table | Primary Key | 2NF Status | Notes |
|-------|-------------|------------|-------|
| User | user_id (single) |  Compliant | Single-column PK, all attributes depend on user_id |
| Property | property_id (single) |  Compliant | Single-column PK, all attributes depend on property_id |
| Booking | booking_id (single) |  Potential Issue | See detailed analysis below |
| Payment | payment_id (single) |  Compliant | Single-column PK, all attributes depend on payment_id |
| Review | review_id (single) |  Compliant | Single-column PK, all attributes depend on review_id |
| Message | message_id (single) |  Compliant | Single-column PK, all attributes depend on message_id |

**Booking Table 2NF Analysis:**
- **Potential Issue:** `total_price` might be derivable from `price_per_night` (from Property) × number of nights
- **Current Status:** Acceptable for performance reasons (denormalization for calculated values is common)
- **Recommendation:** Keep as-is for query performance, but document as calculated field

### 3. Third Normal Form (3NF) Analysis
** Several violations identified requiring schema changes**

**Requirements for 3NF:**
- Must be in 2NF
- No transitive dependencies (non-key attributes should not depend on other non-key attributes)

## Identified 3NF Violations and Solutions

### 3.1 Property Table - Location Normalization

**Current Violation:**
```sql
Property {
    property_id (PK),
    host_id (FK),
    name,
    description,
    location,  -- Potential violation: contains city, country info
    price_per_night,
    created_at,
    updated_at
}
```

**Issue:** The `location` field likely contains composite information (address, city, state, country) which creates transitive dependencies.

**Solution:** Create separate Location-related tables

```sql
-- New normalized structure
Country {
    country_id (PK),
    country_name,
    country_code
}

State {
    state_id (PK),
    country_id (FK),
    state_name,
    state_code
}

City {
    city_id (PK),
    state_id (FK),
    city_name,
    postal_code
}

Address {
    address_id (PK),
    city_id (FK),
    street_address,
    latitude,
    longitude
}

-- Updated Property table
Property {
    property_id (PK),
    host_id (FK),
    address_id (FK),  -- Reference to Address table
    name,
    description,
    price_per_night,
    created_at,
    updated_at
}
```

### 3.2 User Table - Role Management

**Current Status:**  Already compliant
- The `role` enum is atomic and directly dependent on `user_id`
- No transitive dependencies present

### 3.3 Payment Table - Method Normalization

**Current Structure:**
```sql
Payment {
    payment_id (PK),
    booking_id (FK),
    amount,
    payment_date,
    payment_method  -- ENUM: credit_card, paypal, stripe
}
```

**Analysis:**  Currently acceptable
- The enum values are simple and unlikely to have additional attributes
- No transitive dependencies present
- **Recommendation:** If payment methods need additional attributes (fees, processing details), consider normalization

### 3.4 Message Table Analysis

**Current Status:**  Compliant
- All attributes depend directly on `message_id`
- No transitive dependencies

## Recommended Normalized Schema

### Core Tables (Existing - Compliant)

```sql
User {
    user_id (PK),
    first_name,
    last_name,
    email,
    password_hash,
    phone_number,
    role,
    created_at
}

Booking {
    booking_id (PK),
    property_id (FK),
    user_id (FK),
    start_date,
    end_date,
    total_price,
    status,
    created_at
}

Payment {
    payment_id (PK),
    booking_id (FK),
    amount,
    payment_date,
    payment_method
}

Review {
    review_id (PK),
    property_id (FK),
    user_id (FK),
    rating,
    comment,
    created_at
}

Message {
    message_id (PK),
    sender_id (FK),
    recipient_id (FK),
    message_body,
    sent_at
}
```

### New Tables for Location Normalization

```sql
Country {
    country_id (PK) UUID,
    country_name VARCHAR(100) NOT NULL,
    country_code CHAR(2) NOT NULL UNIQUE
}

State {
    state_id (PK) UUID,
    country_id (FK) REFERENCES Country(country_id),
    state_name VARCHAR(100) NOT NULL,
    state_code VARCHAR(10)
}

City {
    city_id (PK) UUID,
    state_id (FK) REFERENCES State(state_id),
    city_name VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20)
}

Address {
    address_id (PK) UUID,
    city_id (FK) REFERENCES City(city_id),
    street_address VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}

-- Updated Property table
Property {
    property_id (PK) UUID,
    host_id (FK) REFERENCES User(user_id),
    address_id (FK) REFERENCES Address(address_id),
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
}
```

## Normalization Benefits

### Advantages of the Normalized Design

1. **Eliminates Data Redundancy**
   - Location information is stored once per unique location
   - Reduces storage space requirements
   - Prevents inconsistent location data

2. **Improves Data Integrity**
   - Changes to location information are automatically reflected across all properties
   - Reduces update anomalies

3. **Enhanced Query Capabilities**
   - Easy to search properties by city, state, or country
   - Simplified location-based analytics
   - Better support for geographical queries

4. **Scalability**
   - Easy to add new location attributes (time zones, regions, etc.)
   - Supports international expansion

### Trade-offs and Considerations

1. **Query Complexity**
   - Property queries now require joins across multiple tables
   - More complex queries for location-based searches

2. **Performance Impact**
   - Additional joins may slow down frequent queries
   - Consider materialized views for performance-critical queries

3. **Application Complexity**
   - Applications need to handle multiple table inserts for new properties
   - More complex validation logic required

## Implementation Strategy

### Phase 1: Create New Tables
```sql
-- Create location hierarchy tables
CREATE TABLE Country (...);
CREATE TABLE State (...);
CREATE TABLE City (...);
CREATE TABLE Address (...);
```

### Phase 2: Data Migration
```sql
-- Extract unique locations from existing Property table
-- Populate new location tables
-- Update Property table with address_id references
```

### Phase 3: Update Application Code
- Modify property creation/update logic
- Update search and query functions
- Implement location validation

### Phase 4: Cleanup
```sql
-- Remove old location column from Property table
ALTER TABLE Property DROP COLUMN location;
```

## Alternative Approach: Controlled Denormalization

For high-performance requirements, consider keeping a denormalized `location_display` field in the Property table for quick searches while maintaining the normalized structure for data integrity:

```sql
Property {
    property_id (PK),
    host_id (FK),
    address_id (FK),
    name,
    description,
    price_per_night,
    location_display,  -- Denormalized for performance (e.g., "New York, NY, USA")
    created_at,
    updated_at
}
```

## Conclusion

The current AirBnB database schema is largely compliant with 3NF, with the primary violation being in the Property table's location handling. The recommended normalization approach creates a robust, scalable location management system while maintaining data integrity. The trade-off between normalization and performance should be evaluated based on specific application requirements and usage patterns.

**Final Status:**  3NF Compliant (after implementing location normalization)

## Updated ER Diagram

The normalized database includes the following entities:
The detailed ER diagram is available on google drive link below:  
- `Database Schema ERD` (open on [link](https://drive.google.com/file/d/1AJpW0MJkHsXTALBUMM7SkSMl4ypEeqXI/view?usp=sharing))

### Core Entities (Existing)
- **User** - System users (guests, hosts, admins)
- **Property** - Rental properties (now references Address)
- **Booking** - Reservation records
- **Payment** - Financial transactions
- **Review** - User feedback on properties
- **Message** - Inter-user communication

### New Location Entities (3NF Compliance)
- **Country** - Country information
- **State** - State/province information
- **City** - City and postal code information
- **Address** - Complete address with coordinates

### Relationship Summary
1. **Country** (1) → (M) **State**
2. **State** (1) → (M) **City**
3. **City** (1) → (M) **Address**
4. **Address** (1) → (M) **Property**
5. **User** (1) → (M) **Property** (hosts)
6. **User** (1) → (M) **Booking** (makes)
7. **Property** (1) → (M) **Booking** (has)
8. **Booking** (1) → (1) **Payment** (generates)
9. **User** (1) → (M) **Review** (writes)
10. **Property** (1) → (M) **Review** (receives)
11. **User** (1) → (M) **Message** (sends/receives)

This normalized structure eliminates all transitive dependencies and achieves full Third Normal Form compliance while maintaining the functional requirements of the AirBnB platform.