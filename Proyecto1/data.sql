-- example data for the table Campus
INSERT INTO Campus (campusName)
VALUES 
    ('Campus A'),
    ('Campus B'),
    ('Campus C');

-- example data for the table Faculty
INSERT INTO Faculty (name)
VALUES ('Sciences'),
    ('Engineering'),
    ('Communication Sciences'),
    ('Arts'),
    ('Humanities'),
    ('Administration'),
    ('Medicine'),
    ('Social Sciences'),
    ('Education'),
    ('Law'),
    ('Architecture'),
    ('Math');

-- example data for the table Career
INSERT INTO Career (careerName, description, facultyId) 
VALUES
    ('Systems Engineering', 'Systems engineering degree', 2),
    ('Civil Engineering', 'Construction degree', 2),
    ('Business Administration', 'Business degree', 6),
    ('Architecture', 'Design and construction degree', 11),
    ('Law', 'Law degree', 10),
    ('Medicine', 'Health sciences degree', 7),
    ('Psychology', 'Social sciences degree', 8),
    ('Communication', 'Media and communication degree', 3),
    ('Education', 'Teacher education degree', 9),
    ('Dentistry', 'Dentistry degree', 7),
    ('Environmental Engineering', 'Environmental sciences degree', 2),
    ('Electronic Engineering', 'Electronic engineering degree', 2),
    ('Art and Design', 'Art and design degree', 4),
    ('Math', 'Math career', 4);

-- example data for the table User_
INSERT INTO User_ (userId, userName, birthDate, email) 
VALUES 
    ('001', 'John Doe', '1989-05-12', 'john.doe@example.com'),
    ('002', 'Jane Smith', '1995-02-28', 'jane.smith@example.com'),
    ('003', 'Robert Johnson', '1982-11-15', 'robert.johnson@example.com'),
    ('004', 'Emily Davis', '1990-07-23', 'emily.davis@example.com'),
    ('005', 'Michael Brown', '1999-01-06', 'michael.brown@example.com'),
    ('006', 'Sarah Lee', '1987-08-02', 'sarah.lee@example.com'),
    ('007', 'David Kim', '1994-04-17', 'david.kim@example.com'),
    ('008', 'Elizabeth Chen', '1992-12-01', 'elizabeth.chen@example.com'),
    ('009', 'Juan Pérez', '1990-01-01', 'juan.perez@mail.com'),
    ('010', 'María García', '1995-02-15', 'maria.garcia@mail.com'),
    ('011', 'Pedro Rodríguez', '1985-06-22', 'pedro.rodriguez@mail.com'),
    ('012', 'Ana Torres', '1998-12-05', 'ana.torres@mail.com'),
    ('013', 'Luisa Fernández', '1992-08-12', 'luisa.fernandez@mail.com'),
    ('014', 'David Gómez', '1997-03-30', 'david.gomez@mail.com'),
    ('015', 'Moises Solano', '2002-03-25', 'moisessoes@gmail.com');


-- example data for the table Student
INSERT INTO Student (userId, isAssistant)
VALUES
    ('001', 0),
    ('002', 1),
    ('003', 1),
    ('004', 0),
    ('005', 0),
    ('006', 1),
    ('007', 0),
    ('008', 1);

-- example data for the table Professor
INSERT INTO Professor (userId)
VALUES ('009'),
       ('010'),
       ('011'),
       ('012'),
       ('013'),
       ('014');

-- example data for the table Administrator
INSERT INTO Administrator (userId)
VALUES ('015');

-- example data for the table CampusXUser
INSERT INTO CampusXUser (campusId, userId)
VALUES (1, '001'),
       (2, '002'),
       (1, '003'),
       (3, '004'),
       (2, '005'),
       (1, '006'),
       (3, '007'),
       (2, '008'),
       (1, '009'),
       (2, '010'),
       (3, '011'),
       (1, '012'),
       (2, '013'),
       (3, '014'),
       (1, '015');

-- example data for the table ProfessorXFaculty
INSERT INTO ProfessorXFaculty (userId, facultyId)
VALUES ('009', 1),
       ('010', 2),
       ('011', 3),
       ('012', 4),
       ('013', 5),
       ('014', 6);

-- creado, en progreso, finalizado
-- example data for the table PeriodStatus
INSERT INTO PeriodStatus (description)
VALUES ('created'), ('in progress'), ('finalized');

-- example data for the table PeriodType
INSERT INTO PeriodType (description)
VALUES ('annual'),
       ('semiannual'),
       ('quarterly'),
       ('fourmonthly'),
       ('bimonthly');

