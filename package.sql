-- PACKAGE definition
    CREATE
    OR
    REPLACE PACKAGE package1 AS
    -- declaration
    EJOB_EXCEPTION EXCEPTION;
    -- exception_type NUMBER;
-- RJob
    TYPE
        RJOB IS RECORD
        (
            nom VARCHAR2(50),
            typeJob CHAR,
            chemin varchar(100)
        );
    -- PROCEDURES
-- createJobs
-- table
    TYPE
        RJOB_ARRAY IS TABLE OF RJOB;
-- =================================================> AJOUTER DES ELEMENTS AU TABLEAU
    PROCEDURE createJobs(var_table_rjob IN RJOB_ARRAY);
-- executeJobs
    type NumberArray is table of number index by binary_integer;
-- =================================================> AJOUTER DES ELEMENTS AU TABLEAU
    PROCEDURE executeJobs(array_ids IN NumberArray);
-- cleanJobs
    PROCEDURE cleanJobs(beforeDate DATE);
END package1;
/

-- PACKAGE creation
    CREATE
    OR REPLACE PACKAGE BODY package1 AS
    -- definition
-- PROCEDURES
-- createJobs
    PROCEDURE createJobs(var_table_rjob RJOB_ARRAY) IS
        test_exp EXCEPTION;
    BEGIN
        FOR i IN var_table_rjob.first..var_table_rjob.last
            LOOP
                IF true THEN
                    RAISE test_exp;
                END IF;
                INSERT INTO TJOB(NOM,
                                 TYPEJOB,
                                 CHEMIN,
                                 DATEDERNIEREEXECUTION)
                VALUES (var_table_rjob(i).NOM,
                        var_table_rjob(i).TYPEJOB,
                        var_table_rjob(i).CHEMIN,
                        NULL);
            END LOOP;
    EXCEPTION
        -- exception handlers begin
--see where errors https://docs.oracle.com/cd/B10500_01/appdev.920/a96624/07_errs.htm
        WHEN test_exp THEN -- handles 'division by zero' error
            INSERT INTO TERRORS(ERROR, ERRORTIME)
            VALUES ('Test Exeption', SYSDATE);
            COMMIT;
        WHEN OTHERS THEN --handles errors
            INSERT INTO TERRORS(ERROR, ERRORTIME)
            VALUES ('Error in createjob', SYSDATE);
            COMMIT;

            INSERT INTO TJOB_EXEC_HISTO(JOB, EXECTIME)
            VALUES ('createJobs', SYSDATE);
    END;
-- executeJobs
    PROCEDURE executeJobs(array_ids NumberArray) AS
        elementjob RJOB;
    BEGIN
        FOR i IN array_ids.first..array_ids.last
            LOOP
                -- recuperer le job
                SELECT NOM,
                       TYPEJOB,
                       CHEMIN
                INTO elementjob
                FROM TJOB
                WHERE id_tjob = array_ids(i);
-- execute le job
                DBMS_SCHEDULER.CREATE_JOB(
                        job_name => elementjob.nom,
                        job_type => elementjob.typejob,
                        job_action => elementjob.chemin
                    );
                DBMS_SCHEDULER.run_job(elementjob.nom);
-- update date job
                UPDATE TJOB
                SET datederniereexecution = SYSDATE
                WHERE id_tjob = array_ids(i);
            END LOOP;
        INSERT INTO TJOB_EXEC_HISTO(JOB, EXECTIME)
        VALUES ('executeJobs', SYSDATE);
    END;
-- cleanJobs
    PROCEDURE cleanJobs(beforeDate DATE) AS
    BEGIN
        DELETE TJOB
        WHERE datederniereexecution < beforeDate;
        INSERT INTO TJOB_EXEC_HISTO(JOB, EXECTIME)
        VALUES ('cleanJobs', SYSDATE);
    END;
END package1;
/