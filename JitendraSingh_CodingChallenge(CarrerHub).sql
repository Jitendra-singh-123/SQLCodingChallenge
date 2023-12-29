
-- Career Hub Coding Challenge
--Name - Jitendra Singh


--1 Provide a SQL script that initializes the database for the Job Board scenario “CareerHub”. 
create database CareerHub;
use CareerHub;

--2. Create tables for Companies, Jobs, Applicants and Applications. 
-- Create Companies table
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    Location VARCHAR(255)
);

-- Create Jobs table
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY,
    CompanyID INT,
    JobTitle VARCHAR(255),
    JobDescription TEXT,
    JobLocation VARCHAR(255),
    Salary DECIMAL,
    JobType VARCHAR(255),
    PostedDate DATETIME,
);

-- Create Applicants table
CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Resume TEXT
);

-- Create Applications table
CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY,
    JobID INT,
    ApplicantID INT,
    ApplicationDate DATETIME,
    CoverLetter TEXT,
);

--3. Define appropriate primary keys, foreign keys, and constraints. 

-- Add foreign key to Jobs table
ALTER TABLE Jobs
ADD CONSTRAINT FK_Jobs_Companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID);

-- Add foreign key to Applications table referencing Jobs table
ALTER TABLE Applications
ADD CONSTRAINT FK_Applications_Jobs FOREIGN KEY (JobID) REFERENCES Jobs(JobID);

-- Add foreign key to Applications table referencing Applicants table
ALTER TABLE Applications
ADD CONSTRAINT FK_Applications_Applicants FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID);


--4.Ensure the script handles potential errors, such as if the database or tables already exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CareerHub')
BEGIN
    CREATE DATABASE CareerHub;
    PRINT 'CareerHub database created.';
END
ELSE
BEGIN
    PRINT 'CareerHub database already exists.';
END



--Inserting Data in all tables
INSERT INTO Companies (CompanyID, CompanyName, Location)
VALUES
    (1, 'Hexaware', 'Chennai'),
    (2, 'Cognizant', 'Mumbai'),
    (3, 'Capgimini', 'Banglore'),
    (4, 'Google', 'Kolkata'),
    (5, 'Infosys', 'Gurugram');

INSERT INTO Jobs (JobID, CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate)
VALUES
    (101, 1, 'Software Developer', 'Develop software applications', 'Gurugram', 85000.00, 'Full-time', '2023-01-15'),
    (102, 2, 'Marketing Specialist', 'Handle marketing campaigns', 'Noida', 75000.00, 'Part-time', '2023-02-20'),
    (103, 3, 'Data Analyst', 'Analyze business data', 'Kolkata', 80000.00, 'Full-time', '2023-03-10'),
    (104, 4, 'Financial Manager', 'Manage financial operations', 'pune', 95000.00, 'Full-time', '2023-04-05'),
    (105, 5, 'HR Coordinator', 'Handle HR tasks', 'Chennai', 70000.00, 'Part-time', '2023-05-12');
  
  INSERT INTO Jobs VALUES (106, 1, 'Editor', 'Handle Editing tasks', 'Mumbai', 90000.00, 'Part-time', '2023-09-12');

INSERT INTO Applicants (ApplicantID, FirstName, LastName, Email, Phone, Resume)
VALUES
    (201, 'Alice', 'Johnson', 'alice@email.com', '123-456-7890', 'Education: ABC University'),
    (202, 'Bob', 'Smith', 'bob@email.com', '987-654-3210', 'Education: XYZ College'),
    (203, 'Charlie', 'Brown', 'charlie@email.com', '456-789-0123', 'Education: PQR Institute'),
    (204, 'David', 'Lee', 'david@email.com', '111-222-3333', 'Education: LMN School'),
    (205, 'Emma', 'Davis', 'emma@email.com', '444-555-6666', 'Education: EFG Institute'),
    (206, 'Frank', 'Wilson', 'frank@email.com', '777-888-9999', 'Education: JKL College');

INSERT INTO Applications (ApplicationID, JobID, ApplicantID, ApplicationDate, CoverLetter)
VALUES
    (401, 101, 201, '2023-01-17', 'I am interested in software development.'),
    (402, 102, 202, '2023-02-22', 'I have experience in marketing.'),
    (403, 103, 203, '2023-03-12', 'I possess strong data analysis skills.'),
    (404, 104, 204, '2023-04-08', 'I have expertise in financial management.'),
    (405, 105, 205, '2023-05-15', 'I am skilled in HR activities.'),
    (406, 102, 206, '2023-06-20', 'I have managed product development.'),
    (407, 103, 202, '2023-07-25', 'I excel in sales and customer handling.'),
    (408, 104, 201, '2023-08-31', 'I possess strong analytical skills.'),
    (409, 105, 204, '2023-09-16', 'I have experience in customer support.'),
    (410, 102, 206, '2023-10-05', 'I am adept at business development.');


--5. Write an SQL query to count the number of applications received for each job listing in the 
--"Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all 
--jobs, even if they have no applications.
SELECT j.JobTitle, COUNT(*) FROM Jobs j
LEFT JOIN Applications a
ON j.JobID = a.JobID
GROUP BY j.JobTitle

