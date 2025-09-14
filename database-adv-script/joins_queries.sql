-- 1. INNER JOIN: Retrieve all bookings and the respective users who made those bookings
-- This query returns only bookings that have associated users
SELECT 
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
ORDER BY 
    b.created_at DESC;

-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews
-- This query returns all properties, even those without reviews
SELECT 
    p.property_id,
    p.host_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    r.review_id,
    r.rating,
    r.comment AS review_comment,
    r.created_at AS review_date,
    u.first_name AS reviewer_first_name,
    u.last_name AS reviewer_last_name
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
LEFT JOIN 
    User u ON r.user_id = u.user_id
ORDER BY 
    p.property_id, r.created_at DESC;

-- 3. FULL OUTER JOIN: Retrieve all users and all bookings, even if user has no booking or booking is not linked to a user
-- This query shows all users and all bookings, including orphaned records
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_date
FROM 
    User u
FULL OUTER JOIN 
    Booking b ON u.user_id = b.user_id
ORDER BY 
    COALESCE(u.user_id, b.user_id), b.created_at DESC;

-- Additional useful join query: Get booking details with property and user information
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
    host.first_name || ' ' || host.last_name AS host_name
FROM 
    Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User host ON p.host_id = host.user_id
WHERE 
    b.status = 'confirmed'
ORDER BY 
    b.start_date DESC;