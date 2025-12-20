-- Project: Roommate Finder
-- Database Schema based on ER Diagram

-- Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(20),
    preferred_location VARCHAR(255),
    password VARCHAR(255) NOT NULL,
    maintenance_id INT -- FK added later or nullable if circular
);

-- Rooms table
CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    owner_id INT NOT NULL, -- References users(user_id) usually, but could be specific Owner table if exists. Assuming User.
    address TEXT NOT NULL,
    rent_amount DECIMAL(10, 2) NOT NULL,
    description TEXT,
    room_type VARCHAR(50),
    availability_status VARCHAR(50) DEFAULT 'Available',
    gender_preference VARCHAR(20), -- 'gender' in diagram
    current_tenant_id INT, -- 'user_id' in diagram, nullable
    FOREIGN KEY (owner_id) REFERENCES users(user_id),
    FOREIGN KEY (current_tenant_id) REFERENCES users(user_id)
);

-- Admin table
CREATE TABLE admins (
    admin_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50),
    location VARCHAR(255),
    -- FKs to other tables based on diagram, though unusual for Admin to link to specific room/visitor in schema definition unless it's an assignment?
    assigned_user_id INT,
    assigned_room_id INT,
    assigned_visitor_id INT,
    FOREIGN KEY (assigned_user_id) REFERENCES users(user_id),
    FOREIGN KEY (assigned_room_id) REFERENCES rooms(room_id)
    -- visitor_id FK added after visitor_log table
);

-- Maintenance table
CREATE TABLE maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    issue_details TEXT,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Roommate table (Potential matches or listings?)
CREATE TABLE roommates (
    roommate_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Payment table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    payment_date DATE,
    due_date DATE,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Visitor Log table
CREATE TABLE visitor_log (
    visitor_id SERIAL PRIMARY KEY,
    visitor_name VARCHAR(100) NOT NULL,
    purpose VARCHAR(255),
    entry_time TIMESTAMP,
    exit_time TIMESTAMP,
    resident_id INT NOT NULL, -- 'resident_id' in diagram, refers to User
    room_id INT NOT NULL,
    FOREIGN KEY (resident_id) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Booking Request table
CREATE TABLE booking_requests (
    request_id SERIAL PRIMARY KEY, -- Synthesized PK for easier management
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    admin_id INT, -- Optional admin handling
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (admin_id) REFERENCES admins(admin_id)
);

-- Add missing FK for Admin -> Visitor
ALTER TABLE admins ADD CONSTRAINT fk_admin_visitor FOREIGN KEY (assigned_visitor_id) REFERENCES visitor_log(visitor_id);

-- Add missing FK for User -> Maintenance (if 1:1 or N:1, but user has maintenance_id column)
ALTER TABLE users ADD CONSTRAINT fk_user_maintenance FOREIGN KEY (maintenance_id) REFERENCES maintenance(maintenance_id);
