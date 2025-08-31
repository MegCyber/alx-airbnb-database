-- =============================================================================
-- AirBnB Database - Sample Data Population Scripts
-- Realistic data reflecting real-world usage patterns
-- =============================================================================

-- Clear existing data (use with caution in production)
-- TRUNCATE TABLE Message, Review, Payment, Booking, Property, Address, City, State, Country, "User" CASCADE;

-- =============================================================================
-- LOCATION HIERARCHY DATA
-- =============================================================================

-- Countries
INSERT INTO Country (country_id, country_name, country_code) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'United States', 'US'),
('550e8400-e29b-41d4-a716-446655440002', 'Canada', 'CA'),
('550e8400-e29b-41d4-a716-446655440003', 'United Kingdom', 'GB'),
('550e8400-e29b-41d4-a716-446655440004', 'France', 'FR'),
('550e8400-e29b-41d4-a716-446655440005', 'Germany', 'DE'),
('550e8400-e29b-41d4-a716-446655440006', 'Spain', 'ES'),
('550e8400-e29b-41d4-a716-446655440007', 'Italy', 'IT'),
('550e8400-e29b-41d4-a716-446655440008', 'Australia', 'AU');

-- States/Provinces for US
INSERT INTO State (state_id, country_id, state_name, state_code) VALUES
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'California', 'CA'),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'New York', 'NY'),
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', 'Texas', 'TX'),
('660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', 'Florida', 'FL'),
('660e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', 'Washington', 'WA'),
('660e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440001', 'Colorado', 'CO');

-- States/Provinces for Canada
INSERT INTO State (state_id, country_id, state_name, state_code) VALUES
('660e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440002', 'Ontario', 'ON'),
('660e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440002', 'British Columbia', 'BC'),
('660e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440002', 'Quebec', 'QC');

-- States/Provinces for UK
INSERT INTO State (state_id, country_id, state_name, state_code) VALUES
('660e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440003', 'England', 'ENG'),
('660e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440003', 'Scotland', 'SCO');

-- Cities
INSERT INTO City (city_id, state_id, city_name, postal_code) VALUES
-- California cities
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'San Francisco', '94102'),
('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', 'Los Angeles', '90210'),
('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', 'San Diego', '92101'),
-- New York cities
('770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440002', 'New York City', '10001'),
('770e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440002', 'Buffalo', '14201'),
-- Texas cities
('770e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440003', 'Austin', '73301'),
('770e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440003', 'Houston', '77001'),
-- Florida cities
('770e8400-e29b-41d4-a716-446655440008', '660e8400-e29b-41d4-a716-446655440004', 'Miami', '33101'),
('770e8400-e29b-41d4-a716-446655440009', '660e8400-e29b-41d4-a716-446655440004', 'Orlando', '32801'),
-- Washington cities
('770e8400-e29b-41d4-a716-446655440010', '660e8400-e29b-41d4-a716-446655440005', 'Seattle', '98101'),
-- Colorado cities
('770e8400-e29b-41d4-a716-446655440011', '660e8400-e29b-41d4-a716-446655440006', 'Denver', '80201'),
-- Canadian cities
('770e8400-e29b-41d4-a716-446655440012', '660e8400-e29b-41d4-a716-446655440007', 'Toronto', 'M5V 3A8'),
('770e8400-e29b-41d4-a716-446655440013', '660e8400-e29b-41d4-a716-446655440008', 'Vancouver', 'V6B 1A1'),
-- UK cities
('770e8400-e29b-41d4-a716-446655440014', '660e8400-e29b-41d4-a716-446655440010', 'London', 'SW1A 1AA'),
('770e8400-e29b-41d4-a716-446655440015', '660e8400-e29b-41d4-a716-446655440011', 'Edinburgh', 'EH1 1YZ');

