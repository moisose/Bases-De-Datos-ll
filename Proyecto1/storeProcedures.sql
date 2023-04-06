CREATE OR ALTER PROCEDURE spCreateUser_(@userId VARCHAR(32), @userName VARCHAR(50), @birthDate DATE, @email varchar(50), @idCampus INT) AS
BEGIN
    IF @userId IS NULL OR @userName IS NULL OR @birthDate IS NULL OR @email IS NULL OR @idCampus IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Campus WHERE campusId = @idCampus)
    BEGIN
        SELECT 'The campus does not exist' AS ExecMessage
        RETURN
    END
    INSERT INTO User_ (userId, userName, birthDate, email, idCampus) VALUES (@userId, @userName, @birthDate, @email, @idCampus)
    SELECT 'User created succesfully' AS ExecMessage
END
GO

-- SP UPDATE USER

CREATE OR ALTER PROCEDURE spUpdateUser_(@userId VARCHAR(32), @userName VARCHAR(50), @birthDate DATE, @email varchar(50), @idCampus INT) AS
BEGIN
    IF @idCampus IS NOT NULL AND NOT EXISTS(SELECT * FROM Campus WHERE campusId = @idCampus)
    BEGIN
        SELECT 'The campus does not exist' AS ExecMessage
        RETURN
    END
    IF @userId IS NOT NULL AND NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    UPDATE User_ SET userName = ISNULL(@userName, userName), birthDate = ISNULL(@birthDate, birthDate), email = ISNULL(@email, email), idCampus = ISNULL(@idCampus, idCampus) WHERE userId = @userId
    SELECT 'User updated succesfully' AS ExecMessage
END

-- SP READ USER

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

-- SP DELETE USER

CREATE OR ALTER PROCEDURE spDeleteUser_(@userId VARCHAR(32)) AS
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
    DELETE FROM User_ WHERE userId = @userId
    SELECT 'User deleted succesfully' AS ExecMessage
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
    SET @average = (SELECT AVG(SUM(SUM(itemValue))) AS GradeAverage 
                    FROM SchoolPeriod INNER JOIN CourseGroup ON CourseGroup.periodId = SchoolPeriod.schoolPeriodId 

                    INNER JOIN UserXCourse ON UserXCourse.courseId = CourseGroup.courseId
                    INNER JOIN User_ ON User_.userId = UserXCourse.userId
                    INNER JOIN Professor ON CourseGroup.professorId = Professor.userId
                    INNER JOIN ProfessorXEvaluation ON ProfessorXEvaluation.userId = Professor.userId
                    INNER JOIN Evaluation ON Evaluation.evaluationId = ProfessorXEvaluation.evaluationId
                    INNER JOIN StudentXItem ON StudentXItem.userId = User_.userId
                    INNER JOIN Item ON Item.itemId = StudentXItem.itemId
                    INNER JOIN Item ON Item.evaluationId = Evaluation.evaluationId

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
    SET @gradeAverageValue = [dbo].spGetGradeAverage(@userId, @schoolPeriodId)
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
        SET @enrollmentTimeScheduleValue = -1
        RETURN @enrollmentTimeScheduleValue -- code to know that the student can not enroll
    END

    RETURN @enrollmentTimeScheduleValue

END

-- ------------------------------
-- -> parametros (userId, schoolPeriodId) x
-- 1-> obtener el enrollment time schedule de un estudiante x
-- 2-> si el entollment time es -1 entonces solo se retorna que no tiene hora de matrícula disponible para esa matricula x
-- 2-> obtener el día del enrollment, haciendo el join del school period y el enrollment x
-- 2-> obtener el el día y hora actual x
-- 3-> si está en el mismo día del enrollment, y la hora actual es mayor o igual a la hora del enrollment time del estudiante y menor que las 3 pm 
-- entonces el estudiante puede matricular x

CREATE OR ALTER PROCEDURE spUserInEnrollmentTime(@userId VARCHAR(32), @schoolPeriodId INT) AS
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

    DECLARE @enrollmentTimeScheduleValue INT, @enrollmentDay DATETIME, @currentDay DATETIME
    SET @enrollmentTimeScheduleValue = [dbo].spEnrollmentTimeSchedule(@userId, @schoolPeriodId)

    -- The user cant enroll and the errorcode is -1

    IF @enrollmentTimeScheduleValue = -1
    BEGIN
        SELECT 'You can not enroll' AS ExecMessage
        RETURN -1
    END

    -- obtain the enrollment day and the current day
    SET @enrollmentDay = (SELECT Enrollment.startDate FROM Enrollment INNER JOIN SchoolPeriod ON SchoolPeriod.schoolPeriodId = Enrollment.PeriodId WHERE Enrollment.PeriodId = @schoolPeriodId)
    SET @currentDay = GETDATE()

    -- if the current day is not the enrollment day, the user cant enroll
    IF DATEPART(DAY, @enrollmentDay) != DATEPART(DAY, @currentDay)
    BEGIN
        SELECT 'You are not in the enrollment day' AS ExecMessage
        RETURN -1
    END

    -- if the current hour is not in the enrollment time schedule, the user cant enroll
    -- the enrollment time schedule is from 7 am to 3 pm, but the start time of the student depends on his grade average
    IF DATEPART(HOUR, @currentDay) < @enrollmentTimeScheduleValue OR DATEPART(HOUR, @currentDay) >= 15
    BEGIN
        SELECT 'You are not in your enrollment time' AS ExecMessage
        RETURN -1
    END

    SELECT 'You are in your enrollment time, you can enroll' AS ExecMessage
    RETURN 1
END