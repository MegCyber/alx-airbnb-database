# AirBnB Database Project

A comprehensive database design for a rental property platform, implementing industry best practices with Third Normal Form (3NF) compliance, robust constraints, and performance optimization.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Database Schema](#database-schema)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)
- [Performance](#performance)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This project provides a complete database solution for an AirBnB-style rental platform, featuring:

- **Normalized Design**: Full 3NF compliance eliminating data redundancy
- **Scalable Architecture**: Supports international locations and multi-currency transactions
- **Performance Optimized**: Strategic indexing for fast queries
- **Business Logic**: Built-in constraints ensuring data integrity
- **Production Ready**: Comprehensive error handling and security considerations

## ✨ Features

### Core Functionality
- **User Management**: Multi-role system (guests, hosts, admins)
- **Property Listings**: Detailed property information with geographic hierarchy
- **Booking System**: Date validation, pricing, and status management
- **Payment Processing**: Multiple payment methods with transaction tracking
- **Review System**: Comprehensive rating system with detailed feedback
- **Messaging**: In-app communication between users

### Technical Features
- **3NF Normalized**: Eliminates data redundancy and update anomalies
- **UUID Primary Keys**: Globally unique identifiers for distributed systems
- **Comprehensive Constraints**: Data validation at the database level
- **Performance Indexes**: Optimized for common query patterns
- **Audit Trails**: Created/updated timestamps on all entities
- **Referential Integrity**: Proper foreign key relationships with cascade options

## 🗂️ Database Schema

### Entity Relationship Overview

```
Country (1) ──→ (M) State (1) ──→ (M) City (1) ──→ (M) Address (1) ──→ (M) Property
                                                                              │
User (1) ──→ (M) Property (hosts)                                           │
User (1) ──→ (M) Booking ←── (M) Property                                   │
Booking (1) ──→ (1) Payment                                                  │
User (1) ──→ (M) Review ←── (M) Property ←───────────────────────────────────┘
User (1) ──→ (M) Message ←── (M) User
```

### Core Tables

| Table | Purpose | Key Features |
|-------|---------|--------------|
| **Country** | Geographic hierarchy root | ISO country codes, standardized names |
| **State** | State/province information | Links to countries, supports regions |
| **City** | City-level geography | Postal codes, municipal data |
| **Address** | Precise locations | GPS coordinates, street addresses |
| **User** | Platform users | Multi-role, email verification |
| **Property** | Rental listings | Rich metadata, availability status |
| **Booking** | Reservations | Date validation, pricing, status tracking |
| **Payment** | Financial transactions | Multiple methods, currency support |
| **Review** | User feedback | 5-star ratings, detailed categories |
| **Message** | Communications | Thread support, read status |

## 🚀 Installation

### Prerequisites

- PostgreSQL 12+ (recommended) or compatible database
- Database administration tool (pgAdmin, DBeaver, etc.)
- Optional: Docker for containerized setup

### Quick Start

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/airbnb-database.git
   cd airbnb-database
   ```

2. **Setup Database**
   ```bash
   # Create database
   createdb airbnb_dev
   
   # Enable UUID extension
   psql airbnb_dev -c "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
   ```

3. **Run Schema Creation**
   ```bash
   psql airbnb_dev -f schema.sql
   ```

4. **Verify Installation**
   ```sql
   -- Check table creation
   \dt
   
   -- Verify sample data
   SELECT COUNT(*) FROM Country;
   ```

### Docker Setup (Alternative)

```bash
# Start PostgreSQL container
docker-compose up -d

# Run schema setup
docker exec -i airbnb_db psql -U airbnb -d airbnb_dev < schema.sql
```

## 📖 Usage

### Basic Operations

#### Adding a New Property
```sql
-- First, ensure address hierarchy exists
INSERT INTO Address (city_id, street_address, latitude, longitude)
VALUES ('uuid-of-city', '123 Main St', 37.7749, -122.4194);

-- Then create the property
INSERT INTO Property (host_id, address_id, name, description, price_per_night)
VALUES (
    'host-uuid',
    'address-uuid', 
    'Cozy Downtown Apartment',
    'Beautiful 2BR apartment in the heart of the city',
    150.00
);
```

#### Creating a Booking
```sql
INSERT INTO Booking (property_id, user_id, start_date, end_date, total_price)
VALUES (
    'property-uuid',
    'guest-uuid',
    '2024-03-01',
    '2024-03-05',
    600.00
);
```

#### Searching Available Properties
```sql
SELECT p.name, p.price_per_night, c.city_name, s.state_name
FROM PropertyWithAddress p
WHERE p.is_available = TRUE
  AND p.city_name = 'San Francisco'
  AND NOT EXISTS (
    SELECT 1 FROM Booking b 
    WHERE b.property_id = p.property_id 
      AND b.status IN ('confirmed', 'pending')
      AND (b.start_date, b.end_date) OVERLAPS ('2024-03-01', '2024-03-05')
  );
```

### Advanced Queries

#### Property Analytics
```sql
-- Average rating by city
SELECT 
    c.city_name,
    COUNT(p.property_id) as total_properties,
    ROUND(AVG(r.rating), 2) as avg_rating,
    ROUND(AVG(p.price_per_night), 2) as avg_price
FROM PropertyWithAddress p
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY c.city_name
ORDER BY avg_rating DESC;
```

#### Host Performance Report
```sql
-- Top hosts by booking volume
SELECT 
    u.first_name || ' ' || u.last_name as host_name,
    COUNT(DISTINCT p.property_id) as properties_count,
    COUNT(b.booking_id) as total_bookings,
    SUM(b.total_price) as total_revenue,
    ROUND(AVG(r.rating), 2) as avg_rating
FROM "User" u
JOIN Property p ON u.user_id = p.host_id
JOIN Booking b ON p.property_id = b.property_id
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE b.status = 'confirmed'
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_revenue DESC
LIMIT 10;
```

## 📚 Documentation

### File Structure
```
├── README.md                 # This file
├── schema.sql               # Complete database schema
├── normalization.md         # 3NF analysis and design decisions
├── docs/
│   ├── er-diagram.svg      # Visual entity-relationship diagram
│   ├── api-examples.md     # Common query patterns
│   └── migration-guide.md  # Schema update procedures
└── tests/
    ├── sample-data.sql     # Test data sets
    └── test-queries.sql    # Validation queries
```

### Key Documentation Files

- **[normalization.md](normalization.md)** - Detailed analysis of normalization process and 3NF compliance
- **[schema.sql](schema.sql)** - Complete DDL statements with comments and constraints
- **ER Diagram** - Visual representation of all entities and relationships

### Design Decisions

#### Location Normalization
The original monolithic `location` field was normalized into a four-tier hierarchy:
- **Benefit**: Eliminates data redundancy, enables geographic queries
- **Trade-off**: More complex joins for property searches
- **Solution**: Pre-built views and strategic indexing

#### UUID Primary Keys
- **Benefit**: Globally unique, supports distributed systems
- **Trade-off**: Slightly larger storage footprint
- **Alternative**: Sequential integers available by modifying schema

#### Denormalized Fields
Some calculated fields (like `total_price` in Booking) are intentionally denormalized:
- **Reason**: Performance optimization for frequently accessed data
- **Maintenance**: Application logic ensures consistency

## ⚡ Performance

### Indexing Strategy

#### Primary Indexes (25+ indexes)
- **Covering Indexes**: For common query patterns
- **Partial Indexes**: For conditional queries (active users, available properties)
- **Composite Indexes**: Multi-column indexes for complex WHERE clauses

#### Query Performance Examples
```sql
-- Optimized property search (uses idx_booking_property_dates_status)
EXPLAIN ANALYZE
SELECT p.name FROM Property p
WHERE NOT EXISTS (
  SELECT 1 FROM Booking b 
  WHERE b.property_id = p.property_id 
    AND b.status = 'confirmed'
    AND (b.start_date, b.end_date) OVERLAPS ('2024-03-01', '2024-03-05')
);
```

### Scaling Considerations

#### Read Scaling
- **Views**: Pre-computed joins for common queries
- **Materialized Views**: Consider for analytics queries
- **Read Replicas**: PostgreSQL streaming replication

#### Write Scaling
- **Connection Pooling**: PgBouncer for connection management
- **Partitioning**: Consider date-based partitioning for Booking/Payment tables
- **Sharding**: Geographic sharding by country/region if needed

### Performance Monitoring
```sql
-- Monitor slow queries
SELECT query, mean_time, calls, total_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;

-- Index usage statistics
SELECT schemaname, tablename, attname, n_distinct, correlation
FROM pg_stats
WHERE tablename IN ('Property', 'Booking', 'User');
```

## 🧪 Testing

### Sample Data
The schema includes sample data for development and testing:
- 8 countries with major states/provinces
- Sample cities and addresses
- Test users, properties, and bookings

### Validation Queries
```sql
-- Test referential integrity
SELECT 'Properties without valid addresses' as test,
       COUNT(*) as count
FROM Property p
LEFT JOIN Address a ON p.address_id = a.address_id
WHERE a.address_id IS NULL;

-- Test constraint violations
SELECT 'Invalid ratings' as test,
       COUNT(*) as count  
FROM Review
WHERE rating < 1 OR rating > 5;
```

### Load Testing
```sql
-- Generate test booking data
INSERT INTO Booking (property_id, user_id, start_date, end_date, total_price)
SELECT 
    (SELECT property_id FROM Property ORDER BY RANDOM() LIMIT 1),
    (SELECT user_id FROM "User" WHERE role = 'guest' ORDER BY RANDOM() LIMIT 1),
    CURRENT_DATE + (RANDOM() * 365)::int,
    CURRENT_DATE + (RANDOM() * 365)::int + (RANDOM() * 14)::int,
    (RANDOM() * 500 + 50)::decimal(10,2)
FROM generate_series(1, 10000);
```

## 🔒 Security Considerations

### Data Protection
- **Password Hashing**: Store only hashed passwords, never plaintext
- **Email Verification**: Built-in email verification status
- **Input Validation**: Database-level constraints prevent invalid data

### Access Control
```sql
-- Example role-based security (uncomment in schema.sql)
CREATE ROLE airbnb_guest;
GRANT SELECT, INSERT ON Booking, Review, Message TO airbnb_guest;
GRANT UPDATE ON Booking TO airbnb_guest; -- Only own bookings in application logic
```

### Audit Trail
- All tables include `created_at` and `updated_at` timestamps
- Consider adding audit triggers for sensitive operations
- Log all schema changes and data migrations

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make changes and test thoroughly
4. Update documentation if needed
5. Submit a pull request

### Code Style
- **SQL**: Use uppercase keywords, consistent indentation
- **Comments**: Document complex constraints and business logic
- **Naming**: Use descriptive names, follow existing conventions

### Testing Requirements
- All new features must include test cases
- Schema changes require migration scripts
- Performance impact should be measured and documented

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by modern rental platform architectures
- Database design patterns from industry best practices
- PostgreSQL community for excellent documentation and tools

## 📞 Support

- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Discussions**: GitHub Discussions for questions and community support
- **Documentation**: Check the `/docs` folder for detailed guides

---

