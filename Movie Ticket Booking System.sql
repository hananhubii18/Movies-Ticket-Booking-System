-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS MovieTicketDB;
USE MovieTicketDB;

-- =========================================================
-- 3. CREATE TABLES
-- =========================================================

CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(40) NOT NULL,
    duration_minutes INT NOT NULL,
    language VARCHAR(30) NOT NULL DEFAULT 'Hindi',
    release_date DATE,
    CHECK (duration_minutes > 0)
);

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20) UNIQUE
);

CREATE TABLE Theatres (
    theatre_id INT AUTO_INCREMENT PRIMARY KEY,
    theatre_name VARCHAR(100) NOT NULL,
    city VARCHAR(80) NOT NULL,
    address VARCHAR(200)
);

CREATE TABLE Screens (
    screen_id INT AUTO_INCREMENT PRIMARY KEY,
    theatre_id INT NOT NULL,
    screen_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (theatre_id)
        REFERENCES Theatres(theatre_id),
    UNIQUE (theatre_id, screen_name)
);

CREATE TABLE Seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    screen_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    seat_type ENUM('Regular', 'Premium', 'Recliner')
        NOT NULL DEFAULT 'Regular',
    FOREIGN KEY (screen_id)
        REFERENCES Screens(screen_id),
    UNIQUE (screen_id, seat_number)
);

CREATE TABLE Shows (
    show_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    screen_id INT NOT NULL,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    base_ticket_price DECIMAL(8,2) NOT NULL,
    show_status ENUM('Scheduled', 'Cancelled', 'Completed')
        NOT NULL DEFAULT 'Scheduled',
    FOREIGN KEY (movie_id)
        REFERENCES Movies(movie_id),
    FOREIGN KEY (screen_id)
        REFERENCES Screens(screen_id),
    CHECK (base_ticket_price >= 0),
    UNIQUE (screen_id, show_date, show_time)
);

CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    show_id INT NOT NULL,
    booking_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    booking_status ENUM('Pending', 'Confirmed', 'Cancelled')
        NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    FOREIGN KEY (show_id)
        REFERENCES Shows(show_id)
);

CREATE TABLE Booking_Seats (
    booking_seat_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    show_id INT NOT NULL,
    seat_id INT NOT NULL,
    ticket_price DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (booking_id)
        REFERENCES Bookings(booking_id),
    FOREIGN KEY (show_id)
        REFERENCES Shows(show_id),
    FOREIGN KEY (seat_id)
        REFERENCES Seats(seat_id),
    UNIQUE (show_id, seat_id),
    CHECK (ticket_price >= 0)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Cash', 'Card', 'UPI', 'Net Banking')
        NOT NULL,
    payment_status ENUM('Pending', 'Successful', 'Failed', 'Refunded')
        NOT NULL DEFAULT 'Pending',
    payment_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id)
        REFERENCES Bookings(booking_id),
    CHECK (amount >= 0)
);

-- =========================================================
-- 4. INSERT SAMPLE DATA
-- =========================================================

INSERT INTO Movies
(title, genre, duration_minutes, language, release_date)
VALUES
('3 Idiots', 'Comedy-Drama', 170, 'Hindi', '2009-12-25'),
('Dangal', 'Sports-Drama', 161, 'Hindi', '2016-12-23'),
('Interstellar', 'Sci-Fi', 169, 'English', '2014-11-07'),
('Zindagi Na Milegi Dobara', 'Adventure-Drama', 155, 'Hindi', '2011-07-15'),
('Inception', 'Sci-Fi-Thriller', 148, 'English', '2010-07-16');

INSERT INTO Customers
(customer_name, email, phone)
VALUES
('Aarav Sharma', 'aarav@example.com', '9876500001'),
('Meera Verma', 'meera@example.com', '9876500002'),
('Kabir Singh', 'kabir@example.com', '9876500003'),
('Ananya Gupta', 'ananya@example.com', '9876500004'),
('Rohan Mehta', 'rohan@example.com', '9876500005');

INSERT INTO Theatres (theatre_name, city, address)
VALUES
('CineStar', 'Chandigarh', 'Sector 17'),
('MovieMax', 'Mohali', 'Airport Road');

INSERT INTO Screens (theatre_id, screen_name)
VALUES
(1, 'Screen 1'),
(1, 'Screen 2'),
(2, 'Screen 1');

