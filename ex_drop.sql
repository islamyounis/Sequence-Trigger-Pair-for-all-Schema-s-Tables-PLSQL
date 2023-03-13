declare 

CURSOR DROP_SEQ
IS
SELECT SEQUENCE_NAME from user_sequences;

CURSOR DROP_TRG
IS
SELECT TRIGGER_NAME from user_triggers;

begin

    for squ_rec in DROP_SEQ 
    loop
        execute immediate 'DROP SEQUENCE  '|| squ_rec.SEQUENCE_NAME;
    end loop;

    for trg_rec in DROP_TRG
    loop
        execute immediate 'DROP TRIGGER '|| trg_rec.TRIGGER_NAME ;
    end loop;

end;
