-module(ring1).
-export([fac/1, loop/2, start/3]).


fac(0) -> 1;
fac(N) ->
     N*fac(N-1).

%% 1. Shell -> P5(P1) -> P4 -> P3 -> P2 -> P1 -> P0
%% 2. Propagetion of P1 info to Shell
%% spawn(ring,loop,[]).				

loop(0, Parent) ->  Parent ! {last_child, Parent};			  
loop(N, Parent) ->
    receive
       create_child -> 
     	    Child = spawn(ring1, loop,[N-1, self()]),
	    io:format("N: ~p , My Parent: ~p , My Pid: ~p, My Child: ~p: ~n",[N, Parent, self(), Child]),
            Child ! create_child;

      {last_child, LastChildPid} ->
            io:format("I am: ~p , Last Child Pid: ~p sent to Parent: ~p~n", [self(), LastChildPid, Parent]),
            Parent ! {last_child, LastChildPid};

      {calculate, G} ->
            M = G*5,
            io:format("I am: ~p , M: ~p~n", [self(), M]),
            Parent ! {calculate, M};  

       _Any -> _Any
    end,
    loop(N,Parent).
	      

start(NumberOfChilds, Parent, G) ->
    FirstChild = spawn(ring1, loop, [NumberOfChilds, Parent]),
    FirstChild ! create_child,
    receive
       {last_child, LastChildPid} ->
              LastChildPid ! {calculate, G}
    end. 

%%-[]=    
