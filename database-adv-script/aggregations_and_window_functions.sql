-- 1. Aggregation: Find the total number of bookings made by each user using COUNT and GROUP BY
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_spent,
    AVG(b.total_price) AS average_booking_value,
    MIN(b.start_date) AS first_booking_date,
    MAX(b.start_date) AS last_booking_date
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
HAVING 
    COUNT(b.booking_id) > 0  -- Only users with at least one booking
ORDER BY 
    total_bookings DESC, total_spent DESC;

-- 2. Window Functions: Rank properties based on the total number of bookings
-- Using ROW_NUMBER() and RANK() to rank properties
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue,
    -- ROW_NUMBER assigns unique sequential numbers
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank,
    -- RANK assigns same rank to ties, with gaps
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank_with_gaps,
    -- DENSE_RANK assigns same rank to ties, without gaps
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    total_bookings DESC, total_revenue DESC;

-- 3. Advanced Window Functions: Partition by location
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    -- Rank within each location
    RANK() OVER (PARTITION BY p.location ORDER BY COUNT(b.booking_id) DESC) AS location_rank,
    -- Running total of bookings within location
    SUM(COUNT(b.booking_id)) OVER (PARTITION BY p.location ORDER BY COUNT(b.booking_id) DESC) AS running_total_bookings,
    -- Percentage of total bookings within location
    ROUND(
        COUNT(b.booking_id) * 100.0 / 
        SUM(COUNT(b.booking_id)) OVER (PARTITION BY p.location), 2
    ) AS percentage_of_location_bookings
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    p.location, total_bookings DESC;

-- 4. Monthly booking trends using window functions
SELECT 
    DATE_TRUNC('month', b.start_date) AS booking_month,
    COUNT(*) AS monthly_bookings,
    SUM(b.total_price) AS monthly_revenue,
    AVG(b.total_price) AS avg_booking_value,
    -- Running total across months
    SUM(COUNT(*)) OVER (ORDER BY DATE_TRUNC('month', b.start_date)) AS cumulative_bookings,
    -- Month-over-month growth
    COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY DATE_TRUNC('month', b.start_date)) AS mom_booking_change,
    -- Percentage change from previous month
    ROUND(
        (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY DATE_TRUNC('month', b.start_date))) * 100.0 /
        NULLIF(LAG(COUNT(*)) OVER (ORDER BY DATE_TRUNC('month', b.start_date)), 0), 2
    ) AS mom_percentage_change
FROM 
    Booking b
WHERE 
    b.status = 'confirmed'
GROUP BY 
    DATE_TRUNC('month', b.start_date)
ORDER BY 
    booking_month;

-- 5. User activity analysis with window functions
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_spent,
    -- Rank users by total bookings
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_count_rank,
    -- Rank users by total spending
    DENSE_RANK() OVER (ORDER BY SUM(b.total_price) DESC) AS spending_rank,
    -- Percentile ranking
    PERCENT_RANK() OVER (ORDER BY COUNT(b.booking_id)) AS booking_percentile,
    -- Ntile to create quartiles
    NTILE(4) OVER (ORDER BY SUM(b.total_price)) AS spending_quartile,
    -- First and last booking dates
    MIN(b.start_date) AS first_booking,
    MAX(b.start_date) AS last_booking
FROM 
    User u
INNER JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY 
    total_bookings DESC;

-- 6. Property performance with lag/lead functions
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    AVG(r.rating) AS average_rating,
    -- Compare with previous property in the same location
    LAG(COUNT(b.booking_id)) OVER (PARTITION BY p.location ORDER BY COUNT(b.booking_id)) AS prev_property_bookings,
    -- Compare with next property in the same location
    LEAD(COUNT(b.booking_id)) OVER (PARTITION BY p.location ORDER BY COUNT(b.booking_id)) AS next_property_bookings,
    -- First and last values in partition
    FIRST_VALUE(p.name) OVER (PARTITION BY p.location ORDER BY COUNT(b.booking_id) DESC) AS top_property_in_location,
    LAST_VALUE(p.name) OVER (
        PARTITION BY p.location 
        ORDER BY COUNT(b.booking_id) DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS bottom_property_in_location
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
LEFT JOIN -- Task 2: Apply Aggregations and Window Functions
-- File: aggregations_and_window_functions.sql
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.name, p.location
ORDER BY 
    p.location, total_bookings DESC;