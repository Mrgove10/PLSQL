BEGIN 
--clean jobs
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution)VALUES('test1','0','chemin/du/test/1.sql','31/12/20');
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution)VALUES('test2','0','chemin/du/test/2.sql','11/11/19');
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution)VALUES('test3','0','chemin/du/test/3.sql','09/09/19');
    package1.cleanjobs(SYSDATE); --fonctionne
END;

--executeJobs
declare
    type NumberVarray is varray(100) of NUMERIC(10);
    myArray NumberVarray;
BEGIN
    myArray := NumberVarray(1,2);
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution) VALUES('test1','0','chemin/du/test/1.sql','31/12/20');
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution) VALUES('test2','0','chemin/du/test/2.sql','11/11/19');
    INSERT INTO TJOB(nom,typejob,chemin,datederniereexecution) VALUES('test3','0','chemin/du/test/3.sql','09/09/19');
    package1.executeJobs(myArray); --ne fonctionne pas 
END;