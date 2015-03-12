-module(rpn_calc).
-export([
         rpn/1,
         test/0
        ]).

test() ->
    5 = rpn("5"),
    87 = rpn("90 3 -"),
    93 = rpn("90 3 +"),
    20 = rpn("10 2 *"),
    5.0 = rpn("10 2 /"),
    8.0 = rpn("2 3 ^"),
    true = math:sqrt(2) == rpn("2 0.5 ^"),
    true = math:log(2) == rpn("2 ln"),
    true = math:log10(2) == rpn("2 log10"),
    ok.

rpn(L) when is_list(L) ->
    %% tokenize strings using spaces
    [Result] = lists:foldl(fun rpn/2, [], string:tokens(L, " ")),
    Result.

rpn("-", [A,B|S]) -> [B-A|S];
rpn("+", [A,B|S]) -> [B+A|S];
rpn("*", [A,B|S]) -> [B*A|S];
rpn("/", [A,B|S]) -> [B/A|S];
rpn("^", [A,B|S]) -> [math:pow(B,A)|S];
rpn("ln", [A|S]) -> [math:log(A)|S];
rpn("log10", [A|S]) -> [math:log10(A)|S];
%% accumulate values in the stack
rpn(X, Stack) -> [read(X)|Stack].

%% convert
read(N) ->
    case string:to_float(N) of
        {error,no_float} -> list_to_integer(N);
        {F,_} -> F
    end.
