
"C:\Program Files\erl10.1\bin\werl.exe" -s odbc start

%% "Data Source=SQL101;Initial Catalog=DB_WSCalculo;User ID=Broker;Password=IBIB1212;Persist Security Info=True;Packet Size=4096;Pooling=False;Application Name=RoboLote"

application:start(odbc).

application:which_applications().
[{odbc,"Erlang ODBC application","2.12.2"},
 {stdlib,"ERTS  CXC 138 10","3.6"},
 {kernel,"ERTS  CXC 138 10","6.1"}]
 
odbc:module_info().

{ok, Ref} = odbc:connect("DSN=DB_WSCalculo;UID=BAMOLIZA;PWD=bam$4bam", [{auto_commit, on}, {timeout, 5000}, {tuple_row, on}, {scrollable_cursors, on}]).

{ok, Ref} = odbc:connect("Driver=SQL Server Native Client 11.0;Server=SRV911;Port=3306;Database=DB_WSCalculo;Uid=BAMOLIZA;Pwd=bam$4bam", []).

{ok, Ref} = odbc:connect("Driver=SQL Server Native Client 11.0;Server=SRV911;Port=3306;Database=DB_WSCalculo;Trusted_Connection=yes", []).

odbc:sql_query(Ref, "SELECT * FROM estudos WHERE cd_produto = 3101 AND cd_versao = 20180901 AND ativo3101p3104 = 1 ORDER BY cd_estudo").

odbc:select_count(Ref, "SELECT * FROM estudos WHERE cd_produto = 3101 AND cd_versao = 20180901 AND ativo3101p3104 = 1 ORDER BY cd_estudo").

odbc:first(Ref).

odbc:next(Ref).

odbc:last(Ref).

odbc:prev(Ref).

{selected, Fields, Data} = odbc:next(Ref).

odbc:disconnect(Ref).