INSERT INTO Seats (screen_id, seat_number, seat_type)
VALUES
(1, 'A1', 'Regular'),
(1, 'A2', 'Regular'),
(1, 'A3', 'Regular'),
(1, 'A4', 'Premium'),
(1, 'A5', 'Premium'),
(1, 'B1', 'Regular'),
(1, 'B2', 'Regular'),
(1, 'B3', 'Premium'),
(1, 'B4', 'Recliner'),
(1, 'B5', 'Recliner'),
(2, 'A1', 'Regular'),
(2, 'A2', 'Regular'),
(2, 'A3', 'Regular'),
(2, 'A4', 'Premium'),
(2, 'A5', 'Premium'),
(3, 'A1', 'Regular'),
(3, 'A2', 'Regular'),
(3, 'A3', 'Premium'),
(3, 'A4', 'Premium'),
(3, 'A5', 'Recliner');

INSERT INTO Shows
(movie_id, screen_id, show_date, show_time, base_ticket_price)
VALUES
(1, 1, '2026-11-01', '10:00:00', 180.00),
(2, 1, '2026-11-01', '14:00:00', 220.00),
(3, 2, '2026-11-01', '18:00:00', 250.00),
(4, 3, '2026-11-02', '12:00:00', 200.00),
(5, 3, '2026-11-02', '19:00:00', 240.00);

INSERT INTO Bookings
(customer_id, show_id, booking_datetime, booking_status)
VALUES
(1, 1, '2026-10-20 10:15:00', 'Confirmed'),
(2, 2, '2026-10-20 11:30:00', 'Confirmed'),
(3, 3, '2026-10-21 15:45:00', 'Confirmed'),
(4, 4, '2026-10-21 16:00:00', 'Pending');

INSERT INTO Booking_Seats
(booking_id, show_id, seat_id, ticket_price)
VALUES
(1, 1, 1, 180.00),
(1, 1, 2, 180.00),
(2, 2, 4, 220.00),
(3, 3, 11, 250.00),
(4, 4, 16, 200.00);

INSERT INTO Payments
(booking_id, amount, payment_method, payment_status, payment_datetime)
VALUES
(1, 360.00, 'UPI', 'Successful', '2026-10-20 10:16:00'),
(2, 220.00, 'Card', 'Successful', '2026-10-20 11:31:00'),
(3, 250.00, 'UPI', 'Successful', '2026-10-21 15:46:00'),
(4, 200.00, 'Cash', 'Pending', '2026-10-21 16:01:00');

-- =========================================================
-- 5. CREATE VIEWS
-- =========================================================

CREATE VIEW vw_booking_details AS
SELECT
    b.booking_id,
    c.customer_name,
    c.email,
    m.title AS movie_title,
    t.theatre_name,
    t.city,
    sc.screen_name,
    sh.show_date,
    sh.show_time,
    GROUP_CONCAT(
        st.seat_number
        ORDER BY st.seat_number SEPARATOR ', '
    ) AS seats,
    COALESCE(SUM(bs.ticket_price), 0) AS ticket_total,
    b.booking_status
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Shows sh ON b.show_id = sh.show_id
JOIN Movies m ON sh.movie_id = m.movie_id
JOIN Screens sc ON sh.screen_id = sc.screen_id
JOIN Theatres t ON sc.theatre_id = t.theatre_id
LEFT JOIN Booking_Seats bs ON b.booking_id = bs.booking_id
LEFT JOIN Seats st ON bs.seat_id = st.seat_id
GROUP BY
    b.booking_id, c.customer_name, c.email,
    m.title, t.theatre_name, t.city, sc.screen_name,
    sh.show_date, sh.show_time, b.booking_status;

CREATE VIEW vw_movie_revenue AS
SELECT
    m.movie_id,
    m.title AS movie_title,
    COUNT(DISTINCT
        CASE
            WHEN b.booking_status = 'Confirmed'
            THEN b.booking_id
        END
    ) AS confirmed_bookings,
    COALESCE(
        SUM(
            CASE
                WHEN p.payment_status = 'Successful'
                THEN p.amount
                ELSE 0
            END
        ), 0
    ) AS total_revenue
FROM Movies m
LEFT JOIN Shows sh ON m.movie_id = sh.movie_id
LEFT JOIN Bookings b ON sh.show_id = b.show_id
LEFT JOIN Payments p ON b.booking_id = p.booking_id
GROUP BY m.movie_id, m.title;

