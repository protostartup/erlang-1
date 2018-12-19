-module(realnum).
-author("B. Angelo Molizane").
-version("1.0").
%-compile(export_all).
-export([is_realnumber/1]).

is_realnumber_(N) -> is_realnumber_(N, true, false).
is_realnumber_([], _, Dp) -> Dp;
is_realnumber_(N, Pr, Dp) -> [A | B] = N
                             ,
                             Dp2 = if Dp -> Dp; 
                                    true -> (A == 46)
                                   end
                             ,
                             (
                               ((A >= 48) and (A =< 57)) 
                               or 
                               ((Dp == false ) and (A == 46)) %% "."
                               or 
                               ((Pr == true ) and ((A == 45) or (A == 43))) %% "- +"
                             ) 
                             and 
                             is_realnumber_(B, false, Dp or Dp2).

is_realnumber(N) when N == [] -> false;
is_realnumber(N) -> is_realnumber_(N).
