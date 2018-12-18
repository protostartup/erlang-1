
%***
%"C:\Program Files\erl10.1\bin\werl.exe" -s odbc start
%***
%OR
%"C:\Program Files\erl10.1\bin\werl.exe"

application:start(odbc).
***

application:which_applications().
 
odbc:module_info().

{ok, Ref} = odbc:connect("DSN=<dns>;UID=<user>;PWD=<pwd>", [{auto_commit, on}, {timeout, 5000}, {tuple_row, on}, {scrollable_cursors, on}]).
{ok, Ref} = odbc:connect("Driver=SQL Server Native Client 11.0;Server=<server>;Port=3306;Database=<database>;Uid=<user>;Pwd=<pwd>", []).
{ok, Ref} = odbc:connect("Driver=SQL Server Native Client 11.0;Server=<server>;Port=3306;Database=<database>;Trusted_Connection=yes", []).

odbc:sql_query(Ref, "SELECT ...").

odbc:select_count(Ref, "SELECT ...").

dbc:first(Ref).

odbc:next(Ref).

odbc:last(Ref).

odbc:prev(Ref).

{selected, Fields, Data} = odbc:next(Ref).

odbc:disconnect(Ref).

f(Ref, Fields, Data).

