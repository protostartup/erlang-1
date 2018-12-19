-module(httpserver).
-export([start/0]).

start() ->
   inets:start(),
   Pid = inets:start(httpd, [{port, 9090}, {server_name,"httpd_test"},
   {server_root,"C://Angelo//http"},{document_root,"C://Angelo//http/htdocs"},
   {bind_address, "localhost"}]), io:fwrite("~p",[Pid]).
