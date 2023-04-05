-- -- Ingresar empleados
-- CREATE OR ALTER PROCEDURE spIngresarEmpleados(@idSucursal int, @idCargo int, @idDistrito int, @descripcionDireccion varchar(100), @nombre varchar(50),
--                                               @telefono int, @fechaContratacion date) AS
-- BEGIN 
--     DECLARE @error int, @errormessage varchar(100)
--     SET @error = 0

--     EXEC CreateEmpleado @idSucursal, @idCargo, @idDistrito, @descripcionDireccion, @nombre, @telefono, @fechaContratacion, @error OUTPUT

--     IF(@error != 0) SET @errormessage = 'No se pudo crear el empleado'
--     PRINT(@errormessage)

-- END
-- GO