-- Addresses
INSERT INTO Address (address_id, city_id, street_address, apartment_unit, latitude, longitude) VALUES
-- San Francisco addresses
('880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '123 Market Street', 'Apt 4B', 37.7749, -122.4194),
('880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', '456 Mission Street', NULL, 37.7849, -122.4094),
('880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440001', '789 Valencia Street', 'Unit 2', 37.7649, -122.4294),
-- Los Angeles addresses
('880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440002', '321 Sunset Boulevard', NULL, 34.0522, -118.2437),
('880e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440002', '654 Hollywood Blvd', 'Penthouse', 34.1022, -118.3437),
-- New York City addresses
('880e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440004', '147 5th Avenue', 'Apt 12A', 40.7128, -74.0060),
('880e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440004', '258 Broadway', NULL, 40.7228, -74.0160),
('880e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440004', '369 Central Park West', 'Apt 5C', 40.7828, -73.9760),
-- Austin addresses
('880e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440006', '741 South Congress', NULL, 30.2672, -97.7431),
('880e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440006', '852 East 6th Street', 'Unit B', 30.2772, -97.7331),
-- Miami addresses
('880e8400-e29b-41d4-a716-446655440011', '770e8400-e29b-41d4-a716-446655440008', '963 Ocean Drive', NULL, 25.7617, -80.1918),
('880e8400-e29b-41d4-a716-446655440012', '770e8400-e29b-41d4-a716-446655440008', '147 Collins Avenue', 'Apt 8B', 25.7917, -80.1318),
-- Seattle addresses
('880e8400-e29b-41d4-a716-446655440013', '770e8400-e29b-41d4-a716-446655440010', '159 Pike Street', NULL, 47.6062, -122.3321),
('880e8400-e29b-41d4-a716-446655440014', '770e8400-e29b-41d4-a716-446655440010', '753 Capitol Hill', 'Apt 3A', 47.6162, -122.3221),
-- International addresses
('880e8400-e29b-41d4-a716-446655440015', '770e8400-e29b-41d4-a716-446655440012', '456 King Street West', NULL, 43.6532, -79.3832),
('880e8400-e29b-41d4-a716-446655440016', '770e8400-e29b-41d4-a716-446655440013', '789 Robson Street', 'Unit 15', 49.2827, -123.1207),
('880e8400-e29b-41d4-a716-446655440017', '770e8400-e29b-41d4-a716-446655440014', '221B Baker Street', NULL, 51.5074, -0.1278),
('880e8400-e29b-41d4-a716-446655440018', '770e8400-e29b-41d4-a716-446655440015', '42 Royal Mile', 'Flat 2', 55.9533, -3.1883);

-- =============================================================================
-- USER DATA
-- =============================================================================

INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role, is_active, email_verified) VALUES
-- Admins
('990e8400-e29b-41d4-a716-446655440001', 'Alice', 'Anderson', 'alice.admin@airbnb.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0101', 'admin', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440002', 'Bob', 'Baker', 'bob.admin@airbnb.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0102', 'admin', TRUE, TRUE),

-- Hosts
('990e8400-e29b-41d4-a716-446655440003', 'Sarah', 'Johnson', 'sarah.johnson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-415-555-0103', 'host', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440004', 'Michael', 'Chen', 'michael.chen@gmail.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-213-555-0104', 'host', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440005', 'Emily', 'Rodriguez', 'emily.rodriguez@yahoo.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-212-555-0105', 'host', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440006', 'David', 'Kim', 'david.kim@outlook.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-512-555-0106', 'host', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440007', 'Jessica', 'Williams', 'jessica.williams@gmail.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-305-555-0107', 'host', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440008', 'Ryan', 'Thompson', 'ryan.thompson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-206-555-0108', 'host', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440009', 'Sophie', 'Martin', 'sophie.martin@gmail.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-416-555-0109', 'host', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440010', 'James', 'Wilson', 'james.wilson@outlook.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+44-20-5555-0110', 'host', TRUE, TRUE),

-- Guests
('990e8400-e29b-41d4-a716-446655440011', 'Amanda', 'Davis', 'amanda.davis@gmail.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0111', 'guest', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440012', 'Christopher', 'Garcia', 'chris.garcia@yahoo.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0112', 'guest', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440013', 'Lisa', 'Miller', 'lisa.miller@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0113', 'guest', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440014', 'Mark', 'Taylor', 'mark.taylor@gmail.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0114', 'guest', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440015', 'Jennifer', 'Brown', 'jennifer.brown@outlook.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0115', 'guest', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440016', 'Kevin', 'Lee', 'kevin.lee@yahoo.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0116', 'guest', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440017', 'Rachel', 'Jones', 'rachel.jones@gmail.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0117', 'guest', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440018', 'Daniel', 'White', 'daniel.white@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0118', 'guest', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440019', 'Michelle', 'Clark', 'michelle.clark@outlook.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+1-555-0119', 'guest', TRUE, TRUE),
('990e8400-e29b-41d4-a716-446655440020', 'Andrew', 'Lewis', 'andrew.lewis@gmail.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyKxFU7ZQQ4Qom', '+44-20-5555-0120', 'guest', TRUE, TRUE);

-- =============================================================================
-- PROPERTY DATA
-- =============================================================================

INSERT INTO Property (property_id, host_id, address_id, name, description, price_per_night, bedrooms, bathrooms, max_guests, property_type, is_available) VALUES
-- San Francisco properties
('aa0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440001', 'Cozy Downtown Loft', 'Beautiful 1-bedroom loft in the heart of San Francisco. Walking distance to Union Square, great restaurants, and public transportation. Perfect for business travelers or couples exploring the city.', 185.00, 1, 1, 2, 'loft', TRUE),

('aa0e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440002', 'Modern Mission District Apartment', 'Stylish 2-bedroom apartment in vibrant Mission District. Features modern amenities, full kitchen, and easy access to best restaurants and nightlife. Great for groups and longer stays.', 225.00, 2, 2, 4, 'apartment', TRUE),

('aa0e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440003', 'Victorian Charm Studio', 'Charming studio in historic Victorian building. Original hardwood floors, high ceilings, and vintage details. Close to Valencia Street shops and restaurants.', 125.00, 1, 1, 2, 'studio', TRUE),

-- Los Angeles properties
('aa0e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440004', 'Sunset Strip Luxury Condo', 'Upscale 2-bedroom condo on famous Sunset Strip. Floor-to-ceiling windows, rooftop pool, and stunning city views. Walking distance to clubs, restaurants, and entertainment venues.', 350.00, 2, 2, 4, 'apartment', TRUE),

('aa0e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440005', 'Hollywood Hills Villa', 'Stunning 4-bedroom villa with pool and panoramic city views. Perfect for groups, events, or luxury getaways. Features gourmet kitchen, entertainment room, and outdoor dining area.', 750.00, 4, 3, 8, 'villa', TRUE),

-- New York City properties
('aa0e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440006', 'Midtown Manhattan Studio', 'Efficient studio apartment in the heart of Manhattan. Perfect location for Broadway shows, shopping, and business meetings. Clean, modern, and well-connected to subway lines.', 165.00, 1, 1, 2, 'studio', TRUE),

('aa0e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440007', 'Broadway Loft Experience', 'Spacious 2-bedroom loft near Broadway theaters. Exposed brick walls, high ceilings, and modern amenities. Ideal for theater enthusiasts and families visiting NYC.', 295.00, 2, 1, 4, 'loft', TRUE),

('aa0e8400-e29b-41d4-a716-446655440008', '990e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440008', 'Central Park View Apartment', 'Elegant 3-bedroom apartment with stunning Central Park views. Classic New York architecture with modern updates. Perfect for families or groups wanting luxury Manhattan experience.', 485.00, 3, 2, 6, 'apartment', TRUE),

-- Austin properties
('aa0e8400-e29b-41d4-a716-446655440009', '990e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440009', 'South Congress Trendy House', 'Hip 3-bedroom house on famous South Congress. Walking distance to live music venues, food trucks, and Austin\'s best shopping. Features outdoor patio and modern kitchen.', 275.00, 3, 2, 6, 'house', TRUE),

('aa0e8400-e29b-41d4-a716-446655440010', '990e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440010', 'East 6th Street Apartment', 'Modern 1-bedroom apartment in trendy East 6th district. Close to bars, restaurants, and nightlife. Perfect for young professionals and music festival visitors.', 145.00, 1, 1, 2, 'apartment', TRUE),

-- Miami properties
('aa0e8400-e29b-41d4-a716-446655440011', '990e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655440011', 'Ocean Drive Art Deco Suite', 'Iconic Art Deco building right on Ocean Drive. 1-bedroom suite with ocean views, vintage charm, and modern amenities. Steps from beach, restaurants, and South Beach nightlife.', 285.00, 1, 1, 3, 'apartment', TRUE),

('aa0e8400-e29b-41d4-a716-446655440012', '990e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655440012', 'Collins Avenue Penthouse', 'Luxury 2-bedroom penthouse with private terrace and ocean views. High-end finishes, full kitchen, and access to building amenities including pool and gym.', 425.00, 2, 2, 4, 'apartment', TRUE),

-- Seattle properties
('aa0e8400-e29b-41d4-a716-446655440013', '990e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440013', 'Pike Place Market Loft', 'Industrial loft overlooking Pike Place Market. Exposed beams, brick walls, and large windows. Walking distance to waterfront, Space Needle, and Seattle\'s best coffee shops.', 195.00, 1, 1, 2, 'loft', TRUE),

('aa0e8400-e29b-41d4-a716-446655440014', '990e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440014', 'Capitol Hill Creative Space', 'Artistic 2-bedroom apartment in vibrant Capitol Hill. Unique decor, full kitchen, and close to galleries, music venues, and diverse dining options.', 175.00, 2, 1, 4, 'apartment', TRUE),

-- International properties
('aa0e8400-e29b-41d4-a716-446655440015', '990e8400-e29b-41d4-a716-446655440009', '880e8400-e29b-41d4-a716-446655440015', 'Toronto Downtown Condo', 'Modern 2-bedroom condo in downtown Toronto. CN Tower views, building amenities, and walking distance to restaurants, shopping, and entertainment districts.', 165.00, 2, 2, 4, 'apartment', TRUE),

('aa0e8400-e29b-41d4-a716-446655440016', '990e8400-e29b-41d4-a716-446655440009', '880e8400-e29b-41d4-a716-446655440016', 'Vancouver Waterfront Suite', 'Stunning waterfront 1-bedroom suite with mountain and ocean views. Modern amenities, close to Granville Island and downtown attractions.', 145.00, 1, 1, 2, 'apartment', TRUE),

('aa0e8400-e29b-41d4-a716-446655440017', '990e8400-e29b-41d4-a716-446655440010', '880e8400-e29b-41d4-a716-446655440017', 'London Baker Street Flat', 'Classic London flat on famous Baker Street. Traditional British charm with modern updates. Close to Regent\'s Park, Oxford Street, and tube stations.', 125.00, 1, 1, 2, 'apartment', TRUE),

('aa0e8400-e29b-41d4-a716-446655440018', '990e8400-e29b-41d4-a716-446655440010', '880e8400-e29b-41d4-a716-446655440018', 'Edinburgh Royal Mile Apartment', 'Historic 2-bedroom apartment on the Royal Mile. Traditional Scottish architecture with castle views. Perfect for exploring Edinburgh\'s Old Town and festivals.', 185.00, 2, 1, 4, 'apartment', TRUE);

-- =============================================================================
-- BOOKING DATA
-- =============================================================================

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, guest_count, special_requests, created_at) VALUES
-- Recent completed bookings
('bb0e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440011', '2024-01-15', '2024-01-18', 555.00, 'completed', 2, 'Late check-in requested', '2024-01-10 14:30:00'),
('bb0e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440012', '2024-01-20', '2024-01-25', 1750.00, 'completed', 3, 'Need parking space', '2024-01-15 09:15:00'),
('bb0e8400-e29b-41d4-a716-446655440003', 'aa0e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440013', '2024-02-01', '2024-02-04', 495.00, 'completed', 1, NULL, '2024-01-28 16:45:00'),
('bb0e8400-e29b-41d4-a716-446655440004', 'aa0e8400-e29b-41d4-a716-446655440009', '990e8400-e29b-41d4-a716-446655440014', '2024-02-10', '2024-02-14', 1100.00, 'completed', 4, 'Celebrating anniversary', '2024-02-05 11:20:00'),
('bb0e8400-e29b-41d4-a716-446655440005', 'aa0e8400-e29b-41d4-a716-446655440011', '990e8400-e29b-41d4-a716-446655440015', '2024-02-14', '2024-02-17', 855.00, 'completed', 2, 'Valentine\'s Day trip', '2024-02-08 13:10:00'),

-- Current/recent confirmed bookings
('bb0e8400-e29b-41d4-a716-446655440006', 'aa0e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440016', '2024-03-01', '2024-03-05', 900.00, 'confirmed', 3, 'Business trip', '2024-02-20 10:30:00'),
('bb0e8400-e29b-41d4-a716-446655440007', 'aa0e8400-e29b-41d4-a716-446655440008', '990e8400-e29b-41d4-a716-446655440017', '2024-03-10', '2024-03-13', 1455.00, 'confirmed', 4, 'Family vacation', '2024-02-25 15:45:00'),
('bb0e8400-e29b-41d4-a716-446655440008', 'aa0e8400-e29b-41d4-a716-446655440013', '990e8400-e29b-41d4-a716-446655440018', '2024-03-15', '2024-03-18', 585.00, 'confirmed', 2, NULL, '2024-03-01 08:20:00'),
('bb0e8400-e29b-41d4-a716-446655440009', 'aa0e8400-e29b-41d4-a716-446655440015', '990e8400-e29b-41d4-a716-446655440019', '2024-03-20', '2024-03-24', 660.00, 'confirmed', 2, 'Conference attendance', '2024-03-05 12:15:00'),
('bb0e8400-e29b-41d4-a716-446655440010', 'aa0e8400-e29b-41d4-a716-446655440017', '990e8400-e29b-41d4-a716-446655440020', '2024-04-01', '2024-04-05', 500.00, 'confirmed', 1, 'Solo travel', '2024-03-15 14:30:00'),

-- Future pending bookings
('bb0e8400-e29b-41d4-a716-446655440011', 'aa0e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440011', '2024-04-15', '2024-04-18', 2250.00, 'pending', 6, 'Group celebration', '2024-03-20 16:45:00'),
('bb0e8400-e29b-41d4-a716-446655440012', 'aa0e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655440012', '2024-05-01', '2024-05-04', 885.00, 'pending', 3, 'Broadway shows', '2024-04-01 11:30:00'),
('bb0e8400-e29b-41d4-a716-446655440013', 'aa0e8400-e29b-41d4-a716-446655440012', '990e8400-e29b-41d4-a716-446655440013', '2024-05-10', '2024-05-14', 1700.00, 'pending', 2, 'Honeymoon', '2024-04-15 09:20:00'),

-- Some cancelled bookings (realistic scenario)
('bb0e8400-e29b-41d4-a716-446655440014', 'aa0e8400-e29b-41d4-a716-446655440010', '990e8400-e29b-41d4-a716-446655440014', '2024-02-20', '2024-02-23', 435.00, 'cancelled', 2, 'Change of plans', '2024-02-10 13:45:00'),
('bb0e8400-e29b-41d4-a716-446655440015', 'aa0e8400-e29b-41d4-a716-446655440014', '990e8400-e29b-41d4-a716-446655440015', '2024-03-05', '2024-03-08', 525.00, 'cancelled', 3, 'Work conflict', '2024-02-28 10:15:00'),

-- Additional bookings for data richness
('bb0e8400-e29b-41d4-a716-446655440016', 'aa0e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440016', '2024-01-25', '2024-01-28', 375.00, 'completed', 1, NULL, '2024-01-20 15:20:00'),
('bb0e8400-e29b-41d4-a716-446655440017', 'aa0e8400-e29b-41d4-a716-446655440016', '990e8400-e29b-41d4-a716-446655440017', '2024-02-05', '2024-02-07', 290.00, 'completed', 2, 'Weekend getaway', '2024-01-30 12:40:00'),
('bb0e8400-e29b-41d4-a716-446655440018', 'aa0e8400-e29b-41d4-a716-446655440018', '990e8400-e29b-41d4-a716-446655440018', '2024-03-25', '2024-03-30', 925.00, 'confirmed', 3, 'Edinburgh Festival', '2024-03-10 14:55:00');

-- =============================================================================
-- PAYMENT DATA
-- =============================================================================

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method, payment_status, transaction_id, currency_code) VALUES
-- Payments for completed bookings
('cc0e8400-e29b-41d4-a716-446655440001', 'bb0e8400-e29b-41d4-a716-446655440001', 555.00, '2024-01-10 14:35:00', 'credit_card', 'completed', 'txn_1abc123def456ghi', 'USD'),
('cc0e8400-e29b-41d4-a716-446655440002', 'bb0e8400-e29b-41d4-a716-446655440002', 1750.00, '2024-01-15 09:20:00', 'credit_card', 'completed', 'txn_2def456ghi789jkl', 'USD'),
('cc0e8400-e29b-41d4-a716-446655440003', 'bb0e8400-e29b-41d4-a716-446655440003', 495.00, '2024-01-28 16:50:00', 'paypal', 'completed', 'txn_3ghi789jkl012mno', 'USD'),
('cc0e8400-e29b-41d4-a716-446655440004', 'bb0e8400-e29b-41d4-a716-446655440004', 1100.00, '2024-02-05 11:25:00', 'stripe', 'completed', 'txn_4jkl012mno345pqr', 'USD'),
('cc0e8400-e29b-41d4-a716-446655440005', 'bb0e8400-e29b-41d4-a716-446655440005', 855.00, '2024-02-08 13:15:00', 'credit_card', 'completed', 'txn_5mno345pqr678stu', 'USD'),

