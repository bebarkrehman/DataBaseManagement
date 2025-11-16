-- ========================================
-- Non-Clustered Indexes for Employee Management Tables
-- ========================================

-- Helper macro to create index if not exists
-- Usage: EXEC sp_create_index_if_not_exists 'TableName', 'IndexName', 'ColumnList';
CREATE PROCEDURE sp_create_index_if_not_exists
    @tableName NVARCHAR(128),
    @indexName NVARCHAR(128),
    @columns NVARCHAR(MAX)
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM sys.indexes 
        WHERE name = @indexName
          AND object_id = OBJECT_ID(@tableName)
    )
    BEGIN
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = 'CREATE NONCLUSTERED INDEX ' + QUOTENAME(@indexName) +
                   ' ON ' + QUOTENAME(@tableName) + ' (' + @columns + ');';
        EXEC sp_executesql @sql;
    END
END


-- ========================================
-- Company Table
-- ========================================
EXEC sp_create_index_if_not_exists 'Company', 'IX_Company_CompanyId', 'CompanyId';

-- ========================================
-- Country Table
-- ========================================
EXEC sp_create_index_if_not_exists 'Country', 'IX_Country_Employee_Company', 'CompanyId';
EXEC sp_create_index_if_not_exists 'Country', 'IX_Country_Date', 'CreatedDate';

-- ========================================
-- State Table
-- ========================================
EXEC sp_create_index_if_not_exists 'State', 'IX_State_Employee_Company', 'CompanyId,StateId';
EXEC sp_create_index_if_not_exists 'State', 'IX_State_Date', 'CreatedDate';

-- ========================================
-- City Table
-- ========================================
EXEC sp_create_index_if_not_exists 'City', 'IX_City_Employee_Company', 'CompanyId,CityId';
EXEC sp_create_index_if_not_exists 'City', 'IX_City_Date', 'CreatedDate';

-- ========================================
-- Branch Table
-- ========================================
EXEC sp_create_index_if_not_exists 'Branch', 'IX_Branch_Employee_Company', 'CompanyId,BranchId';
EXEC sp_create_index_if_not_exists 'Branch', 'IX_Branch_Date', 'CreatedDate';

-- ========================================
-- Department Table
-- ========================================
EXEC sp_create_index_if_not_exists 'Department', 'IX_Department_Employee_Company', 'CompanyId,DepartmentId';
EXEC sp_create_index_if_not_exists 'Department', 'IX_Department_Date', 'CreatedDate';

-- ========================================
-- Designation Table
-- ========================================
EXEC sp_create_index_if_not_exists 'Designation', 'IX_Designation_Employee_Company', 'CompanyId,DesignationId';
EXEC sp_create_index_if_not_exists 'Designation', 'IX_Designation_Date', 'CreatedDate';

-- ========================================
-- EmployeeType Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeType', 'IX_EmployeeType_Employee_Company', 'CompanyId,EmployeeTypeId';
EXEC sp_create_index_if_not_exists 'EmployeeType', 'IX_EmployeeType_Date', 'CreatedDate';

-- ========================================
-- Employee Table
-- ========================================
EXEC sp_create_index_if_not_exists 'Employee', 'IX_Employee_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'Employee', 'IX_Employee_JoinDate', 'JoinDate';
EXEC sp_create_index_if_not_exists 'Employee', 'IX_Employee_LeavingDate', 'LeavingDate';
EXEC sp_create_index_if_not_exists 'Employee', 'IX_Employee_CreatedDate', 'CreatedDate';

-- ========================================
-- EmployeeQualification Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeQualification', 'IX_EmpQual_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeQualification', 'IX_EmpQual_Date', 'CreatedDate';

-- ========================================
-- EmployeeExperience Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeExperience', 'IX_EmpExp_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeExperience', 'IX_EmpExp_FromDate', 'FromDate';
EXEC sp_create_index_if_not_exists 'EmployeeExperience', 'IX_EmpExp_ToDate', 'ToDate';

-- ========================================
-- EmployeeReference Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeReference', 'IX_EmpRef_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeReference', 'IX_EmpRef_Date', 'CreatedDate';

-- ========================================
-- EmployeeDocument Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeDocument', 'IX_EmpDoc_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeDocument', 'IX_EmpDoc_UploadDate', 'UploadDate';

-- ========================================
-- EmployeeSalary Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeSalary', 'IX_EmpSal_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeSalary', 'IX_EmpSal_CreatedDate', 'CreatedDate';

-- ========================================
-- EmployeeAllowance Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeAllowance', 'IX_EmpAll_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeAllowance', 'IX_EmpAll_Date', 'CreatedDate';

-- ========================================
-- EmployeeDeduction Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeDeduction', 'IX_EmpDed_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeDeduction', 'IX_EmpDed_Date', 'CreatedDate';

-- ========================================
-- EmployeeAddition Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeAddition', 'IX_EmpAdd_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeAddition', 'IX_EmpAdd_Date', 'CreatedDate';

-- ========================================
-- EmployeeAdvance Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeAdvance', 'IX_EmpAdv_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeAdvance', 'IX_EmpAdv_AdvanceDate', 'AdvanceDate';

-- ========================================
-- EmployeeManualAttendance Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeManualAttendance', 'IX_EmpManAtt_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeManualAttendance', 'IX_EmpManAtt_AttendanceDate', 'AttendanceDate';

-- ========================================
-- EmployeePF Tables (Opening, Withdrawal, Adjustment)
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeePFOpening', 'IX_PFOpen_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeePFWithdrawal', 'IX_PFWith_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeePFAdjustment', 'IX_PFAdj_Employee_Company', 'CompanyId,EmployeeId';

-- ========================================
-- EmployeeEOBI Table
-- ========================================
EXEC sp_create_index_if_not_exists 'EmployeeEOBI', 'IX_EmpEOBI_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'EmployeeEOBI', 'IX_EmpEOBI_ContributionMonth', 'ContributionMonth';

-- ========================================
-- Payroll Tables
-- ========================================
EXEC sp_create_index_if_not_exists 'PayrollMaster', 'IX_PayrollMaster_Employee_Company', 'CompanyId,EmployeeId';
EXEC sp_create_index_if_not_exists 'PayrollMaster', 'IX_PayrollMaster_PayrollMonth', 'PayrollMonth';

EXEC sp_create_index_if_not_exists 'PayrollDetail', 'IX_PayrollDetail_Master_Company', 'CompanyId,PayrollMasterId';
EXEC sp_create_index_if_not_exists 'PayrollDetail', 'IX_PayrollDetail_Employee_Company', 'CompanyId,EmployeeId';


