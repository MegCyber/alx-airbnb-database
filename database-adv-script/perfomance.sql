-- INITIAL QUERY (Before Optimization)
-- This query retrieves all bookings with user details, property details, and payment details
-- This version may have performance issues due to unnecessary joins and lack of indexing

-- Query Version 1: Initial (Potentially Inefficient)
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_total,
    b.status AS booking_status,
    b.created_at AS booking_created,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created,
    
    -- Property details
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created,
    
    -- Host details
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    h.phone_number AS host_phone,
    
    -- Payment details
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method,
    
    -- Additional potentially unnecessary columns
    p.created_at AS prop_created_date,
    u.created_at AS user_reg_date,
    h.created_at AS host_reg_date

FROM 
    Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id

WHERE 
    b.start_date >= '2024-01-01'
    AND b.status IN ('confirmed', 'pending')
    
ORDER BY 
    b.created_at DESC,
    u.last_name,
    p.name;

-- OPTIMIZED QUERY VERSION 1
-- Reduced columns, better WHERE clause positioning, and added index hints

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    -- Essential user details only
    u.first_name || ' ' || u.last_name AS guest_name,
    u.email AS guest_email,
    
    -- Essential property details only
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Essential host details only
    h.first_name || ' ' || h.last_name AS host_name,
    h.email AS host_email,
    
    -- Payment summary
    pay.amount AS payment_amount,
    pay.payment_method

FROM 
    Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id

WHERE 
    b.status IN ('confirmed', 'pending')  -- Filter early
    AND b.start_date >= '2024-01-01'      -- Use indexed column
    
ORDER BY 
    b.start_date DESC;  -- Simple ordering on indexed column

-- OPTIMIZED QUERY VERSION 2
-- Using subqueries to reduce join complexity for payment information

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.first_name || ' ' || u.last_name AS guest_name,
    u.email AS guest_email,
    
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    h.first_name || ' ' || h.last_name AS host_name,
    
    -- Use correlated subquery for payment info to reduce join complexity
    (SELECT pay.amount 
     FROM Payment pay 
     WHERE pay.booking_id = b.booking_id 
     LIMIT 1) AS payment_amount,
     
    (SELECT pay.payment_method 
     FROM Payment pay 
     WHERE pay.booking_id = b.booking_id 
     LIMIT 1) AS payment_method

FROM 
    Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id

WHERE 
    b.status IN ('confirmed', 'pending')
    AND b.start_date >= '2024-01-01'
    AND b.start_date <= '2024-12-31'  -- Add upper bound for better index usage
    
ORDER BY 
    b.start_date DESC
LIMIT 1000;  -- Add limit to prevent large result sets

-- OPTIMIZED QUERY VERSION 3
-- Using window functions for more complex aggregations efficiently

WITH booking_payments AS (
    SELECT 
        booking_id,
        SUM(amount) AS total_paid,
        STRING_AGG(payment_method, ', ') AS payment_methods,
        MAX(payment_date) AS last_payment_date
    FROM Payment
    GROUP BY booking_id
)

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.first_name || ' ' || u.last_name AS guest_name,
    u.email AS guest_email,
    
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    h.first_name || ' ' || h.last_name AS host_name,
    
    bp.total_paid,
    bp.payment_methods,
    bp.last_payment_date,
    
    -- Add useful calculations
    CASE 
        WHEN bp.total_paid >= b.total_price THEN 'Fully Paid'
        WHEN bp.total_paid > 0 THEN 'Partially Paid'
        ELSE 'Unpaid'
    END AS payment_status

FROM 
    Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id
    LEFT JOIN booking_payments bp ON b.booking_id = bp.booking_id

WHERE 
    b.status IN ('confirmed', 'pending')
    AND b.start_date BETWEEN '2024-01-01' AND '2024-12-31'
    
ORDER BY 
    b.start_date DESC;

-- QUERY FOR SPECIFIC USE CASE: Recent bookings with essential info only
-- This is the most optimized version for common dashboard queries

SELECT 
    b.booking_id,
    TO_CHAR(b.start_date, 'YYYY-MM-DD') AS check_in,
    TO_CHAR(b.end_date, 'YYYY-MM-DD') AS check_out,
    b.total_price,
    b.status,
    
    u.first_name || ' ' || u.last_name AS guest,
    p.name AS property,
    p.location,
    
    -- Calculate nights
    (b.end_date - b.start_date) AS nights,
    
    -- Payment status check
    CASE 
        WHEN EXISTS (SELECT 1 FROM Payment pay WHERE pay.booking_id = b.booking_id)
        THEN 'Payment Recorded'
        ELSE 'No Payment'
    END AS payment_status

FROM 
    Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id

WHERE 
    b.start_date >= CURRENT_DATE - INTERVAL '30 days'
    AND b.status = 'confirmed'
    
ORDER BY 
    b.start_date DESC
LIMIT 50;

-- ADDITIONAL PERFORMANCE INSIGHTS

-- Query to find bookings that might need optimization attention
SELECT 
    'Large result set queries' AS optimization_area,
    COUNT(*) AS booking_count
FROM Booking b
WHERE b.start_date >= '2020-01-01'

UNION ALL

SELECT 
    'Complex join queries' AS optimization_area,
    COUNT(DISTINCT b.booking_id) AS booking_count
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN Payment pay ON b.booking_id = pay.booking_id
EXPLAIN
UNION ALL

SELECT 
    'Unindexed filter queries' AS optimization_area,
    COUNT(*) AS booking_count
FROM Booking b
WHERE b.total_price > 500
AND b.status = 'confirmed';