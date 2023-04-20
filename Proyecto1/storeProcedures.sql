
USE db01
GO

CREATE OR ALTER PROCEDURE spCreateUser_(@userId VARCHAR(32), @userName VARCHAR(50), @birthDate DATE, @email varchar(50)) AS
BEGIN
    IF @userId IS NULL OR @userName IS NULL OR @birthDate IS NULL OR @email IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    INSERT INTO User_ (userId, userName, birthDate, email) VALUES (@userId, @userName, @birthDate, @email)
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
    UPDATE User_ SET userName = ISNULL(@userName, userName), birthDate = ISNULL(@birthDate, birthDate), email = ISNULL(@email, email) WHERE userId = @userId
    SELECT 'User updated succesfully' AS ExecMessage
END
GO

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
GO

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
GO

-- ------------------------------
-- -> parametros (userId, schoolPeriodId) x
-- 1-> obtener el enrollment time schedule de un estudiante x
-- 2-> si el entollment time es -1 entonces solo se retorna que no tiene hora de matrícula disponible para esa matricula x
-- 2-> obtener el día del enrollment, haciendo el join del school period y el enrollment x
-- 2-> obtener el el día y hora actual x
-- 3-> si está en el mismo día del enrollment, y la hora actual es mayor o igual a la hora del enrollment time del estudiante y menor que las 3 pm 
-- entonces el estudiante puede matricular x

CREATE OR ALTER PROCEDURE spUserInEnrollmentTime(@userId VARCHAR(32), @schoolPeriodId INT, @result BIT OUTPUT) AS
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
        SET @result = -1
    END

    -- obtain the enrollment day and the current day
    SET @enrollmentDay = (SELECT Enrollment.startDate FROM Enrollment INNER JOIN SchoolPeriod ON SchoolPeriod.schoolPeriodId = Enrollment.PeriodId WHERE Enrollment.PeriodId = @schoolPeriodId)
    SET @currentDay = GETDATE()

    -- if the current day is not the enrollment day, the user cant enroll
    IF DATEPART(DAY, @enrollmentDay) != DATEPART(DAY, @currentDay)
    BEGIN
        SELECT 'You are not in the enrollment day' AS ExecMessage
        SET @result = -1
    END

    -- if the current hour is not in the enrollment time schedule, the user cant enroll
    -- the enrollment time schedule is from 7 am to 3 pm, but the start time of the student depends on his grade average
    IF DATEPART(HOUR, @currentDay) < @enrollmentTimeScheduleValue OR DATEPART(HOUR, @currentDay) >= 15
    BEGIN
        SELECT 'You are not in your enrollment time' AS ExecMessage
        SET @result = -1
    END

    SELECT 'You are in your enrollment time, you can enroll' AS ExecMessage
    SET @result = 1
END
GO