-- example data for the table SchoolPeriod
INSERT INTO SchoolPeriod (periodTypeId, startDate, endDate, statusId)
VALUES
    (4, '2021-02-07', '2022-05-15', 3),
    (5, '2021-12-01', '2022-01-29', 2),
    (2, '2021-07-01', '2021-11-28', 1),
    (2, '2022-02-07', '2022-06-20', 1),
    (2, '2022-06-07', '2022-11-24', 1);

-- example data for the table EnrollmentStatus
INSERT INTO EnrollmentStatus (description)
VALUES ('open'), ('closed');

-- example data for the table Enrollment
INSERT INTO Enrollment (periodId, statusId, startDate, endingDate)
VALUES (5, 2, '2022-02-01', '2022-06-30');

-- example data for the table EvalutionType
INSERT INTO EvaluationType (description)
VALUES 
    ('written exam'),
    ('Oral exam'),
    ('Homework'),
    ('Oral presentation'),
    ('Project'),
    ('Laboratory practice'),
    ('Essay'),
    ('Investigation');

-- example data for the table FileType
INSERT INTO FileType (fileTypeName)
VALUES ('json'),
       ('bson'),
       ('txt'),
       ('html'),
       ('css'),
       ('js'),
       ('py'),
       ('java'),
       ('cs'),
       ('php'),
       ('sql'),
       ('xml'),
       ('yaml'),
       ('pdf'),
       ('doc'),
       ('xls'),
       ('ppt'),
       ('jpg'),
       ('mp3'),
       ('mp4'),
       ('zip'),
       ('rar'),
       ('tar.gz'),
       ('other');

-- example data for the table Day
INSERT INTO Day_ (name)
VALUES ('Monday'), ('Tuesday'), ('Wednesday'), ('Thursday'), ('Friday'), ('Saturday'), ('Sunday');

-- example data for the table Course
INSERT INTO Course (courseName, facultyId, credits, hoursPerWeek, description, periodTypeId)
VALUES ('Calculus I', 12, 4, 4, 'Introductory calculus course', 2),
       ('Calculus II', 12, 4, 4, 'Calculus course with focus on integrals', 2),
       ('Linear Algebra', 12, 3, 3, 'Introductory linear algebra course', 2),
       ('Discrete Mathematics', 12, 3, 3, 'Course on discrete mathematics and combinatorics', 2),
       ('Programming Fundamentals', 2, 4, 4, 'Introduction to programming using Java', 2),
       ('Data Structures and Algorithms', 2, 4, 4, 'Course on data structures and algorithms using Java', 2),
       ('Marketing Management', 4, 3, 3, 'This course covers the principles and practices of marketing management.', 2),
       ('Introduction to Psychology', 8, 3, 3, 'This course covers the fundamentals of psychology.', 2),
       ('Spanish Language and Literature', 9, 3, 3, 'This course covers the literature and language of the Spanish-speaking world.', 2);

-- example data for the table Schedule
INSERT INTO Schedule (starTime, finishTime)
VALUES 
    ('07:30:00', '09:20:00'),
    ('9:30:00', '11:20:00'),
    ('01:00:00', '15:20:00'),
    ('15:30:00', '17:20:00'),
    ('17:30:00', '19:20:00');

-- example data for the table ScheduleXDay
INSERT INTO ScheduleXDay (scheduleId, dayId) 
VALUES (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1),
    (1, 2),
    (2, 2),
    (3, 2),
    (4, 2),
    (5, 2),
    (1, 3),
    (2, 3),
    (3, 3),
    (4, 3),
    (5, 3),
    (1, 4),
    (2, 4),
    (3, 4),
    (4, 4),
    (5, 4),
    (1, 5),
    (2, 5),
    (3, 5),
    (4, 5),
    (5, 5),
    (1, 6),
    (2, 6),
    (3, 6),
    (4, 6),
    (5, 6);

-- example data for the table CourseGroup
INSERT INTO CourseGroup (courseId, periodId, professorId, maxStudents)
VALUES (1, 4, '009', 20),
       (2, 4, '010', 25),
       (3, 4, '011', 30),
       (4, 4, '012', 18),
       (5, 4, '013', 22),
       (6, 4, '014', 28),
       (7, 4, '009', 35),
       (8, 4, '010', 15),
       (9, 4, '011', 20),
       (1, 5, '009', 20),
       (2, 5, '010', 25),
       (3, 5, '011', 30),
       (4, 5, '012', 18),
       (5, 5, '013', 22),
       (6, 5, '014', 28),
       (7, 5, '009', 35),
       (8, 5, '010', 15),
       (9, 5, '011', 20);