CREATE VIEW vw_available_seats AS
SELECT
    sh.show_id,
    m.title AS movie_title,
    sh.show_date,
    sh.show_time,
    sc.screen_id,
    st.seat_id,
    st.seat_number,
    st.seat_type,
    CASE st.seat_type
        WHEN 'Premium' THEN sh.base_ticket_price * 1.25
        WHEN 'Recliner' THEN sh.base_ticket_price * 1.75
        ELSE sh.base_ticket_price
    END AS ticket_price
FROM Shows sh
JOIN Movies m ON sh.movie_id = m.movie_id
JOIN Screens sc ON sh.screen_id = sc.screen_id
JOIN Seats st ON sc.screen_id = st.screen_id
LEFT JOIN Booking_Seats bs
    ON bs.show_id = sh.show_id AND bs.seat_id = st.seat_id
WHERE bs.booking_seat_id IS NULL
  AND sh.show_status = 'Scheduled';

-- =========================================================
-- 6. STORED PROCEDURES
-- =========================================================

DELIMITER $$

CREATE PROCEDURE sp_show_available_seats(IN p_show_id INT)
BEGIN
    SELECT
        show_id, movie_title, show_date, show_time,
        seat_number, seat_type, ticket_price
    FROM vw_available_seats
    WHERE show_id = p_show_id
    ORDER BY seat_number;
END$$

CREATE PROCEDURE sp_book_seat(
    IN p_customer_id INT,
    IN p_show_id INT,
    IN p_seat_id INT,
    IN p_payment_method VARCHAR(20)
)
BEGIN
    DECLARE v_screen_id INT;
    DECLARE v_show_status VARCHAR(20);
    DECLARE v_seat_screen_id INT;
    DECLARE v_seat_type VARCHAR(20);
    DECLARE v_base_price DECIMAL(8,2);
    DECLARE v_price DECIMAL(8,2);
    DECLARE v_booking_id INT;
    DECLARE v_exists INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT screen_id, show_status, base_ticket_price
    INTO v_screen_id, v_show_status, v_base_price
    FROM Shows
    WHERE show_id = p_show_id
    FOR UPDATE;

    IF v_show_status <> 'Scheduled' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Show is not available for booking.';
    END IF;

    SELECT screen_id, seat_type
    INTO v_seat_screen_id, v_seat_type
    FROM Seats
    WHERE seat_id = p_seat_id;

    IF v_seat_screen_id <> v_screen_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat does not belong to this show screen.';
    END IF;

    SELECT COUNT(*)
    INTO v_exists
    FROM Booking_Seats
    WHERE show_id = p_show_id AND seat_id = p_seat_id;

    IF v_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This seat is already booked.';
    END IF;

    SET v_price = CASE v_seat_type
        WHEN 'Premium' THEN v_base_price * 1.25
        WHEN 'Recliner' THEN v_base_price * 1.75
        ELSE v_base_price
    END;

    INSERT INTO Bookings
        (customer_id, show_id, booking_status)
    VALUES
        (p_customer_id, p_show_id, 'Pending');

    SET v_booking_id = LAST_INSERT_ID();

    INSERT INTO Booking_Seats
        (booking_id, show_id, seat_id, ticket_price)
    VALUES
        (v_booking_id, p_show_id, p_seat_id, v_price);

    INSERT INTO Payments
        (booking_id, amount, payment_method, payment_status)
    VALUES
        (v_booking_id, v_price, p_payment_method, 'Pending');

    COMMIT;

    SELECT
        v_booking_id AS booking_id,
        v_price AS ticket_price,
        'Pending' AS booking_status,
        'Booking created; payment is pending.' AS message;
END$$

CREATE PROCEDURE sp_cancel_booking(IN p_booking_id INT)
BEGIN
    DECLARE v_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT booking_status
    INTO v_status
    FROM Bookings
    WHERE booking_id = p_booking_id
    FOR UPDATE;

    IF v_status = 'Cancelled' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Booking is already cancelled.';
    END IF;

    UPDATE Bookings
    SET booking_status = 'Cancelled'
    WHERE booking_id = p_booking_id;

    UPDATE Payments
    SET payment_status =
        CASE
            WHEN payment_status = 'Successful' THEN 'Refunded'
            ELSE payment_status
        END
    WHERE booking_id = p_booking_id;

    DELETE FROM Booking_Seats
    WHERE booking_id = p_booking_id;

    COMMIT;

    SELECT CONCAT('Booking ', p_booking_id, ' cancelled.') AS message;