-- Payments for confirmed bookings
('cc0e8400-e29b-41d4-a716-446655440006', 'bb0e8400-e29b-41d4-a716-446655440006', 900.00, '2024-02-20 10:35:00', 'credit_card', 'completed', 'txn_6pqr678stu901vwx', 'USD'),
('cc0e8400-e29b-41d4-a716-446655440007', 'bb0e8400-e29b-41d4-a716-446655440007', 1455.00, '2024-02-25 15:50:00', 'debit_card', 'completed', 'txn_7stu901vwx234yza', 'USD'),
('cc0e8400-e29b-41d4-a716-446655440008', 'bb0e8400-e29b-41d4-a716-446655440008', 585.00, '2024-03-01 08:25:00', 'paypal', 'completed', 'txn_8vwx234yza567bcd', 'USD'),
('cc0e8400-e29b-41d4-a716-446655440009', 'bb0e8400-e29b-41d4-a716-446655440009', 660.00, '2024-03-05 12:20:00', 'credit_card', 'completed', 'txn_9yza567bcd890efg', 'CAD'),
('cc0e8400-e29b-41d4-a716-446655440010', 'bb0e8400-e29b-41d4-a716-446655440010', 500.00, '2024-03-15 14:35:00', 'stripe', 'completed', 'txn_0bcd890efg123hij', 'GBP'),

