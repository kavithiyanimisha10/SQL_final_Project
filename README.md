# University Course Management System — SQL Project

A relational database project simulating a university's course management system. It models students, instructors, departments, courses, and enrollments, and demonstrates a range of SQL operations from basic CRUD to window functions.

## Overview

This project creates a `UniversityCourseManagement` database with five interrelated tables and a set of 16 queries covering everything from data manipulation to joins, subqueries, and analytics.

## Database Schema

### 1. `Students`

Stores student personal and enrollment record information.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `StudentID` | `INT` | `PRIMARY KEY` | Unique identifier for each student |
| `FirstName` | `VARCHAR(50)` | | Student's first name |
| `LastName` | `VARCHAR(50)` | | Student's last name |
| `Email` | `VARCHAR(100)` | | Student's contact email |
| `BirthDate` | `DATE` | | Student's date of birth |
| `EnrollmentDate` | `DATE` | | Date the student joined the university |

**Seed data (6 rows):** John Doe, Jane Smith, Rahul Patel, Priya Shah, Amit Mehta, Neha Joshi — enrollment dates ranging from 2021-08-01 to 2024-01-15.

### 2. `Departments`

Reference table listing the academic departments in the university.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `DepartmentID` | `INT` | `PRIMARY KEY` | Unique identifier for each department |
| `DepartmentName` | `VARCHAR(100)` | | Name of the department |

**Seed data (2 rows):** `1 = Computer Science`, `2 = Mathematics`.

### 3. `Courses`

Stores course offerings, each tied to a department.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `CourseID` | `INT` | `PRIMARY KEY` | Unique identifier for each course |
| `CourseName` | `VARCHAR(100)` | | Name of the course |
| `DepartmentID` | `INT` | `FOREIGN KEY → Departments.DepartmentID` | Department offering the course |
| `Credits` | `INT` | | Number of credits the course is worth |

**Seed data (5 rows):**
| CourseID | CourseName | DepartmentID | Credits |
|---|---|---|---|
| 101 | Introduction to SQL | 1 (CS) | 3 |
| 102 | Data Structures | 2 (Math) | 4 |
| 103 | Python Programming | 1 (CS) | 3 |
| 104 | Advanced Mathematics | 2 (Math) | 4 |
| 105 | Database Management | 1 (CS) | 3 |

> Note: In the seed data, "Data Structures" is filed under Mathematics (DepartmentID 2), not Computer Science — worth knowing when reading Query 3 and Query 5's results.

### 4. `Instructors`

Stores faculty records, each tied to a department.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `InstructorID` | `INT` | `PRIMARY KEY` | Unique identifier for each instructor |
| `FirstName` | `VARCHAR(50)` | | Instructor's first name |
| `LastName` | `VARCHAR(50)` | | Instructor's last name |
| `Email` | `VARCHAR(100)` | | Instructor's contact email |
| `DepartmentID` | `INT` | `FOREIGN KEY → Departments.DepartmentID` | Department the instructor belongs to |
| `Salary` | `DECIMAL(10,2)` | | Instructor's salary |

**Seed data (4 rows):** Alice Johnson (CS, 75000), Bob Lee (Math, 68000), David Brown (CS, 82000), Sarah Wilson (Math, 70000).

### 5. `Enrollments`

Junction table linking students to the courses they've taken.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `EnrollmentID` | `INT` | `PRIMARY KEY` | Unique identifier for each enrollment record |
| `StudentID` | `INT` | `FOREIGN KEY → Students.StudentID` | Student who enrolled |
| `CourseID` | `INT` | `FOREIGN KEY → Courses.CourseID` | Course enrolled in |
| `EnrollmentDate` | `DATE` | | Date of enrollment in that course |

**Seed data (8 rows):** links students 1–6 to courses across CS and Math, including two students (Jane Smith and Rahul Patel) enrolled in more than one course each.

### Entity Relationship Summary

```
Departments (1) ──< Courses (many)
Departments (1) ──< Instructors (many)
Students (1) ──< Enrollments (many) >── (1) Courses
```

- `Courses.DepartmentID` → `Departments.DepartmentID`
- `Instructors.DepartmentID` → `Departments.DepartmentID`
- `Enrollments.StudentID` → `Students.StudentID`
- `Enrollments.CourseID` → `Courses.CourseID`

## Queries Included

