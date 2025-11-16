-- Version 0: Ensure SchemaVersion table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SchemaVersion')
BEGIN
    CREATE TABLE SchemaVersion (
        VersionNumber INT PRIMARY KEY,
        AppliedOn DATETIME NOT NULL
    );
END

IF NOT EXISTS (SELECT 1 FROM SchemaVersion WHERE VersionNumber = 1)
BEGIN
    -------------------------------
    -- Company Table
    -------------------------------
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Company')
    BEGIN
        CREATE TABLE Company (
            CompanyId INT  PRIMARY KEY,
            CompanyName NVARCHAR(100) NOT NULL,
            Status BIT NOT NULL DEFAULT 1,
            CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
            CreatedBy INT NULL,
            UpdatedDate DATETIME NULL,
            UpdatedBy INT NULL
        );
    END

    -------------------------------
    -- Country Table
    -------------------------------
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Country')
    BEGIN
        CREATE TABLE Country (
            CountryId INT NOT NULL,
            CompanyId INT NOT NULL,
            CountryName NVARCHAR(100) NOT NULL,
            CountryLogo NVARCHAR(100) NOT NULL,
            Status BIT NOT NULL DEFAULT 1,
            CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
            CreatedBy INT NULL,
            UpdatedDate DATETIME NULL,
            UpdatedBy INT NULL,
            CONSTRAINT PK_Country PRIMARY KEY (CountryId, CompanyId)
        );
    END

    -------------------------------
    -- State Table
    -------------------------------
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'State')
    BEGIN
        CREATE TABLE State (
            StateId INT NOT NULL,
            CompanyId INT NOT NULL,
            StateName NVARCHAR(100) NOT NULL,
            CountryId INT NOT NULL,
            Status BIT NOT NULL DEFAULT 1,
            CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
            CreatedBy INT NULL,
            UpdatedDate DATETIME NULL,
            UpdatedBy INT NULL,
            CONSTRAINT PK_State PRIMARY KEY (StateId, CompanyId),
            CONSTRAINT FK_State_Country FOREIGN KEY (CountryId, CompanyId) REFERENCES Country(CountryId, CompanyId)
        );
    END

    -------------------------------
    -- City Table
    -------------------------------
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'City')
    BEGIN
        CREATE TABLE City (
            CityId INT NOT NULL,
            CompanyId INT NOT NULL,
            CityName NVARCHAR(100) NOT NULL,
            StateId INT NOT NULL,
            Status BIT NOT NULL DEFAULT 1,
            CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
            CreatedBy INT NULL,
            UpdatedDate DATETIME NULL,
            UpdatedBy INT NULL,
            CONSTRAINT PK_City PRIMARY KEY (CityId, CompanyId),
            CONSTRAINT FK_City_State FOREIGN KEY (StateId, CompanyId) REFERENCES State(StateId, CompanyId)
        );
    END

    -------------------------------
    -- Branch Table
    -------------------------------
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Branch')
    BEGIN
        CREATE TABLE Branch (
            BranchId INT NOT NULL,
            CompanyId INT NOT NULL,
            BranchCode NVARCHAR(20) NULL,
            BranchName NVARCHAR(100) NOT NULL,
            AddressLine1 NVARCHAR(200) NULL,
            AddressLine2 NVARCHAR(200) NULL,
            CityId INT NULL,
            StateId INT NULL,
            CountryId INT NULL,
            PhoneNumber NVARCHAR(20) NULL,
            Email NVARCHAR(100) NULL,
            ManagerId INT NULL,
            Status BIT NOT NULL DEFAULT 1,
            CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
            CreatedBy INT NULL,
            UpdatedDate DATETIME NULL,
            UpdatedBy INT NULL,
            CONSTRAINT PK_Branch PRIMARY KEY (BranchId, CompanyId),
            CONSTRAINT FK_Branch_City FOREIGN KEY (CityId, CompanyId) REFERENCES City(CityId, CompanyId),
            CONSTRAINT FK_Branch_State FOREIGN KEY (StateId, CompanyId) REFERENCES State(StateId, CompanyId),
            CONSTRAINT FK_Branch_Country FOREIGN KEY (CountryId, CompanyId) REFERENCES Country(CountryId, CompanyId)
        );
    END

    -------------------------------
    -- Department Table
    -------------------------------
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Department')
    BEGIN
        CREATE TABLE Department (
            DepartmentId INT NOT NULL,
            CompanyId INT NOT NULL,
            DepartmentName NVARCHAR(100) NOT NULL,
            DepartmentCode NVARCHAR(20) NULL,
            Status BIT NOT NULL DEFAULT 1,
            CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
            CreatedBy INT NULL,
            UpdatedDate DATETIME NULL,
            UpdatedBy INT NULL,
            CONSTRAINT PK_Department PRIMARY KEY (DepartmentId, CompanyId)
        );
    END

    -------------------------------
    -- Designation Table
    -------------------------------
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Designation')
    BEGIN
        CREATE TABLE Designation (
            DesignationId INT NOT NULL,
            CompanyId INT NOT NULL,
            DesignationName NVARCHAR(100) NOT NULL,
            DesignationCode NVARCHAR(20) NULL,
            Status BIT NOT NULL DEFAULT 1,
            CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
            CreatedBy INT NULL,
            UpdatedDate DATETIME NULL,
            UpdatedBy INT NULL,
            CONSTRAINT PK_Designation PRIMARY KEY (DesignationId, CompanyId)
        );
    END

    -------------------------------
    -- EmployeeType Table
    -------------------------------
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeType')
    BEGIN
        CREATE TABLE EmployeeType (
            EmployeeTypeId INT NOT NULL,
            CompanyId INT NOT NULL,
            EmployeeTypeName NVARCHAR(100) NOT NULL,
            Status BIT NOT NULL DEFAULT 1,
            CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
            CreatedBy INT NULL,
            UpdatedDate DATETIME NULL,
            UpdatedBy INT NULL,
            CONSTRAINT PK_EmployeeType PRIMARY KEY (EmployeeTypeId, CompanyId)
        );
    END

    -------------------------------
    -- Employee Table
    -------------------------------
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Employee')
    BEGIN
        CREATE TABLE Employee (
            EmployeeId INT NOT NULL,
            CompanyId INT NOT NULL,
            EmployeeCode NVARCHAR(20) NULL,
            FirstName NVARCHAR(100) NOT NULL,
            LastName NVARCHAR(100) NOT NULL,
            FullName AS (FirstName + ' ' + LastName) PERSISTED,
            Gender_LookupId INT NULL,
            DateOfBirth DATE NULL,
            JoinDate DATE NULL,
            ConfirmationDate DATE NULL,
            LeavingDate DATE NULL,
            BranchId INT NULL,
            DepartmentId INT NULL,
            DesignationId INT NULL,
            EmployeeTypeId INT NULL,
            Status BIT NOT NULL DEFAULT 1,
            ReportedTo INT NULL,
            OtherReportedTo INT NULL,
            CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
            CreatedBy INT NULL,
            UpdatedDate DATETIME NULL,
            UpdatedBy INT NULL,
            CONSTRAINT PK_Employee PRIMARY KEY (EmployeeId, CompanyId),
            CONSTRAINT FK_Employee_Branch FOREIGN KEY (BranchId, CompanyId) REFERENCES Branch(BranchId, CompanyId),
            CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentId, CompanyId) REFERENCES Department(DepartmentId, CompanyId),
            CONSTRAINT FK_Employee_Designation FOREIGN KEY (DesignationId, CompanyId) REFERENCES Designation(DesignationId, CompanyId),
            CONSTRAINT FK_Employee_EmployeeType FOREIGN KEY (EmployeeTypeId, CompanyId) REFERENCES EmployeeType(EmployeeTypeId, CompanyId)
        );
    END

    -------------------------------
