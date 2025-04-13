
-- Employee Performance & HR Analytics 

-- 1. Departments Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

-- 2. Employees Table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    date_of_joining DATE,
    department_id INT,
    gender ENUM('Male', 'Female', 'Other'),
    status ENUM('Active', 'Resigned', 'On Leave'),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- 3. Salaries Table
CREATE TABLE Salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    base_salary DECIMAL(10,2),
    bonus DECIMAL(10,2),
    salary_month DATE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- 4. Attendance Records Table
CREATE TABLE AttendanceRecords (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    date DATE,
    status ENUM('Present', 'Absent', 'Leave'),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- 5. Performance Reviews Table
CREATE TABLE PerformanceReviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    review_date DATE,
    reviewer VARCHAR(100),
    performance_score INT CHECK (performance_score BETWEEN 1 AND 10),
    comments TEXT,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Sample Data

INSERT INTO Departments (name) VALUES ('Engineering'), ('HR'), ('Marketing');

INSERT INTO Employees (full_name, email, date_of_joining, department_id, gender, status) VALUES
('Jim Halpert', 'jim@dundermifflin.com', '2020-01-15', 1, 'Male', 'Active'),
('Dwight Schrute', 'dwight@dundermifflin.com', '2018-03-20', 1, 'Male', 'Active'),
('Angela Martin', 'angela@dundermifflin.com', '2019-07-10', 2, 'Female', 'On Leave');

INSERT INTO Salaries (employee_id, base_salary, bonus, salary_month) VALUES
(1, 5000.00, 500.00, '2025-04-01'),
(2, 5500.00, 700.00, '2025-04-01'),
(3, 4500.00, 300.00, '2025-04-01');

INSERT INTO AttendanceRecords (employee_id, date, status) VALUES
(1, '2025-04-01', 'Present'),
(2, '2025-04-01', 'Absent'),
(3, '2025-04-01', 'Leave');

INSERT INTO PerformanceReviews (employee_id, review_date, reviewer, performance_score, comments) VALUES
(1, '2025-03-31', 'Michael Scott', 8, 'Great team player.'),
(2, '2025-03-31', 'Michael Scott', 9, 'Strong leadership.'),
(3, '2025-03-31', 'Michael Scott', 6, 'Needs improvement in collaboration.');

-- Views

CREATE VIEW ActiveEmployeeReviews AS
SELECT e.full_name, pr.review_date, pr.performance_score
FROM Employees e
JOIN PerformanceReviews pr ON e.employee_id = pr.employee_id
WHERE e.status = 'Active' AND pr.review_date = (
    SELECT MAX(review_date) FROM PerformanceReviews WHERE employee_id = e.employee_id
);

-- Stored Procedure

DELIMITER //
CREATE PROCEDURE AddReview (
    IN emp_id INT,
    IN review_date DATE,
    IN reviewer_name VARCHAR(100),
    IN score INT,
    IN comments_text TEXT
)
BEGIN
    INSERT INTO PerformanceReviews (employee_id, review_date, reviewer, performance_score, comments)
    VALUES (emp_id, review_date, reviewer_name, score, comments_text);
END;
//
DELIMITER ;
