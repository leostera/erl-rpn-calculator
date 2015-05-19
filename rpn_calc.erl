-module(rpn_calc).

-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

old_test() ->
    5 = rpn("5"),
    87 = rpn("90 3 -"),
    93 = rpn("90 3 +"),
    20 = rpn("10 2 *"),
    5.0 = rpn("10 2 /"),
    8.0 = rpn("2 3 ^"),
    true = math:sqrt(2) == rpn("2 0.5 ^"),
    true = math:log(2) == rpn("2 ln"),
    true = math:log10(2) == rpn("2 log10"),
    10 = rpn("5 3 2 sum"),
    30 = rpn("5 3 2 prod"),
    25.0 = rpn("5 3 2 prod 2 / 10 sum"),
    ok.

rpn(L) when is_list(L) ->
    %% tokenize strings using spaces
    [Result] = lists:foldl(fun rpn/2, [], string:tokens(L, " ")),
    Result.

%% operands!
rpn("-", [A,B|S]) -> [B-A|S];
rpn("+", [A,B|S]) -> [B+A|S];
rpn("*", [A,B|S]) -> [B*A|S];
rpn("/", [A,B|S]) -> [B/A|S];
rpn("^", [A,B|S]) -> [math:pow(B,A)|S];
rpn("ln", [A|S]) -> [math:log(A)|S];
rpn("log10", [A|S]) -> [math:log10(A)|S];
rpn("sum", S) -> [lists:foldl(fun(A,B) -> A+B end, 0, S)];
rpn("prod", S) -> [lists:foldl(fun(A,B) -> A*B end, 1, S)];

%% accumulate values in the stack
rpn(X, Stack) -> [read(X)|Stack].

%% convert
read(N) ->
    case string:to_float(N) of
        {error,no_float} -> list_to_integer(N);
        {F,_} -> F
    end.

% TESTS
%

add_test() ->
  ?assertEqual([4], rpn("sum", [2,2])).