-- Pending payments
('cc0e8400-e29b-41d4-a716-446655440011', 'bb0e8400-e29b-41d4-a716-446655440011', 2250.00, '2024-03-20 16:50:00', 'bank_transfer', 'pending', 'txn_1efg123hij456klm', 'USD'),
('cc0e8400-e29b-41d4-a716-446655440012', 'bb0e8400-e29b-41d4-a716-446655440012', 885.00, '2024-04-01 11:35:00', 'credit_card', 'pending', 'txn_2hij456klm789nop', 'USD'),
('cc0e8400-e29b-41d4-a716-446655440013', 'bb0e8400-e29b-41d4-a716-446655440013', 1700.00, '2024-04-15 09:25:00', 'credit_card', 'pending', 'txn_3klm789nop012qrs', 'USD'),

-- Additional payments for completed bookings
('cc0e8400-e29b-41d4-a716-446655440014', 'bb0e8400-e29b-41d4-a716-446655440016', 375.00, '2024-01-20 15:25:00', 'paypal', 'completed', 'txn_4nop012qrs345tuv', 'USD'),
('cc0e8400-e29b-41d4-a716-446655440015', 'bb0e8400-e29b-41d4-a716-446655440017', 290.00, '2024-01-30 12:45:00', 'stripe', 'completed', 'txn_5qrs345tuv678wxy', 'CAD'),
('cc0e8400-e29b-41d4-a716-446655440016', 'bb0e8400-e29b-41d4-a716-446655440018', 925.00, '2024-03-10 15:00:00', 'credit_card', 'completed', 'txn_6tuv678wxy901zab', 'GBP');

