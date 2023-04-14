USE db01_prueba

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

-- SP GET GRADE AVERAGE
CREATE OR ALTER PROCEDURE spGetGradeAverage(@userId VARCHAR(32), @schoolPeriodId INT) AS
BEGIN
    DECLARE @average FLOAT
    SET @average = -1

    IF @userId IS NULL OR @schoolPeriodId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN 0
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN 0
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId)
    BEGIN
        IF @schoolPeriodId <= 0
        BEGIN
            SELECT 'It is the first school period' AS ExecMessage
            RETURN 100
        END

        SELECT 'The school period does not exist' AS ExecMessage
        RETURN 0
    END

    SET @average = (SELECT AVG(SUM((SUM(grade) * 0.15) / SUM(itemValue))) AS GradeAverage 
                    FROM Student
                    INNER JOIN WeeklySchedule ON Student.userId = WeeklySchedule.userId
                    INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
                    INNER JOIN SchoolPeriod ON SchoolPeriod.schoolPeriodId = CourseGroup.periodId
                    INNER JOIN Evaluation ON Evaluation.courseGroupId = CourseGroup.courseGroupId
                    INNER JOIN Item ON Item.evaluationId = Evaluation.evaluationId
                    INNER JOIN StudentXItem ON StudentXItem.itemId = Item.itemId AND StudentXItem.userId = Student.userId

                    WHERE User_.userId = @userId AND SchoolPeriod.schoolPeriodId = @schoolPeriodId)

    RETURN @average
END

-- SP ENROLLMENT TIME SCHEDULE
CREATE OR ALTER PROCEDURE spEnrollmentTimeSchedule(@userId VARCHAR(32), @schoolPeriodId INT) AS 
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
    
    DECLARE @gradeAverageValue FLOAT, @enrollmentTimeScheduleValue INT
    SET @gradeAverageValue = spGetGradeAverage(@userId, @schoolPeriodId)
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
    ELSE
    BEGIN
        SELECT 'You can not enroll' AS ExecMessage
    END

    RETURN @enrollmentTimeScheduleValue

END


-- SP STUDENT MEETS ALL REQUIREMENTS TO ENROLL THE COURSE
CREATE OR ALTER PROCEDURE spMeetRequirements(@userId INT, @courseId INT) AS
BEGIN

DECLARE @meetsRequirements BIT 
SET @meetsRequirements = 0

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


IF (SELECT COUNT(Student.userId) 
	FROM Student 
	INNER JOIN WeeklySchedule ON WeeklySchedule.userId = Student.userId
	INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
	INNER JOIN CourseRequirement ON CourseRequirement.courseId = CourseGroup.courseId 

	INNER JOIN CourseXPlan ON CourseXPlan.courseXPlanId = CourseRequirement.courseXPlanId
	INNER JOIN Course ON Course.courseId = CourseXPlan.courseId 
							 
			  
	WHERE @courseId = Course.courseId) = (SELECT COUNT(CourseRequirement.courseId) 
											FROM CourseRequirement 
											INNER JOIN CourseXPlan ON CourseXPlan.courseXPlanId = CourseRequirement.courseXPlanId
											INNER JOIN Course ON Course.courseId = CourseXPlan.courseId
                                            INNER JOIN StudentXCourse ON StudentXCourse.courseId = CourseRequirement.courseId
											WHERE @courseId = Course.courseId AND
                                            StudentXCourse.status = 1)
BEGIN

SET @meetsRequirements = 1

END

RETURN @meetsRequirements

END


-- SP ENROLLMENT
CREATE OR ALTER PROCEDURE spEnrollment(@userId VARCHAR(32), @schoolPeriodId INT, @courseGroupId INT, @timeOfDay TIME) AS
BEGIN
    DECLARE @enrollmentSchedule INT, @meetsRequirements BIT, @courseId INT, @horarioInicio TIME, @horarioFinal TIME
    SET @enrollmentSchedule = 0, @meetsRequirements = 0

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

	-- Validates if student meets all requirements to enroll the course
	SET @courseId =(SELECT courseId FROM CourseGroup WHERE courseGroupId = @courseGroupId)
	SET @meetsRequirements = spMeetRequirements(@userId, @courseId)

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
						  FROM Schedule 
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
				WHERE Course.courseId = @courseId)
	BEGIN
		SELECT 'The selected couse has already been enrolled in another group' AS ExecMessage
        RETURN
	END

	-- Validates if the student can enroll in the current time (start time of enrollment to finish time of enrollment)
    SET @enrollmentSchedule = spEnrollmentTimeSchedule(@userId, @schoolPeriodId)
    IF (DATEPART(HOUR, @timeOfDay) < @enrollmentSchedule OR DATEPART(HOUR, @timeOfDay) > @enrollmentSchedule) AND DATEPART(HOUR, @timeOfDay) < 12
    BEGIN
        SELECT 'You can not enroll' AS ExecMessage
        RETURN
    END

    INSERT INTO WeeklySchedule (userId, courseGroupId) VALUES (@userId, @courseGroupId)
    SELECT 'User enrolled succesfully' AS ExecMessage
