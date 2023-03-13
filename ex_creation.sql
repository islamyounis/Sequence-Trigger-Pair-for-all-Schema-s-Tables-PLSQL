SET SERVEROUTPUT ON

declare

cursor GET_PK
        is 
    SELECT  CC.COLUMN_NAME, C.TABLE_NAME
    FROM USER_CONSTRAINTS C
    INNER JOIN USER_CONS_COLUMNS CC ON CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
    INNER JOIN user_tab_cols utc on utc.COLUMN_NAME = CC.COLUMN_NAME
    WHERE CONSTRAINT_TYPE = 'P' AND DATA_TYPE = 'NUMBER'
    group by CC.COLUMN_NAME, C.TABLE_NAME;

 V_MAX_PK NUMBER(15); -- i put size number here 15, cuz it can be any table with pk like national pk which has 15 digits

begin

  for PK_REC in GET_PK 
  loop

    execute immediate  'SELECT  (max( '|| PK_REC.COLUMN_NAME ||' ))+1 FROM '|| PK_REC.TABLE_NAME INTO V_MAX_PK;  
      
     execute immediate  
     'CREATE SEQUENCE ' ||PK_REC.TABLE_NAME||'_SEQ 
     START WITH '|| V_MAX_PK ||' 
    MAXVALUE 999999999999999
    MINVALUE 1
    NOCYCLE
    CACHE 20
    NOORDER';
    
     execute immediate  
     'CREATE TRIGGER '|| PK_REC.TABLE_NAME ||'_TRG 
     BEFORE INSERT
    ON '|| PK_REC.TABLE_NAME ||' 
    REFERENCING NEW AS New OLD AS Old
    FOR EACH ROW
    begin
    :new.'||PK_REC.COLUMN_NAME||' := '||PK_REC.TABLE_NAME||'_SEQ.nextval;
    end;';
    
    --DBMS_OUTPUT.PUT_LINE(V_MAX_PK);

    end loop;
    
end;

show errors