-module(listsql).
-author("B. Angelo Molizane").
-version("1.0").
%-compile(export_all).
-export([test/0, test/3]).
-export([list/1]).
-import(string, [concat/2, to_float/1]).
-import(realnum, [is_realnumber/1]).

%test() ->
%    {ok, Ref} = odbc:connect("Driver=SQL Server Native Client 11.0;Server=<server>;Port=3306;Database=<database>;Trusted_Connection=yes", [])
%    ,
%    odbc:select_count(Ref, "SELECT * FROM <table> WHERE <conditions> ORDER BY <fields>")
%    ,
%    list(Ref)
%    .

test() ->
    test("<server>", "<database>", "SELECT * FROM <table> WHERE <conditions> ORDER BY <fields>")
    .

test(Server, Database, SQL) ->
    {ok, Ref} = odbc:connect("Driver=SQL Server Native Client 11.0;Server=" ++ Server ++ ";Port=3306;Database=" ++ Database ++ ";Trusted_Connection=yes", [])
    %%{ok, Ref} = odbc:connect(string:concat(string:concat(string:concat(string:concat("Driver=SQL Server Native Client 11.0;Server=", Server), ";Port=3306;Database="), Database), ";Trusted_Connection=yes"), [])
    ,
    odbc:select_count(Ref, SQL)
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
    %io:fwrite("~f", [X]);
    A = string:replace(io_lib:format("~f", [X]), ".", ",")
    ,
    io:fwrite("~s", [A]);
fielddata(null) ->
    io:fwrite("NULL");
fielddata(X) ->
    case is_realnumber(X) of
         true -> [B | _] = X
                 ,
                 if B == 46 -> {A, _} = string:to_float("0" ++ X); % "."
                       true -> {A, _} = string:to_float(X)
                 end
                 ,
                 C = string:replace(io_lib:format("~f", [A]), ".", ",")
                 ,
                 io:fwrite("~s", [C]);
        false -> io:fwrite("\"~s\"", [X])
    end
    .

eachfield([]) -> io:fwrite("\r\n");
eachfield(Row) ->
    [A | B] = Row
    ,
    fielddata(A)
    ,
    io:fwrite("\r\n")
    ,
    %if B =/= [] ->
    eachfield(B)
    %;
    %       true -> io:fwrite("\r\n")
    %end
    .

eachrow([], _) -> io:fwrite("\r\n");
eachrow(Row, Ref) ->
    [A | _] = Row
    ,
    eachfield(tuple_to_list(A))
    ,
    {selected, _, Rw} = odbc:next(Ref)
    ,
    %if Rw =/= [] ->
    eachrow(Rw, Ref)
    %;
    %        true -> io:fwrite("\r\n")
    %end
    .