END

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


-- CRUD User_

-- CREATE
CREATE OR ALTER PROCEDURE spCreateUser(@userId VARCHAR(32), @userName VARCHAR(50), @birthDate DATETIME, @email VARCHAR(50), @idCampus INT) AS
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
    IF NOT EXISTS(SELECT * FROM Campus WHERE idCampus = @idCampus)
    BEGIN
        SELECT 'The campus does not exist' AS ExecMessage
        RETURN
    END

    INSERT INTO User_ (userId, userName, birthDate, email, idCampus) VALUES (@userId, @userName, @birthDate, @email, @idCampus)
END

-- READ
CREATE OR ALTER PROCEDURE spReadUser(@userId VARCHAR(32)) AS
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

-- UPDATE
CREATE OR ALTER PROCEDURE spUpdateUser(@userId VARCHAR(32), @userName VARCHAR(50), @birthDate DATETIME, @email VARCHAR(50), @idCampus INT) AS
BEGIN
    IF @userId IS NULL OR @userName IS NULL OR @birthDate IS NULL OR @email IS NULL OR @idCampus IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Campus WHERE idCampus = @idCampus)
    BEGIN
        SELECT 'The campus does not exist' AS ExecMessage
        RETURN
    END

    UPDATE User_ SET userName = ISNULL(@userName, userName), birthDate = ISNULL(@birthDate, birthDate), email = ISNULL(@email, email), idCampus = ISNULL(@idCampus, idCampus) WHERE userId = @userId
END

-- DELETE 
CREATE OR ALTER PROCEDURE spDeleteUser(@userId VARCHAR(32)) AS
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

        DELETE FROM User_ WHERE userId = @userId
    END TRY
    BEGIN CATCH
        SELECT 'The user can not be deleted' AS ExecMessage
    END CATCH
END


-- CRUD File_

-- CREATE
CREATE OR ALTER PROCEDURE spCreateFile(@userId VARCHAR(32), @fileTypeId int, @periodId int, @creationDate date, @modificationDate date, @name varchar(50), @description varchar(100), @ver int) AS
BEGIN
    IF @userId IS NULL OR @fileTypeId IS NULL OR @periodId IS NULL OR @creationDate IS NULL OR @modificationDate IS NULL OR @name IS NULL OR @description IS NULL OR @ver IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF EXISTS(SELECT * FROM File_ WHERE userId = @userId AND fileTypeId = @fileTypeId AND periodId = @periodId AND creationDate = @creationDate AND modificationDate = @modificationDate AND name = @name AND description = @description AND ver = @ver)
    BEGIN
        SELECT 'The file already exists' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM FileType WHERE fileTypeId = @fileTypeId)
    BEGIN
        SELECT 'The file type does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @periodId)
    BEGIN
        SELECT 'The school period does not exist' AS ExecMessage
        RETURN
    END

    INSERT INTO File_ (userId, fileTypeId, periodId, creationDate, modificationDate, name, description, ver) VALUES (@userId, @fileTypeId, @periodId, @creationDate, @modificationDate, @name, @description, @ver)
END

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

-- UPDATE
CREATE OR ALTER PROCEDURE spUpdateFile(@fileId INT, @newUserId VARCHAR(32), @newFileTypeId int, @newPeriodId int, @newCreationDate date, @newModificationDate date, @newName varchar(50), @newDescription varchar(100), @newVer int) AS
BEGIN
    IF @fileId IS NULL OR @newUserId IS NULL OR @newFileTypeId IS NULL OR @newPeriodId IS NULL OR @newCreationDate IS NULL OR @newModificationDate IS NULL OR @newName IS NULL OR @newDescription IS NULL OR @newVer IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @newUserId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM FileType WHERE fileTypeId = @newFileTypeId)
    BEGIN
        SELECT 'The file type does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @newPeriodId)
    BEGIN
        SELECT 'The school period does not exist' AS ExecMessage
        RETURN
    END

    UPDATE File_ SET userId = ISNULL(@newUserId, userId), fileTypeId = ISNULL(@newFileTypeId, fileTypeId), periodId = ISNULL(@newPeriodId, periodId), creationDate = ISNULL(@newCreationDate, creationDate), modificationDate = ISNULL(@newModificationDate, modificationDate), name = ISNULL(@newName, name), description = ISNULL(@newDescription, description), ver = ISNULL(@newVer, ver) WHERE fileId = @fileId
END

-- DELETE
CREATE OR ALTER PROCEDURE spDeleteFile(@fileId INT) AS
BEGIN
    BEGIN TRY
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
    END TRY
    BEGIN CATCH
        SELECT 'The file can not be deleted' AS ExecMessage
    END CATCH
END