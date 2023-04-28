USE db01
GO

-- SP READ SCHOOL PERIOD
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
    SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId
END
GO

-- SP GET GRADE AVERAGE
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
	SELECT @sum / @courseAmount
	
END
GO

-- SP INSERT ENROLLMENTXSTUDENT
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

    INSERT INTO EnrollmentXStudent(enrollmentTime, userId, enrollmentId) VALUES(@enrollmentTime, @userId, @enrollmentId)
END
GO

-- SP ENROLLMENT TIME SCHEDULE
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

	SELECT @enrollmentTimeScheduleValue

END
GO


-- SP STUDENT MEETS ALL REQUIREMENTS TO ENROLL THE COURSE
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
CREATE OR ALTER PROCEDURE spEnrollment(@userId VARCHAR(32), @schoolPeriodId INT, @courseGroupId INT, @enrollmentId INT) AS
BEGIN
    DECLARE @enrollmentSchedule INT, @previousSchoolPeriod INT, @meetsRequirements BIT, @courseId INT, @horarioInicio TIME, @horarioFinal TIME, @timeOfDay INT, @currentTime TIME, @dateOfToday DATETIME
    SET @previousSchoolPeriod = 0
    SET @enrollmentSchedule = 0
	SET @meetsRequirements = 0
    SET @dateOfToday = GETDATE()
	SET @timeOfDay = DATEPART(HOUR, @dateOfToday)
	SET @currentTime = (SELECT CONVERT(varchar, GETDATE(), 108))

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
    IF (@timeOfDay < @enrollmentSchedule) OR (@timeOfDay > 15)
    BEGIN
        SELECT 'You can not enroll.' AS ExecMessage
        RETURN
    END

    INSERT INTO WeeklySchedule (userId, courseGroupId) VALUES (@userId, @courseGroupId)
    EXEC spInsertEnrollmentXStudent @enrollmentId, @schoolPeriodId, @userId, @currentTime
    SELECT 'User enrolled succesfully' AS ExecMessage
END
GO

--SP UNREGISTER
CREATE OR ALTER PROCEDURE spUnregister(@userId VARCHAR(32), @courseGroupId INT) AS
BEGIN
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
    SELECT 'User unregistered succesfully' AS ExecMessage
END
GO

--SP GET CURSOS
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

    SELECT Course.courseId, courseName, credits, CourseEvaluation.description, CourseEvaluation.score
    FROM Course
    INNER JOIN StudentXCourse ON StudentXCourse.courseId = Course.courseId
    INNER JOIN Student ON Student.userId = StudentXCourse.userId
    INNER JOIN CareerXUser ON CareerXUser.userId = Student.userId
    INNER JOIN CareerPlan ON CareerPlan.careerId = CareerXUser.careerId
    INNER JOIN CourseXPlan ON CourseXPlan.planId = CareerPlan.planId
	INNER JOIN CourseGroup ON CourseGroup.courseId = Course.courseId
    INNER JOIN CourseEvaluation ON CourseEvaluation.courseGroupId = CourseGroup.courseGroupId
    WHERE Student.userId = @userId AND StudentXCourse.status = 1

END
GO

-- CRUD User_

-- CREATE
CREATE OR ALTER PROCEDURE spCreateUser_(@userId VARCHAR(32), @userName VARCHAR(50), @birthDate DATETIME, @email VARCHAR(50), @idCampus INT, @student BIT) AS
BEGIN
    IF @userId IS NULL OR @userName IS NULL OR @birthDate IS NULL OR @email IS NULL OR @idCampus IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF EXISTS(SELECT * FROM User WHERE userId = @userId)
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

    SELECT * FROM User_ WHERE userId = @userId
END
GO

-- UPDATE
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


-- SP GET LATESTS FILE VERSION
CREATE OR ALTER PROCEDURE spGetLatestFileVersion(@userId VARCHAR(32), @fileId INT) AS
BEGIN
    IF @userId IS NULL OR @fileId IS NULL
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

    SELECT TOP 1 File_.fileId  FROM File_ INNER JOIN Version ON File_.fileId = Version.fileId WHERE userId = @userId AND File_.fileId = @fileId ORDER BY modificationDate DESC
END
GO

