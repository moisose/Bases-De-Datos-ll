USE db01
GO

--------------------------------------------------------------------------------------------------------------
----------------------------------------- ENROLLMENT SP ------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- SP GET GRADE AVERAGE
-- ENTRIES: @userId VARCHAR(32), @schoolPeriodId INT
-- Description: This procedure return the grade average of a student in a school period
CREATE OR ALTER PROCEDURE spGetGradeAverage(@userId VARCHAR(32), @schoolPeriodId INT, @resultado INT OUTPUT) AS
BEGIN
    DECLARE @sum FLOAT, @courseAmount INT
    SET @sum = 0
	SET @courseAmount = 0

    IF @userId IS NULL OR @schoolPeriodId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        SELECT 0
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        SELECT 0
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId)
    BEGIN
        IF @schoolPeriodId <= 0
        BEGIN
            SELECT 'It is the first school period' AS ExecMessage
            SELECT 100
        END

        SELECT 'The school period does not exist' AS ExecMessage
        SELECT 0
    END

	SET @courseAmount = (SELECT COUNT(CourseGroup.courseGroupId) AS total 
                    FROM Student
                    INNER JOIN WeeklySchedule ON Student.userId = WeeklySchedule.userId
                    INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
                    INNER JOIN SchoolPeriod ON SchoolPeriod.schoolPeriodId = CourseGroup.periodId
                    WHERE Student.userId = @userId AND SchoolPeriod.schoolPeriodId = @schoolPeriodId)

    SET @sum = (SELECT SUM(grade) AS totalSum 
                    FROM Student
                    INNER JOIN WeeklySchedule ON Student.userId = WeeklySchedule.userId
                    INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
                    INNER JOIN SchoolPeriod ON SchoolPeriod.schoolPeriodId = CourseGroup.periodId
                    INNER JOIN Evaluation ON Evaluation.courseGroupId = CourseGroup.courseGroupId
                    INNER JOIN Item ON Item.evaluationId = Evaluation.evaluationId
                    INNER JOIN StudentXItem ON StudentXItem.itemId = Item.itemId AND StudentXItem.userId = Student.userId

                    WHERE Student.userId = @userId AND SchoolPeriod.schoolPeriodId = @schoolPeriodId) 

    SET @resultado = @sum / @courseAmount
	--SELECT @sum / @courseAmount
	
END
GO

-- SP INSERT ENROLLMENTXSTUDENT
-- ENTRIES: @enrollmentId INT, @schoolPeriodId INT, @userId VARCHAR(32), @enrollmentTime TIME
-- Description: This procedure insert a new enrollmentXstudent, is used in the procedure spEnrollStudent
CREATE OR ALTER PROCEDURE spInsertEnrollmentXStudent(@enrollmentId INT, @schoolPeriodId INT, @userId VARCHAR(32), @enrollmentTime TIME) AS
BEGIN
	DECLARE @time INT
	SET @time = DATEPART(HOUR, @enrollmentTime)
    IF @enrollmentId IS NULL OR @userId IS NULL OR @time IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Enrollment WHERE enrollmentId = @enrollmentId)
    BEGIN
        SELECT 'The enrollment does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF @time <= 0
    BEGIN
        SELECT 'The time must be greater than 0' AS ExecMessage
        RETURN
    END
    IF EXISTS(SELECT * FROM EnrollmentXStudent WHERE userId = @userId AND enrollmentId = @enrollmentId)
    BEGIN
        SELECT 'The student is already enrolled in this enrollment' AS ExecMessage
        RETURN
    END

    INSERT INTO EnrollmentXStudent(enrollmentTime, userId, enrollmentId) VALUES(@enrollmentTime, @userId, @enrollmentId)
END
GO

-- SP ENROLLMENT TIME SCHEDULE
-- ENTRIES: @userId VARCHAR(32), @schoolPeriodId INT, @enrollmentTimeScheduleValue INT OUTPUT
-- Description: This procedure return the enrollment time schedule of a student in a school period
-- The enrollment time change depending of the grade average of the student
CREATE OR ALTER PROCEDURE spEnrollmentTimeSchedule(@userId VARCHAR(32), @schoolPeriodId INT, @enrollmentTimeScheduleValue INT OUTPUT) AS 
BEGIN
    IF @schoolPeriodId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId)
    BEGIN
        SELECT 'The school period does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    
    DECLARE @gradeAverageValue FLOAT
    EXEC spGetGradeAverage @userId, @schoolPeriodId, @gradeAverageValue OUTPUT
    SET @enrollmentTimeScheduleValue = 0

    IF @gradeAverageValue >= 95
    BEGIN
        SET @enrollmentTimeScheduleValue = 7
    END
    ELSE IF @gradeAverageValue >= 90
    BEGIN
        SET @enrollmentTimeScheduleValue = 8
    END
    ELSE IF @gradeAverageValue >= 85
    BEGIN
        SET @enrollmentTimeScheduleValue = 9
    END
    ELSE IF @gradeAverageValue >= 80
    BEGIN
        SET @enrollmentTimeScheduleValue = 10
    END
    ELSE IF @gradeAverageValue >= 75
    BEGIN
        SET @enrollmentTimeScheduleValue = 11
    END
    ELSE IF @gradeAverageValue >= 70
    BEGIN
        SET @enrollmentTimeScheduleValue = 12
    END

	--SELECT @enrollmentTimeScheduleValue