-- =============================================================================
-- REVIEW DATA
-- =============================================================================

INSERT INTO Review (review_id, property_id, user_id, booking_id, rating, comment, cleanliness_rating, accuracy_rating, checkin_rating, communication_rating, location_rating, value_rating, created_at) VALUES
-- Reviews for completed bookings
('dd0e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440011', 'bb0e8400-e29b-41d4-a716-446655440001', 5, 'Absolutely loved this place! The location was perfect for exploring San Francisco, and Sarah was an amazing host. The loft was exactly as described - clean, comfortable, and stylish. Would definitely book again!', 5, 5, 5, 5, 5, 4, '2024-01-19 10:30:00'),

('dd0e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440012', 'bb0e8400-e29b-41d4-a716-446655440002', 4, 'Great location on Sunset Strip with amazing views. The condo was luxurious and well-appointed. Only minor issue was some noise from the street at night, but overall excellent experience. Michael was very responsive to questions.', 4, 5, 5, 5, 5, 4, '2024-01-26 14:15:00'),

('dd0e8400-e29b-41d4-a716-446655440003', 'aa0e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440013', 'bb0e8400-e29b-41d4-a716-446655440003', 5, 'Perfect studio for my business trip to NYC. Emily was incredibly helpful with check-in instructions and local recommendations. The location couldn\'t be better - walking distance to everything I needed. Highly recommend!', 5, 5, 5, 5, 5, 5, '2024-02-05 09:45:00'),

('dd0e8400-e29b-41d4-a716-446655440004', 'aa0e8400-e29b-41d4-a716-446655440009', '990e8400-e29b-41d4-a716-446655440014', 'bb0e8400-e29b-41d4-a716-446655440004', 5, 'What a fantastic house for our anniversary celebration! David was an excellent host - very welcoming and provided great local tips. The house was spacious, clean, and the outdoor patio was perfect for morning coffee. Austin is amazing!', 5, 5, 4, 5, 5, 5, '2024-02-15 16:20:00'),

