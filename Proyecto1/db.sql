USE [db01]
GO

IF OBJECT_ID('CareerPlan') IS NOT NULL
BEGIN 
DROP TABLE CareerPlan
END
GO
CREATE TABLE [CareerPlan](
    planId INT IDENTITY(1,1) PRIMARY KEY,
    careerId INT NOT NULL, 
    creationDate DATETIME NOT NULL,
    activationDate DATE NOT NULL,
	endingDate DATE NOT NULL,
	statusId INT NOT NULL
)
GO

-- =============================================

IF OBJECT_ID('PlanStatus') IS NOT NULL
BEGIN
DROP TABLE PlanStatus
END
GO
CREATE TABLE [PlanStatus](
    [statusId] INT IDENTITY(1,1) PRIMARY KEY,
    [description] VARCHAR(50) NOT NULL
)
GO

-- =============================================

IF OBJECT_ID('CourseXPlan') IS NOT NULL
BEGIN
DROP TABLE CourseXPlan
END
GO
CREATE TABLE [CourseXPlan](
    [courseXPlanId] INT IDENTITY(1,1) PRIMARY KEY,
    [planId] INT NOT NULL,
    [courseId] INT NOT NULL
)
GO

-- =============================================

IF OBJECT_ID('CourseRequirement') IS NOT NULL
BEGIN
DROP TABLE CourseRequirement
END
GO

CREATE TABLE [CourseRequirement](
    [courseRequirementId] INT IDENTITY(1,1) PRIMARY KEY,
    [courseId] INT NOT NULL,
    [courseXPlanId] INT NOT NULL
)
GO

-- =============================================

IF OBJECT_ID('SchoolPeriod') IS NOT NULL
BEGIN
DROP TABLE SchoolPeriod
END
GO
CREATE TABLE [SchoolPeriod](
    [schoolPeriodId] INT IDENTITY(1,1) PRIMARY KEY,
    [periodTypeId] INT NOT NULL,
    [startDate] DATE NOT NULL,
    [endDate] DATE NOT NULL,
    [statusId] INT NOT NULL
)
GO

-- =============================================

IF OBJECT_ID('PeriodType') IS NOT NULL
BEGIN
DROP TABLE PeriodType
END
GO

CREATE TABLE [PeriodType](
    [periodTypeId] INT IDENTITY(1,1) PRIMARY KEY,
    [description] VARCHAR(50) NOT NULL
)
GO

-- =============================================

IF OBJECT_ID('PeriodStatus') IS NOT NULL
BEGIN
DROP TABLE PeriodStatus
END
GO

CREATE TABLE [PeriodStatus](
    [statusId] INT IDENTITY(1,1) PRIMARY KEY,
    [description] VARCHAR(50) NOT NULL
)
GO

/*
Table Course
*/
IF OBJECT_ID('Course') IS NOT NULL
BEGIN 
DROP TABLE Course
END
GO

CREATE TABLE Course(
    courseId INT PRIMARY KEY IDENTITY,
    courseName VARCHAR(50) NOT NULL, 
    facultyId INT NOT NULL,
    credits INT NOT NULL,
    hoursPerWeek INT NOT NULL,
    description VARCHAR(100) NOT NULL,
    periodTypeId INT NOT NULL
)

/*
Table CourseXFile
*/
IF OBJECT_ID('CourseXFile') IS NOT NULL
BEGIN 
DROP TABLE CourseXFile
END
GO

CREATE TABLE CourseXFile(
    CourseXFileId INT PRIMARY KEY IDENTITY,
    courseId INT NOT NULL,
    fileId INT NOT NULL
)

/*
Table EnrollmentXStudent
*/
IF OBJECT_ID('EnrollmentXStudent') IS NOT NULL
BEGIN 
DROP TABLE EnrollmentXStudent
END
GO

