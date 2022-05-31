create or replace procedure bl_cl.prc_truncate_table(table_name in varchar2)
AS
begin
Execute IMMEDIATE 'Truncate table '|| table_name;
end prc_truncate_table;

exec bl_cl.prc_truncate_table('CE_SALES');

