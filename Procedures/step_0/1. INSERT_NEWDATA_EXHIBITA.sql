-- ==========================
-- Description: Step 1. Marcar as linhas que já foram inseridas na tabela final
--              Step 2. Atualizar as referências de datas para variáveis do tipo de variaiveis de data
--              Step 3. Atualizar os valores de CURRENTNUMBEROFUNITSBEDSROOMS, PROPERTYTYPE e PROPERTYSUBTYPE
--              Step 4. Atualizar os valores de PHYSICALOCCUPANCYATCONTRIBUTION

-- Sources: EXHIBITA_LOAD, DATECONVERT
-- Target: EXHIBITA
-- ==========================

--DROP PROCEDURE INSERT_NEWDATA_EXHIBITA

CREATE PROCEDURE [dbo].[INSERT_NEWDATA_EXHIBITA]
       
AS

BEGIN

    BEGIN TRY
    ----
    --DELETE FROM EXHIBITA WHERE (SELECT COUNT(*) FROM EXHIBITA_LOAD X WHERE X.EXATRANSACTIONID=EXHIBITA.EXATRANSACTIONID)>0
        
        -- Francisco : Step 1
        -- Francisco : Marcar as linhas que já foram inseridas na tabela final
        -- Francisco : Sources - EXHIBITA_LOAD
            UPDATE EXHIBITA_LOAD SET INFINAL=0
            UPDATE EXHIBITA_LOAD SET INFINAL=(SELECT COUNT(*) FROM EXHIBITA WHERE EXHIBITA.EXA_PLID=EXHIBITA_LOAD.EXA_PLID)

        -- Francisco : Step 2
        -- Francisco : Atualizar as referências de datas para variáveis do tipo de variaiveis de data
        -- Francisco : Sources - DATECONVERT, EXHIBITA_LOAD
            UPDATE EXHIBITA_LOAD SET OCCUPANCYDATE=(SELECT MAX(DateLong) FROM DATECONVERT D, EXHIBITA_LOAD A WHERE D.DateDateLong=A.OCCUPANCYDATE AND A.EXA_PLID=EXHIBITA_LOAD.EXA_PLID) WHERE OCCUPANCYDATE<100000 AND OCCUPANCYDATE>10000
            UPDATE EXHIBITA_LOAD SET ORIGINATIONDATE=(SELECT MAX(DateLong) FROM DATECONVERT D, EXHIBITA_LOAD A WHERE D.DateDateLong=A.ORIGINATIONDATE AND A.EXA_PLID=EXHIBITA_LOAD.EXA_PLID) WHERE ORIGINATIONDATE<100000 AND ORIGINATIONDATE>10000
            UPDATE EXHIBITA_LOAD SET MATURITYDATE=(SELECT MAX(DateLong) FROM DATECONVERT D, EXHIBITA_LOAD A WHERE D.DateDateLong=A.MATURITYDATE AND A.EXA_PLID=EXHIBITA_LOAD.EXA_PLID) WHERE MATURITYDATE<100000 AND MATURITYDATE>10000
            UPDATE EXHIBITA_LOAD SET VALUATIONDATEATCONTRIBUTION=(SELECT MAX(DateLong) FROM DATECONVERT D, EXHIBITA_LOAD A WHERE D.DateDateLong=A.VALUATIONDATEATCONTRIBUTION AND A.EXA_PLID=EXHIBITA_LOAD.EXA_PLID) WHERE VALUATIONDATEATCONTRIBUTION<100000 AND VALUATIONDATEATCONTRIBUTION>10000
            UPDATE EXHIBITA_LOAD SET CONTRIBUTIONFINANCIALSASOFDATE=(SELECT MAX(DateLong) FROM DATECONVERT D, EXHIBITA_LOAD A WHERE D.DateDateLong=A.CONTRIBUTIONFINANCIALSASOFDATE AND A.EXA_PLID=EXHIBITA_LOAD.EXA_PLID) WHERE CONTRIBUTIONFINANCIALSASOFDATE<100000 AND CONTRIBUTIONFINANCIALSASOFDATE>10000
            UPDATE EXHIBITA_LOAD SET SECONDMOSTRECENTFINANCIALENDDATE=(SELECT MAX(DateLong) FROM DATECONVERT D, EXHIBITA_LOAD A WHERE D.DateDateLong=A.SECONDMOSTRECENTFINANCIALENDDATE AND A.EXA_PLID=EXHIBITA_LOAD.EXA_PLID) WHERE SECONDMOSTRECENTFINANCIALENDDATE<100000 AND SECONDMOSTRECENTFINANCIALENDDATE>10000
            UPDATE EXHIBITA_LOAD SET THIRDMOSTRECENTFINANCIALENDDATE=(SELECT MAX(DateLong) FROM DATECONVERT D, EXHIBITA_LOAD A WHERE D.DateDateLong=A.THIRDMOSTRECENTFINANCIALENDDATE AND A.EXA_PLID=EXHIBITA_LOAD.EXA_PLID) WHERE THIRDMOSTRECENTFINANCIALENDDATE<100000 AND THIRDMOSTRECENTFINANCIALENDDATE>10000
            UPDATE EXHIBITA_LOAD SET GROUNDLEASEMATURITYDATE=(SELECT MAX(DateLong) FROM DATECONVERT D, EXHIBITA_LOAD A WHERE D.DateDateLong=A.GROUNDLEASEMATURITYDATE AND A.EXA_PLID=EXHIBITA_LOAD.EXA_PLID) WHERE GROUNDLEASEMATURITYDATE<100000 AND GROUNDLEASEMATURITYDATE>10000
            UPDATE EXHIBITA_LOAD SET RATECAPEXPIRATIONDATE=(SELECT MAX(DateLong) FROM DATECONVERT D, EXHIBITA_LOAD A WHERE D.DateDateLong=A.RATECAPEXPIRATIONDATE AND A.EXA_PLID=EXHIBITA_LOAD.EXA_PLID) WHERE RATECAPEXPIRATIONDATE<100000 AND RATECAPEXPIRATIONDATE>10000

        -- Francisco : Step 3
        -- Francisco : Atualizar os valores de CURRENTNUMBEROFUNITSBEDSROOMS, PROPERTYTYPE e PROPERTYSUBTYPE

            update EXHIBITA_LOAD set CURRENTNUMBEROFUNITSBEDSROOMS=0 where CURRENTNUMBEROFUNITSBEDSROOMS<2 OR CURRENTNUMBEROFUNITSBEDSROOMS>10000
            UPDATE EXHIBITA_LOAD set propertytype='Multifamily', propertysubtype=propertytype where UPPER(left(propertytype,3))='AGE'

        -- Francisco : Step 4
        -- Francisco : Atualizar os valores de PHYSICALOCCUPANCYATCONTRIBUTION 
            UPDATE EXHIBITA_LOAD SET PHYSICALOCCUPANCYATCONTRIBUTION=.01*PHYSICALOCCUPANCYATCONTRIBUTION WHERE PHYSICALOCCUPANCYATCONTRIBUTION>1
            UPDATE EXHIBITA_LOAD SET PHYSICALOCCUPANCYATCONTRIBUTION=0 WHERE PHYSICALOCCUPANCYATCONTRIBUTION<0

    INSERT INTO [dbo].[EXHIBITA]
            ([EXA_PLID]
            ,[EXATRANSACTIONID]
            ,[PROSPECTUSLOANID]
            ,[NUMBEROFPROPERTIES]
            ,[PROPERTYNAME]
            ,[PROPERTYORIGINATOR]
            ,[PROPERTYADDRESS]
            ,[PROPERTYCITY]
            ,[PROPERTYSTATE]
            ,[PROPERTYZIPCODE]
            ,[PROPERTYCOUNTY]
            ,[PROPERTYTYPE]
            ,[PROPERTYSUBTYPE]
            ,[YEARBUILT]
            ,[YEARLASTRENOVATED]
            ,[CURRENTNUMBEROFUNITSBEDSROOMS]
            ,[UNITOFMEASURE]
            ,[LOWINCOMEUNITS]
            ,[VERYLOWINCOMEUNITS]
            ,[PHYSICALOCCUPANCYATCONTRIBUTION]
            ,[OCCUPANCYDATE]
            ,[LOANPURPOSE]
            ,[SPECIALPURPOSEENTITYYN]
            ,[ORIGINATIONDATE]
            ,[MATURITYDATE]
            ,[TOTALLOANAMOUNTATORIGINATION]
            ,[TOTALLOANAMOUNTATCONTRIBUTION]
            ,[PERCENTAGEOFPOOLATORIGINATION]
            ,[SCHEDULEDLOANBALANCEATMATURITY]
            ,[GROSSRATEATCONTRIBUTION]
            ,[LOANADMINFEE]
            ,[NETRATEATCONTRIBUTION]
            ,[LOANACCRUALTYPE]
            ,[LOANAMORTTYPE]
            ,[LOANAMORTTERM]
            ,[LOANORIGTERM]
            ,[LOANIOPER]
            ,[LOANSEAS]
            ,[LOANPREPAYPROVISION]
            ,[VALUATIONDATEATCONTRIBUTION]
            ,[VALUATIONAMOUNTATCONTRIBUTION]
            ,[CUTOFFDATELTV]
            ,[MATURITYLTV]
            ,[UWNCFDSCRAMORTIZING]
            ,[UWNCFDSCRIO]
            ,[UWREVENUE]
            ,[UWOPERATINGEXPENSES]
            ,[UWNOI]
            ,[UWNCF]
            ,[CONTRIBUTIONFINANCIALSASOFDATE]
            ,[REVENUEATCONTRIBUTION]
            ,[OPERATINGEXPENSESATCONTRIBUTION]
            ,[NOIATCONTRIBUTION]
            ,[NCFATCONTRIBUTION]
            ,[SECONDMOSTRECENTFINANCIALENDDATE]
            ,[SECONDMOSTRECENTEGI]
            ,[SECONDMOSTRECENTEXPENSES]
            ,[SECONDMOSTRECENTNOI]
            ,[SECONDMOSTRECENTNCF]
            ,[THIRDMOSTRECENTFINANCIALENDDATE]
            ,[THIRDMOSTRECENTEGI]
            ,[THIRDMOSTRECENTEXPENSES]
            ,[THIRDMOSTRECENTNOI]
            ,[THIRDMOSTRECENTNCF]
            ,[LIENPOSITION]
            ,[TITLEVESTINGFEELEASEHOLDBOTH]
            ,[GROUNDLEASEMATURITYDATE]
            ,[TYPEOFLOCKBOX]
            ,[ENGINEERINGESCROWDEFERREDMAINTENANCE]
            ,[TAXESCROWINITIAL]
            ,[TAXESCROWMONTHLY]
            ,[INSURANCEESCROWINITIAL]
            ,[INSURANCEESCROWMONTHLY]
            ,[REPLACEMENTRESERVEINITIAL]
            ,[REPLACEMENTRESERVEMONTHLY]
            ,[REPLACEMENTRESERVECONTRACTUALCAP]
            ,[TILCRESERVEINITIAL]
            ,[TILCRESERVEMONTHLY]
            ,[ENVIRONMENTALESCROW]
            ,[OTHERESCROWINITIAL]
            ,[OTHERESCROWMONTHLY]
            ,[OTHERESCROWRESERVEDESCRIPTION]
            ,[SPRINGINGRESERVETYPE]
            ,[SPRINGINGRESERVEAMOUNT]
            ,[SEISMICINSURANCEIFPMLGREATER20PCTYN]
            ,[UWRENTPERUNIT]
            ,[ELEVATORSYN]
            ,[SECONDARYFINANCINGINPLACEEXISTINGYN]
            ,[SECONDARYFINANCINGAMOUNTEXISTING]
            ,[SECONDARYFINANCINGDESCRIPTIONEXISTING]
            ,[FUTURESUPPLEMENTALFINANCINGYN]
            ,[FUTURESUPPLEMENTALFINANCINGDESCRIPTION]
            ,[FUTURESUPPLEMENTALFINANCINGDESCRIPTIONCONTINUED]
            ,[LOANRATEINDEX]
            ,[LOANRATEMARGIN]
            ,[RATECAPLIFETIME]
            ,[RATECAPYESORNO]
            ,[RATECAPEXPIRATIONDATE]
            ,[RATECAPSTRIKE]
            ,[MONTHLYDEBTSERVICEATCAP]
            ,[MONTHLYDEBTSERVICEAMORTIZING]
            ,[MONTHLYDEBTSERVICEIO])

    SELECT [EXA_PLID]
        ,[EXATRANSACTIONID]
        ,[PROSPECTUSLOANID]
        ,[NUMBEROFPROPERTIES]
        ,[PROPERTYNAME]
        ,[PROPERTYORIGINATOR]
        ,[PROPERTYADDRESS]
        ,[PROPERTYCITY]
        ,[PROPERTYSTATE]
        ,[PROPERTYZIPCODE]
        ,[PROPERTYCOUNTY]
        ,[PROPERTYTYPE]
        ,[PROPERTYSUBTYPE]
        ,[YEARBUILT]
        ,[YEARLASTRENOVATED]
        ,[CURRENTNUMBEROFUNITSBEDSROOMS]
        ,[UNITOFMEASURE]
        ,[LOWINCOMEUNITS]
        ,[VERYLOWINCOMEUNITS]
        ,[PHYSICALOCCUPANCYATCONTRIBUTION]
        ,[OCCUPANCYDATE]
        ,[LOANPURPOSE]
        ,[SPECIALPURPOSEENTITYYN]
        ,[ORIGINATIONDATE]
        ,[MATURITYDATE]
        ,[TOTALLOANAMOUNTATORIGINATION]
        ,[TOTALLOANAMOUNTATCONTRIBUTION]
        ,[PERCENTAGEOFPOOLATORIGINATION]
        ,[SCHEDULEDLOANBALANCEATMATURITY]
        ,[GROSSRATEATCONTRIBUTION]
        ,[LOANADMINFEE]
        ,[NETRATEATCONTRIBUTION]
        ,[LOANACCRUALTYPE]
        ,[LOANAMORTTYPE]
        ,[LOANAMORTTERM]
        ,[LOANORIGTERM]
        ,[LOANIOPER]
        ,[LOANSEAS]
        ,[LOANPREPAYPROVISION]
        ,[VALUATIONDATEATCONTRIBUTION]
        ,[VALUATIONAMOUNTATCONTRIBUTION]
        ,[CUTOFFDATELTV]
        ,[MATURITYLTV]
        ,[UWNCFDSCRAMORTIZING]
        ,[UWNCFDSCRIO]
        ,[UWREVENUE]
        ,[UWOPERATINGEXPENSES]
        ,[UWNOI]
        ,[UWNCF]
        ,[CONTRIBUTIONFINANCIALSASOFDATE]
        ,[REVENUEATCONTRIBUTION]
        ,[OPERATINGEXPENSESATCONTRIBUTION]
        ,[NOIATCONTRIBUTION]
        ,[NCFATCONTRIBUTION]
        ,[SECONDMOSTRECENTFINANCIALENDDATE]
        ,[SECONDMOSTRECENTEGI]
        ,[SECONDMOSTRECENTEXPENSES]
        ,[SECONDMOSTRECENTNOI]
        ,[SECONDMOSTRECENTNCF]
        ,[THIRDMOSTRECENTFINANCIALENDDATE]
        ,[THIRDMOSTRECENTEGI]
        ,[THIRDMOSTRECENTEXPENSES]
        ,[THIRDMOSTRECENTNOI]
        ,[THIRDMOSTRECENTNCF]
        ,[LIENPOSITION]
        ,[TITLEVESTINGFEELEASEHOLDBOTH]
        ,[GROUNDLEASEMATURITYDATE]
        ,[TYPEOFLOCKBOX]
        ,[ENGINEERINGESCROWDEFERREDMAINTENANCE]
        ,[TAXESCROWINITIAL]
        ,[TAXESCROWMONTHLY]
        ,[INSURANCEESCROWINITIAL]
        ,[INSURANCEESCROWMONTHLY]
        ,[REPLACEMENTRESERVEINITIAL]
        ,[REPLACEMENTRESERVEMONTHLY]
        ,[REPLACEMENTRESERVECONTRACTUALCAP]
        ,[TILCRESERVEINITIAL]
        ,[TILCRESERVEMONTHLY]
        ,[ENVIRONMENTALESCROW]
        ,[OTHERESCROWINITIAL]
        ,[OTHERESCROWMONTHLY]
        ,[OTHERESCROWRESERVEDESCRIPTION]
        ,[SPRINGINGRESERVETYPE]
        ,[SPRINGINGRESERVEAMOUNT]
        ,[SEISMICINSURANCEIFPMLGREATER20PCTYN]
        ,[UWRENTPERUNIT]
        ,[ELEVATORSYN]
        ,[SECONDARYFINANCINGINPLACEEXISTINGYN]
        ,[SECONDARYFINANCINGAMOUNTEXISTING]
        ,[SECONDARYFINANCINGDESCRIPTIONEXISTING]
        ,[FUTURESUPPLEMENTALFINANCINGYN]
        ,[FUTURESUPPLEMENTALFINANCINGDESCRIPTION]
        ,[FUTURESUPPLEMENTALFINANCINGDESCRIPTIONCONTINUED]
        ,[LOANRATEINDEX]
        ,[LOANRATEMARGIN]
        ,[RATECAPLIFETIME]
        ,[RATECAPYESORNO]
        ,[RATECAPEXPIRATIONDATE]
        ,[RATECAPSTRIKE]
        ,[MONTHLYDEBTSERVICEATCAP]
        ,[MONTHLYDEBTSERVICEAMORTIZING]
        ,[MONTHLYDEBTSERVICEIO]
    
    FROM [dbo].[EXHIBITA_LOAD] WHERE INFINAL=0

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