-- SP GET ALL VERSIONS OF FILE
CREATE OR ALTER PROCEDURE spGetAllVersionsOfFile(@userId VARCHAR(32), @fileId INT) AS
BEGIN
    IF @userId IS NULL OR @fileId IS NULL
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

    SELECT Version.modificationDate FROM File_ INNER JOIN Version ON File_.fileId = Version.fileId WHERE userId = @userId AND File_.fileId = @fileId
END
GO

-- GET VERSION OF FILE
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
CREATE OR ALTER PROCEDURE spModifyFile(@userId VARCHAR(32), @fileId INT, @modificationDate DATE, @name VARCHAR(50), @description VARCHAR(100), @error INT OUTPUT) AS
BEGIN
    IF @userId IS NULL OR @fileId IS NULL OR @modificationDate IS NULL OR @name IS NULL OR @description IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId AND userId = @userId)
    BEGIN
        SELECT 'The user does not own the file' AS ExecMessage
        SET @error = 1
        RETURN
    END

    DECLARE @updateError INT 
    SET @updateError = 0

    EXEC spUpdateFile @fileId, NULL, NULL, NULL, @name, @description, @updateError OUTPUT

    IF @updateError = 1
    BEGIN
        SELECT 'The file could not be updated' AS ExecMessage
        SET @error = 1
        RETURN
    END

    INSERT INTO Version (fileId, modificationDate, filename) VALUES (@fileId, @modificationDate, @name)
    SET @error = 0

END
GO


-- CRUD File_

-- CREATE
CREATE OR ALTER PROCEDURE spCreateFile(@userId VARCHAR(32), @filename VARCHAR(15), @fileTypeId INT, @periodId INT, @creationDate DATE, @name VARCHAR(50), @description VARCHAR(100)) AS
BEGIN
    IF @userId IS NULL OR @filename IS NULL OR @fileTypeId IS NULL OR @periodId IS NULL OR @creationDate IS NULL OR @name IS NULL OR @description IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF EXISTS(SELECT * FROM File_ WHERE userId = @userId AND fileTypeId = @fileTypeId AND periodId = @periodId AND creationDate = @creationDate AND name = @name AND description = @description)
    BEGIN
        SELECT 'The file already exists' AS ExecMessage
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
    IF NOT EXISTS(SELECT * FROM FileType WHERE fileTypeId = @fileTypeId)
    BEGIN
        SELECT 'The file type does not exist' AS ExecMessage
        RETURN
    END

    INSERT INTO File_ (userId, fileTypeId, periodId, creationDate, name, description) VALUES (@userId, @fileTypeId, @periodId, @creationDate, @name, @description)
    INSERT INTO Version (fileId, modificationDate, filename) VALUES (@@IDENTITY, @creationDate, @filename)

END
GO

-- READ
CREATE OR ALTER PROCEDURE spReadFile(@fileId INT) AS
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

    SELECT * FROM File_ WHERE fileId = @fileId
END
GO

-- UPDATE
CREATE OR ALTER PROCEDURE spUpdateFile(@fileId INT, @fileTypeId INT, @periodId INT, @creationDate DATE, @name VARCHAR(50), @description VARCHAR(100), @error INT OUTPUT) AS
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
CREATE OR ALTER PROCEDURE spDeleteFile(@fileId INT) AS
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

    DELETE FROM File_ WHERE fileId = @fileId
END
GO

-- -- Store Procedure for check if the user id in his enrollment time
-- CREATE OR ALTER PROCEDURE spUserInEnrollmentTime(@userId VARCHAR(32), @schoolPeriodId INT, @result BIT OUTPUT) AS
-- BEGIN
--     IF @userId IS NULL OR @schoolPeriodId IS NULL
--     BEGIN
--         SELECT 'NULL parameters' AS ExecMessage
--         RETURN
--     END
--     IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
--     BEGIN
--         SELECT 'The user does not exist' AS ExecMessage
--         RETURN
--     END
--     IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId)
--     BEGIN
--         SELECT 'The school period does not exist' AS ExecMessage
--         RETURN
--     END

--     DECLARE @enrollmentTimeScheduleValue INT, @enrollmentDay DATETIME, @currentDay DATETIME
--     SET @enrollmentTimeScheduleValue = [dbo].spEnrollmentTimeSchedule(@userId, @schoolPeriodId)

--     -- The user cant enroll and the errorcode is -1

