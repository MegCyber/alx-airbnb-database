-- Create indexes for high-usage columns in User, Booking, and Property tables

-- USER TABLE INDEXES
-- Index on email (frequently used in WHERE clauses for user authentication)
CREATE INDEX idx_user_email ON User(email);

-- Index on phone_number (used for user lookup)
CREATE INDEX idx_user_phone ON User(phone_number);

-- Index on role (used for filtering users by type: guest, host, admin)
CREATE INDEX idx_user_role ON User(role);

-- Composite index on first_name and last_name (used for name searches)
CREATE INDEX idx_user_fullname ON User(first_name, last_name);

-- Index on created_at (used for sorting and filtering by registration date)
CREATE INDEX idx_user_created_at ON User(created_at);

-- BOOKING TABLE INDEXES
-- Index on user_id (foreign key, frequently joined)
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index on property_id (foreign key, frequently joined)
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index on start_date (used for date range queries and sorting)
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Index on end_date (used for date range queries)
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Index on status (used for filtering confirmed, pending, cancelled bookings)
CREATE INDEX idx_booking_status ON Booking(status);

-- Composite index on start_date and end_date (for date range queries)
CREATE INDEX idx_booking_date_range ON Booking(start_date, end_date);

-- Composite index on property_id and start_date (for property availability queries)
CREATE INDEX idx_booking_property_date ON Booking(property_id, start_date);

-- Index on total_price (used for sorting and filtering by price)
CREATE INDEX idx_booking_total_price ON Booking(total_price);

-- Index on created_at (used for sorting bookings by creation time)
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- PROPERTY TABLE INDEXES
-- Index on host_id (foreign key, frequently joined)
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on location (used for searching properties by location)
CREATE INDEX idx_property_location ON Property(location);

-- Index on pricepernight (used for price range filtering and sorting)
CREATE INDEX idx_property_pricepernight ON Property(pricepernight);

-- Index on name (used for property name searches)
CREATE INDEX idx_property_name ON Property(name);

-- Composite index on location and pricepernight (common search combination)
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- Index on created_at (used for sorting properties by creation date)
CREATE INDEX idx_property_created_at ON Property(created_at);

-- REVIEW TABLE INDEXES (if applicable)
-- Index on property_id (foreign key, frequently joined)
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index on user_id (foreign key, frequently joined)
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Index on rating (used for filtering and sorting by rating)
CREATE INDEX idx_review_rating ON Review(rating);

-- Index on created_at (used for sorting reviews by date)
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index on property_id and rating (for property rating queries)
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- PAYMENT TABLE INDEXES (if applicable)
-- Index on booking_id (foreign key, frequently joined)
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index on payment_date (used for date-based queries)
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Index on payment_method (used for filtering by payment type)
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Index on amount (used for financial reporting)
CREATE INDEX idx_payment_amount ON Payment(amount);

-- MESSAGE TABLE INDEXES (if applicable)
-- Index on sender_id (foreign key, frequently joined)
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Index on recipient_id (foreign key, frequently joined)
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Index on sent_at (used for sorting messages by time)
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for conversation queries
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- SPECIALIZED INDEXES FOR COMMON QUERY PATTERNS

-- Partial index for active bookings only (more efficient for status-specific queries)
CREATE INDEX idx_booking_confirmed_dates ON Booking(start_date, end_date) 
WHERE status = 'confirmed';

-- Partial index for available properties (assuming a status column exists)
CREATE INDEX idx_property_available_location ON Property(location, pricepernight) 
WHERE status = 'available';

-- Functional index for case-insensitive email searches
CREATE INDEX idx_user_email_lower ON User(LOWER(email));

-- Functional index for case-insensitive location searches
CREATE INDEX idx_property_location_lower ON Property(LOWER(location));
