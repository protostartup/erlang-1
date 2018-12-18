-module(listsql).
-export([test/0]).
-export([list/1]).

test() ->
    {ok, Ref} = odbc:connect("Driver=SQL Server Native Client 11.0;Server=<server>;Port=3306;Database=<database>;Trusted_Connection=yes", [])
    ,
    odbc:select_count(Ref, "SELECT * FROM <table> WHERE <cond1> AND <cond2> AND <cond3> ORDER BY <fields>")
    ,
    list(Ref)
    .

list(Ref) ->
    {selected, Fields, Row} = odbc:first(Ref)
    ,
    header(Fields)
    ,
    if Row =/= [] -> eachrow(Row, Ref);
             true -> io:fwrite("\r\n")
    end
    .

header(Fields) ->
    [A | B] = Fields
    ,
    io:fwrite(A)
    ,
    if B =/= [] -> io:fwrite("\t"), header(B);
           true -> io:fwrite("\r\n")
    end
    .

%valid_time({Date = {Y,M,D}, Time = {H,Min,S}}) ->
%    io:format("The Date tuple (~p) says today is: ~p/~p/~p,~n",[Date,Y,M,D]),
%    io:format("The time tuple (~p) indicates: ~p:~p:~p.~n", [Time,H,Min,S]);
%valid_time(_) ->
%    io:format("Stop feeding me wrong data!~n").
    
%fielddata({Date = {Year, Month, Day}, Time = {Hour, Minute, Seconds}}) ->
fielddata({{Year, Month, Day}, {0, 0, 0}}) ->
    io:fwrite("~2..0B/~2..0B/~4..0B", [Day, Month, Year]);
fielddata({{Year, Month, Day}, {Hour, Minute, Seconds}}) ->
    io:fwrite("~2..0B/~2..0B/~4..0B ~2..0B:~2..0B:~2..0B", [Day, Month, Year, Hour, Minute, Seconds]);
fielddata(X) when is_integer(X); is_boolean(X) ->
    io:fwrite("~w", [X]);
fielddata(X) when is_float(X) ->
    io:fwrite("~f", [X]);
fielddata(null) ->
    io:fwrite("NULL");
fielddata(X) ->
    io:fwrite("\"~s\"", [X])
    .

eachfield(Row) ->
    [A | B] = Row
    ,
    fielddata(A)
    ,
    if B =/= [] -> io:fwrite("\t"), eachfield(B);
           true -> io:fwrite("\r\n")
    end
    .

eachrow(Row, Ref) ->
    [A | _] = Row
    ,
    eachfield(tuple_to_list(A))
    ,
    {selected, _, Rw} = odbc:next(Ref)
    ,
    if Rw =/= [] -> eachrow(Rw, Ref);
            true -> io:fwrite("\r\n")
    end
    .