END
GO

-- SP GET ENROLLMENT TIME
-- ENTRIES: @userId VARCHAR(32), @schoolPeriodId INT, @enrollmentTime TIME OUTPUT
-- Description: This procedure return the enrollment time of a student
CREATE OR ALTER PROCEDURE spGetEnrollmentTime(@userId VARCHAR(32)) AS
BEGIN

    -- VERIFY NULL PARAMETERS
    IF @userId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END



    DECLARE @enrollmentId INT, @enrollmentTimeSchedule INT, @previousSchoolPeriod INT 

    SET @enrollmentId = (SELECT TOP 1 Enrollment.enrollmentId FROM Enrollment ORDER BY Enrollment.enrollmentId DESC)

    --IF @enrollmentId IS NULL
    --BEGIN
    --    SELECT 'There is not enrollment available' AS ExecMessage
    --    RETURN
    --END
    --IF (SELECT Enrollment.startDate FROM Enrollment WHERE Enrollment.enrollmentId = @enrollmentId) < GETDATE() 
    --BEGIN
    --    SELECT 'The las enrollment has end' AS ExecMessage
    --    RETURN
    --END
    
    SET @previousSchoolPeriod = (SELECT TOP(1) schoolPeriodId FROM SchoolPeriod
        INNER JOIN CourseGroup ON SchoolPeriod.schoolPeriodId = CourseGroup.periodId
        INNER JOIN Course ON CourseGroup.courseId = Course.courseId
        INNER JOIN StudentXCourse ON Course.courseId = StudentXCourse.courseId
		INNER JOIN WeeklySchedule ON CourseGroup.courseGroupId = weeklySchedule.courseGroupId
        
        WHERE studentXCourse.userId = @userId 
		AND StudentXCourse.status = 1 ORDER BY schoolPeriodId DESC)
    
    IF @previousSchoolPeriod IS NULL
    BEGIN
        SET @enrollmentTimeSchedule = 7
    END
    ELSE
    BEGIN
        EXEC spEnrollmentTimeSchedule @userId, @previousSchoolPeriod, @enrollmentTimeSchedule OUTPUT
    END
   
    SELECT (SELECT Enrollment.startDate FROM Enrollment WHERE Enrollment.enrollmentId = @enrollmentId), @enrollmentTimeSchedule
END
GO