### Query 1 — CRUD Operations on All Tables
Demonstrates the full Create-Read-Update-Delete cycle on every table: for each of `Students`, `Departments`, `Courses`, `Instructors`, and `Enrollments`, a temporary row is `INSERT`ed, read back with `SELECT *`, modified with `UPDATE`, and then removed with `DELETE`. Because every inserted row is deleted by the end of the block, the database returns to its original seeded state after this query runs.

### Query 2 — Students Enrolled After 2022
```sql
SELECT * FROM Students WHERE EnrollmentDate > '2022-12-31';
```
Filters the `Students` table to return only students whose `EnrollmentDate` falls in 2023 or later. Demonstrates basic date filtering with `WHERE`. Returns Rahul Patel, Priya Shah, and Neha Joshi from the seed data.

### Query 3 — Courses Offered by the Mathematics Department
```sql
SELECT c.CourseID, c.CourseName, c.Credits FROM Courses c
JOIN Departments d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;
```
Joins `Courses` to `Departments` to filter by department name rather than ID, and caps the result at 5 rows with `LIMIT`. Returns "Data Structures" and "Advanced Mathematics" from the seed data.

### Query 4 — Courses With More Than 5 Enrolled Students
```sql
SELECT c.CourseID, c.CourseName, COUNT(e.StudentID) AS TotalStudents
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName
HAVING COUNT(e.StudentID) > 5;
```
Groups enrollments by course and counts students per course, then uses `HAVING` to keep only courses exceeding 5 enrollments. Demonstrates the difference between `WHERE` (filters rows before grouping) and `HAVING` (filters after aggregation). With only 8 total enrollment rows in the seed data, no course currently crosses the 5-student threshold — add more enrollment rows to see results.

### Query 5 — Students Enrolled in Both SQL and Data Structures
```sql
SELECT s.StudentID, s.FirstName, s.LastName FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures')
GROUP BY s.StudentID, s.FirstName, s.LastName
HAVING COUNT(DISTINCT c.CourseName) = 2;
```
Finds students who appear in enrollment records for *both* named courses by grouping per student and requiring exactly 2 distinct matching course names. Returns Jane Smith, who is enrolled in both.

### Query 6 — Students Enrolled in Either SQL or Data Structures
```sql
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures');
```
Same join pattern as Query 5, but without the `HAVING` clause — returns any student enrolled in at least one of the two courses (an OR condition), using `DISTINCT` to avoid duplicate rows for students in both.

### Query 7 — Average Credits Across All Courses
```sql
SELECT AVG(Credits) AS AverageCredits FROM Courses;
```
A simple aggregate query using `AVG()` to compute the mean number of credits across all 5 seeded courses (3.4).