CREATE TABLE EnrollmentXStudent(
    enrollmentXStudentId INT PRIMARY KEY IDENTITY,
    enrollmentTime DATETIME NOT NULL,
    userId INT NOT NULL,
    enrollmentId INT NOT NULL
)

/*
Table CourseEvaluation
*/
IF OBJECT_ID('CourseEvaluation') IS NOT NULL
BEGIN 
DROP TABLE CourseEvaluation
END
GO

CREATE TABLE CourseEvaluation(
    courseEvaluationId INT PRIMARY KEY IDENTITY,
    description VARCHAR(100) NOT NULL,
    courseId INT NOT NULL,
    courseGroupId INT NOT NULL,
    score FLOAT NOT NULL
)

/*
Table CareerXUser
*/
IF OBJECT_ID('CareerXUser') IS NOT NULL
BEGIN 
DROP TABLE CareerXUser
END
GO

CREATE TABLE CareerXUser(
    careerXUserId INT PRIMARY KEY IDENTITY,
    careerId INT NOT NULL,
    userId INT NOT NULL
)

/*
Table CampusXUser
*/
IF OBJECT_ID('CampusXUser') IS NOT NULL
BEGIN 
DROP TABLE CampusXUser
END
GO

CREATE TABLE CampusXUser(
    campusXUserId INT PRIMARY KEY IDENTITY,
    campusId INT NOT NULL,
    userId INT NOT NULL
)

/*
Table Faculty
*/
IF OBJECT_ID('Faculty') IS NOT NULL
BEGIN 
DROP TABLE Faculty
END
GO

CREATE TABLE Faculty(
    facultyId INT PRIMARY KEY IDENTITY,
    name VARCHAR(50) NOT NULL
)
GO

/*
Table Evaluation
*/
IF OBJECT_ID('Evaluation') IS NOT NULL
BEGIN 
DROP TABLE Evaluation
END
GO

CREATE TABLE Evaluation(
    evaluationId INT PRIMARY KEY IDENTITY,
    description VARCHAR(100) NOT NULL,
    deadline DATETIME NOT NULL,
    totalValue FLOAT NOT NULL,
    evaluationTypeId INT NOT NULL
)
GO

/*-------------------------------------------------------------------
Table day
--------------------------------------------------------------------*/
IF OBJECT_ID('Day_') IS NOT NULL
BEGIN 
DROP TABLE Day_
END
GO
CREATE TABLE Day_(
    dayId INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL 
)

/*-------------------------------------------------------------------
Table Schedule
--------------------------------------------------------------------*/
IF OBJECT_ID('Schedule') IS NOT NULL
BEGIN 
DROP TABLE Schedule
END
GO
CREATE TABLE Schedule(
    scheduleId INT IDENTITY(1,1) PRIMARY KEY,
    starTime DATETIME NOT NULL, 
    finishTime DATETIME NOT NULL 
)


/*-------------------------------------------------------------------
Table ScheduleXDay
--------------------------------------------------------------------*/

IF OBJECT_ID('ScheduleXDay') IS NOT NULL
BEGIN 
DROP TABLE ScheduleXDay
END
GO
CREATE TABLE ScheduleXDay(
    scheduleXDayId INT IDENTITY(1,1) PRIMARY KEY,
    scheduleId INT NOT NULL, 
    dayId INT NOT NULL
)
GO

/*-------------------------------------------------------------------
Table CourseGroup
--------------------------------------------------------------------*/

IF OBJECT_ID('CourseGroup') IS NOT NULL
BEGIN 
DROP TABLE CourseGroup
END
GO
CREATE TABLE CourseGroup(
    courseGroupId INT IDENTITY(1,1) PRIMARY KEY,
    courseId INT NOT NULL,
    periodId INT NOT NULL,
    professorId INT NOT NULL,
    maxStudents INT NOT NULL
)
GO

/*-------------------------------------------------------------------
Table ScheduleXCourseGroup
--------------------------------------------------------------------*/

