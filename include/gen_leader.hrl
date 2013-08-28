%% Notification control of candidate membership changes. `all'
%% means that returns from the handle_DOWN/3 and elected/3 leader's events
%% will be broadcast to all candidates.
-type bcast_type() :: 'all' | 'sender'.

-type option() :: {'workers',    Workers::[node()]}
                | {'vardir',     Dir::string()}
                | {'bcast_type', Type::bcast_type()}
                | {'heartbeat',  Seconds::integer()}.

-type options() :: [option()].

-type status() :: 'elec1' | 'elec2' | 'wait' | 'joining' | 'worker' |
                  'waiting_worker' | 'norm'.

%% A locally registered name
-type name() :: atom().

%% A monitor ref
-type mon_ref() :: reference().

-type server_ref() :: name() | {name(),node()} | {global,name()} | pid().

%% Incarnation number
-type incarn() :: non_neg_integer().

%% Logical clock
-type lclock() :: non_neg_integer().

%% Node priority in the election
-type priority() :: integer().

%% Election id
-type elid() :: {priority(), incarn(), lclock()}.

%% See gen_server.
-type caller_ref() :: {pid(), reference()}.

%% Opaque state of the gen_leader behaviour.
-record(election, {
          leader = none             :: 'none' | pid(),
          previous_leader = none    :: 'none' | pid(),
          name                      :: name(),
          leadernode = none         :: node(),
          candidate_nodes = []      :: [node()],
          worker_nodes = []         :: [node()],
          down = []                 :: [node()],
          monitored = []            :: [{mon_ref(), node()}],
          buffered = []             :: [{reference(),caller_ref()}],
          seed_node = none          :: 'none' | node(),
          status                    :: status(),
          elid                      :: elid(),
          acks = []                 :: [node()],
          work_down = []            :: [node()],
          cand_timer_int            :: integer(),
          cand_timer                :: term(),
          pendack                   :: node(),
          incarn                    :: incarn(),
          nextel                    :: integer(),
          %% all | one. When `all' each election event
          %% will be broadcast to all candidate nodes.
          bcast_type                :: bcast_type()
         }).