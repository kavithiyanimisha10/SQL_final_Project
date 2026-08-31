CREATE DATABASE UniversityCourseManagement;

-- CREATE STUDENT TABLE

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

INSERT INTO Students VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01'),
(3, 'Rahul', 'Patel', 'rahul.patel@email.com', '2001-03-10', '2023-08-01'),
(4, 'Priya', 'Shah', 'priya.shah@email.com', '2000-11-20', '2024-01-15'),
(5, 'Amit', 'Mehta', 'amit.mehta@email.com', '1999-07-18', '2022-09-10'),
(6, 'Neha', 'Joshi', 'neha.joshi@email.com', '2002-02-14', '2023-01-20');

-- CREATE DEPARTMENT TABLE

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

INSERT INTO Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

-- CREATE COURSES TABLE

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Courses VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4),
(103, 'Python Programming', 1, 3),
(104, 'Advanced Mathematics', 2, 4),
(105, 'Database Management', 1, 3);

-- CREATE INSTRUCTORS TABLE

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Instructors VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1, 75000),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2, 68000),
(3, 'David', 'Brown', 'david.brown@univ.com', 1, 82000),
(4, 'Sarah', 'Wilson', 'sarah.wilson@univ.com', 2, 70000);

-- CREATE ENROLLMENTS TABLE

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Enrollments VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01'),
(3, 3, 101, '2023-08-01'),
(4, 4, 103, '2024-01-15'),
(5, 5, 101, '2022-09-10'),
(6, 6, 104, '2023-01-20'),
(7, 2, 101, '2021-08-01'),
(8, 3, 103, '2023-08-01');

-- QUERY 1 : CRUD OPERATION IN ALL TABLES

INSERT INTO Students VALUES
(7, 'Karan', 'Joshi', 'karan.joshi@email.com', '2001-06-15', '2024-08-01');

SELECT * FROM Students;

UPDATE Students
SET Email = 'karan.new@email.com'
WHERE StudentID = 7;

DELETE FROM Students WHERE StudentID = 7;

-- ------------------------------------------------------

INSERT INTO Departments
VALUES (3, 'Physics');

SELECT * FROM Departments;

UPDATE Departments
SET DepartmentName = 'Applied Physics'
WHERE DepartmentID = 3;

DELETE FROM Departments
WHERE DepartmentID = 3;

-- ------------------------------------------------------

INSERT INTO Courses
VALUES (106, 'Web Development', 1, 3);

SELECT * FROM Courses;

UPDATE Courses
SET Credits = 4
WHERE CourseID = 106;

DELETE FROM Courses
WHERE CourseID = 106;

-- ------------------------------------------------------

INSERT INTO Instructors
VALUES
(5, 'Michael', 'Clark', 'michael@univ.com', 1, 72000);

SELECT * FROM Instructors;

UPDATE Instructors
SET Salary = 76000
WHERE InstructorID = 5;

DELETE FROM Instructors
WHERE InstructorID = 5;

-- ------------------------------------------------------

INSERT INTO Enrollments
VALUES
(9, 1, 103, '2022-08-05');

SELECT * FROM Enrollments;

UPDATE Enrollments
SET CourseID = 105
WHERE EnrollmentID = 9;

DELETE FROM Enrollments
WHERE EnrollmentID = 9;

-- QUERY 2 : RETRIEVE WHO ENROLLED AFTER 2022

SELECT * FROM Students
WHERE EnrollmentDate > '2022-12-31';

-- QUERY 3 : COURSES OFFERED BY MATHEMATICS DEPARTMENT LIMIT 5

SELECT c.CourseID,c.CourseName,c.Credits FROM Courses c
JOIN Departments d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;

-- QUERY 4 : NUMBER OF STUDENTS ENROLLED IN EACH COURSE WHICH HAVE MORE THAN 5 STUDENTS

SELECT c.CourseID,c.CourseName,
       COUNT(e.StudentID) AS TotalStudents
FROM Courses c
JOIN Enrollments e
ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName
HAVING COUNT(e.StudentID) > 5;

-- QUERY 5 : STUDENT ENROLLED IN BOTH SQL AND DATA STRUCTURES

SELECT s.StudentID,s.FirstName,s.LastName FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures')
GROUP BY s.StudentID, s.FirstName, s.LastName
HAVING COUNT(DISTINCT c.CourseName) = 2;

-- QUERY 6 : STUDENT ENROLLED IN EITHER SQL OR DATA STRUCTURES

SELECT DISTINCT s.StudentID,s.FirstName,s.LastName FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures');

-- QUERY 7 : AVERAGE CREDIT FOR ALL COURSES

SELECT AVG(Credits) AS AverageCredits FROM Courses;

-- QUERY 8 : MAXIMUM SALARY OF INSTRUCTORS IN COMPUTER SCIENCE

SELECT MAX(i.Salary) AS MaximumSalary FROM Instructors i
JOIN Departments d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';

-- QUERY 9 : COUNT STUDENTS ENROLLED IN EACH DEPARTMENT

SELECT d.DepartmentID,d.DepartmentName,COUNT(DISTINCT e.StudentID) AS TotalStudents FROM Departments d
LEFT JOIN Courses c ON d.DepartmentID = c.DepartmentID
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentID, d.DepartmentName;

-- QUERY 10 : INNER JOIN - STUDENTS AND THEIR COURSES

SELECT s.StudentID,s.FirstName,s.LastName,c.CourseID,c.CourseName FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- QUERY 11 : LEFT JOIN - STUDENT AND THEIR COURSES

SELECT s.StudentID,s.FirstName,s.LastName,c.CourseName FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- QUERY 12 : SUBQUERY - STUDENTS ENROLLED IN EACH COURSE HAVING MORE THAN 10 STUDENTS

SELECT DISTINCT s.StudentID,s.FirstName,s.LastName FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN
(SELECT CourseID FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 10);

-- QUERY 13 : EXTRACT YEAR FROM ENROLL DATE

SELECT StudentID,FirstName,LastName,EnrollmentDate,
YEAR(EnrollmentDate) AS EnrollmentYear
FROM Students;

-- QUERY 14 : CONCATENATE INSTRUCTOR FIRST & LAST NAME

SELECT InstructorID,CONCAT(FirstName, ' ', LastName) AS InstructorName FROM Instructors;

-- QUERY 15 : RUNNING TOTAL OF STUDENT ENROLLED

SELECT EnrollmentID,StudentID,CourseID,EnrollmentDate,
	COUNT(*) OVER (
		ORDER BY EnrollmentDate, EnrollmentID
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS RunningTotal
FROM Enrollments
ORDER BY EnrollmentDate, EnrollmentID;

-- QUERY 16 : LABEL STUDENTS AS SENIOR OR JUNIOR

SELECT StudentID,FirstName,LastName,EnrollmentDate,
CASE
WHEN EnrollmentDate < DATE_SUB(CURDATE(), INTERVAL 4 YEAR)
THEN 'Senior'
ELSE 'Junior'
END AS StudentStatus
FROM Students;