--     IF @enrollmentTimeScheduleValue = -1
--     BEGIN
--         SELECT 'You can not enroll' AS ExecMessage
--         SET @result = -1
--     END

--     -- obtain the enrollment day and the current day
--     SET @enrollmentDay = (SELECT Enrollment.startDate FROM Enrollment INNER JOIN SchoolPeriod ON SchoolPeriod.schoolPeriodId = Enrollment.PeriodId WHERE Enrollment.PeriodId = @schoolPeriodId)
--     SET @currentDay = GETDATE()

--     -- if the current day is not the enrollment day, the user cant enroll
--     IF DATEPART(DAY, @enrollmentDay) != DATEPART(DAY, @currentDay)
--     BEGIN
--         SELECT 'You are not in the enrollment day' AS ExecMessage
--         SET @result = -1
--     END

--     -- if the current hour is not in the enrollment time schedule, the user cant enroll
--     -- the enrollment time schedule is from 7 am to 3 pm, but the start time of the student depends on his grade average
--     IF DATEPART(HOUR, @currentDay) < @enrollmentTimeScheduleValue OR DATEPART(HOUR, @currentDay) >= 15
--     BEGIN
--         SELECT 'You are not in your enrollment time' AS ExecMessage
--         SET @result = -1
--     END

--     SELECT 'You are in your enrollment time, you can enroll' AS ExecMessage
--     SET @result = 1
-- END
-- GO



-- Store procedure for check if ther user has an asigned career
-- SP VERIFY CAREER
CREATE OR ALTER PROCEDURE spVerifyCareer (@userId, @statusResult BIT OUTPUT) AS
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

    IF EXISTS(SELECT * FROM User_ INNER JOIN CareerXUser WHERE userId = @userId)
    BEGIN
        SELECT 'The user has a career' AS ExecMessage
        SET @statusResult = 1
        RETURN
    END
END
GO

-- Store procedure for get the enrolled courses of a student
-- SP GET ENROLLED COURSES
CREATE OR ALTER PROCEDURE spGetEnrolledCourses(@userId VARCHAR(32), @schoolPeriodId INT) AS
BEGIN
    IF @userId IS NULL OR @schoolPeriodId IS NULL
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

    SELECT Course.courseId, CourseGroup.courseGroupId, Course.courseName, Schedule.startTime, Schedule.finishTime, Day_.name
    FROM Course
    INNER JOIN CourseGroup ON Course.courseId = CourseGroup.courseId
    INNER JOIN WeeklySchedule ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
    INNER JOIN SchoolPeriod ON CourseGroup.periodId = SchoolPeriod.schoolPeriodId
	INNER JOIN ScheduleXCourseGroup ON ScheduleXCourseGroup.courseGroupId = CourseGroup.courseGroupId
	INNER JOIN ScheduleXDay ON ScheduleXDay.scheduleXDayId = ScheduleXCourseGroup.scheduleXDayId
	INNER JOIN Schedule ON Schedule.scheduleId = ScheduleXDay.scheduleXDayId
	INNER JOIN Day_ ON Day_.dayId = ScheduleXDay.dayId
	
	
    WHERE WeeklySchedule.userId = @userId AND SchoolPeriod.schoolPeriodId = @schoolPeriodId 
END
GO

-- Store procedure for get the last career plan
--SP GET LAST PLAN 
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
    SELECT TOP 1 * FROM CareerPlan INNER JOIN CareerXUser ON CareerPlan.careerPlanId = CareerXUser.careerPlanId
        WHERE careerId = @careerId AND userId = @userId ORDER BY activationDate DESC
END
GO

-- Store procedure for get the student grade of a specific course
-- SP GET GRADE OF A COURSE
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

    SET @sum = (SELECT SUM(grade) AS totalSum 
                    FROM Student
                    INNER JOIN WeeklySchedule ON Student.userId = WeeklySchedule.userId
                    INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
                    INNER JOIN Evaluation ON Evaluation.courseGroupId = CourseGroup.courseGroupId
                    INNER JOIN Item ON Item.evaluationId = Evaluation.evaluationId
                    INNER JOIN StudentXItem ON StudentXItem.itemId = Item.itemId AND StudentXItem.userId = Student.userId

                    WHERE Student.userId = @userId) 

	SELECT @sum 
END
GO