('dd0e8400-e29b-41d4-a716-446655440005', 'aa0e8400-e29b-41d4-a716-446655440011', '990e8400-e29b-41d4-a716-446655440015', 'bb0e8400-e29b-41d4-a716-446655440005', 4, 'Lovely Valentine\'s Day getaway! The Art Deco building has so much character and the ocean views were breathtaking. Jessica was great to work with. The place was clean and well-located, though parking was a bit challenging. Still a wonderful experience overall!', 4, 4, 4, 5, 5, 4, '2024-02-18 11:30:00'),

('dd0e8400-e29b-41d4-a716-446655440006', 'aa0e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440016', 'bb0e8400-e29b-41d4-a716-446655440016', 5, 'Charming Victorian studio with authentic San Francisco character! The location in the Mission was perfect for exploring local restaurants and nightlife. Host was responsive and the space was exactly as advertised. Great value for money.', 5, 5, 5, 4, 5, 5, '2024-01-29 13:15:00'),

('dd0e8400-e29b-41d4-a716-446655440007', 'aa0e8400-e29b-41d4-a716-446655440016', '990e8400-e29b-41d4-a716-446655440017', 'bb0e8400-e29b-41d4-a716-446655440017', 4, 'Nice weekend getaway in Vancouver! The waterfront views were stunning and the location was convenient for exploring the city. The apartment was clean and modern. Host provided good communication throughout our stay.', 4, 4, 4, 4, 5, 4, '2024-02-08 15:45:00'),

-- Additional reviews with varied ratings
('dd0e8400-e29b-41d4-a716-446655440008', 'aa0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440012', NULL, 3, 'The location was great and Sarah was helpful, but the loft showed some wear and tear. The heating wasn\'t working properly during our January stay. Good for the price, but could use some updates.', 3, 4, 3, 4, 5, 4, '2024-02-10 12:00:00'),

('dd0e8400-e29b-41d4-a716-446655440009', 'aa0e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440013', NULL, 4, 'Great apartment in the Mission! Very spacious and clean, perfect for our group. The neighborhood has amazing food options. Sarah was responsive to our questions. Only issue was some street noise, but that\'s expected in this vibrant area.', 4, 5, 4, 5, 4, 4, '2024-02-20 10:30:00'),

('dd0e8400-e29b-41d4-a716-446655440010', 'aa0e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440014', NULL, 5, 'Incredible luxury condo! Michael went above and beyond to make our stay special. The views are absolutely stunning, especially at sunset. The building amenities were excellent and the location can\'t be beat. Worth every penny!', 5, 5, 5, 5, 5, 4, '2024-03-01 14:20:00'),

('dd0e8400-e29b-41d4-a716-446655440011', 'aa0e8400-e29b-41d4-a716-446655440008', '990e8400-e29b-41d4-a716-446655440015', NULL, 5, 'Dream apartment with Central Park views! Emily was fantastic - great communication and helpful recommendations. The apartment was immaculate and beautifully decorated. Perfect for our family trip to NYC. The kids loved watching the park from the windows!', 5, 5, 5, 5, 5, 5, '2024-03-05 16:45:00'),

('dd0e8400-e29b-41d4-a716-446655440012', 'aa0e8400-e29b-41d4-a716-446655440013', '990e8400-e29b-41d4-a716-446655440016', NULL, 4, 'Cool loft overlooking Pike Place Market! Ryan was a great host with lots of local knowledge. The space had character and the location was unbeatable for exploring Seattle. Coffee shops everywhere! Minor issues with WiFi but overall very satisfied.', 4, 4, 4, 5, 5, 4, '2024-02-25 11:15:00');

-- =============================================================================
-- MESSAGE DATA
-- =============================================================================

INSERT INTO Message (message_id, sender_id, recipient_id, property_id, booking_id, subject, message_body, is_read, sent_at, read_at) VALUES
-- Pre-booking inquiries
('ee0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440011', '990e8400-e29b-41d4-a716-446655440003', 'aa0e8400-e29b-41d4-a716-446655440001', NULL, 'Inquiry about Downtown Loft', 'Hi Sarah! I\'m interested in booking your cozy downtown loft for January 15-18. Is it available? Also, is late check-in possible? Thank you!', TRUE, '2024-01-09 14:20:00', '2024-01-09 16:30:00'),

('ee0e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440011', 'aa0e8400-e29b-41d4-a716-446655440001', NULL, 'Re: Inquiry about Downtown Loft', 'Hi Amanda! Yes, the loft is available for those dates. Late check-in is absolutely fine - I\'ll send you the keypad code. Looking forward to hosting you!', TRUE, '2024-01-09 17:15:00', '2024-01-09 18:45:00'),

('ee0e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440012', '990e8400-e29b-41d4-a716-446655440004', 'aa0e8400-e29b-41d4-a716-446655440004', NULL, 'Business trip booking question', 'Hello Michael, I need accommodation for 3 people for a business trip Jan 20-25. Does your Sunset Strip condo have a parking space? This would be perfect for our needs.', TRUE, '2024-01-14 09:30:00', '2024-01-14 11:00:00'),

