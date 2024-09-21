-module(dev_dedup).
-export([init/2, execute/2, uses/0]).

%%% A device that deduplicates messages to a process.
%%% Only runs on the first pass.

init([<<"Variant">>, <<"1.0">>], State) ->
    {ok, State#{ dedup := [] }}.

execute(Message, State#{ pass := 1, dedup := Dedup }) ->
    case member(ID = ao_message:id(Message), Dedup) of
        true ->
            {break, State};
        false ->
            {ok, State#{ dedup := [ID | Dedup] }}
    end;
execute(Message, State) ->
    {ok, State}.

member(_ID, []) ->
    false;
member(ID, [ID | _]) ->
    true;
member(ID, [_ | Rest]) ->
    member(ID, Rest).

uses() -> all.