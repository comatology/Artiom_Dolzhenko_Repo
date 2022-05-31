create or replace  PROCEDURE test_dubles 
IS
BEGIN
   FOR l_script IN (
      SELECT * FROM bl_cl.WRK_TABLES_FOR_TESTS
)
   LOOP
   begin
  EXECUTE IMMEDIATE l_script.dublicates_test;
  end;
   END LOOP;
   EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

END test_dubles; 
