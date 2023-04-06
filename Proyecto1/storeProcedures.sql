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