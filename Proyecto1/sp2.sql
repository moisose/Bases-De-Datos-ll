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
    SET @average = (SELECT AVG(SUM(SUM(itemValue))) AS GradeAverage 
                    FROM SchoolPeriod INNER JOIN CourseGroup ON CourseGroup.periodId = SchoolPeriod.periodId 

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


-- SP ENROLLMENT
CREATE OR ALTER PROCEDURE spEnrollment(@userId VARCHAR(32), @schoolPeriodId INT, @timeOfDay TIME) AS
BEGIN
    DECLARE @enrollmentSchedule INT
    SET @enrollmentSchedule = 0

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
    IF EXISTS(SELECT * FROM UserXSchoolPeriod WHERE userId = @userId AND schoolPeriodId = @schoolPeriodId)
    BEGIN
        SELECT 'The user is already enrolled' AS ExecMessage
        RETURN
    END

    SET @enrollmentSchedule = spEnrollmentTimeSchedule(@userId, @schoolPeriodId)
    IF (DATEPART(HOUR, @timeOfDay) < @enrollmentSchedule OR DATEPART(HOUR, @timeOfDay) > @enrollmentSchedule) AND DATEPART(HOUR, @timeOfDay) < 12
    BEGIN
        SELECT 'You can not enroll' AS ExecMessage
        RETURN
    END

    INSERT INTO WeeklySchedule (schoolPeriodId, userId) VALUES (@schoolPeriodId, @userId)
    SELECT 'User enrolled succesfully' AS ExecMessage
END

si tiene los requisitos del curso, si no hay choque de horarios, y si no matricula un mismo curso en diferentes grupos