IF OBJECT_ID('ScheduleXCourseGroup') IS NOT NULL
BEGIN
DROP TABLE ScheduleXCourseGroup
END
GO

CREATE TABLE ScheduleXCourseGroup(
    scheduleXCourseGroupId INT IDENTITY(1,1) PRIMARY KEY,
    scheduleId INT NOT NULL,
    courseGroupId INT NOT NULL
)
GO

/*-------------------------------------------------------------------
Table CourseGroupXFile
--------------------------------------------------------------------*/

IF OBJECT_ID('CourseGroupXFile') IS NOT NULL
BEGIN
DROP TABLE CourseGroupXFile
END
GO

CREATE TABLE CourseGroupXFile(
    courseGroupXFileId INT IDENTITY(1,1) PRIMARY KEY,
    courseGroupId INT NOT NULL,
    fileId INT NOT NULL
)
GO

/*-------------------------------------------------------------------
Table User
--------------------------------------------------------------------*/

IF OBJECT_ID('User_') IS NOT NULL
BEGIN
DROP TABLE User_
END
GO

CREATE TABLE User_(
    userId VARCHAR(32) PRIMARY KEY,
    userName VARCHAR(50) NOT NULL,
    birthDate DATE NOT NULL,
    email VARCHAR(50) NOT NULL,
    idCampus INT NOT NULL
)
GO

/*-------------------------------------------------------------------
Table WeeklySchedule
--------------------------------------------------------------------*/

IF OBJECT_ID('WeeklySchedule') IS NOT NULL
BEGIN
DROP TABLE WeeklySchedule
END
GO

CREATE TABLE WeeklySchedule(
    weeklyScheduleId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    courseGroupId INT NOT NULL
)
GO

IF OBJECT_ID('StudentXPlan') IS NOT NULL
BEGIN 
DROP TABLE StudentXPlan
END
GO
CREATE TABLE StudentXPlan(
    studentXPlanId int IDENTITY(1,1) PRIMARY KEY,
    userId VARCHAR(32) NOT NULL,
    planId int NOT NULL
)
GO

-- --------------------------------------------------

IF OBJECT_ID('professorXEvaluation') IS NOT NULL
BEGIN
DROP TABLE professorXEvaluation
END
GO
CREATE TABLE professorXEvaluation(
    professorXEvaluationId int IDENTITY(1,1) PRIMARY KEY,
    userId VARCHAR(32) NOT NULL,
    evaluationId int NOT NULL
)
GO

-- --------------------------------------------------

IF OBJECT_ID('ProfessorXFaculty') IS NOT NULL
BEGIN
DROP TABLE ProfessorXFaculty
END
GO
CREATE TABLE ProfessorXFaculty(
    professorXFacultyId int IDENTITY(1,1) PRIMARY KEY,
    userId VARCHAR(32) NOT NULL,
    facultyId int NOT NULL
)
GO

-- --------------------------------------------------

IF OBJECT_ID('File_') IS NOT NULL
BEGIN
DROP TABLE File_
END
GO
CREATE TABLE File_(
    fileId int IDENTITY(1,1) PRIMARY KEY,
    userId VARCHAR(32) NOT NULL,
    fileTypeId int NOT NULL,
    periodId int NOT NULL,
    creationDate date NOT NULL,
    modificationDate date NOT NULL,
    name varchar(50) NOT NULL,
    description varchar(100) NOT NULL,
    ver int NOT NULL
)
GO

-- --------------------------------------------------

IF OBJECT_ID('Enrollment') IS NOT NULL
BEGIN
DROP TABLE Enrollment
END
GO
CREATE TABLE Enrollment(
    enrollmentId int IDENTITY(1,1) PRIMARY KEY,
    periodId int NOT NULL,
    statusId int NOT NULL,
    starDate date NOT NULL,
    endingDate date NOT NULL
)
GO

-- --------------------------------------------------

