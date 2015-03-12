-module(rpn_calc).
-export([work/1]).

work(L) when is_list(L) ->
    %% tokenize strings using spaces
    [Result] = lists:foldl(fun rpn/2, [], string:tokens(L, " ")),
    Result.

%% accumulate values in the stack
rpn(X, Stack) -> [read(X)|Stack].

