-- =============================================================================
-- AirBnB Database Schema - SQL DDL Statements
-- Third Normal Form (3NF) Compliant Design
-- =============================================================================

-- =============================================================================
-- DROP TABLES (for schema recreation - use with caution)
-- =============================================================================

-- DROP TABLE IF EXISTS Message CASCADE;
-- DROP TABLE IF EXISTS Review CASCADE;
-- DROP TABLE IF EXISTS Payment CASCADE;
-- DROP TABLE IF EXISTS Booking CASCADE;
-- DROP TABLE IF EXISTS Property CASCADE;
-- DROP TABLE IF EXISTS Address CASCADE;
-- DROP TABLE IF EXISTS City CASCADE;
-- DROP TABLE IF EXISTS State CASCADE;
-- DROP TABLE IF EXISTS Country CASCADE;
-- DROP TABLE IF EXISTS User CASCADE;

-- =============================================================================
-- LOCATION HIERARCHY TABLES (New for 3NF Compliance)
-- =============================================================================

-- Country Table
CREATE TABLE Country (
    country_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    country_name VARCHAR(100) NOT NULL,
    country_code CHAR(2) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- State/Province Table
CREATE TABLE State (
    state_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    country_id UUID NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    state_code VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_state_country 
        FOREIGN KEY (country_id) REFERENCES Country(country_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- City Table
CREATE TABLE City (
    city_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    state_id UUID NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_city_state 
        FOREIGN KEY (state_id) REFERENCES State(state_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Address Table
CREATE TABLE Address (
    address_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    city_id UUID NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    apartment_unit VARCHAR(50),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_address_city 
        FOREIGN KEY (city_id) REFERENCES City(city_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
        
    -- Check Constraints
    CONSTRAINT chk_latitude_range 
        CHECK (latitude >= -90 AND latitude <= 90),
    CONSTRAINT chk_longitude_range 
        CHECK (longitude >= -180 AND longitude <= 180)
);

-- =============================================================================
-- CORE BUSINESS TABLES
-- =============================================================================

-- User Table
CREATE TABLE "User" (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role VARCHAR(10) NOT NULL DEFAULT 'guest',
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Check Constraints
    CONSTRAINT chk_user_role 
        CHECK (role IN ('guest', 'host', 'admin')),
    CONSTRAINT chk_email_format 
        CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_name_length 
        CHECK (length(trim(first_name)) > 0 AND length(trim(last_name)) > 0)
);

-- Property Table (Updated for 3NF compliance)
CREATE TABLE Property (
    property_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id UUID NOT NULL,
    address_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    bedrooms INTEGER DEFAULT 1,
    bathrooms INTEGER DEFAULT 1,
    max_guests INTEGER DEFAULT 1,
    property_type VARCHAR(50) DEFAULT 'apartment',
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_property_host 
        FOREIGN KEY (host_id) REFERENCES "User"(user_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_property_address 
        FOREIGN KEY (address_id) REFERENCES Address(address_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
        
    -- Check Constraints
    CONSTRAINT chk_price_positive 
        CHECK (price_per_night > 0),
    CONSTRAINT chk_bedrooms_positive 
        CHECK (bedrooms > 0),
    CONSTRAINT chk_bathrooms_positive 
        CHECK (bathrooms > 0),
    CONSTRAINT chk_max_guests_positive 
        CHECK (max_guests > 0),
    CONSTRAINT chk_property_type 
        CHECK (property_type IN ('apartment', 'house', 'villa', 'studio', 'loft', 'other')),
    CONSTRAINT chk_name_length 
        CHECK (length(trim(name)) > 0),
    CONSTRAINT chk_description_length 
        CHECK (length(trim(description)) >= 10)
);

-- Booking Table
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    guest_count INTEGER DEFAULT 1,
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_booking_property 
        FOREIGN KEY (property_id) REFERENCES Property(property_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_booking_user 
        FOREIGN KEY (user_id) REFERENCES "User"(user_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
        
    -- Check Constraints
    CONSTRAINT chk_booking_dates 
        CHECK (end_date > start_date),
    CONSTRAINT chk_booking_status 
        CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
    CONSTRAINT chk_total_price_positive 
        CHECK (total_price > 0),
    CONSTRAINT chk_guest_count_positive 
        CHECK (guest_count > 0),
    CONSTRAINT chk_future_start_date 
        CHECK (start_date >= CURRENT_DATE)
);

-- Payment Table
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(20) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'pending',
    transaction_id VARCHAR(255),
    currency_code CHAR(3) DEFAULT 'USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_payment_booking 
        FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
        
    -- Check Constraints
    CONSTRAINT chk_payment_amount_positive 
        CHECK (amount > 0),
    CONSTRAINT chk_payment_method 
        CHECK (payment_method IN ('credit_card', 'debit_card', 'paypal', 'stripe', 'bank_transfer')),
    CONSTRAINT chk_payment_status 
        CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
    CONSTRAINT chk_currency_code_format 
        CHECK (currency_code ~ '^[A-Z]{3}$')
);

-- Review Table
CREATE TABLE Review (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    booking_id UUID,
    rating INTEGER NOT NULL,
    comment TEXT NOT NULL,
    cleanliness_rating INTEGER,
    accuracy_rating INTEGER,
    checkin_rating INTEGER,
    communication_rating INTEGER,
    location_rating INTEGER,
    value_rating INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_review_property 
        FOREIGN KEY (property_id) REFERENCES Property(property_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_review_user 
        FOREIGN KEY (user_id) REFERENCES "User"(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_review_booking 
        FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
        
    -- Check Constraints
    CONSTRAINT chk_rating_range 
        CHECK (rating >= 1 AND rating <= 5),
    CONSTRAINT chk_cleanliness_rating_range 
        CHECK (cleanliness_rating IS NULL OR (cleanliness_rating >= 1 AND cleanliness_rating <= 5)),
    CONSTRAINT chk_accuracy_rating_range 
        CHECK (accuracy_rating IS NULL OR (accuracy_rating >= 1 AND accuracy_rating <= 5)),
    CONSTRAINT chk_checkin_rating_range 
        CHECK (checkin_rating IS NULL OR (checkin_rating >= 1 AND checkin_rating <= 5)),
    CONSTRAINT chk_communication_rating_range 
        CHECK (communication_rating IS NULL OR (communication_rating >= 1 AND communication_rating <= 5)),
    CONSTRAINT chk_location_rating_range 
        CHECK (location_rating IS NULL OR (location_rating >= 1 AND location_rating <= 5)),
    CONSTRAINT chk_value_rating_range 
        CHECK (value_rating IS NULL OR (value_rating >= 1 AND value_rating <= 5)),
    CONSTRAINT chk_comment_length 
        CHECK (length(trim(comment)) >= 10)
);

-- Message Table
CREATE TABLE Message (
    message_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    property_id UUID,
    booking_id UUID,
    subject VARCHAR(255),
    message_body TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_message_sender 
        FOREIGN KEY (sender_id) REFERENCES "User"(user_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_message_recipient 
        FOREIGN KEY (recipient_id) REFERENCES "User"(user_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_message_property 
        FOREIGN KEY (property_id) REFERENCES Property(property_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_message_booking 
        FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
        
    -- Check Constraints
    CONSTRAINT chk_different_users 
        CHECK (sender_id != recipient_id),
    CONSTRAINT chk_message_body_length 
        CHECK (length(trim(message_body)) > 0),
    CONSTRAINT chk_read_timestamp 
        CHECK (read_at IS NULL OR read_at >= sent_at)
);

-- =============================================================================
-- PERFORMANCE INDEXES
-- =============================================================================

-- Location Hierarchy Indexes
CREATE INDEX idx_country_code ON Country(country_code);
CREATE INDEX idx_country_name ON Country(country_name);

CREATE INDEX idx_state_country ON State(country_id);
CREATE INDEX idx_state_name ON State(state_name);

CREATE INDEX idx_city_state ON City(state_id);
CREATE INDEX idx_city_name ON City(city_name);
CREATE INDEX idx_city_postal ON City(postal_code);

CREATE INDEX idx_address_city ON Address(city_id);
CREATE INDEX idx_address_coordinates ON Address(latitude, longitude);

-- User Table Indexes
CREATE INDEX idx_user_email ON "User"(email);
CREATE INDEX idx_user_role ON "User"(role);
CREATE INDEX idx_user_active ON "User"(is_active);
CREATE INDEX idx_user_created ON "User"(created_at);

-- Property Table Indexes
CREATE INDEX idx_property_host ON Property(host_id);
CREATE INDEX idx_property_address ON Property(address_id);
CREATE INDEX idx_property_available ON Property(is_available);
CREATE INDEX idx_property_price ON Property(price_per_night);
CREATE INDEX idx_property_type ON Property(property_type);
CREATE INDEX idx_property_created ON Property(created_at);

-- Booking Table Indexes
CREATE INDEX idx_booking_property ON Booking(property_id);
CREATE INDEX idx_booking_user ON Booking(user_id);
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_booking_created ON Booking(created_at);

-- Composite index for availability checking
CREATE INDEX idx_booking_property_dates_status ON Booking(property_id, start_date, end_date, status);

-- Payment Table Indexes
CREATE INDEX idx_payment_booking ON Payment(booking_id);
CREATE INDEX idx_payment_date ON Payment(payment_date);
CREATE INDEX idx_payment_status ON Payment(payment_status);
CREATE INDEX idx_payment_method ON Payment(payment_method);
CREATE INDEX idx_payment_transaction ON Payment(transaction_id);

-- Review Table Indexes
CREATE INDEX idx_review_property ON Review(property_id);
CREATE INDEX idx_review_user ON Review(user_id);
CREATE INDEX idx_review_booking ON Review(booking_id);
CREATE INDEX idx_review_rating ON Review(rating);
CREATE INDEX idx_review_created ON Review(created_at);

-- Message Table Indexes
CREATE INDEX idx_message_sender ON Message(sender_id);
CREATE INDEX idx_message_recipient ON Message(recipient_id);
CREATE INDEX idx_message_property ON Message(property_id);
CREATE INDEX idx_message_booking ON Message(booking_id);
CREATE INDEX idx_message_sent ON Message(sent_at);
CREATE INDEX idx_message_unread ON Message(recipient_id, is_read, sent_at);

-- =============================================================================
-- ADDITIONAL CONSTRAINTS AND BUSINESS RULES
-- =============================================================================

-- Unique constraint to prevent duplicate bookings for same property/dates
CREATE UNIQUE INDEX idx_unique_confirmed_booking 
ON Booking(property_id, start_date, end_date) 
WHERE status IN ('confirmed', 'pending');

-- Prevent users from reviewing their own properties
ALTER TABLE Review ADD CONSTRAINT chk_no_self_review 
CHECK (user_id != (SELECT host_id FROM Property WHERE Property.property_id = Review.property_id));

-- Ensure booking dates don't overlap for confirmed bookings (handled by unique index above)

-- Prevent future-dated reviews (reviews should be after booking end date)
ALTER TABLE Review ADD CONSTRAINT chk_review_after_stay 
CHECK (
    booking_id IS NULL OR 
    created_at >= (SELECT end_date FROM Booking WHERE Booking.booking_id = Review.booking_id)
);

-- =============================================================================
-- SAMPLE DATA INSERTION (Optional - for testing)
-- =============================================================================

-- Insert sample countries
INSERT INTO Country (country_name, country_code) VALUES 
('United States', 'US'),
('Canada', 'CA'),
('United Kingdom', 'GB'),
('France', 'FR'),
('Germany', 'DE'),
('Spain', 'ES'),
('Italy', 'IT'),
('Australia', 'AU');

-- Insert sample states for US
INSERT INTO State (country_id, state_name, state_code) VALUES 
((SELECT country_id FROM Country WHERE country_code = 'US'), 'California', 'CA'),
((SELECT country_id FROM Country WHERE country_code = 'US'), 'New York', 'NY'),
((SELECT country_id FROM Country WHERE country_code = 'US'), 'Texas', 'TX'),
((SELECT country_id FROM Country WHERE country_code = 'US'), 'Florida', 'FL');

-- Insert sample cities
INSERT INTO City (state_id, city_name, postal_code) VALUES 
((SELECT state_id FROM State WHERE state_name = 'California'), 'San Francisco', '94102'),
((SELECT state_id FROM State WHERE state_name = 'California'), 'Los Angeles', '90210'),
((SELECT state_id FROM State WHERE state_name = 'New York'), 'New York City', '10001'),
((SELECT state_id FROM State WHERE state_name = 'Texas'), 'Austin', '73301');

-- =============================================================================
-- VIEWS FOR COMMON QUERIES (Optional)
-- =============================================================================

-- View for property details with full address
CREATE VIEW PropertyWithAddress AS
SELECT 
    p.property_id,
    p.name,
    p.description,
    p.price_per_night,
    p.bedrooms,
    p.bathrooms,
    p.max_guests,
    p.property_type,
    p.is_available,
    a.street_address,
    a.apartment_unit,
    c.city_name,
    c.postal_code,
    s.state_name,
    s.state_code,
    co.country_name,
    co.country_code,
    a.latitude,
    a.longitude,
    u.first_name || ' ' || u.last_name AS host_name,
    u.email AS host_email,
    p.created_at,
    p.updated_at
FROM Property p
JOIN Address a ON p.address_id = a.address_id
JOIN City c ON a.city_id = c.city_id
JOIN State s ON c.state_id = s.state_id
JOIN Country co ON s.country_id = co.country_id
JOIN "User" u ON p.host_id = u.user_id;

-- View for booking details with property and user info
CREATE VIEW BookingDetails AS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.guest_count,
    p.name AS property_name,
    p.property_type,
    u.first_name || ' ' || u.last_name AS guest_name,
    u.email AS guest_email,
    h.first_name || ' ' || h.last_name AS host_name,
    h.email AS host_email,
    c.city_name,
    s.state_name,
    co.country_name,
    b.created_at
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
JOIN "User" u ON b.user_id = u.user_id
JOIN "User" h ON p.host_id = h.user_id
JOIN Address a ON p.address_id = a.address_id
JOIN City c ON a.city_id = c.city_id
JOIN State s ON c.state_id = s.state_id
JOIN Country co ON s.country_id = co.country_id;

-- =============================================================================
-- FUNCTIONS AND TRIGGERS (Optional)
-- =============================================================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply the trigger to relevant tables
CREATE TRIGGER update_user_updated_at BEFORE UPDATE ON "User" 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_property_updated_at BEFORE UPDATE ON Property 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_country_updated_at BEFORE UPDATE ON Country 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_state_updated_at BEFORE UPDATE ON State 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_city_updated_at BEFORE UPDATE ON City 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_address_updated_at BEFORE UPDATE ON Address 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================================================
-- SECURITY AND PERMISSIONS (Optional)
-- =============================================================================

-- Create roles for different user types
-- CREATE ROLE airbnb_admin;
-- CREATE ROLE airbnb_host;
-- CREATE ROLE airbnb_guest;
-- CREATE ROLE airbnb_readonly;

-- Grant appropriate permissions
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO airbnb_admin;
-- GRANT SELECT, INSERT, UPDATE ON Property, Booking, Review, Message TO airbnb_host;
-- GRANT SELECT, INSERT, UPDATE ON Booking, Review, Message TO airbnb_guest;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO airbnb_readonly;