-- SP STUDENT MEETS ALL REQUIREMENTS TO ENROLL THE COURSE
-- ENTRIES: @userId VARCHAR(32), @courseId INT, @meetsRequirements BIT OUTPUT
-- Description: This procedure return if a student meets all requirements to enroll a course
CREATE OR ALTER PROCEDURE spMeetRequirements(@userId VARCHAR(32), @courseId INT, @meetsRequirements BIT OUTPUT) AS
BEGIN

    IF @userId IS NULL OR @courseId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Course WHERE courseId = @courseId)
    BEGIN
        SELECT 'The course does not exist' AS ExecMessage
        RETURN
    END

    CREATE TABLE #TCourseRequirement (
    courseRequirementId INT,
    courseId INT,
    courseXPlanId INT
    )


    INSERT INTO #TCourseRequirement (courseRequirementId, courseId, courseXPlanId)
    SELECT courseRequirementId, courseId, courseXPlanId
    FROM CourseRequirement
    WHERE courseXPlanId = (SELECT courseXPlanId FROM CourseXPlan WHERE courseId = @courseId)

    -- SELECT * FROM #TCourseRequirement

    WHILE (SELECT COUNT(*) FROM #TCourseRequirement) != 0
    BEGIN

    IF (SELECT TOP(1) StudentXCourse.status FROM StudentXCourse INNER JOIN CourseXPlan ON CourseXPlan.courseId = StudentXCourse.courseId INNER JOIN CourseRequirement ON CourseXPlan.courseXPlanId = CourseRequirement.courseXPlanId INNER JOIN Course ON Course.courseId = CourseXPlan.courseId WHERE Course.courseId = @courseId) = 0
    BEGIN
        SET @meetsRequirements = 0
        --SELECT @meetsRequirements
        RETURN
    END

    DELETE TOP(1) FROM #TCourseRequirement


    END

    DROP TABLE #TCourseRequirement

    SET @meetsRequirements = 1
    --SELECT @meetsRequirements

END
GO

-- SP ENROLLMENT
-- ENTRIES: @userId VARCHAR(32), @schoolPeriodId INT, @courseGroupId INT, @enrollmentId INT OUTPUT
-- Description: This procedure enroll a student in a course group
CREATE OR ALTER PROCEDURE spEnrollment(@userId VARCHAR(32), @courseGroupId INT) AS
BEGIN
    DECLARE @enrollmentSchedule INT, @previousSchoolPeriod INT, @meetsRequirements BIT, @courseId INT, @horarioInicio TIME, @horarioFinal TIME, @timeOfDay INT, @currentTime TIME, @dateOfToday DATETIME, @enrollmentId INT, @periodId INT
    SET @previousSchoolPeriod = 0
    SET @enrollmentSchedule = 0
	SET @meetsRequirements = 0
    SET @dateOfToday = GETDATE()
	SET @timeOfDay = DATEPART(HOUR, @dateOfToday)
	SET @currentTime = (SELECT CONVERT(varchar, GETDATE(), 108))
    SET @enrollmentId = (SELECT TOP 1 Enrollment.enrollmentId FROM Enrollment ORDER BY Enrollment.enrollmentId DESC)
    SET @periodId = (SELECT periodId FROM CourseGroup WHERE courseGroupId = @courseGroupId)

	DECLARE @schoolPeriodId INT
	SET @schoolPeriodId = (SELECT TOP 1 schoolPeriodId FROM SchoolPeriod ORDER BY schoolPeriodId DESC)

    --IF (SELECT periodId FROM Enrollment WHERE @enrollmentId = enrollmentId) != @periodId
    --BEGIN
    --    SELECT 'The enrollment period is not the same as the course group' AS ExecMessage
    --    RETURN
    --END

    IF (SELECT EnrollmentStatus.description FROM EnrollmentStatus INNER JOIN Enrollment ON Enrollment.statusId = EnrollmentStatus.statusId WHERE @schoolPeriodId = periodId) = 'Inactivo'
        OR @dateOfToday < (SELECT Enrollment.startDate FROM Enrollment WHERE @schoolPeriodId = periodId) OR @dateOfToday > (SELECT Enrollment.endingDate FROM Enrollment WHERE @schoolPeriodId = periodId)
    BEGIN
        SELECT 'The date of enrollment period is not today or is closed' AS ExecMessage
        RETURN
    END
    IF @userId IS NULL OR @schoolPeriodId IS NULL OR @courseGroupId IS NULL OR @enrollmentId IS NULL OR @dateOfToday IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId)
    BEGIN
        SELECT 'The school period does not exist' AS ExecMessage
        RETURN
    END
    IF EXISTS(SELECT * FROM WeeklySchedule WHERE userId = @userId AND courseGroupId = @courseGroupId)
    BEGIN
        SELECT 'The user is already enrolled' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM CourseGroup WHERE courseGroupId = @courseGroupId)
    BEGIN
        SELECT 'The course group does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Enrollment WHERE enrollmentId = @enrollmentId)
    BEGIN
        SELECT 'The enrollment does not exist' AS ExecMessage
        RETURN
    END

	-- Validates if student meets all requirements to enroll the course
	SET @courseId =(SELECT courseId FROM CourseGroup WHERE courseGroupId = @courseGroupId)
	EXEC spMeetRequirements @userId, @courseId, @meetsRequirements OUTPUT

    IF @meetsRequirements = 0
    BEGIN
        SELECT 'Student does not meet the needed requirements to enroll this course' AS ExecMessage
        RETURN
    END 

	-- Validates if the schedule of the course group doesnt collide with another group schedule
	SET @horarioInicio = (SELECT startTime 
						  FROM ScheduleXDay 
						  INNER JOIN ScheduleXCourseGroup ON ScheduleXCourseGroup.scheduleXDayId = ScheduleXDay.scheduleXDayId
                          INNER JOIN Schedule ON Schedule.scheduleId = ScheduleXDay.scheduleId
						  INNER JOIN CourseGroup ON CourseGroup.courseGroupId = ScheduleXCourseGroup.courseGroupId
						  WHERE CourseGroup.courseGroupId = @courseGroupId)
	SET @horarioFinal = (SELECT finishTime 
						  FROM ScheduleXDay
						  INNER JOIN ScheduleXCourseGroup ON ScheduleXCourseGroup.scheduleXDayId = ScheduleXDay.scheduleXDayId
                          INNER JOIN Schedule ON Schedule.scheduleId = ScheduleXDay.scheduleId
						  INNER JOIN CourseGroup ON CourseGroup.courseGroupId = ScheduleXCourseGroup.courseGroupId
						  WHERE CourseGroup.courseGroupId = @courseGroupId)

	IF EXISTS (SELECT * FROM WeeklySchedule
				INNER JOIN CourseGroup ON WeeklySchedule.courseGroupId = CourseGroup.courseGroupId
				INNER JOIN ScheduleXCourseGroup ON ScheduleXCourseGroup.courseGroupId = CourseGroup.courseGroupId
                INNER JOIN ScheduleXDay ON ScheduleXDay.scheduleXDayId = ScheduleXCourseGroup.scheduleXDayId
				INNER JOIN Schedule ON Schedule.scheduleId = ScheduleXDay.scheduleId
				WHERE @schoolPeriodId = periodId AND
					  ( @horarioInicio BETWEEN startTime AND finishTime ) OR ( @horarioFinal BETWEEN startTime AND finishTime))
	BEGIN
		SELECT 'The schedule of the selected group collides with the schedule of other group' AS ExecMessage
        RETURN
	END

	-- Validates if student hasn't enrolled the same course in other group
	IF EXISTS (SELECT WeeklySchedule.courseGroupId 
				FROM Student
				INNER JOIN WeeklySchedule ON WeeklySchedule.userId = Student.userId
				INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
				INNER JOIN Course ON CourseGroup.courseId = Course.courseId
				WHERE Course.courseId = @courseId AND @userId = Student.userId)
	BEGIN
		SELECT 'The selected couse has already been enrolled in another group' AS ExecMessage
        RETURN
	END

    -- calculate the last school period of the student
    SET @previousSchoolPeriod = (SELECT TOP(1) schoolPeriodId FROM SchoolPeriod
        INNER JOIN CourseGroup ON SchoolPeriod.schoolPeriodId = CourseGroup.periodId
        INNER JOIN Course ON CourseGroup.courseId = Course.courseId
        INNER JOIN StudentXCourse ON Course.courseId = StudentXCourse.courseId
		INNER JOIN WeeklySchedule ON CourseGroup.courseGroupId = weeklySchedule.courseGroupId
        
        WHERE studentXCourse.userId = @userId 
		AND StudentXCourse.status = 1 ORDER BY schoolPeriodId DESC)

    IF @previousSchoolPeriod IS NULL
    BEGIN
        SET @enrollmentSchedule = 7
    END
    ELSE 
    BEGIN
        EXEC dbo.spEnrollmentTimeSchedule @userId, @previousSchoolPeriod, @enrollmentSchedule OUTPUT
    END

	-- Validates if the student can enroll in the current time (start time of enrollment to finish time of enrollment)
    IF (@timeOfDay < @enrollmentSchedule)-- OR (@timeOfDay > 15)
    BEGIN
        SELECT 'You can not enroll because is not your time to enroll or it has passed.' AS ExecMessage
        RETURN
    END

    INSERT INTO WeeklySchedule (userId, courseGroupId) VALUES (@userId, @courseGroupId)
    EXEC spInsertEnrollmentXStudent @enrollmentId, @schoolPeriodId, @userId, @currentTime
    SELECT 'User enrolled succesfully' AS ExecMessage