END$$

DELIMITER ;

-- =========================================================
-- 7. TRIGGERS
-- =========================================================

DELIMITER $$

CREATE TRIGGER trg_booking_seat_before_insert
BEFORE INSERT ON Booking_Seats
FOR EACH ROW
BEGIN
    DECLARE v_show_screen INT;
    DECLARE v_seat_screen INT;

    SELECT screen_id INTO v_show_screen
    FROM Shows
    WHERE show_id = NEW.show_id;

    SELECT screen_id INTO v_seat_screen
    FROM Seats
    WHERE seat_id = NEW.seat_id;

    IF v_show_screen <> v_seat_screen THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat belongs to a different screen.';
    END IF;
END$$

CREATE TRIGGER trg_payment_after_insert
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    IF NEW.payment_status = 'Successful' THEN
        UPDATE Bookings
        SET booking_status = 'Confirmed'
        WHERE booking_id = NEW.booking_id
          AND booking_status = 'Pending';
    END IF;
END$$

CREATE TRIGGER trg_payment_after_update
AFTER UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF NEW.payment_status = 'Successful'
       AND OLD.payment_status <> 'Successful' THEN
        UPDATE Bookings
        SET booking_status = 'Confirmed'
        WHERE booking_id = NEW.booking_id
          AND booking_status = 'Pending';
    END IF;
END$$

DELIMITER ;

-- =========================================================
-- 8. BASIC SQL QUERIES
-- =========================================================

SELECT * FROM Movies;
SELECT * FROM Customers;
SELECT * FROM Theatres;
SELECT * FROM Shows;

SELECT *
FROM Movies
WHERE language = 'Hindi';

SELECT title, duration_minutes
FROM Movies
WHERE duration_minutes > 160;

SELECT *
FROM Movies
ORDER BY title ASC;

SELECT *
FROM Shows
WHERE base_ticket_price < 250;

SELECT COUNT(*) AS total_movies
FROM Movies;

SELECT AVG(base_ticket_price) AS average_ticket_price
FROM Shows;

-- =========================================================
-- 9. JOIN QUERIES
-- =========================================================

SELECT
    m.title,
    sh.show_date,
    sh.show_time,
    sh.base_ticket_price
FROM Movies m
JOIN Shows sh ON m.movie_id = sh.movie_id;

SELECT
    c.customer_name,
    b.booking_id,
    b.booking_status
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id;

SELECT
    m.title,
    t.theatre_name,
    t.city,
    sc.screen_name,
    sh.show_date,
    sh.show_time
FROM Shows sh
JOIN Movies m ON sh.movie_id = m.movie_id
JOIN Screens sc ON sh.screen_id = sc.screen_id
JOIN Theatres t ON sc.theatre_id = t.theatre_id;

SELECT
    b.booking_id,
    c.customer_name,
    p.amount,
    p.payment_method,
    p.payment_status
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
LEFT JOIN Payments p ON b.booking_id = p.booking_id;

SELECT
    c.customer_name,
    m.title,
    st.seat_number,
    bs.ticket_price
FROM Booking_Seats bs
JOIN Bookings b ON bs.booking_id = b.booking_id
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Shows sh ON bs.show_id = sh.show_id
JOIN Movies m ON sh.movie_id = m.movie_id
JOIN Seats st ON bs.seat_id = st.seat_id;

-- =========================================================
-- 10. AGGREGATE FUNCTIONS AND SUBQUERIES
-- =========================================================

SELECT
    m.title,
    COUNT(b.booking_id) AS total_bookings
FROM Movies m
LEFT JOIN Shows sh ON m.movie_id = sh.movie_id
LEFT JOIN Bookings b ON sh.show_id = b.show_id
GROUP BY m.movie_id, m.title;

SELECT SUM(amount) AS total_revenue
FROM Payments
WHERE payment_status = 'Successful';

SELECT payment_method, SUM(amount) AS total_amount
FROM Payments
WHERE payment_status = 'Successful'
GROUP BY payment_method;

SELECT payment_status, COUNT(*) AS number_of_payments
FROM Payments
GROUP BY payment_status;

SELECT c.customer_name, COUNT(b.booking_id) AS booking_count
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(b.booking_id) > 1;

SELECT title, duration_minutes
FROM Movies
WHERE duration_minutes >
    (SELECT AVG(duration_minutes) FROM Movies);