IF OBJECT_ID('EnrollmentStatus') IS NOT NULL
BEGIN
DROP TABLE EnrollmentStatus
END
GO
CREATE TABLE EnrollmentStatus(
    statusId int IDENTITY(1,1) PRIMARY KEY,
    description varchar(50) NOT NULL
)
GO

-- Tabla Item
IF OBJECT_ID('Item') IS NOT NULL
BEGIN 
DROP TABLE Item
END
GO
CREATE TABLE Item(
    itemId INT IDENTITY(1,1) PRIMARY KEY,
    evaluationId INT NOT NULL, 
    description VARCHAR (100) NOT NULL,
    itemValue INT NOT NULL
)

-- Tabla EvaluationType
IF OBJECT_ID('EvaluationType') IS NOT NULL
BEGIN 
DROP TABLE EvaluationType
END
GO
CREATE TABLE EvaluationType(
    evaluationTypeId INT IDENTITY(1,1) PRIMARY KEY,
    description VARCHAR (100) NOT NULL
)

-- Tabla Student
IF OBJECT_ID('Student') IS NOT NULL
BEGIN 
DROP TABLE Student
END
GO
CREATE TABLE Student(
    userId VARCHAR(32) PRIMARY KEY,
    isAssistant BIT NOT NULL
)

-- Tabla Professor
IF OBJECT_ID('Professor') IS NOT NULL
BEGIN 
DROP TABLE Professor
END
GO
CREATE TABLE Professor(
    userId VARCHAR(32) PRIMARY KEY
)

-- Tabla Administrator
IF OBJECT_ID('Administrator') IS NOT NULL
BEGIN 
DROP TABLE Administrator
END
GO
CREATE TABLE Administrator(
    userId VARCHAR(32) PRIMARY KEY
)

-- Tabla FileType
IF OBJECT_ID('FileType') IS NOT NULL
BEGIN 
DROP TABLE FileType
END
GO
CREATE TABLE FileType(
    fileTypeId INT IDENTITY(1,1) PRIMARY KEY,
    fileTypeName VARCHAR (50) NOT NULL
)

-- Tabla CareerXFile
IF OBJECT_ID('CareerXFile') IS NOT NULL
BEGIN
DROP TABLE CareerXFile
END
GO
CREATE TABLE CareerXFile(
    careerXFileId INT IDENTITY(1,1) PRIMARY KEY,
    careerId INT NOT NULL,
    fileId INT NOT NULL
)

-- Tabla Campus
IF OBJECT_ID('Campus') IS NOT NULL
BEGIN
DROP TABLE Campus
END
GO
CREATE TABLE Campus(
    campusId INT IDENTITY(1,1) PRIMARY KEY,
    campusName VARCHAR (50) NOT NULL
)

-- Tabla Career
IF OBJECT_ID('Career') IS NOT NULL
BEGIN
DROP TABLE Career
END
GO

CREATE TABLE Career(
    careerId INT IDENTITY(1,1) PRIMARY KEY,
    careerName VARCHAR (50) NOT NULL,
    description VARCHAR (50) NOT NULL,
    facultyId INT NOT NULL
)

IF OBJECT_ID('StudentXItem') IS NOT NULL
BEGIN
DROP TABLE StudentXItem
END
GO
CREATE TABLE StudentXItem(
    StudentXItem INT IDENTITY(1,1) PRIMARY KEY,
    userId VARCHAR(32) NOT NULL,
    itemId INT NOT NULL,
    grade FLOAT NOT NULL
)

IF OBJECT_ID('StudentXCourse') IS NOT NULL
BEGIN
DROP TABLE StudentXCourse
END
GO
CREATE TABLE StudentXCourse(
    userXCourseId INT IDENTITY(1,1) PRIMARY KEY,
    userId VARCHAR(32) NOT NULL,
    courseId INT NOT NULL,
    status BIT NOT NULL -- 0 = Not Approved, 1 = Approved
)

