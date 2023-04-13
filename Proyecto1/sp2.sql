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
                    FROM SchoolPeriod 
                    INNER JOIN CourseGroup ON CourseGroup.periodId = SchoolPeriod.schoolPeriodId 
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
											WHERE @courseId = Course.courseId)
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
						  FROM Schedule 
						  INNER JOIN ScheduleXCourseGroup ON ScheduleXCourseGroup.scheduleId = Schedule.scheduleId
						  INNER JOIN CourseGroup ON CourseGroup.courseGroupId = ScheduleXCourseGroup.courseGroupId
						  WHERE CourseGroup.courseGroupId = @courseGroupId)
	SET @horarioFinal = (SELECT finishTime 
						  FROM Schedule 
						  INNER JOIN ScheduleXCourseGroup ON ScheduleXCourseGroup.scheduleId = Schedule.scheduleId
						  INNER JOIN CourseGroup ON CourseGroup.courseGroupId = ScheduleXCourseGroup.courseGroupId
						  WHERE CourseGroup.courseGroupId = @courseGroupId)

	IF EXISTS (SELECT * FROM WeeklySchedule
				INNER JOIN CourseGroup ON WeeklySchedule.courseGroupId = CourseGroup.courseGroupId
				INNER JOIN ScheduleXCourseGroup ON ScheduleXCourseGroup.courseGroupId = CourseGroup.courseGroupId
				INNER JOIN Schedule ON Schedule.scheduleId = ScheduleXCourseGroup.scheduleId
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