END
GO

-- SP UNREGISTER
-- Entries: userId, courseGroupId
-- Description: Unregisters a student from a course group
CREATE OR ALTER PROCEDURE spUnregister(@userId VARCHAR(32), @courseGroupId INT) AS
BEGIN
	DECLARE @courseGroupPeriodId INT, @enrollmentId INT

	SET @courseGroupPeriodId = (SELECT periodId FROM CourseGroup WHERE courseGroupId = @courseGroupId)

	SET @enrollmentId = (SELECT TOP(1) enrollmentId FROM Enrollment ORDER BY enrollmentId DESC)

    IF @userId IS NULL OR @courseGroupId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM CourseGroup WHERE courseGroupId = @courseGroupId)
    BEGIN
        SELECT 'The course group does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM WeeklySchedule WHERE userId = @userId AND courseGroupId = @courseGroupId)
    BEGIN
        SELECT 'The user is not enrolled' AS ExecMessage
        RETURN
    END

    DELETE FROM WeeklySchedule WHERE userId = @userId AND courseGroupId = @courseGroupId

	IF NOT EXISTS(SELECT * FROM WeeklySchedule INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId WHERE userId = @userId and periodId = @courseGroupPeriodId)
	BEGIN
		DELETE FROM EnrollmentXStudent WHERE userId = @userId AND enrollmentId = @enrollmentId
	END
	
    SELECT 'User unregistered succesfully' AS ExecMessage
