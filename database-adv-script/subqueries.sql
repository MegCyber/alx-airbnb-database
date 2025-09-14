-- 1. Non-correlated subquery: Find all properties where the average rating is greater than 4.0
-- This subquery calculates the average rating for each property and filters those above 4.0
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    p.description
FROM 
    Property p
WHERE 
    p.property_id IN (
        SELECT 
            r.property_id
        FROM 
            Review r
        WHERE 
            r.property_id = p.property_id
        GROUP BY 
            r.property_id
        HAVING 
            AVG(r.rating) > 4.0
    )
ORDER BY 
    p.name;

-- Alternative approach using EXISTS for better performance in some cases
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    (SELECT AVG(r.rating) 
     FROM Review r 
     WHERE r.property_id = p.property_id) AS average_rating
FROM 
    Property p
WHERE 
    EXISTS (
        SELECT 1
        FROM Review r
        WHERE r.property_id = p.property_id
        GROUP BY r.property_id
        HAVING AVG(r.rating) > 4.0
    )
ORDER BY 
    average_rating DESC;

-- 2. Correlated subquery: Find users who have made more than 3 bookings
-- The subquery is correlated because it references the outer query's user_id
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.created_at,
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS total_bookings
FROM 
    User u
WHERE 
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) > 3
ORDER BY 
    total_bookings DESC;

-- Alternative correlated subquery approach
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role
FROM 
    User u
WHERE 
    3 < (SELECT COUNT(*) 
         FROM Booking b 
         WHERE b.user_id = u.user_id)
ORDER BY 
    u.first_name, u.last_name;

-- Additional subquery examples for learning:

-- 3. Find properties that have never been booked
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight
FROM 
    Property p
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM Booking b
        WHERE b.property_id = p.property_id
    )
ORDER BY 
    p.created_at DESC;

-- 4. Find users who have made bookings with total value above average
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (SELECT SUM(b.total_price) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS total_spent
FROM 
    User u
WHERE 
    (SELECT SUM(b.total_price) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) > (
         SELECT AVG(total_price)
         FROM Booking
     )
    AND EXISTS (
        SELECT 1
        FROM Booking b
        WHERE b.user_id = u.user_id
    )
ORDER BY 
    total_spent DESC;

-- 5. Find the most expensive property in each location
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight
FROM 
    Property p
WHERE 
    p.pricepernight = (
        SELECT MAX(p2.pricepernight)
        FROM Property p2
        WHERE p2.location = p.location
    )
ORDER BY 
    p.location, p.pricepernight DESC;