-module(rpn_calc).
-export([
         rpn/1,
         test/0
        ]).

test() ->
    5 = rpn("5"),
    ok.

rpn(L) when is_list(L) ->
    %% tokenize strings using spaces
    [Result] = lists:foldl(fun rpn/2, [], string:tokens(L, " ")),
    Result.

%% accumulate values in the stack
rpn(X, Stack) -> [read(X)|Stack].

%% convert
read(N) ->
    case string:to_float(N) of
        {error,no_float} -> list_to_integer(N);
        {F,_} -> F
    end.
