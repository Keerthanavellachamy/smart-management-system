-- =========================================================
-- SMART CAMPUS MANAGEMENT SYSTEM DATABASE
-- =========================================================

CREATE DATABASE IF NOT EXISTS smart_campus;
USE smart_campus;


-- =========================================================
-- 1. USERS
-- =========================================================

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(120) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student','faculty','admin') NOT NULL
);


-- =========================================================
-- 2. DEPARTMENTS
-- =========================================================

CREATE TABLE IF NOT EXISTS departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(80) UNIQUE NOT NULL
);


-- =========================================================
-- 3. STUDENTS
-- =========================================================

CREATE TABLE IF NOT EXISTS students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    register_no VARCHAR(30) UNIQUE NOT NULL,
    name VARCHAR(120) NOT NULL,
    dept_id INT,
    year_no INT,
    section VARCHAR(10),
    email VARCHAR(120),
    phone VARCHAR(20),
    dob DATE,
    cgpa DECIMAL(3,2),
    status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
);


-- =========================================================
-- 4. FACULTY
-- =========================================================

CREATE TABLE IF NOT EXISTS faculty (
    faculty_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120) NOT NULL,
    dept_id INT,
    designation VARCHAR(80),
    email VARCHAR(120),
    phone VARCHAR(20),
    experience_years INT,
    availability VARCHAR(30),

    FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
);


-- =========================================================
-- 5. COURSES
-- =========================================================

CREATE TABLE IF NOT EXISTS courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(30) UNIQUE,
    course_name VARCHAR(120),
    dept_id INT,
    semester INT,
    credits INT,
    faculty_id INT,

    FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id),

    FOREIGN KEY (faculty_id)
        REFERENCES faculty(faculty_id)
);


-- =========================================================
-- 6. ENROLLMENTS
-- =========================================================

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,

    FOREIGN KEY (student_id)
        REFERENCES students(student_id),

    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);


-- =========================================================
-- 7. ATTENDANCE
-- =========================================================

CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    class_date DATE,
    status ENUM('Present','Absent','Leave'),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id),

    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);


-- =========================================================
-- 8. CLASSROOMS
-- =========================================================

CREATE TABLE IF NOT EXISTS classrooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(30),
    building VARCHAR(60),
    capacity INT,
    floor_no INT,
    equipment TEXT,
    current_class VARCHAR(60),
    status ENUM('Available','Occupied','Reserved')
);


-- =========================================================
-- 9. BUSES
-- =========================================================

CREATE TABLE IF NOT EXISTS buses (
    bus_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_number VARCHAR(30),
    driver VARCHAR(120),
    route VARCHAR(255),
    capacity INT,
    departure_time TIME,
    status VARCHAR(30)
);


-- =========================================================
-- 10. ROUTES
-- =========================================================

CREATE TABLE IF NOT EXISTS routes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120),
    stops TEXT
);


-- =========================================================
-- 11. BOOKS
-- DIGITAL LIBRARY
-- =========================================================

USE smart_campus;

DROP TABLE IF EXISTS book_issues;
DROP TABLE IF EXISTS books;

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    book_name VARCHAR(180) NOT NULL,
    author VARCHAR(120) NOT NULL,
    category VARCHAR(80) NOT NULL,
    isbn VARCHAR(30),
    quantity INT NOT NULL DEFAULT 0,
    available_copies INT NOT NULL DEFAULT 0
);

CREATE TABLE book_issues (
    issue_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    student_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20) DEFAULT 'Issued',

    FOREIGN KEY (book_id)
        REFERENCES books(book_id),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id)
);


-- =========================================================
-- 13. EVENTS
-- =========================================================

CREATE TABLE IF NOT EXISTS events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(180),
    event_type VARCHAR(60),
    event_date DATE,
    event_time TIME,
    venue VARCHAR(120),
    organizer VARCHAR(120),
    description TEXT,
    registration_limit INT
);


-- =========================================================
-- 14. EVENT REGISTRATIONS
-- =========================================================

CREATE TABLE IF NOT EXISTS event_registrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    student_id INT,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (event_id)
        REFERENCES events(event_id),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id)
);


-- =========================================================
-- 15. ACHIEVEMENTS
-- =========================================================

CREATE TABLE IF NOT EXISTS achievements (
    achievement_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    achievement VARCHAR(180),
    category VARCHAR(60),
    achievement_date DATE,
    organization VARCHAR(120),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id)
);


-- =========================================================
-- 16. ANNOUNCEMENTS
-- =========================================================

CREATE TABLE IF NOT EXISTS announcements (
    announcement_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(180),
    body TEXT,
    priority VARCHAR(20),
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- 17. NOTIFICATIONS
-- =========================================================

CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(180),
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);


-- =========================================================
-- 18. SUSTAINABILITY
-- =========================================================

CREATE TABLE IF NOT EXISTS sustainability (
    sustainability_id INT PRIMARY KEY AUTO_INCREMENT,
    metric_date DATE,
    energy_kwh DECIMAL(10,2),
    water_liters DECIMAL(10,2),
    waste_recycled_tons DECIMAL(8,2),
    trees_planted INT,
    solar_kwh DECIMAL(10,2)
);


-- =========================================================
-- 19. SUPPORT REQUESTS
-- =========================================================

CREATE TABLE IF NOT EXISTS support_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    subject VARCHAR(180),
    category VARCHAR(60),
    description TEXT,
    status VARCHAR(30) DEFAULT 'Open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);


-- =========================================================
-- DEPARTMENT DATA
-- =========================================================

INSERT IGNORE INTO departments (name)
VALUES
('ECE'),
('CSE'),
('EEE'),
('Common');


-- =========================================================
-- DIGITAL LIBRARY SAMPLE BOOK DATA
-- =========================================================

INSERT INTO books
(book_name, author, category, isbn, quantity, available_copies)
VALUES
(
    'Digital Signal Processing',
    'A. V. Oppenheim',
    'Engineering',
    '9780132119111',
    8,
    5
),
(
    'Clean Code',
    'Robert C. Martin',
    'Programming',
    '9780132350884',
    6,
    3
),
(
    'Artificial Intelligence',
    'Stuart Russell',
    'AI/ML',
    '9780134610993',
    7,
    7
),
(
    'The Design of Everyday Things',
    'Don Norman',
    'Design',
    '9780465050659',
    4,
    2
),
(
    'Computer Networks',
    'Andrew S. Tanenbaum',
    'Engineering',
    '9780132126953',
    10,
    10
),
(
    'The C Programming Language',
    'Brian W. Kernighan',
    'Programming',
    '9780131103627',
    8,
    8
),
(
    'Machine Learning',
    'Tom M. Mitchell',
    'AI/ML',
    '9780070428072',
    5,
    5
),
(
    'Engineering Mathematics',
    'K. A. Stroud',
    'Engineering',
    '9781137031068',
    10,
    7
);