-- EmployeeQualification Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeQualification')
BEGIN
    CREATE TABLE EmployeeQualification (
        EmployeeQualificationId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        DegreeName_LookupId NVARCHAR(100) NOT NULL,
        University_LookupId NVARCHAR(100) NULL,
        YearOfPassing INT NULL,
        Grade NVARCHAR(20) NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeQualification PRIMARY KEY (EmployeeQualificationId, CompanyId),
        CONSTRAINT FK_EmployeeQualification_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END

-------------------------------
-- EmployeeExperience Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeExperience')
BEGIN
    CREATE TABLE EmployeeExperience (
        EmployeeExperienceId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        CompanyName NVARCHAR(100) NOT NULL,
        Designation NVARCHAR(100) NULL,
        FromDate DATE NULL,
        ToDate DATE NULL,
        TotalExperienceMonths INT NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeExperience PRIMARY KEY (EmployeeExperienceId, CompanyId),
        CONSTRAINT FK_EmployeeExperience_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END

-------------------------------
-- EmployeeReference Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeReference')
BEGIN
    CREATE TABLE EmployeeReference (
        EmployeeReferenceId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        ReferenceName NVARCHAR(100) NOT NULL,
        Relationship_LookupId INT NULL,
        ContactNumber NVARCHAR(20) NULL,
        Email NVARCHAR(100) NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeReference PRIMARY KEY (EmployeeReferenceId, CompanyId),
        CONSTRAINT FK_EmployeeReference_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END

-------------------------------
-- EmployeeDocument Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeDocument')
BEGIN
    CREATE TABLE EmployeeDocument (
        EmployeeDocumentId INT IDENTITY(1,1) PRIMARY KEY,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        DocumentType NVARCHAR(50) NOT NULL,
        DocumentName NVARCHAR(100) NULL,
        DocumentPath NVARCHAR(500) NULL,
        UploadDate DATETIME NOT NULL DEFAULT GETDATE(),
        Status BIT NOT NULL DEFAULT 1,
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT FK_EmployeeDocument_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END

-------------------------------
-- EmployeeSalary Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeSalary')
BEGIN
    CREATE TABLE EmployeeSalary (
        EmployeeSalaryId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        BasicSalary DECIMAL(18,2) NOT NULL,
        GrossSalary DECIMAL(18,2) NOT NULL,
        SalaryType NVARCHAR(MAX) NOT NULL DEFAULT 'Monthly',
        Currency NVARCHAR(MAX) NOT NULL DEFAULT 'RS',
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeSalary PRIMARY KEY (EmployeeSalaryId, CompanyId),
        CONSTRAINT FK_EmployeeSalary_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END
-------------------------------
-- Allowance Type Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AllowanceType')
BEGIN
    CREATE TABLE AllowanceType (
        AllowanceTypeId INT Not NULL,
        CompanyId INT NOT NULL,                     -- Company reference
        AllowanceTypeName NVARCHAR(100) NOT NULL,  -- e.g., House Rent, Medical
        Status BIT NOT NULL DEFAULT 1,             -- Active/Inactive
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_AllowanceType PRIMARY KEY (AllowanceTypeId, CompanyId)
    );
     
END

-------------------------------
-- Addition Type Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AdditionType')
BEGIN
    CREATE TABLE AdditionType (
        AdditionTypeId INT NOT NULL,
        CompanyId INT NOT NULL,                     -- Company reference
        AdditionTypeName NVARCHAR(100) NOT NULL,   -- e.g., Bonus, Incentive
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_AdditionType PRIMARY KEY (AdditionTypeId, CompanyId)
    );
END

-------------------------------
-- Deduction Type Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DeductionType')
BEGIN
    CREATE TABLE DeductionType (
        DeductionTypeId INT NOT NULL,
        CompanyId INT NOT NULL,                     -- Company reference
        DeductionTypeName NVARCHAR(100) NOT NULL,  -- e.g., Tax, Loan
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_DeductionType PRIMARY KEY (DeductionTypeId, CompanyId)
    );
END

-------------------------------
-- EmployeeAllowance Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeAllowance')
BEGIN
    CREATE TABLE EmployeeAllowance (
        EmployeeAllowanceId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        AllowanceTypeId INT NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeAllowance PRIMARY KEY (EmployeeAllowanceId, CompanyId),
        CONSTRAINT FK_EmployeeAllowance_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId),
        CONSTRAINT FK_EmployeeAllowance_EmployeeAllowance FOREIGN KEY (AllowanceTypeId,CompanyId) REFERENCES AllowanceType(AllowanceTypeId, CompanyId)
    );
END
-------------------------------
-- EmployeeDeduction Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeAddition')
BEGIN
    CREATE TABLE EmployeeAddition (
        EmployeeAdditionId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        DeductionTypeId INT NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeAddition PRIMARY KEY (EmployeeAdditionId, CompanyId),
        CONSTRAINT FK_EmployeeAddition_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId),
        CONSTRAINT FK_EmployeeAllowance_EmployeeAddition FOREIGN KEY (DeductionTypeId,CompanyId) REFERENCES DeductionType(DeductionTypeId, CompanyId)
    );
END
-------------------------------
-- EmployeeDeduction Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeDeduction')
BEGIN
    CREATE TABLE EmployeeDeduction (
        EmployeeDeductionId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        DeductionTypeId INT NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeDeduction PRIMARY KEY (EmployeeDeductionId, CompanyId),
        CONSTRAINT FK_EmployeeAllowance_EmployeeDeduction FOREIGN KEY (DeductionTypeId,CompanyId) REFERENCES AdditionType(AdditionTypeId, CompanyId)
    );
END

-------------------------------
-- EmployeeAdvance Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeAdvance')
BEGIN
    CREATE TABLE EmployeeAdvance (
        EmployeeAdvanceId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        AdvanceAmount DECIMAL(18,2) NOT NULL,
        AdvanceDate DATE NOT NULL,
        Purpose NVARCHAR(200) NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
         CONSTRAINT PK_EmployeeAdvance PRIMARY KEY (EmployeeAdvanceId, EmployeeId),
        CONSTRAINT FK_EmployeeAdvance_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END
-------------------------------
-- Shift Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Shift')
BEGIN
    CREATE TABLE Shift (
        ShiftId INT NOT NULL,
        CompanyId INT NOT NULL,
        ShiftName NVARCHAR(50) NOT NULL,
        StartTime TIME NOT NULL,
        EndTime TIME NOT NULL,
        Status BIT NOT NULL DEFAULT 1,
        MarkInNextDate BIT NULL DEFAULT 0,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_Shift PRIMARY KEY (ShiftId, CompanyId)

    );
END

-------------------------------
-- EmployeeWorkingDay Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeWorkingDay')
BEGIN
    CREATE TABLE EmployeeWorkingDay (
        EmployeeWorkingDayId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        ShiftId INT NOT NULL,
        DayOfWeek INT NOT NULL,
        DayName NVARCHAR(100) NOT NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeWorkingDay PRIMARY KEY (EmployeeWorkingDayId, CompanyId),
        CONSTRAINT FK_EmployeeWorkingDay_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId),
        CONSTRAINT FK_EmployeeWorkingDay_Shift FOREIGN KEY (ShiftId, CompanyId) REFERENCES Shift(ShiftId, CompanyId)
    );
END

-------------------------------
-- EmployeeRoster Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeRoster')
BEGIN
    CREATE TABLE EmployeeRoster (
        EmployeeRosterId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        ShiftId INT NOT NULL,
        RosterDate DATE NOT NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeRoster PRIMARY KEY (EmployeeRosterId, CompanyId),
        CONSTRAINT FK_EmployeeRoster_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId),
        CONSTRAINT FK_EmployeeRoster_Shift FOREIGN KEY (ShiftId, CompanyId) REFERENCES Shift(ShiftId, CompanyId)
    );
END

-------------------------------
-- EmployeePublicHoliday Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeePublicHoliday')
BEGIN
    CREATE TABLE EmployeePublicHoliday (
        EmployeePublicHolidayId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        HolidayDate DATE NOT NULL,
        HolidayName NVARCHAR(100) NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeePublicHoliday PRIMARY KEY (EmployeePublicHolidayId, CompanyId),
        CONSTRAINT FK_EmployeePublicHoliday_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END

-------------------------------
-- LeavePeriod Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LeavePeriod')
BEGIN
    CREATE TABLE LeavePeriod (
        LeavePeriodId INT NOT NULL,
        CompanyId INT NOT NULL,
        PeriodName NVARCHAR(50) NOT NULL,
        StartDate DATE NOT NULL,
        EndDate DATE NOT NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_LeavePeriod PRIMARY KEY (LeavePeriodId, CompanyId)
    );
END

-------------------------------
-- LeaveType Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LeaveType')
BEGIN
    CREATE TABLE LeaveType (
        LeaveTypeId INT NOT NULL,
        CompanyId INT NOT NULL,
        LeaveTypeName NVARCHAR(50) NOT NULL,
        Description NVARCHAR(200) NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_LeaveType PRIMARY KEY (LeaveTypeId, CompanyId)
    );
END

-------------------------------
-- EmployeeLeave Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeLeave')
BEGIN
    CREATE TABLE EmployeeLeave (
        EmployeeLeaveId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        LeaveTypeId INT NOT NULL,
        LeavePeriodId INT NOT NULL,
        StartDate DATE NOT NULL,
        EndDate DATE NOT NULL,
        TotalDays DECIMAL(5,2) NOT NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
        Reason NVARCHAR(200) NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeLeave PRIMARY KEY (EmployeeLeaveId, CompanyId),
        CONSTRAINT FK_EmployeeLeave_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId),
        CONSTRAINT FK_EmployeeLeave_LeaveType FOREIGN KEY (LeaveTypeId, CompanyId) REFERENCES LeaveType(LeaveTypeId, CompanyId),
        CONSTRAINT FK_EmployeeLeave_LeavePeriod FOREIGN KEY (LeavePeriodId, CompanyId) REFERENCES LeavePeriod(LeavePeriodId, CompanyId)
    );
END

-------------------------------
-- EmployeeLeaveDetail Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeLeaveDetail')
BEGIN
    CREATE TABLE EmployeeLeaveDetail (
        EmployeeLeaveDetailId INT NOT NULL,
        EmployeeLeaveId INT NOT NULL,
        CompanyId INT NOT NULL,
        LeaveDate DATE NOT NULL,
        DayType NVARCHAR(20) NOT NULL DEFAULT 'FullDay',
        Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeLeaveDetail PRIMARY KEY (EmployeeLeaveDetailId, CompanyId),
        CONSTRAINT FK_EmployeeLeaveDetail_EmployeeLeave FOREIGN KEY (EmployeeLeaveId, CompanyId) REFERENCES EmployeeLeave(EmployeeLeaveId, CompanyId)
    );
END

-------------------------------
-- EmployeeAttendance Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeAttendance')
BEGIN
    CREATE TABLE EmployeeAttendance (
        EmployeeAttendanceId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        AttendanceDate DATE NOT NULL,
        ShiftId INT NULL,
        CheckInTime DATETIME NULL,
        CheckOutTime DATETIME NULL,
        TotalHours AS (CASE WHEN CheckInTime IS NOT NULL AND CheckOutTime IS NOT NULL 
                             THEN DATEDIFF(MINUTE, CheckInTime, CheckOutTime)/60.0 
                             ELSE 0 END) PERSISTED,
        FromShift DATETIME NOT NULL,
        ToShiftTime DATETIME NOT NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Present',
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeAttendance PRIMARY KEY (EmployeeAttendanceId, CompanyId),
        CONSTRAINT FK_EmployeeAttendance_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId),
        CONSTRAINT FK_EmployeeAttendance_Shift FOREIGN KEY (ShiftId, CompanyId) REFERENCES Shift(ShiftId, CompanyId)
    );
END

-------------------------------
-- EmployeeAttendanceLog Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeAttendanceLog')
BEGIN
    CREATE TABLE EmployeeAttendanceLog (
        AttendanceLogId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        AttendanceDate DATE NOT NULL,
        LogTime DATETIME NOT NULL,
        LogType NVARCHAR(10) NOT NULL,
        DeviceIP NVARCHAR(100) NOT NULL,
        DeviceId NVARCHAR(50) NULL,
        Status NVARCHAR(20) NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        CONSTRAINT PK_EmployeeAttendanceLog PRIMARY KEY (AttendanceLogId, CompanyId),
        CONSTRAINT FK_AttendanceLog_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END

-------------------------------
-- MachineConfig Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'MachineConfig')
BEGIN
    CREATE TABLE MachineConfig (
        MachineId INT NOT NULL,
        CompanyId INT NOT NULL,
        MachineName NVARCHAR(100) NOT NULL,
        DeviceId NVARCHAR(50) NOT NULL,
        DeviceType NVARCHAR(50) NULL,
        IPAddress NVARCHAR(50) NULL,
        Location NVARCHAR(100) NULL,
        Status BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_MachineConfig PRIMARY KEY (MachineId, CompanyId),
    );
END

--Employee Manual Attendance
-------------------------------
-- EmployeeManualAttendance Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeManualAttendance')
BEGIN
    CREATE TABLE EmployeeManualAttendance (
        EmployeeManualAttendanceId INT NOT NULL,
        EmployeeId INT NOT NULL,
        CompanyId INT NOT NULL,
        AttendanceDate DATE NOT NULL,              -- Date for which manual entry is recorded
        LogType NVARCHAR(10) NOT NULL,            -- 'IN' or 'OUT' or 'Both'
        LogTimeIN DATETIME NOT NULL,                 -- Manual check-in or check-out time
        LogTimeOUT DATETIME NOT NULL, 
        Reason NVARCHAR(200) NULL,                 -- Reason for manual entry
        Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending/Approved/Rejected
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeManualAttendance PRIMARY KEY (EmployeeManualAttendanceId, CompanyId),
        -- Foreign Key Constraints
        CONSTRAINT FK_EmployeeManualAttendance_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END

-------------------------------
-- EmployeePFOpening Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeePFOpening')
BEGIN
    CREATE TABLE EmployeePFOpening (
        EmployeePFOpeningId INT NOT NULL,
        EmployeeId INT NOT NULL,              -- Employee reference
        CompanyId INT NOT NULL,               -- Company reference
        OpeningDate DATE NOT NULL,            -- PF opening date
        CompanyPFAmount DECIMAL(18,2) NOT NULL DEFAULT 0,   -- Amount contributed by company
        EmployeePFAmount DECIMAL(18,2) NOT NULL DEFAULT 0,  -- Amount contributed by employee
        CompanyPFPercent DECIMAL(5,2) NOT NULL DEFAULT 0,   -- Percentage contribution by company
        EmployeePFPercent DECIMAL(5,2) NOT NULL DEFAULT 0,  -- Percentage contribution by employee
        Status BIT NOT NULL DEFAULT 1,        -- Active / Inactive
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,

         CONSTRAINT PK_EmployeePFOpening PRIMARY KEY (EmployeePFOpeningId, CompanyId),
        -- Foreign Key Constraint
        CONSTRAINT FK_EmployeePFOpening_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END
-------------------------------
-- EmployeePFWithdrawal Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeePFWithdrawal')
BEGIN
    CREATE TABLE EmployeePFWithdrawal (
        EmployeePFWithdrawalId INT NOT NULL,
        EmployeeId INT NOT NULL,                   -- Employee reference
        CompanyId INT NOT NULL,                    -- Company reference
        WithdrawalDate DATE NOT NULL,              -- Date of withdrawal
        WithdrawalAmount DECIMAL(18,2) NOT NULL,  -- Amount withdrawn
        Remarks NVARCHAR(200) NULL,               -- Optional notes/reason
        Status BIT NOT NULL DEFAULT 1,             -- Active / Approved / Cancelled
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeePFWithdrawal PRIMARY KEY (EmployeePFWithdrawalId, CompanyId),
        -- Foreign Key Constraint
        CONSTRAINT FK_EmployeePFWithdrawal_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END
-------------------------------
-- EmployeePFAdjustment Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeePFAdjustment')
BEGIN
    CREATE TABLE EmployeePFAdjustment (
        EmployeePFAdjustmentId INT NOT NULL,
        EmployeeId INT NOT NULL,                   -- Employee reference
        CompanyId INT NOT NULL,                    -- Company reference
        AdjustmentDate DATE NOT NULL,              -- Date of adjustment
        AdjustmentType NVARCHAR(50) NOT NULL,     -- e.g., 'Addition', 'Deduction', 'Correction'
        Amount DECIMAL(18,2) NOT NULL,            -- Adjustment amount (+ve or -ve)
        Remarks NVARCHAR(200) NULL,               -- Optional reason/details
        Status BIT NOT NULL DEFAULT 1,             -- Active / Approved / Cancelled
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeePFAdjustment PRIMARY KEY (EmployeePFAdjustmentId, CompanyId),
        -- Foreign Key Constraint
        CONSTRAINT FK_EmployeePFAdjustment_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END
-------------------------------
-- EmployeeEOBI Table
-------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeEOBI')
BEGIN
    CREATE TABLE EmployeeEOBI (
        EmployeeEOBIId INT NOT NULL,
        EmployeeId INT NOT NULL,                 -- Employee reference
        CompanyId INT NOT NULL,                  -- Company reference
        ContributionMonth DATE NOT NULL,         -- Month of contribution
        EmployeeContribution DECIMAL(18,2) NOT NULL,  -- Employee share
        CompanyContribution DECIMAL(18,2) NOT NULL,   -- Company share
        TotalContribution AS (EmployeeContribution + CompanyContribution) PERSISTED,
        Status BIT NOT NULL DEFAULT 1,           -- Active / Approved
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
        CONSTRAINT PK_EmployeeEOBI PRIMARY KEY (EmployeeEOBIId, CompanyId),
        -- Foreign Key Constraint
        CONSTRAINT FK_EmployeeEOBI_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId)
    );
END

--------------------------------
-- Payroll Master Table (Enhanced)
--------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PayrollMaster')
BEGIN
    CREATE TABLE PayrollMaster (
        PayrollMasterId INT ,
        CompanyId INT NOT NULL,                 -- Company reference
        EmployeeId INT NOT NULL,                -- Employee reference
        PayrollMonth DATE NOT NULL,             -- Payroll month
        WorkingDays INT NOT NULL DEFAULT 0,     -- Number of working days in month
        TotalAllowance DECIMAL(18,2) NOT NULL DEFAULT 0,  -- Total Allowances
        TotalAddition DECIMAL(18,2) NOT NULL DEFAULT 0,   -- Total Additions
        TotalDeduction DECIMAL(18,2) NOT NULL DEFAULT 0,  -- Total Deductions
        NetSalary DECIMAL(18,2) NOT NULL DEFAULT 0,       -- Net Salary = Allow + Add - Deduct
        Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending / Processed / Approved
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,

       CONSTRAINT PK_PayrollMaster PRIMARY KEY (PayrollMasterId, CompanyId),
        -- Foreign Key Constraints
        CONSTRAINT FK_PayrollMaster_Employee FOREIGN KEY (EmployeeId, CompanyId) REFERENCES Employee(EmployeeId, CompanyId),
    );
END

--------------------------------
-- Payroll Detail Table
--------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PayrollDetail')
BEGIN
    CREATE TABLE PayrollDetail (
        PayrollDetailId INT NOT NULL,
        CompanyId INT NOT NULL,
        PayrollMasterId INT NOT NULL,           -- Link to PayrollMaster
        EmployeeId INT NOT NULL,                -- Employee reference
        Amount DECIMAL(18,2) NOT NULL,         -- Amount for this component
        Type NVARCHAR(20) NOT NULL,            -- 'Allowance', 'Addition', 'Deduction'
        AllowanceTypeId INT NULL,               -- Link to AllowanceType if Type='Allowance'
        AdditionTypeId INT NULL,                -- Link to AdditionType if Type='Addition'
        DeductionTypeId INT NULL,               -- Link to DeductionType if Type='Deduction'
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        UpdatedDate DATETIME NULL,
        UpdatedBy INT NULL,
         CONSTRAINT PK_PayrollDetail PRIMARY KEY (PayrollDetailId, CompanyId),
        -- Foreign Key Constraints
        CONSTRAINT FK_PayrollDetail_Master FOREIGN KEY (PayrollMasterId,CompanyId) REFERENCES PayrollMaster(PayrollMasterId,CompanyId),
        CONSTRAINT FK_PayrollDetail_Employee FOREIGN KEY (PayrollMasterId,CompanyId) REFERENCES Employee(EmployeeId,CompanyId),
        CONSTRAINT FK_PayrollDetail_Allowance FOREIGN KEY (AllowanceTypeId,CompanyId) REFERENCES EmployeeAllowance(EmployeeAllowanceId,CompanyId),
        CONSTRAINT FK_PayrollDetail_Addition FOREIGN KEY (AdditionTypeId,CompanyId) REFERENCES EmployeeDeduction(EmployeeDeductionId,CompanyId),
        CONSTRAINT FK_PayrollDetail_Deduction FOREIGN KEY (DeductionTypeId,CompanyId) REFERENCES EmployeeAddition(EmployeeAdditionId,CompanyId)
    );
END

    -------------------------------
    -- Insert Schema Version
    -------------------------------
    INSERT INTO SchemaVersion (VersionNumber, AppliedOn)
    VALUES (1, GETDATE());
END
