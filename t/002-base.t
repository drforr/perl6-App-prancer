use v6;

use Test;
use Crust::Test;
use App::Prancer::StateMachine;

my regex Valid-Name { <[ A .. P ]> \d ** 2 };
my regex Valid-Code { \d ** 3 };

my regex Valid-Vertex { ^ [ <Valid-Name> | <Valid-Code> ] $ };

my $s = App::Prancer::StateMachine.new;

is $s.graph.keys.elems, 54,
   q{Correct number of vertices in the graph};

ok so True == ( map { ?/ <Valid-Vertex> / },
                    $s.graph.keys).all,
   q{Vertex labels have the correct name};

subtest sub {
  plan 4;

  ok so True == ( map { ?$_.<node> }, $s.graph.values).all,
     q{Vertices all have 'node' keys};
  ok so True == ( map { ?$_.<true> }, $s.graph.values).all,
     q{Vertices all have 'true' keys};
  ok so True == ( map { ?/ <Valid-Vertex> / },
                  map { $_.<true> }, $s.graph.values).all,
     q{'true' values have the correct format};
  ok so True == ( map { ?$s.graph.{$_} },
                  grep { ?$_ ~~ / ^ <Valid-Name> / },
                  map { $_.<true> }, $s.graph.values ).all,
     q{'true' edges that go to a decision are in the graph};
}, q{'true' edges};

subtest sub {
  plan 4;

  ok so True == ( map { ?$_.<node> }, $s.graph.values).all,
     q{Vertices all have 'node' keys};
  ok so True == ( map { ?$_.<false> }, $s.graph.values).all,
     q{Vertices all have 'false' keys};
  ok so True == ( map { ?/ <Valid-Vertex> / },
                  map { $_.<false> }, $s.graph.values).all,
     q{'false' values have the correct format};
  ok so True == ( map { ?$s.graph.{$_} },
                  grep { ?$_ ~~ / ^ <Valid-Name> / },
                  map { $_.<false> }, $s.graph.values ).all,
     q{'false' edges that go to a decision are in the graph};
}, q{'false' edges};

done-testing;