('ee0e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440012', 'aa0e8400-e29b-41d4-a716-446655440004', NULL, 'Re: Business trip booking question', 'Hi Christopher! Yes, we have one assigned parking space in the building garage. I\'ll include the parking details in your check-in instructions. The condo will be perfect for your business trip!', TRUE, '2024-01-14 12:30:00', '2024-01-14 14:20:00'),

-- Booking-related communications
('ee0e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440011', 'aa0e8400-e29b-41d4-a716-446655440001', 'bb0e8400-e29b-41d4-a716-446655440001', 'Check-in instructions', 'Hi Amanda! Looking forward to your stay tomorrow. The keypad code is 5824#. WiFi password is SF2024guest. Local coffee shop recommendations: Blue Bottle is 2 blocks away. Let me know if you need anything!', TRUE, '2024-01-14 16:45:00', '2024-01-14 19:20:00'),

('ee0e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440011', '990e8400-e29b-41d4-a716-446655440003', 'aa0e8400-e29b-41d4-a716-446655440001', 'bb0e8400-e29b-41d4-a716-446655440001', 'Thank you!', 'Sarah, thank you so much for the wonderful stay! Everything was perfect. We especially loved the location and your local recommendations. Will definitely book again when we\'re back in SF!', TRUE, '2024-01-18 11:30:00', '2024-01-18 13:15:00'),

('ee0e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440017', 'aa0e8400-e29b-41d4-a716-446655440007', 'bb0e8400-e29b-41d4-a716-446655440007', 'Pre-arrival information', 'Hi Rachel! Your Broadway loft is ready for your March 10-13 stay. I\'ve included a list of current Broadway shows and ticket office locations. The apartment has a great view of the theater district!', TRUE, '2024-03-08 14:20:00', '2024-03-08 16:45:00'),

-- Support and service messages
('ee0e8400-e29b-41d4-a716-446655440008', '990e8400-e29b-41d4-a716-446655440014', '990e8400-e29b-41d4-a716-446655440006', 'aa0e8400-e29b-41d4-a716-446655440009', 'bb0e8400-e29b-41d4-a716-446655440004', 'Question about check-out', 'Hi David! We\'re having such a great time at your Austin house. Quick question - what time is check-out tomorrow? Also, where should we leave the keys? Thanks!', TRUE, '2024-02-13 19:30:00', '2024-02-13 20:15:00'),

('ee0e8400-e29b-41d4-a716-446655440009', '990e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440014', 'aa0e8400-e29b-41d4-a716-446655440009', 'bb0e8400-e29b-41d4-a716-446655440004', 'Re: Question about check-out', 'Hi Mark! So glad you\'re enjoying Austin! Check-out is at 11 AM, but if you need a bit more time, that\'s fine. Just leave the keys on the kitchen counter. Safe travels and thanks for being great guests!', TRUE, '2024-02-13 21:00:00', '2024-02-13 21:30:00'),

-- Host-to-guest follow-up messages
('ee0e8400-e29b-41d4-a716-446655440010', '990e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655440015', 'aa0e8400-e29b-41d4-a716-446655440011', 'bb0e8400-e29b-41d4-a716-446655440005', 'Hope you enjoyed Miami!', 'Hi Jennifer! I hope you and your partner had a wonderful Valentine\'s Day weekend in Miami. Would love to hear how your stay was. Feel free to leave a review when you have a moment!', TRUE, '2024-02-18 10:15:00', '2024-02-18 14:30:00'),

-- Recent inquiries and bookings
('ee0e8400-e29b-41d4-a716-446655440011', '990e8400-e29b-41d4-a716-446655440016', '990e8400-e29b-41d4-a716-446655440003', 'aa0e8400-e29b-41d4-a716-446655440002', NULL, 'Group booking inquiry', 'Hello Sarah, I\'m looking to book your Mission District apartment for my team (3 people) for a business trip March 1-5. We\'ll be working from the apartment during the day. Is this suitable? Do you have good WiFi?', TRUE, '2024-02-19 15:45:00', '2024-02-19 17:20:00'),

('ee0e8400-e29b-41d4-a716-446655440012', '990e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440016', 'aa0e8400-e29b-41d4-a716-446655440002', NULL, 'Re: Group booking inquiry', 'Hi Kevin! Yes, the apartment is perfect for business stays. We have high-speed WiFi (fiber optic) and a large dining table that works well as a workspace. The neighborhood has great lunch options too. Booking confirmed!', TRUE, '2024-02-19 18:30:00', '2024-02-19 19:45:00'),

-- International booking communications
('ee0e8400-e29b-41d4-a716-446655440013', '990e8400-e29b-41d4-a716-446655440020', '990e8400-e29b-41d4-a716-446655440010', 'aa0e8400-e29b-41d4-a716-446655440017', 'bb0e8400-e29b-41d4-a716-446655440010', 'Excited for London visit!', 'Hi James! I\'m really looking forward to my solo trip to London next week. This will be my first time visiting the UK. Do you have any must-see recommendations for someone staying near Baker Street?', TRUE, '2024-03-25 16:20:00', '2024-03-25 18:10:00'),

