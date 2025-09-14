-- Implementation of table partitioning on the Booking table based on start_date

-- STEP 1: Create the main partitioned table (PostgreSQL syntax)
-- Note: This assumes we're creating a new partitioned table structure

-- First, let's create the partitioned booking table
CREATE TABLE Booking_Partitioned (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
) PARTITION BY RANGE (start_date);

-- STEP 2: Create individual partitions for different date ranges

-- Partition for 2023 bookings
CREATE TABLE Booking_2023 PARTITION OF Booking_Partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for Q1 2024
CREATE TABLE Booking_2024_Q1 PARTITION OF Booking_Partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

-- Partition for Q2 2024
CREATE TABLE Booking_2024_Q2 PARTITION OF Booking_Partitioned
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

-- Partition for Q3 2024
CREATE TABLE Booking_2024_Q3 PARTITION OF Booking_Partitioned
    FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

-- Partition for Q4 2024
CREATE TABLE Booking_2024_Q4 PARTITION OF Booking_Partitioned
    FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- Partition for Q1 2025
CREATE TABLE Booking_2025_Q1 PARTITION OF Booking_Partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');

-- Partition for Q2 2025
CREATE TABLE Booking_2025_Q2 PARTITION OF Booking_Partitioned
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');

-- Partition for Q3 2025
CREATE TABLE Booking_2025_Q3 PARTITION OF Booking_Partitioned
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');

-- Partition for Q4 2025
CREATE TABLE Booking_2025_Q4 PARTITION OF Booking_Partitioned
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');

-- Default partition for any dates that don't fit other partitions
CREATE TABLE Booking_Default PARTITION OF Booking_Partitioned DEFAULT;

-- STEP 3: Create indexes on partitions for optimal performance

-- Index on user_id for each partition (for joins and user-based queries)
CREATE INDEX idx_booking_2023_user_id ON Booking_2023(user_id);
CREATE INDEX idx_booking_2024_q1_user_id ON Booking_2024_Q1(user_id);
CREATE INDEX idx_booking_2024_q2_user_id ON Booking_2024_Q2(user_id);
CREATE INDEX idx_booking_2024_q3_user_id ON Booking_2024_Q3(user_id);
CREATE INDEX idx_booking_2024_q4_user_id ON Booking_2024_Q4(user_id);
CREATE INDEX idx_booking_2025_q1_user_id ON Booking_2025_Q1(user_id);
CREATE INDEX idx_booking_2025_q2_user_id ON Booking_2025_Q2(user_id);
CREATE INDEX idx_booking_2025_q3_user_id ON Booking_2025_Q3(user_id);
CREATE INDEX idx_booking_2025_q4_user_id ON Booking_2025_Q4(user_id);

-- Index on property_id for each partition
CREATE INDEX idx_booking_2023_property_id ON Booking_2023(property_id);
CREATE INDEX idx_booking_2024_q1_property_id ON Booking_2024_Q1(property_id);
CREATE INDEX idx_booking_2024_q2_property_id ON Booking_2024_Q2(property_id);
CREATE INDEX idx_booking_2024_q3_property_id ON Booking_2024_Q3(property_id);
CREATE INDEX idx_booking_2024_q4_property_id ON Booking_2024_Q4(property_id);
CREATE INDEX idx_booking_2025_q1_property_id ON Booking_2025_Q1(property_id);
CREATE INDEX idx_booking_2025_q2_property_id ON Booking_2025_Q2(property_id);
CREATE INDEX idx_booking_2025_q3_property_id ON Booking_2025_Q3(property_id);
CREATE INDEX idx_booking_2025_q4_property_id ON Booking_2025_Q4(property_id);

-- Index on status for each partition
CREATE INDEX idx_booking_2023_status ON Booking_2023(status);
CREATE INDEX idx_booking_2024_q1_status ON Booking_2024_Q1(status);
CREATE INDEX idx_booking_2024_q2_status ON Booking_2024_Q2(status);
CREATE INDEX idx_booking_2024_q3_status ON Booking_2024_Q3(status);
CREATE INDEX idx_booking_2024_q4_status ON Booking_2024_Q4(status);
CREATE INDEX idx_booking_2025_q1_status ON Booking_2025_Q1(status);
CREATE INDEX idx_booking_2025_q2_status ON Booking_2025_Q2(status);
CREATE INDEX idx_booking_2025_q3_status ON Booking_2025_Q3(status);
CREATE INDEX idx_booking_2025_q4_status ON Booking_2025_Q4(status);