-- =============================================
-- Foreign Keys

ALTER TABLE [CareerPlan] WITH CHECK ADD FOREIGN KEY([careerId])
REFERENCES [Career] ([careerId])
GO

ALTER TABLE [CareerPlan] WITH CHECK ADD FOREIGN KEY([statusId])
REFERENCES [PlanStatus] ([statusId])
GO

ALTER TABLE [CourseXPlan] WITH CHECK ADD FOREIGN KEY([planId])
REFERENCES [CareerPlan] ([planId])
GO

ALTER TABLE [CourseXPlan] WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [Course] ([courseId])
GO

ALTER TABLE [CourseRequirement] WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [Course] ([courseId])
GO

ALTER TABLE [CourseRequirement] WITH CHECK ADD FOREIGN KEY([courseXPlanId])
REFERENCES [CourseXPlan] ([courseXPlanId])
GO

ALTER TABLE [SchoolPeriod] WITH CHECK ADD FOREIGN KEY([periodTypeId])
REFERENCES [PeriodType] ([periodTypeId])
GO

ALTER TABLE [SchoolPeriod] WITH CHECK ADD FOREIGN KEY([statusId])
REFERENCES [PeriodStatus] ([statusId])
GO

ALTER TABLE [Course] WITH CHECK ADD FOREIGN KEY([facultyId])
REFERENCES [Faculty] ([facultyId])

ALTER TABLE [Course] WITH CHECK ADD FOREIGN KEY([periodTypeId])
REFERENCES [PeriodType] ([periodTypeId])
GO

ALTER TABLE [CourseXFile] WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [Course] ([courseId])
GO

ALTER TABLE [CourseXFile] WITH CHECK ADD FOREIGN KEY([fileId])
REFERENCES [File_] ([fileId])
GO

ALTER TABLE [EnrollmentXStudent] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [Student] ([userId])
GO

ALTER TABLE [EnrollmentXStudent] WITH CHECK ADD FOREIGN KEY([enrollmentId])
REFERENCES [Enrollment] ([enrollmentId])
GO

ALTER TABLE [CourseEvaluation] WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [Course] ([courseId])

ALTER TABLE [CourseEvaluation] WITH CHECK ADD FOREIGN KEY([courseGroupId])
REFERENCES [CourseGroup] ([courseGroupId])
GO

ALTER TABLE [CareerXUser] WITH CHECK ADD FOREIGN KEY([careerId])
REFERENCES [Career] ([careerId])
GO

ALTER TABLE [CareerXUser] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [User_] ([userId])
GO

ALTER TABLE [CampusXUser] WITH CHECK ADD FOREIGN KEY([campusId])
REFERENCES [Campus] ([campusId])
GO

ALTER TABLE [CampusXUser] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [User_] ([userId])
GO

ALTER TABLE [Evaluation] WITH CHECK ADD FOREIGN KEY([evaluationTypeId])
REFERENCES [EvaluationType] ([evaluationTypeId])
GO

ALTER TABLE [ScheduleXDay] WITH CHECK ADD FOREIGN KEY([ScheduleId])
REFERENCES [Schedule] ([ScheduleId])
GO

ALTER TABLE [ScheduleXDay] WITH CHECK ADD FOREIGN KEY([dayId])
REFERENCES [Day_] ([dayId])
GO

ALTER TABLE [CourseGroup] WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [Course] ([courseId])
GO

ALTER TABLE [CourseGroup] WITH CHECK ADD FOREIGN KEY([periodId])
REFERENCES [SchoolPeriod] ([schoolPeriodId])
GO

ALTER TABLE [CourseGroup] WITH CHECK ADD FOREIGN KEY([professorId])
REFERENCES [Professor] ([userId])
GO

ALTER TABLE [ScheduleXCourseGroup] WITH CHECK ADD FOREIGN KEY([ScheduleId])
REFERENCES [Schedule] ([ScheduleId])
GO

