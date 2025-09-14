# Task 0: Complex Queries with Joins

## Objective
Master SQL joins by writing complex queries using different types of joins to retrieve meaningful data from the Airbnb database.

## Overview
This task demonstrates proficiency in SQL joins, which are fundamental for combining data from multiple related tables. The queries showcase three main types of joins and their practical applications in a real-world database scenario.

## Files
- `joins_queries.sql` - Contains all SQL join queries for this task

## Queries Implemented

### 1. INNER JOIN Query
**Purpose**: Retrieve all bookings with their respective user information

**Query**: Combines `Booking` and `User` tables to show booking details alongside user information for confirmed bookings only.

**Key Features**:
- Shows only records where both booking and user exist
- Ordered by booking start date (most recent first)
- Includes essential booking and user details

### 2. LEFT JOIN Query
**Purpose**: Retrieve all properties and their reviews, including properties with no reviews

**Query**: Uses LEFT JOIN to ensure all properties are displayed, even those without reviews.

**Key Features**:
- Shows all properties regardless of review status
- Includes reviewer information when available
- NULL values appear for properties without reviews
- Ordered by property ID and review date

### 3. FULL OUTER JOIN Query
**Purpose**: Retrieve all users and bookings, including unmatched records

**Implementation Note**: 
- MySQL doesn't support FULL OUTER JOIN natively
- Implemented using UNION of LEFT and RIGHT JOINs
- Alternative PostgreSQL syntax provided in comments

**Key Features**:
- Shows all users (even those without bookings)
- Shows all bookings (even orphaned ones)
- Handles NULL values appropriately

## Additional Complex Queries

### Comprehensive Booking Information
- Multi-table join including User, Property, Host, and Payment data
- Demonstrates practical application of multiple JOINs
- Filtered for confirmed/completed bookings only

### Booking Pattern Analysis
- Aggregated data showing user booking statistics
- Uses GROUP BY with HAVING clause
- Shows average prices and booking frequency

## Database Schema Assumptions

The queries assume the following table structure:

```sql
User (user_id, first_name, last_name, email, phone_number, role, created_at)
Property (property_id, name, location, price_per_night, description, host_id)
Booking (booking_id, user_id, property_id, start_date, end_date, total_price, status)
Review (review_id, property_id, user_id, rating, comment, created_at)
Payment (payment_id, booking_id, amount, payment_date, payment_method)
```

## Key Learning Points

1. **INNER JOIN**: Returns only matching records from both tables
2. **LEFT JOIN**: Returns all records from left table, matched records from right table
3. **FULL OUTER JOIN**: Returns all records from both tables, with NULLs for non-matches
4. **Query Optimization**: Proper use of ORDER BY and filtering conditions
5. **Real-world Application**: Complex business scenarios requiring multiple table relationships

## Usage Instructions

1. Ensure you have access to a MySQL/PostgreSQL database with the Airbnb schema
2. Execute the queries in `joins_queries.sql` sequentially
3. Analyze the results to understand different join behaviors
4. Modify WHERE clauses to filter results as needed

## Performance Considerations

- Indexes on join columns (user_id, property_id, booking_id) recommended
- Large result sets may require pagination
- Consider using LIMIT clause for testing purposes
- EXPLAIN can be used to analyze query execution plans

## Expected Results

- **Query 1**: All bookings with complete user information
- **Query 2**: All properties with available review data (NULLs for properties without reviews)
- **Query 3**: Complete user and booking data with proper NULL handling

This task establishes the foundation for advanced SQL querying and demonstrates practical applications of joins in database operations.