-- STEP 4: Migrate data from original table (if applicable)
-- This step would involve copying data from the original Booking table to the partitioned table

-- INSERT INTO Booking_Partitioned 
-- SELECT * FROM Booking;

-- STEP 5: Performance testing queries for partitioned table

-- Query 1: Test date range query performance (should only scan relevant partitions)
-- This query should only scan the Q2 2024 partition
SELECT 
    COUNT(*) as booking_count,
    AVG(total_price) as avg_price,
    SUM(total_price) as total_revenue
FROM 
    Booking_Partitioned
WHERE 
    start_date BETWEEN '2024-04-01' AND '2024-06-30'
    AND status = 'confirmed';

-- Query 2: Test monthly aggregation (should benefit from partition pruning)
SELECT 
    DATE_TRUNC('month', start_date) AS month,
    COUNT(*) as monthly_bookings,
    SUM(total_price) as monthly_revenue,
    AVG(total_price) as avg_booking_value
FROM 
    Booking_Partitioned
WHERE 
    start_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 
    DATE_TRUNC('month', start_date)
ORDER BY 
    month;

-- Query 3: Test specific quarter performance
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name || ' ' || u.last_name as guest_name,
    p.name as property_name
FROM 
    Booking_Partitioned b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
WHERE 
    b.start_date BETWEEN '2024-07-01' AND '2024-09-30'
    AND b.status = 'confirmed'
ORDER BY 
    b.start_date;

-- Query 4: Test cross-partition query
SELECT 
    DATE_TRUNC('quarter', start_date) AS quarter,
    COUNT(*) as bookings,
    SUM(total_price) as revenue,
    COUNT(DISTINCT user_id) as unique_guests,
    COUNT(DISTINCT property_id) as unique_properties
FROM 
    Booking_Partitioned
WHERE 
    start_date >= '2024-01-01'
GROUP BY 
    DATE_TRUNC('quarter', start_date)
ORDER BY 
    quarter;

-- Query 5: Test partition-specific query optimization
-- This should only access the 2025 Q1 partition
SELECT 
    property_id,
    COUNT(*) as booking_count,
    SUM(total_price) as total_revenue,
    AVG(total_price) as avg_booking_value
FROM 
    Booking_Partitioned
WHERE 
    start_date BETWEEN '2025-01-01' AND '2025-03-31'
    AND status IN ('confirmed', 'pending')
GROUP BY 
    property_id
HAVING 
    COUNT(*) > 5
ORDER BY 
    total_revenue DESC;

-- STEP 6: Maintenance queries for partition management

-- Function to automatically create new partitions (PostgreSQL)
CREATE OR REPLACE FUNCTION create_quarterly_partition(year INTEGER, quarter INTEGER)
RETURNS VOID AS $$
DECLARE
    start_date DATE;
    end_date DATE;
    partition_name TEXT;
BEGIN
    -- Calculate start and end dates for the quarter
    start_date := DATE(year || '-' || ((quarter - 1) * 3 + 1) || '-01');
    end_date := start_date + INTERVAL '3 months';
    
    -- Create partition name
    partition_name := 'Booking_' || year || '_Q' || quarter;
    
    -- Create the partition
    EXECUTE format('CREATE TABLE %I PARTITION OF Booking_Partitioned
                    FOR VALUES FROM (%L) TO (%L)',
                   partition_name, start_date, end_date);
    
    -- Create indexes on the new partition
    EXECUTE format('CREATE INDEX idx_%s_user_id ON %I(user_id)', 
                   lower(partition_name), partition_name);
    EXECUTE format('CREATE INDEX idx_%s_property_id ON %I(property_id)', 
                   lower(partition_name), partition_name);
    EXECUTE format('CREATE INDEX idx_%s_status ON %I(status)', 
                   lower(partition_name), partition_name);
END;
$$ LANGUAGE plpgsql;

-- Usage: Create partition for Q1 2026
-- SELECT create_quarterly_partition(2026, 1);

-- Query to check partition information
SELECT 
    schemaname,
    tablename,
    partitionbounds
FROM 
    pg_tables
WHERE 
    tablename LIKE 'booking_%'
ORDER BY 
    tablename;

-- Query to check partition sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM 
    pg_tables 
WHERE 
    tablename LIKE 'booking_%'
ORDER BY 
    pg_total_relation_size(schemaname||'.'||tablename) DESC;
