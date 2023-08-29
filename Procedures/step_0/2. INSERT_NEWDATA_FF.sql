/****** Object:  StoredProcedure [dbo].[INSERT_NEWDATA_FF]    Script Date: 4/8/2021 10:17:52 AM ******/
--DROP PROCEDURE INSERT_NEWDATA_FF

CREATE PROCEDURE [dbo].[INSERT_NEWDATA_FF]
       
AS

BEGIN

    BEGIN TRY
    ----
        -- Francisco
        UPDATE FF_LOAD SET INFINAL=0
        UPDATE FF_LOAD SET INFINAL=(SELECT COUNT(*) FROM FF WHERE FF.LID_PID_SB_SE_DT_ST_CC=FF_LOAD.LID_PID_SB_SE_DT_ST_CC)

        UPDATE FF_LOAD SET STATEMENTENDDATE=(SELECT MAX(DateLong) FROM DATECONVERT D, FF_LOAD A WHERE D.DateDateLong=A.STATEMENTENDDATE) WHERE STATEMENTENDDATE<100000 AND STATEMENTENDDATE>10000
        UPDATE FF_LOAD SET STATEMENTBEGDATE=(SELECT MAX(DateLong) FROM DATECONVERT D, FF_LOAD A WHERE D.DateDateLong=A.STATEMENTBEGDATE) WHERE STATEMENTBEGDATE<100000 AND STATEMENTBEGDATE>10000


    INSERT INTO [dbo].[FF]
            ([LID_PID_SB_SE_DT_ST_CC]
            ,[LID_PID_SB_SE_DT_ST]
            ,[ExATransactionID]
            ,[ProspectusLoanID]
            ,[TransactionID]
            ,[LoanID]
            ,[PropertyID]
            ,[StatementBegDate]
            ,[StatementEndDate]
            ,[DataType]
            ,[StmtType]
            ,[CategoryCode]
            ,[Amount])
    SELECT [LID_PID_SB_SE_DT_ST_CC]
        ,[LID_PID_SB_SE_DT_ST]
        ,[ExATransactionID]
        ,[ProspectusLoanID]
        ,[TransactionID]
        ,[LoanID]
        ,[PropertyID]
        ,[StatementBegDate]
        ,[StatementEndDate]
        ,[DataType]
        ,[StmtType]
        ,[CategoryCode]
        ,[Amount]
    FROM [dbo].[FF_LOAD] WHERE INFINAL=0

    update ff set ProspectusLoanID=(select max(ProspectusLoanID) from lper x where x.loanid=ff.loanid) where ProspectusLoanID is null
    update ff set ProspectusLoanID=(select max(ProspectusLoanID) from property x where x.loanid=ff.loanid) where ProspectusLoanID is null

    
    DECLARE @TIMESTAMP DATETIME2(7),@TN NVARCHAR(20)
    SELECT @TIMESTAMP=CURRENT_TIMESTAMP,@TN='FF'
    INSERT INTO LOADLOG
    (ANALYST_RUNTIME_TN_EXA_NUMROWS,
    RUNTIME,
    TABLENAME,
    EXATRANSACTIONID,
    NUMROWS,
    ISLOAD)
    SELECT DISTINCT
    CONCAT(@TIMESTAMP,'_',@TN,'_',EXATRANSACTIONID,'_',(SELECT COUNT(*) FROM FF_LOAD X WHERE X.EXATRANSACTIONID=F.EXATRANSACTIONID AND X.INFINAL=0)),
    @TIMESTAMP,
    @TN,
    EXATRANSACTIONID,
    (SELECT COUNT(*) FROM FF_LOAD X WHERE X.EXATRANSACTIONID=F.EXATRANSACTIONID AND X.INFINAL=0),
    0
    FROM FF_LOAD F  WHERE INFINAL=0
    ------
    END TRY

BEGIN CATCH
    SELECT 
     ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage
END CATCH

END