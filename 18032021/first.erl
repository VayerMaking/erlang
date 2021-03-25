-module(first).
-export([get_state/0, loop/0]).

get_ok() -> 
	nok,
	alala,
	ok.

get_state() ->
	{{'ETH', 300},
	{'ADA', 1}}.

loop() ->
	loop().