END
GO

-- SP GET CURSOS
-- Entries: userId
-- Description: Gets all the courses that a student can enroll
CREATE OR ALTER PROCEDURE spGetCourses(@userId VARCHAR(32)) AS
BEGIN
    IF @userId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END

    SELECT CourseGroup.courseGroupId, Course.courseId, courseName, credits, CourseEvaluation.description, score
    FROM Course
    INNER JOIN CourseXPlan ON CourseXPlan.courseId = Course.courseId
    INNER JOIN CareerPlan ON CareerPlan.planId = CourseXPlan.planId
    INNER JOIN CourseGroup ON CourseGroup.courseId = Course.courseId
    INNER JOIN CourseEvaluation ON CourseEvaluation.courseGroupId = CourseGroup.courseGroupId

   WHERE Course.courseId != (SELECT StudentXCourse.courseId FROM StudentXCourse WHERE @userId = StudentXCourse.userId) 
   AND CareerPlan.planId = (SELECT CareerPlan.planId FROM Student INNER JOIN StudentXPlan ON StudentXPlan.userId = Student.userId 
   INNER JOIN CareerPlan ON StudentXPlan.planId = CareerPlan.planId WHERE StudentXPlan.userId = @userId)

END
GO

--------------------------------------------------------------------------------------------------------------
----------------------------------------- REQUIRED INFO SP ---------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- SP READ SCHOOL PERIOD
-- ENTRIES: @schoolPeriodId INT
-- Description: This procedure return all the data of a school period
CREATE OR ALTER PROCEDURE spReadSchoolPeriod(@schoolPeriodId INT) AS
BEGIN
    IF @schoolPeriodId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId)
    BEGIN
        SELECT 'The school period does not exist' AS ExecMessage
        RETURN
    END
    SELECT schoolPeriodId, periodTypeId, startDate, endDate, statusId 
    FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId
END
GO

-- SP VERIFY CAREER
-- ENTRIES: userId
-- DESCRIPTION: Check if the user has a career
CREATE OR ALTER PROCEDURE spVerifyCareer (@userId VARCHAR(32), @statusResult BIT OUTPUT) AS
BEGIN

    IF @userId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE User_.userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END

    IF EXISTS(SELECT * FROM User_ INNER JOIN CareerXUser ON User_.userId = CareerXUser.userId WHERE User_.userId = @userId)
    BEGIN
        SELECT 'The user has a career' AS ExecMessage
        SET @statusResult = 1
        RETURN
    END
    ELSE
    BEGIN
        SET @statusResult = 0
        SELECT 'The user does not have a career' AS ExecMessage
        RETURN
    END
END
GO

-- SP GET ENROLLED COURSES
-- ENTRIES: userId, schoolPeriodId
-- DESCRIPTION: Get the enrolled courses of a student in a school period
CREATE OR ALTER PROCEDURE spGetEnrolledCourses(@userId VARCHAR(32)) AS
BEGIN
	DECLARE @schoolPeriodId INT
	SET @schoolPeriodId = (SELECT TOP 1 schoolPeriodId FROM SchoolPeriod ORDER BY schoolPeriodId DESC)

    IF @userId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END

    SELECT CourseGroup.courseGroupId, Course.courseId, Course.courseName, credits, CourseEvaluation.description, CourseEvaluation.score --, Schedule.startTime, Schedule.finishTime, Day_.name
    FROM Course
    INNER JOIN CourseGroup ON Course.courseId = CourseGroup.courseId
    INNER JOIN WeeklySchedule ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
    INNER JOIN SchoolPeriod ON CourseGroup.periodId = SchoolPeriod.schoolPeriodId
	INNER JOIN CourseEvaluation ON CourseEvaluation.courseGroupId = CourseGroup.courseGroupId
		
    WHERE WeeklySchedule.userId = @userId AND SchoolPeriod.schoolPeriodId = @schoolPeriodId AND CourseEvaluation.courseGroupId = CourseGroup.courseGroupId
END
GO

