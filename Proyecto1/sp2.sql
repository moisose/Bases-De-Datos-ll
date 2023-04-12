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
    SET @average = (SELECT AVG(SUM(SUM(itemValue))) AS GradeAverage 
                    FROM SchoolPeriod INNER JOIN CourseGroup ON CourseGroup.periodId = SchoolPeriod.schoolPeriodId 

                    INNER JOIN StudentXCourse ON StudentXCourse.courseId = CourseGroup.courseId
                    INNER JOIN User_ ON User_.userId = StudentXCourse.userId
                    INNER JOIN Professor ON CourseGroup.professorId = Professor.userId
                    INNER JOIN ProfessorXEvaluation ON ProfessorXEvaluation.userId = Professor.userId
                    INNER JOIN Evaluation ON Evaluation.evaluationId = ProfessorXEvaluation.evaluationId
                    INNER JOIN StudentXItem ON StudentXItem.userId = User_.userId
                    INNER JOIN Item ON Item.itemId = StudentXItem.itemId AND Item.evaluationId = Evaluation.evaluationId

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
CREATE OR ALTER PROCEDURE spMeetRequirements(@userId INT, @courseId)
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

IF NOT EXISTS(SELECT userId FROM Student INNER JOIN WeeklySchedule ON WeeklySchedule.userId INNER JOIN GroupCourse ON GroupCourse.groupId = WeeklySchedule.groupId INNER JOIN Course ON Course.courseId = GroupCourse.courseId INNER JOIN CourseRequirement ON CourseRequirement.courseId = Course.courseId INNER JOIN Course AS CourseReq ON CourseReq.courseId = Course.courseId WHERE Course.courseId = @courseId AND userId = @userId)
BEGIN

END


-- SP ENROLLMENT
CREATE OR ALTER PROCEDURE spEnrollment(@userId VARCHAR(32), @schoolPeriodId INT, @courseGroupId INT, @timeOfDay TIME) AS
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
    IF EXISTS(SELECT * FROM WeeklySchedule WHERE userId = @userId AND courseGroupId = @courseGroupId)
    BEGIN
        SELECT 'The user is already enrolled' AS ExecMessage
        RETURN
    END

	-- Validates if student meets all requirements to enroll the course
    IF NOT EXISTS(SELECT Student.userId FROM CourseGroup INNER JOIN Course ON Course.courseId = CourseGroup.courseId 
											INNER JOIN CourseRequirement ON CourseRequirement.courseId = Course.courseId 
											INNER JOIN WeeklySchedule ON WeeklySchedule.courseGroupId = CourseGroup.courseGroupId 
											INNER JOIN Student ON Student.userId = WeeklySchedule.userId WHERE Student.userId = @userId AND (Course.courseId = CourseGroup.courseId AND CourseGroup.courseGroupId = @courseGroupId))
    BEGIN
        SELECT 'Student does not meet the needed requirements to enroll this course' AS ExecMessage
        RETURN
    END 

	-- Validates if the schedule of the course group doesnt collide with another group schedule

	-- Validates if student hasn't enrolled the same course in other group

    SET @enrollmentSchedule = spEnrollmentTimeSchedule(@userId, @schoolPeriodId)
    IF (DATEPART(HOUR, @timeOfDay) < @enrollmentSchedule OR DATEPART(HOUR, @timeOfDay) > @enrollmentSchedule) AND DATEPART(HOUR, @timeOfDay) < 12
    BEGIN
        SELECT 'You can not enroll' AS ExecMessage
        RETURN
    END

    INSERT INTO WeeklySchedule (userId, courseGroupId) VALUES (@userId, @courseGroupId)
    SELECT 'User enrolled succesfully' AS ExecMessage
END

si no hay choque de horarios, y si no matricula un mismo curso en diferentes grupos

