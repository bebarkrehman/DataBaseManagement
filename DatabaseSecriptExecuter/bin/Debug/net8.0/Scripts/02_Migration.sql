IF NOT EXISTS (SELECT 1 FROM SchemaVersion WHERE VersionNumber = 2)
BEGIN
--Non ClusterIndex
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'EmployeePublicHoliday')
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM sys.indexes 
        WHERE name = 'IX_EmployeePublicHoliday_HolidayDate_EmployeeId'
          AND object_id = OBJECT_ID('EmployeePublicHoliday')
    )
    BEGIN
        CREATE NONCLUSTERED INDEX IX_EmployeePublicHoliday_HolidayDate_EmployeeId
        ON EmployeePublicHoliday (HolidayDate,EmployeeId);
    END
END

--Non ClusterIndex
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'EmployeeLeave')
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM sys.indexes 
        WHERE name = 'IX_EmployeeLeave_StartDate_EndDate_EmployeeId'
          AND object_id = OBJECT_ID('EmployeeLeave')
    )
    BEGIN
        CREATE NONCLUSTERED INDEX IX_EmployeeLeave_StartDate_EndDate_EmployeeId
        ON EmployeeLeave (StartDate,EndDate,EmployeeId);
    END
END


--Non ClusterIndex
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'EmployeeLeaveDetail')
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM sys.indexes 
        WHERE name = 'IX_EmployeeLeaveDetail_LeaveDate_EmployeeId'
          AND object_id = OBJECT_ID('EmployeeLeaveDetail')
    )
    BEGIN
        CREATE NONCLUSTERED INDEX IX_EmployeeLeaveDetail_LeaveDate_EmployeeId
        ON EmployeeLeaveDetail (LeaveDate,EmployeeId);
    END
END
 -------------------------------
    -- Insert Schema Version
    -------------------------------
    INSERT INTO SchemaVersion (VersionNumber, AppliedOn)
    VALUES (2, GETDATE());
END