('ee0e8400-e29b-41d4-a716-446655440014', '990e8400-e29b-41d4-a716-446655440010', '990e8400-e29b-41d4-a716-446655440020', 'aa0e8400-e29b-41d4-a716-446655440017', 'bb0e8400-e29b-41d4-a716-446655440010', 'Welcome to London!', 'Hello Andrew! So excited to welcome you to London. For your first visit, I highly recommend the British Museum (walking distance), Regent\'s Park for morning jogs, and Borough Market for amazing food. I\'ll prepare a detailed guide for you!', TRUE, '2024-03-26 09:15:00', '2024-03-26 11:30:00'),

-- Problem resolution messages
('ee0e8400-e29b-41d4-a716-446655440015', '990e8400-e29b-41d4-a716-446655440018', '990e8400-e29b-41d4-a716-446655440008', 'aa0e8400-e29b-41d4-a716-446655440013', 'bb0e8400-e29b-41d4-a716-446655440008', 'Minor WiFi issue', 'Hi Ryan, we\'re loving the Pike Place Market loft! Just wanted to let you know the WiFi has been a bit spotty today. Not a major issue, but thought you should know. Everything else is perfect!', TRUE, '2024-03-16 14:30:00', '2024-03-16 15:45:00'),

('ee0e8400-e29b-41d4-a716-446655440016', '990e8400-e29b-41d4-a716-446655440008', '990e8400-e29b-41d4-a716-446655440018', 'aa0e8400-e29b-41d4-a716-446655440013', 'bb0e8400-e29b-41d4-a716-446655440008', 'Re: Minor WiFi issue', 'Hi Daniel! Thanks for letting me know. I\'ve contacted our internet provider and they\'re sending a technician tomorrow morning. In the meantime, there\'s a great coffee shop with free WiFi just downstairs. Sorry for the inconvenience!', TRUE, '2024-03-16 16:20:00', '2024-03-16 17:00:00'),

-- Future booking confirmations
('ee0e8400-e29b-41d4-a716-446655440017', '990e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440011', 'aa0e8400-e29b-41d4-a716-446655440005', 'bb0e8400-e29b-41d4-a716-446655440011', 'Group celebration details', 'Hi Amanda! Thanks for booking the Hollywood Hills villa for your group celebration. I want to make sure everything is perfect for your April 15-18 stay. Could you let me know more details about your event so I can prepare accordingly?', FALSE, '2024-03-22 10:30:00', NULL),

('ee0e8400-e29b-41d4-a716-446655440018', '990e8400-e29b-41d4-a716-446655440012', '990e8400-e29b-41d4-a716-446655440005', 'aa0e8400-e29b-41d4-a716-446655440007', 'bb0e8400-e29b-41d4-a716-446655440012', 'Broadway show recommendations', 'Hello Emily! My family and I are so excited about our May trip to NYC. We\'re hoping to see some Broadway shows during our stay. What shows would you recommend for a family with teenagers? Also, any tips for getting tickets?', FALSE, '2024-04-02 13:45:00', NULL),

-- Admin communications
('ee0e8400-e29b-41d4-a716-446655440019', '990e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440003', NULL, NULL, 'Host Performance Review', 'Hi Sarah! Hope you\'re doing well. We wanted to reach out about your excellent hosting performance this quarter. Your properties have consistently high ratings and guest satisfaction. Keep up the great work!', TRUE, '2024-03-01 09:00:00', '2024-03-01 11:30:00'),

('ee0e8400-e29b-41d4-a716-446655440020', '990e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440004', NULL, NULL, 'Platform Update Notification', 'Hello Michael! We\'re excited to announce new features coming to our platform next month, including enhanced messaging and better calendar management tools. We\'ll send detailed information soon. Thanks for being a valued host!', FALSE, '2024-03-28 16:20:00', NULL);

-- =============================================================================

-- =============================================================================
-- DATA SUMMARY
-- =============================================================================
/*
This sample data includes:

LOCATION DATA:
- 8 Countries (US, Canada, UK, France, Germany, Spain, Italy, Australia)
- 12 States/Provinces (6 US states, 3 Canadian provinces, 2 UK regions)
- 15 Cities across North America and UK
- 18 Specific addresses with real coordinates

USER DATA:
- 2 Admin users
- 8 Host users across different locations
- 10 Guest users with varied profiles
- All users have realistic email addresses and phone numbers

PROPERTY DATA:
- 18 Properties across major cities
- Variety of property types (apartments, houses, lofts, studios, villas)
- Realistic pricing based on location and property type
- Detailed descriptions reflecting real property listings

BOOKING DATA:
- 18 Bookings with realistic date ranges
- Mix of completed, confirmed, pending, and cancelled bookings
- Varied guest counts and special requests
- Realistic pricing calculations

PAYMENT DATA:
- 16 Payment records matching booking data
- Multiple payment methods (credit card, PayPal, Stripe, bank transfer)
- Different currencies (USD, CAD, GBP)
- Various payment statuses

REVIEW DATA:
- 12 Detailed reviews with realistic content
- Varied ratings from 3-5 stars
- Detailed sub-ratings for different aspects
- Mix of positive feedback and constructive criticism

MESSAGE DATA:
- 20 Messages showing realistic communication patterns
- Pre-booking inquiries and responses
- Check-in instructions and support
- Follow-up messages and problem resolution
- Admin communications

This dataset provides a comprehensive foundation for testing all aspects of the AirBnB platform including:
- Property search and filtering
- Booking workflows
- Payment processing
- Review systems
- Communication features
- Analytics and reporting
- Geographic queries
- Multi-currency support
*/