-- SP GET LAST PLAN 
-- ENTRIES: userId, careerId
-- DESCRIPTION: Get the last career plan of a student
CREATE OR ALTER PROCEDURE spGetLastPlan(@userId VARCHAR(32), @careerId INT) AS
BEGIN
    IF @userId IS NULL OR @careerId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Career WHERE careerId = @careerId)
    BEGIN
        SELECT 'The career does not exist' AS ExecMessage
        RETURN
    END
	IF NOT EXISTS(SELECT * FROM CareerXUser WHERE CareerXUser.careerId = @careerId AND CareerXUser.userId = @userId)
	BEGIN
		SELECT 'The student is not from this career' AS ExecMessage
        RETURN
	END
    SELECT TOP 1 userId,planId, CareerPlan.careerId FROM CareerPlan INNER JOIN CareerXUser ON CareerPlan.careerId = CareerXUser.careerId
        WHERE CareerPlan.careerId = @careerId AND userId = @userId ORDER BY activationDate DESC
END
GO

-- SP GET GRADE OF A COURSE
-- ENTRIES: userId, courseId
-- DESCRIPTION: Get the grade of a student in a course
CREATE OR ALTER PROCEDURE spGetGradeOfCourse(@userId VARCHAR(32), @courseId INT) AS
BEGIN
    DECLARE @sum FLOAT
    SET @sum = 0
    
    IF @userId IS NULL OR @courseId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Course WHERE courseId = @courseId)
    BEGIN
        SELECT 'The course does not exist' AS ExecMessage
        RETURN
    END
	IF NOT EXISTS(SELECT * FROM User_ INNER JOIN WeeklySchedule ON User_.userId = WeeklySchedule.userId
		INNER JOIN CourseGroup ON WeeklySchedule.courseGroupId = CourseGroup.courseGroupId
		INNER JOIN Course ON CourseGroup.courseId = Course.courseId
		WHERE User_.userId = @userId
		AND CourseGroup.courseId = @courseId )
    BEGIN
        SELECT 'The student has not taken the course' AS ExecMessage
        RETURN
    END

    SET @sum = (SELECT SUM(grade) AS totalSum 
                    FROM Student
                    INNER JOIN WeeklySchedule ON Student.userId = WeeklySchedule.userId
                    INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
                    INNER JOIN Evaluation ON Evaluation.courseGroupId = CourseGroup.courseGroupId
                    INNER JOIN Item ON Item.evaluationId = Evaluation.evaluationId
                    INNER JOIN StudentXItem ON StudentXItem.itemId = Item.itemId AND StudentXItem.userId = Student.userId

                    WHERE Student.userId = @userId
					AND CourseGroup.courseId = @courseId) 

	SELECT @sum 
END
GO

--------------------------------------------------------------------------------------------------------------
----------------------------------------- CRUD User_ ---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- CREATE USER
-- Entries: userId, userName, birthDate, email, idCampus, student
-- Description: Creates a new user, if is a student, it also creates a new student
CREATE OR ALTER PROCEDURE spCreateUser_(@userId VARCHAR(32), @userName VARCHAR(50), @birthDate DATETIME, @email VARCHAR(50), @idCampus INT, @student BIT) AS
BEGIN
    IF @userId IS NULL OR @userName IS NULL OR @birthDate IS NULL OR @email IS NULL OR @idCampus IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user already exists' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Campus WHERE campusId = @idCampus)
    BEGIN
        SELECT 'The campus does not exist' AS ExecMessage
        RETURN
    END

    INSERT INTO User_ (userId, userName, birthDate, email) VALUES (@userId, @userName, @birthDate, @email)
    INSERT INTO CampusXUser (campusId, userId) VALUES (@idCampus, @userId)

    IF @student = 1
    BEGIN
    INSERT INTO Student (userId, isAssistant) VALUES (@userId, 0)
    END
END
GO

-- READ
-- Entries: userId
-- Description: Gets the information of a user
CREATE OR ALTER PROCEDURE spReadUser_(@userId VARCHAR(32)) AS
BEGIN
    IF @userId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END

    SELECT userId, userName, birthDate, email FROM User_ WHERE userId = @userId
END
GO

-- UPDATE
-- Entries: userId, userName, birthDate, email, idCampus
-- Description: Updates the information of a user
CREATE OR ALTER PROCEDURE spUpdateUser_(@userId VARCHAR(32), @userName VARCHAR(50), @birthDate DATETIME, @email VARCHAR(50), @idCampus INT) AS
BEGIN
    IF @userId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Campus WHERE campusId = @idCampus)
    BEGIN
        SELECT 'The campus does not exist' AS ExecMessage
        RETURN
    END

    UPDATE User_ SET userName = ISNULL(@userName, userName), birthDate = ISNULL(@birthDate, birthDate), email = ISNULL(@email, email) WHERE userId = @userId
    
    UPDATE CampusXUser SET campusId = ISNULL(@idCampus, campusId) WHERE userId = @userId
