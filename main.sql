@@drops.sql
@@tables.sql
@@sequence.sql
@@triggers.sql
@@package.sql
@@inserts.sql
    
DECLARE
  TYPE RJOB IS RECORD
    (
        nom VARCHAR2(50), 
        typeJob CHAR, 
        chemin varchar(100)
    );    
    
    TYPE RJOB_ARRAY IS TABLE OF RJOB; 
    elements RJOB_ARRAY;
    -- ajout des elements dans ton tableau
BEGIN
  PACKAGE1.createJobs(RJOB_ARRAY);
END;