### Query 8 — Maximum Instructor Salary in Computer Science
```sql
SELECT MAX(i.Salary) AS MaximumSalary FROM Instructors i
JOIN Departments d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';
```
Joins `Instructors` to `Departments` and applies `MAX()` scoped to a single department. Returns 82000 (David Brown's salary).

### Query 9 — Student Count per Department
```sql
SELECT d.DepartmentID, d.DepartmentName, COUNT(DISTINCT e.StudentID) AS TotalStudents FROM Departments d
LEFT JOIN Courses c ON d.DepartmentID = c.DepartmentID
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentID, d.DepartmentName;
```
Chains two `LEFT JOIN`s (Departments → Courses → Enrollments) so that departments with no courses or no enrollments still appear in the result with a count of 0, rather than being dropped as they would be with `INNER JOIN`. `COUNT(DISTINCT e.StudentID)` avoids double-counting a student enrolled in multiple courses in the same department.

### Query 10 — Inner Join: Students and Their Courses
```sql
SELECT s.StudentID, s.FirstName, s.LastName, c.CourseID, c.CourseName FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;
```
Returns only students who have at least one enrollment — students with no enrollment records are excluded entirely, which is the defining behavior of `INNER JOIN`.

### Query 11 — Left Join: Students and Their Courses (Including Unenrolled)
```sql
SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;
```
Same shape as Query 10 but with `LEFT JOIN`, so every student appears at least once — students with no enrollments show up with `NULL` in the `CourseName` column instead of being dropped. Directly illustrates the contrast with Query 10.

### Query 12 — Subquery: Students in Courses With More Than 10 Enrollments
```sql
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (
  SELECT CourseID FROM Enrollments
  GROUP BY CourseID
  HAVING COUNT(StudentID) > 10
);
```
Uses a subquery in the `WHERE ... IN` clause to first identify which `CourseID`s have more than 10 enrollments, then filters students against that list. Demonstrates nested query logic as an alternative to a join-and-filter approach. With only 8 seed enrollment rows total, no course currently meets the threshold — this pattern will return rows once more enrollment data is added.

### Query 13 — Extract Year From Enrollment Date
```sql
SELECT StudentID, FirstName, LastName, EnrollmentDate,
  YEAR(EnrollmentDate) AS EnrollmentYear
FROM Students;
```
Uses the `YEAR()` date function to pull just the year component out of the `EnrollmentDate` column as a new computed column.

### Query 14 — Concatenate Instructor First & Last Name
```sql
SELECT InstructorID, CONCAT(FirstName, ' ', LastName) AS InstructorName FROM Instructors;
```
Uses `CONCAT()` to merge `FirstName` and `LastName` into a single formatted `InstructorName` column, separated by a space.

### Query 15 — Running Total of Enrollments
```sql
SELECT EnrollmentID, StudentID, CourseID, EnrollmentDate,
  COUNT(*) OVER (
    ORDER BY EnrollmentDate, EnrollmentID
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS RunningTotal
FROM Enrollments
ORDER BY EnrollmentDate, EnrollmentID;
```
A window function example: `COUNT(*) OVER (...)` computes a running (cumulative) count of enrollments ordered by date, without collapsing rows the way `GROUP BY` would. Each row shows the total number of enrollments up to and including that row — useful for tracking growth over time.

### Query 16 — Label Students as Senior or Junior
```sql
SELECT StudentID, FirstName, LastName, EnrollmentDate,
CASE
  WHEN EnrollmentDate < DATE_SUB(CURDATE(), INTERVAL 4 YEAR)
  THEN 'Senior'
  ELSE 'Junior'
END AS StudentStatus
FROM Students;
```
Uses a `CASE` expression combined with `DATE_SUB(CURDATE(), INTERVAL 4 YEAR)` to compute a dynamic cutoff date (4 years before today) and label each student as `'Senior'` if they enrolled before that cutoff, or `'Junior'` otherwise. Because it's based on `CURDATE()`, the classification shifts automatically as time passes — no seed data will remain "Senior" forever without re-running against a fixed reference date.

### Summary Table

| # | Query | Concept Demonstrated |
|---|---|---|
| 1 | CRUD operations across all five tables | `INSERT`, `SELECT`, `UPDATE`, `DELETE` |
| 2 | Students who enrolled after 2022 | Filtering with `WHERE` |
| 3 | Courses offered by the Mathematics department | `JOIN`, `LIMIT` |
| 4 | Courses with more than 5 enrolled students | `GROUP BY`, `HAVING` |
| 5 | Students enrolled in both SQL and Data Structures | `JOIN`, `HAVING COUNT(DISTINCT ...)` |
| 6 | Students enrolled in SQL or Data Structures | `JOIN`, `DISTINCT`, `IN` |
| 7 | Average credits across all courses | `AVG()` |
| 8 | Maximum instructor salary in Computer Science | `MAX()`, `JOIN` |
| 9 | Student count per department | `LEFT JOIN`, `COUNT(DISTINCT ...)` |
| 10 | Students and their courses | `INNER JOIN` |
| 11 | Students and their courses (including unenrolled) | `LEFT JOIN` |
| 12 | Students in courses with more than 10 enrollments | Subquery |
| 13 | Extract enrollment year | `YEAR()` |
| 14 | Concatenate instructor names | `CONCAT()` |
| 15 | Running total of enrollments over time | Window function (`COUNT() OVER`) |
| 16 | Label students as Senior/Junior by enrollment date | `CASE`, `DATE_SUB()`, `CURDATE()` |

## Requirements

- MySQL 8.0+ (uses `DATE_SUB`, `CURDATE`, and window functions, which require MySQL 8.0 or a compatible RDBMS)

## How to Run

1. Clone this repository.
2. Open a MySQL client (MySQL Workbench, CLI, etc.).
3. Run the script:
   ```bash
   mysql -u your_username -p < FINAL_SQL_PROJECT.sql
   ```
4. This will create the database, tables, seed data, and execute all queries in sequence.

## File Structure

```
.
├── FINAL_SQL_PROJECT.sql   # Full schema, seed data, and queries
└── README.md               # Project documentation
```

## Notes

- Query 1 demonstrates CRUD by inserting a temporary row into each table, then updating and deleting it — the tables return to their original seeded state after execution.
- Queries 4 and 12 use thresholds (`> 5`, `> 10`) that exceed the current seed data size, so they illustrate the pattern rather than returning rows against this particular dataset — increase the seed data to see them return results.

## Author

Feel free to fork, adapt, or extend this project for your own learning or portfolio.