END
GO

-- DELETE 
-- Entries: userId
-- Description: Deletes a user
CREATE OR ALTER PROCEDURE spDeleteUser_(@userId VARCHAR(32)) AS
BEGIN
    BEGIN TRY
        IF @userId IS NULL
        BEGIN
            SELECT 'NULL parameters' AS ExecMessage
            RETURN
        END
        IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
        BEGIN
            SELECT 'The user does not exist' AS ExecMessage
            RETURN
        END

        -- verify if the user is a student/teacher/administrator and delete it
        IF EXISTS(SELECT * FROM Student WHERE userId = @userId)
        BEGIN
            DELETE FROM Student WHERE userId = @userId
        END
        IF EXISTS(SELECT * FROM Teacher WHERE userId = @userId)
        BEGIN
            DELETE FROM Teacher WHERE userId = @userId
        END
        IF EXISTS(SELECT * FROM CampusXUser WHERE userId = @userId)
        BEGIN
            DELETE FROM CampusXUser WHERE userId = @userId
        END
        IF EXISTS(SELECT * FROM Administrator WHERE userId = @userId)
        BEGIN
            DELETE FROM Administrator WHERE userId = @userId
        END

        -- delete the user
        DELETE FROM User_ WHERE userId = @userId

    END TRY
    BEGIN CATCH
        SELECT 'The user can not be deleted' AS ExecMessage
    END CATCH
END
GO

--------------------------------------------------------------------------------------------------------------
----------------------------------------- FILES SP -----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- SP GET FILE VERSIONS 
-- ENTRIES: name
-- DESCRIPTION: Gets all the versions of a file bases on the name
CREATE OR ALTER PROCEDURE spGetFileVersions(@name VARCHAR(70)) AS
BEGIN
    IF @name IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE name = @name)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END

    SELECT Version.modificationDate FROM Version INNER JOIN File_ ON File_.fileId = Version.fileId WHERE File_.name = @name
END
GO

-- SP GET FILE NAME FROM VERSION
-- ENTRIES: name, modificationDate
-- DESCRIPTION: Gets the filename of a file based on the name and the modification date
CREATE OR ALTER PROCEDURE spGetFileNameFromVersion(@name VARCHAR(70), @modificationDate DATETIME) AS
BEGIN
    IF @name IS NULL OR @modificationDate IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE name = @name)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END

    SELECT Version.filename FROM Version INNER JOIN File_ ON File_.fileId = Version.fileId WHERE File_.name = @name AND File_.fileId = Version.fileId AND Version.modificationDate = @modificationDate
END
GO


-- SP GET LATESTS FILE VERSION
-- ENTRIES: userId, fileId
-- DESCRIPTION: Gets the latest version of a file
CREATE OR ALTER PROCEDURE spGetLatestFileVersion(@userId VARCHAR(32), @fileName VARCHAR(70)) AS
BEGIN
    IF @userId IS NULL OR @fileName IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE name = @fileName)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END

	DECLARE @fileId INT
	SET @fileId = (SELECT fileId FROM File_ WHERE name = @fileName)

    SELECT TOP 1 Version.filename FROM Version INNER JOIN File_ ON File_.fileId = Version.fileId WHERE userId = @userId AND File_.fileId = @fileId ORDER BY modificationDate DESC
END
GO

-- SP GET ALL VERSIONS OF FILE
-- ENTRIES: userId, fileId
-- DESCRIPTION: Gets all the versions of a file
CREATE OR ALTER PROCEDURE spGetAllVersionsOfFile(@fileId INT) AS
BEGIN
    IF @fileId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END

    SELECT Version.modificationDate FROM File_ INNER JOIN Version ON File_.fileId = Version.fileId WHERE File_.fileId = @fileId
END
GO

-- GET VERSION OF FILE
-- ENTRIES: userId, fileId, modificationDate
-- DESCRIPTION: Gets the version of a file in a specific date
CREATE OR ALTER PROCEDURE spGetVersionOfFile(@userId VARCHAR(32), @fileId INT, @modificationDate DATE) AS
BEGIN
    IF @userId IS NULL OR @fileId IS NULL OR @modificationDate IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Version WHERE fileId = @fileId AND modificationDate = @modificationDate)
    BEGIN
        SELECT 'The version does not exist' AS ExecMessage
        RETURN
    END

    SELECT filename FROM Version WHERE fileId = @fileId AND modificationDate = @modificationDate
END
GO