-- example data for the table PlanStatus
INSERT INTO PlanStatus (description)
VALUES ('creation'), ('active'), ('closed');

-- example data for the table CareerPlan
INSERT INTO CareerPlan (careerId, creationDate, activationDate, endingDate, statusId)
VALUES
	(1, '2022-01-01', '2022-02-01', '2025-05-01', 2),
	(2, '2022-02-15', '2022-03-01', '2025-06-01', 2),
	(3, '2022-03-10', '2022-04-01', '2025-07-01', 2),
	(4, '2022-04-05', '2022-05-01', '2025-08-01', 2),
	(5, '2022-05-01', '2022-06-01', '2025-09-01', 2),
    (7, '2022-05-01', '2022-06-01', '2025-09-01', 2),
    (9, '2022-05-01', '2022-06-01', '2025-09-01', 2),
    (13, '2022-05-01', '2022-06-01', '2025-09-01', 2),
    (14, '2022-05-01', '2022-06-01', '2025-09-01', 2);

-- example data for the table CourseXPlan
INSERT INTO CourseXPlan (planId, courseId)
VALUES
	(9, 1),
	(9, 2),
	(9, 3),
	(1, 4),
	(1, 5),
	(1, 6),
	(8, 7),
	(6, 8),
	(7, 9);

-- example data for the table CourseRequirment
INSERT INTO CourseRequirement (courseId, courseXPlanId)
VALUES
	(2, 1),
	(3, 2),
	(6, 5);

-- example data for the table ScheduleXCourseGroup
INSERT INTO ScheduleXCourseGroup (scheduleXDayId, courseGroupId)
VALUES
	(11, 1),
    (21, 1),
	(11, 2),
    (22, 2),
	(7, 3),
    (17, 3),
	(9, 4),
    (19, 4),
	(13, 5),
    (23, 5),
	(15, 6),
    (25, 6),
	(1, 7),
    (2, 7),
	(28, 8),
    (4, 9),
	(11, 10),
    (22, 10),
    (11, 11),
    (21, 11),
    (7, 12),
    (17, 12),
    (9, 13),
    (19, 13),
    (13, 14),
    (23, 14),
    (15, 15),
    (25, 15),
    (1, 16),
    (2, 16),
    (28, 17),
    (4, 18);

-- example data for the table CourseEvaluation
INSERT INTO [CourseEvaluation] (description, courseGroupId, score)
VALUES
	('The course was well-organized and informative. I found it helpful in preparing for my career.', 1, 8.7),
	('The course content was engaging and the instructor was knowledgeable. Overall, it was a great learning experience.', 1, 9.1),
	('The course was informative, but the pace was a bit slow for my liking. I think it could have been more challenging.', 2, 6.9),
	('The course content was relevant and useful. The instructor was approachable and willing to help.', 3, 7.8),
	('The course was interesting, but I think it could have gone into more depth on some topics. Overall, it was a good learning experience.', 4, 7.2),
	('The course was very useful and the instructor was knowledgeable. I learned a lot and would recommend it to others.', 5, 8.4),
	('The course was challenging, but the instructor was helpful and provided good feedback. I feel like I learned a lot and improved my skills.', 6, 8.1),
	('The course was engaging and the instructor was approachable. I enjoyed learning about the subject and found the content relevant.', 7, 8.3),
	('The course was informative and the instructor was knowledgeable. Overall, it was a good learning experience.', 8, 7.6),
    ('The course was very challenging, but the instructor was very helpful and provided good feedback. I learned a lot and improved my skills.', 9, 9.0),
	('The course content was engaging and the instructor was knowledgeable. I enjoyed learning about the subject and found the assignments very helpful.', 10, 8.2),
	('The course was well-structured and the instructor was approachable. I found it to be a great learning experience overall.', 11, 8.8),
	('The course was informative, but the instructor was a bit disorganized at times. I think it could have been more efficient.', 12, 7.1),
	('The course content was relevant and useful. The instructor was approachable and willing to help. Overall, it was a great learning experience.', 13, 9.4),
	('The course was very interesting and the instructor was very knowledgeable. I learned a lot and would highly recommend it to others.', 14, 9.6),
	('The course was well-designed and the instructor was very engaging. I found it to be a great learning experience overall.', 15, 8.9),
	('The course was very challenging, but the instructor was very knowledgeable and supportive. I learned a lot and felt a great sense of accomplishment.', 16, 9.3),
	('The course content was comprehensive and the instructor was very approachable. I found it to be a great learning experience overall.', 17, 8.5),
    ('The course content was very relevant and the instructor was very knowledgeable. I learned a lot and felt very engaged throughout the course.', 18, 9.2);

-- 