ALTER TABLE [ScheduleXCourseGroup] WITH CHECK ADD FOREIGN KEY([courseGroupId])
REFERENCES [CourseGroup] ([courseGroupId])
GO

ALTER TABLE [CourseGroupXFile] WITH CHECK ADD FOREIGN KEY([courseGroupId])
REFERENCES [CourseGroup] ([courseGroupId])
GO

ALTER TABLE [CourseGroupXFile] WITH CHECK ADD FOREIGN KEY([fileId])
REFERENCES [File_] ([fileId])
GO

ALTER TABLE [User_] WITH CHECK ADD FOREIGN KEY([idCampus])
REFERENCES [Campus] ([campusId])
GO

ALTER TABLE [WeeklySchedule] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [Student] ([userId])
GO

ALTER TABLE [WeeklySchedule] WITH CHECK ADD FOREIGN KEY([courseGroupId])
REFERENCES [CourseGroup] ([courseGroupId])
GO

ALTER TABLE [StudentXPlan] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [Student] ([userId])
GO

ALTER TABLE [StudentXPlan] WITH CHECK ADD FOREIGN KEY([planId])
REFERENCES [CareerPlan] ([planId])
GO

ALTER TABLE [professorXEvaluation] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [Professor] ([userId])
GO

ALTER TABLE [professorXEvaluation] WITH CHECK ADD FOREIGN KEY([evaluationId])
REFERENCES [Evaluation] ([evaluationId])
GO

ALTER TABLE [ProfessorXFaculty] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [Professor] ([userId])
GO

ALTER TABLE [ProfessorXFaculty] WITH CHECK ADD FOREIGN KEY([facultyId])
REFERENCES [Faculty] ([facultyId])
GO

ALTER TABLE [File_] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [User_] ([userId])
GO

ALTER TABLE [File_] WITH CHECK ADD FOREIGN KEY([fileTypeId])
REFERENCES [FileType] ([fileTypeId])
GO

ALTER TABLE [File_] WITH CHECK ADD FOREIGN KEY([periodId])
REFERENCES [SchoolPeriod] ([schoolPeriodId])
GO

ALTER TABLE [Enrollment] WITH CHECK ADD FOREIGN KEY([periodId])
REFERENCES [SchoolPeriod] ([schoolPeriodId])
GO
ALTER TABLE [Enrollment] WITH CHECK ADD FOREIGN KEY([statusId])
REFERENCES [EnrollmentStatus] ([statusId])
GO

--Tabla Item
ALTER TABLE [Item] WITH CHECK ADD FOREIGN KEY([evaluationId])
REFERENCES [Evaluation] ([evaluationId])
GO

--Tabla Student
ALTER TABLE [Student] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [User_] ([userId])
GO

-- Tabla Professor
ALTER TABLE [Professor] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [User_] ([userId])
GO

-- Tabla Visual
ALTER TABLE [Administrator] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [User_] ([userId])
GO

ALTER TABLE [Career] WITH CHECK ADD FOREIGN KEY([facultyId])
REFERENCES [Faculty] ([facultyId])
GO

ALTER TABLE [CareerXFile] WITH CHECK ADD FOREIGN KEY([careerId])
REFERENCES [Career] ([careerId])
GO

ALTER TABLE [CareerXFile] WITH CHECK ADD FOREIGN KEY([fileId])
REFERENCES [File_] ([fileId])
GO

ALTER TABLE [StudentXEvaluation] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [Student] ([userId])
GO

ALTER TABLE [StudentXEvaluation] WITH CHECK ADD FOREIGN KEY([itemId])
REFERENCES [Item] ([itemId])
GO

ALTER TABLE [StudentXCourse] WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [Student] ([userId])
GO

ALTER TABLE [StudentXCourse] WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [Course] ([courseId])
GO