-- SP MODIFY FILE (NEW VERSION)
-- ENTRIES: userId, fileId, modificationDate, name, description
-- DESCRIPTION: Modifies a file (creates a new version)
CREATE OR ALTER PROCEDURE spModifyFile(@userId VARCHAR(32), @name VARCHAR(70), @filename VARCHAR(15)) AS
BEGIN

    IF @userId IS NULL OR @name IS NULL OR @filename IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END

    DECLARE @FileId INT
    SET @FileId = (SELECT fileId from File_ WHERE name = @name)

    DECLARE @modificationDate DATETIME
    SET @modificationDate = GETDATE()

    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId AND userId = @userId)
    BEGIN
        SELECT 'The user does not own the file' AS ExecMessage
        RETURN
    END

    INSERT INTO Version (fileId, modificationDate, filename) VALUES (@fileId, @modificationDate, @filename)

END
GO


-- CRUD File_

-- CREATE
-- ENTRIES: userId, filename, fileTypeId, periodId, name, description
-- DESCRIPTION: Creates a file
CREATE OR ALTER PROCEDURE spCreateFile(@userId VARCHAR(32), @filename VARCHAR(15), @fileType VARCHAR(8), @periodId INT, @name VARCHAR(70), @description VARCHAR(100)) AS
BEGIN
    IF @userId IS NULL OR @filename IS NULL OR @fileType IS NULL OR @periodId IS NULL OR @name IS NULL OR @description IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @periodId)
    BEGIN
        SELECT 'The period does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM FileType WHERE fileTypeName = @fileType)
    BEGIN
        SELECT 'The file type does not exist' AS ExecMessage
        RETURN
    END

    DECLARE @fileTypeId INT
    SET @fileTypeId = (SELECT fileTypeId FROM FileType WHERE fileTypeName = @fileType)

    INSERT INTO File_ (userId, fileTypeId, periodId, creationDate, name, description) VALUES (@userId, @fileTypeId, @periodId, GETDATE(), @name, @description)
    INSERT INTO Version (fileId, modificationDate, filename) VALUES (@@IDENTITY, GETDATE(), @filename)
END
GO

-- READ
-- ENTRIES: fileId
-- DESCRIPTION: Returns the info of all files
CREATE OR ALTER PROCEDURE spReadFile AS
BEGIN

    SELECT fileId, userId, fileTypeId, periodId, creationDate, name, description FROM File_
    
END
GO

-- EXISTS
-- ENTRIES: fileId
-- DESCRIPTION: Returns if a file exits or not
CREATE OR ALTER PROCEDURE spExistsFile(@name VARCHAR(70)) AS
BEGIN

    IF @name IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END

    IF NOT EXISTS(SELECT * FROM File_ WHERE name = @name)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END

    SELECT 'The file exists' AS ExecMessage
END
GO

-- UPDATE
-- ENTRIES: fileId, fileTypeId, periodId, creationDate, name, description
-- DESCRIPTION: Updates a file
CREATE OR ALTER PROCEDURE spUpdateFile(@fileId INT, @fileTypeId INT, @periodId INT, @creationDate DATE, @name VARCHAR(70), @description VARCHAR(100), @error INT OUTPUT) AS
BEGIN
    IF @fileId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF @fileTypeId IS NOT NULL AND NOT EXISTS(SELECT * FROM FileType WHERE fileTypeId = @fileTypeId)
    BEGIN
        SELECT 'The file type does not exist' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF @periodId IS NOT NULL AND NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @periodId)
    BEGIN
        SELECT 'The period does not exist' AS ExecMessage
        SET @error = 1
        RETURN
    END

    UPDATE File_ SET fileTypeId = ISNULL(@fileTypeId, fileTypeId), periodId = ISNULL(@periodId, periodId), creationDate = ISNULL(@creationDate, creationDate), name = ISNULL(@name, name), description = ISNULL(@description, description) WHERE fileId = @fileId
    SET @error = 0
END
GO

-- DELETE
-- ENTRIES: fileId
-- DESCRIPTION: Deletes a file
CREATE OR ALTER PROCEDURE spDeleteFile(@name VARCHAR(15)) AS
BEGIN
    IF @name IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END

	DECLARE @fileId INT
	SET @fileId = (SELECT fileId FROM Version WHERE Version.filename = @name)

	DECLARE @amount INT
	SET @amount = (SELECT COUNT(*) FROM Version WHERE Version.fileId = @fileId)

	IF @amount > 1
	BEGIN
		DELETE FROM Version WHERE Version.filename = @name
	END
	ELSE
	BEGIN
		DELETE FROM Version WHERE Version.filename = @name
		DELETE FROM File_ WHERE fileId = @fileId
	END
		
END
GO