--6. Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary 
--range. Allow parameters for the minimum and maximum salary values. Display the job title, 
--company name, location, and salary for each matching job.
DECLARE @MinimumSalary DECIMAL(10, 2) = 50000;
DECLARE @MaximumSalary DECIMAL(10, 2) = 80000;
SELECT j.JobTitle,c.CompanyName,c.Location,j.Salary FROM Jobs j
JOIN Companies c
ON j.CompanyID = c.CompanyID WHERE j.Salary BETWEEN @MinimumSalary AND @MaximumSalary;


--7. Write an SQL query that retrieves the job application history for a specific applicant. Allow a 
--parameter for the ApplicantID, and return a result set with the job titles, company names, and 
--application dates for all the jobs the applicant has applied to.
DECLARE @ApplicantID INT = 201;
SELECT Jobs.JobTitle, Companies.CompanyName, Applications.ApplicationDate
FROM Applications
INNER JOIN Jobs ON Applications.JobID = Jobs.JobID
INNER JOIN Companies ON Jobs.CompanyID = Companies.CompanyID
WHERE Applications.ApplicantID = @ApplicantID;


--8. Create an SQL query that calculates and displays the average salary offered by all companies for 
--job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero.
SELECT c.CompanyName,AVG(Salary) as Average_Salary FROM Companies c
JOIN Jobs j ON c.CompanyID = j.CompanyID WHERE j.Salary > 0
GROUP BY c.CompanyName

--9. Write an SQL query to identify the company that has posted the most job listings. Display the 
--company name along with the count of job listings they have posted. Handle ties if multiple 
--companies have the same maximum count.
SELECT TOP 1 c.CompanyName,COUNT(j.JobID) AS JobCount FROM Companies c
LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyName ORDER BY JobCount DESC

--10. Find the applicants who have applied for positions in companies located in 'CityX' and have at 
--least 3 years of experience.	
--Column 'Experience' was not present in Applicants table
ALTER TABLE Applicants
ADD Experience INT;

UPDATE Applicants
SET Experience = 10
WHERE ApplicantID = 202; 

--Let CityX be 'Chennai'
SELECT a.ApplicantID,a.FirstName FROM Applicants a
JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
JOIN Jobs j ON ap.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE c.Location = 'Chennai' AND a.Experience >= 3;



--11. Retrieve a list of distinct job titles with salaries between $60,000 and $80,000
SELECT DISTINCT JobTitle FROM Jobs 
WHERE Salary BETWEEN 60000 AND 80000

--12. Find the jobs that have not received any applications.
SELECT j.JobID,j.JobTitle FROM Jobs j
WHERE j.JobID NOT IN(SELECT DISTINCT a.JobID FROM Applications a)

--13. Retrieve a list of job applicants along with the companies they have applied to and the positions 
--they have applied for
SELECT a.FirstName, a.LastName,c.CompanyName,j.JobTitle FROM Applicants a
JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
JOIN Jobs j  ON j.JobID = ap.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID


--14. Retrieve a list of companies along with the count of jobs they have posted, even if they have not 
--received any applications.
SELECT c.CompanyName,COUNT(*) as JobCount FROM Companies c 
LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyName


--15. List all applicants along with the companies and positions they have applied for, including those 
--who have not applied
SELECT a.FirstName , a.LastName ,c.CompanyName ,j.JobTitle
FROM Applicants a
LEFT JOIN Applications ap ON a.ApplicantID=ap.ApplicantID
LEFT JOIN Jobs j ON ap.JobID =j.JobID
LEFT JOIN Companies c ON j.CompanyID = c.CompanyID;

--16. Find companies that have posted jobs with a salary higher than the average salary of all jobs.
SELECT c.CompanyName FROM Companies c
JOIN Jobs j ON c.CompanyID = j.CompanyID
WHERE j.Salary > (SELECT AVG(salary) FROM jobs);

--17. Display a list of applicants with their names and a concatenated string of their city and state
--Column City and State not present in Applicants Table
ALTER TABLE Applicants
ADD City varchar(20), State varchar(20);

UPDATE Applicants
SET City = 'Chennai', State = 'Tamil Nadu'
WHERE ApplicantID = 206;

SELECT FirstName + ' ' + LastName + ' ' as Names, City + ',' + State AS Address FROM Applicants 

--18. Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'
SELECT *
FROM Jobs
WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%';

--19. Retrieve a list of applicants and the jobs they have applied for, including those who have not 
--applied and jobs without applicants.
SELECT A.FirstName, A.LastName, J.JobTitle FROM Applicants A
LEFT JOIN Applications AP ON A.ApplicantID = AP.ApplicantID
LEFT JOIN Jobs J ON AP.JobID = J.JobID;


--20. List all combinations of applicants and companies where the company is in a specific city and the 
--applicant has more than 2 years of experience. For example: city=Chennai
SELECT A.FirstName, A.LastName, C.CompanyName,c.Location
FROM Applicants A
CROSS JOIN Companies C
WHERE C.Location = 'Chennai' AND A.Experience > 2;



SELECT * FROM Jobs
SELECT * FROM Applicants
SELECT * FROM Companies
SELECT * FROM Applications