SELECT show_id, base_ticket_price
FROM Shows
WHERE base_ticket_price >
    (SELECT AVG(base_ticket_price) FROM Shows);

SELECT customer_name, email
FROM Customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM Bookings
);

-- =========================================================
-- 11. PROJECT REPORTS
-- =========================================================

SELECT * FROM vw_booking_details
ORDER BY booking_id;

SELECT * FROM vw_movie_revenue
ORDER BY total_revenue DESC;

SELECT * FROM vw_available_seats
WHERE show_id = 1;

SELECT
    m.title,
    COUNT(b.booking_id) AS total_bookings
FROM Movies m
LEFT JOIN Shows sh ON m.movie_id = sh.movie_id
LEFT JOIN Bookings b
    ON sh.show_id = b.show_id
    AND b.booking_status <> 'Cancelled'
GROUP BY m.movie_id, m.title
ORDER BY total_bookings DESC;

SELECT COALESCE(SUM(amount), 0) AS total_revenue
FROM Payments
WHERE payment_status = 'Successful';

SELECT
    DATE(payment_datetime) AS payment_date,
    SUM(amount) AS daily_revenue
FROM Payments
WHERE payment_status = 'Successful'
GROUP BY DATE(payment_datetime)
ORDER BY payment_date;

SELECT
    c.customer_name,
    m.title,
    sh.show_date,
    sh.show_time,
    b.booking_status
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
JOIN Shows sh ON b.show_id = sh.show_id
JOIN Movies m ON sh.movie_id = m.movie_id
ORDER BY c.customer_name, sh.show_date;

SELECT
    sh.show_id,
    m.title,
    sh.show_date,
    sh.show_time
FROM Shows sh
JOIN Movies m ON sh.movie_id = m.movie_id
LEFT JOIN Bookings b
    ON sh.show_id = b.show_id
    AND b.booking_status <> 'Cancelled'
WHERE b.booking_id IS NULL;

SELECT
    payment_status,
    COUNT(*) AS total_payments,
    SUM(amount) AS total_amount
FROM Payments
GROUP BY payment_status;

SELECT
    sh.show_id,
    m.title,
    COUNT(st.seat_id) AS total_seats,
    COUNT(bs.booking_seat_id) AS allocated_seats
FROM Shows sh
JOIN Movies m ON sh.movie_id = m.movie_id
JOIN Screens sc ON sh.screen_id = sc.screen_id
JOIN Seats st ON sc.screen_id = st.screen_id
LEFT JOIN Booking_Seats bs
    ON sh.show_id = bs.show_id
    AND st.seat_id = bs.seat_id
GROUP BY sh.show_id, m.title;

-- =========================================================
-- 12. TRANSACTION EXAMPLE
-- Run this section separately when testing transactions.
-- =========================================================

-- START TRANSACTION;
-- UPDATE Movies SET genre = 'Test Genre' WHERE movie_id = 1;
-- ROLLBACK;

-- Another transaction example:
-- START TRANSACTION;
-- UPDATE Shows SET base_ticket_price = 190 WHERE show_id = 1;
-- SAVEPOINT price_updated;
-- UPDATE Shows SET base_ticket_price = 300 WHERE show_id = 2;
-- ROLLBACK TO SAVEPOINT price_updated;
-- COMMIT;

-- =========================================================
-- 13. TEST THE BOOKING SYSTEM
-- Run these commands separately after creating everything.
-- =========================================================

-- Show available seats:
-- CALL sp_show_available_seats(1);

-- Book seat_id 3 for customer 5 in show 1:
-- CALL sp_book_seat(5, 1, 3, 'UPI');

-- Check the new booking and its ID:
-- SELECT * FROM Bookings ORDER BY booking_id DESC;
-- SELECT * FROM Payments ORDER BY payment_id DESC;

-- Replace 5 with the actual new booking ID:
-- UPDATE Payments
-- SET payment_status = 'Successful'
-- WHERE booking_id = 5;

-- Cancel a booking:
-- CALL sp_cancel_booking(5);

-- =========================================================
-- 14. VERIFY DATABASE OBJECTS
-- =========================================================

SHOW TABLES;

SHOW FULL TABLES WHERE Table_type = 'VIEW';

SHOW PROCEDURE STATUS WHERE Db = 'MovieTicketDB';

SHOW TRIGGERS;

DESCRIBE Movies;
DESCRIBE Bookings;
DESCRIBE Booking_Seats;
DESCRIBE Payments;

-- END OF PROJECT
