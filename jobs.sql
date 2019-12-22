--fonctionne
END;
BEGIN 
--clean jobs
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution)VALUES('test1','0','chemin/du/test/1.sql','31/12/20');
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution)VALUES('test2','0','chemin/du/test/2.sql','11/11/19');
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution)VALUES('test3','0','chemin/du/test/3.sql','09/09/19');
    package1.cleanjobs(SYSDATE); 

--ne fonctionne pas 
DECLARE
    type NumberVarray is varray(100) of NUMERIC(10);
    myArray NumberVarray;
BEGIN
    myArray := NumberVarray(1,2);
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution) VALUES('test1','0','chemin/du/test/1.sql','31/12/20');
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution) VALUES('test2','0','chemin/du/test/2.sql','11/11/19');
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution) VALUES('test3','0','chemin/du/test/3.sql','09/09/19');
    package1.executeJobs(myArray); 
END;

--ne fonctionne pas 
DECLARE
    TYPE RJOB IS RECORD
    (
        nom VARCHAR2(50), 
        typeJob CHAR, 
        chemin varchar(100)
    );
    var_job RJOB;
    var_job2 RJOB;
    TYPE RJOB_ARRAY IS TABLE OF RJOB INDEX BY binary_integer; 
    elements RJOB_ARRAY;
BEGIN
    var_job.nom := 'test';
    var_job.typeJob := 0;
    var_job.chemin := 'test/chemin/vers/quelquechose.sql';
    
    var_job2.nom := 'testnumero2';
    var_job2.typeJob := 1;
    var_job2.chemin := 'testnumero2/chemin/vers/quelquechose2.sql';
    
    elements(1) := var_job;
    elements(2) := var_job2;
    
    PACKAGE1.createJobs(elements);
END;