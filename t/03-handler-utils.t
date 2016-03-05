use v6;
use Test;
use App::Prancer::Handler :testing;

plan 11;

diag q{add-route};
diag q{list-routes};
diag q{find-route};

diag q{Insert routes shortest-first};
subtest sub
	{
	plan 14;

	my $routes = {};

	is-deeply $routes, { },
		q{Null hypothesis};

	add-route( $routes, 1, '/' );

	is-deeply $routes,
		{ '/' =>
		  { '' => 1 } },
		q{Insert '/'};

	add-route( $routes, 2, '/', 'a' );

	is-deeply $routes,
		{ '/' =>
		  { ''  => 1,
		    'a' => { '' => 2 } } },
		q{Insert '/a'};

	add-route( $routes, 100, '/', Str );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { '' => 2 },
		    '#(Str)' => { '' => 100 } } },
		q{Insert '/*'};

	add-route( $routes, 1000, '/', Int );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { '' => 2 },
		    '#(Str)' => { '' => 100 },
		    '#(Int)' => { '' => 1000 } } },
		q{Insert '/1'};

	add-route( $routes, 4, '/', 'b' );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { '' => 2 },
		    '#(Str)' => { '' => 100 },
		    '#(Int)' => { '' => 1000 },
		    'b'      => { '' => 4 } } },
		q{Insert '/b'};

	add-route( $routes, 5, '/', 'c', '/' );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100 },
		    '#(Int)' => { ''  => 1000 },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { '' => 5 } } } },
		q{Insert '/c/'};

	add-route( $routes, 101, '/', Str, '/' );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100,
		                  '/' => { '' => 101 } },
		    '#(Int)' => { ''  => 1000 },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { '' => 5 } } } },
		q{Insert '/*/'};

	add-route( $routes, 1001, '/', Int, '/' );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100,
		                  '/' => { '' => 101 } },
		    '#(Int)' => { ''  => 1000,
		                  '/' => { '' => 1001 } },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { '' => 5 } } } },
		q{Insert '/1/'};

	add-route( $routes, 7, '/', 'd', '/', 'e' );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100,
		                  '/' => { '' => 101 } },
		    '#(Int)' => { ''  => 1000,
		                  '/' => { '' => 1001 } },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { ''  => 5 } },
		    'd'      => { '/' => { 'e' => { '' => 7 } } } } },
		q{Insert '/d/e'};

	add-route( $routes, 102, '/', Str, '/', 'f' );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100,
		                  '/' => { ''  => 101,
		                           'f' => { '' => 102 } } },
		    '#(Int)' => { ''  => 1000,
		                  '/' => { '' => 1001 } },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { ''  => 5 } },
		    'd'      => { '/' => { 'e' => { '' => 7 } } } } },
		q{Insert '/*/f'};

	add-route( $routes, 1002, '/', Int, '/', 'f' );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100,
		                  '/' => { ''  => 101,
		                           'f' => { '' => 102 } } },
		    '#(Int)' => { ''  => 1000,
		                  '/' => { ''  => 1001,
		                           'f' => { '' => 1002 } } },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { ''  => 5 } },
		    'd'      => { '/' => { 'e' => { '' => 7 } } } } },
		q{Insert '/*/f'};

	add-route( $routes, 103, '/', 'g', '/', Str );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100,
		                  '/' => { ''  => 101,
		                           'f' => { '' => 102 } } },
		    '#(Int)' => { ''  => 1000,
		                  '/' => { ''  => 1001,
		                           'f' => { '' => 1002 } } },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { ''       => 5 } },
		    'd'      => { '/' => { 'e'      => { '' => 7 } } },
		    'g'      => { '/' => { '#(Str)' => { '' => 103 } } } } },
		q{Insert '/g/*'};

	add-route( $routes, 104, '/', Str, '/', Str );

	is-deeply $routes,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100,
		                  '/' => { ''       => 101,
		                           'f'      => { '' => 102 },
		                           '#(Str)' => { '' => 104 } } },
		    '#(Int)' => { ''  => 1000,
		                  '/' => { ''  => 1001,
		                           'f' => { '' => 1002 } } },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { ''       => 5 } },
		    'd'      => { '/' => { 'e'      => { '' => 7 } } },
		    'g'      => { '/' => { '#(Str)' => { '' => 103 } } } } },
		q{Insert '/*/*'};

	}, q{Structure inserted forward};

diag q{Insert trie elements longest-first because of potential vivification};

subtest sub
	{
	plan 1;

	my $routes = {};

	add-route( $routes, 104,  '/', Str, '/', Str );
	add-route( $routes, 103,  '/', 'g', '/', Str );
	add-route( $routes, 1002, '/', Int, '/', 'f' );
	add-route( $routes, 102,  '/', Str, '/', 'f' );
	add-route( $routes, 7,    '/', 'd', '/', 'e' );
	add-route( $routes, 1001, '/', Int, '/' );
	add-route( $routes, 101,  '/', Str, '/' );
	add-route( $routes, 5,    '/', 'c', '/' );
	add-route( $routes, 4,    '/', 'b' );
	add-route( $routes, 1000, '/', Int );
	add-route( $routes, 100,  '/', Str );
	add-route( $routes, 2,    '/', 'a' );
	add-route( $routes, 1,    '/' );

	is-deeply $routes,
		{ '/' =>
		  { '' => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100,
		                  '/' => { ''       => 101,
		                           'f'      => { '' => 102 },
		                           '#(Str)' => { '' => 104 } } },
		    '#(Int)' => { ''  => 1000,
		                  '/' => { ''  => 1001,
		                           'f' => { '' => 1002 } } },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { ''       => 5 } },
		    'd'      => { '/' => { 'e'      => { '' => 7 } } },
		    'g'      => { '/' => { '#(Str)' => { '' => 103 } } } } },
		q{Insert '/*/*'};

	}, q{Structure inserted backward};

subtest sub
	{
	plan 1;

	my $routes = :{};

	add-route( $routes, 104,  '/', Str, '/', Str );
	add-route( $routes, 103,  '/', 'g', '/', Str );
	add-route( $routes, 1002, '/', Int, '/', 'f' );
	add-route( $routes, 102,  '/', Str, '/', 'f' );
	add-route( $routes, 7,    '/', 'd', '/', 'e' );
	add-route( $routes, 1001, '/', Int, '/' );
	add-route( $routes, 101,  '/', Str, '/' );
	add-route( $routes, 5,    '/', 'c', '/' );
	add-route( $routes, 4,    '/', 'b' );
	add-route( $routes, 1000, '/', Int );
	add-route( $routes, 100,  '/', Str );
	add-route( $routes, 2,    '/', 'a' );
	add-route( $routes, 1,    '/' );

	is-deeply [ list-routes( $routes ) ],
		[
		'/',
		'/#(Int)',
		'/#(Int)/',
		'/#(Int)/f',
		'/#(Str)',
		'/#(Str)/',
		'/#(Str)/#(Str)',
		'/#(Str)/f',
		'/a',
		'/b',
		'/c/',
		'/d/e',
		'/g/#(Str)',
		], q{List routes};

	}, q{List routes};

subtest sub
	{
	my $routes = {};
	nok find-route( $routes, '/' ),
		q{Can't find route '/' with no routes specified};
	nok find-route( $routes, '/', 'a' ),
		q{Can't find route '/a' with no routes specified};
	nok find-route( $routes, '/', 1 ),
		q{Can't find route '/1' with no routes specified};

	add-route( $routes, 1, '/' );
	diag q{Adding default route};

	is find-route( $routes, '/' ), 1,
		q{Can find default route};
	nok find-route( $routes, '/', 'a' ),
		q{Can't find route '/a' with default route};
	nok find-route( $routes, '/', 1 ),
		q{Can't find route '/1' with default route};

	}, q{Find default route};

subtest sub
	{
	my $routes = {};

	add-route( $routes, 1, '/' );
	diag q{Adding default route};

	add-route( $routes, 2, '/', Str );
	diag q{Adding '/*' route};

	is find-route( $routes, '/' ), 1,
		q{Can find default route};
	is find-route( $routes, '/', 'a' ), 2,
		q{Can find route '/a' with wildcard};
	is find-route( $routes, '/', 1 ), 2,
		q{Can find route '/1' with wildcard};

	add-route( $routes, 3, '/', Int );
	diag q{Adding '/#' route};

	is find-route( $routes, '/' ), 1,
		q{Can find default route};
	is find-route( $routes, '/', 'a' ), 2,
		q{Can find route '/a' with '/*' wildcard};
	is find-route( $routes, '/', 1 ), 3,
		q{Can find route '/1' with '/#' wildcard};

	add-route( $routes, 4, '/', 'a' );
	diag q{Adding '/a' route};

	is find-route( $routes, '/' ), 1,
		q{Can find default route};
	is find-route( $routes, '/', 'b' ), 2,
		q{Can find route '/b' with '/*' wildcard};
	is find-route( $routes, '/', 1 ), 3,
		q{Can find route '/1' with '/#' wildcard};
	is find-route( $routes, '/', 'a' ), 4,
		q{Can find route '/a' with '/a' route};

	}, q{Find /foo routes};

diag "MUST ADD /a/ TESTS AS WELL.";

subtest sub
	{
	my $routes = {};

	add-route( $routes, 1, '/', 'a' );
	add-route( $routes, 2, '/', Int );
	add-route( $routes, 3, '/', Str );

	nok find-route( $routes, '/', 'a', '/', 'b' ), q{Can't find /a/b};
	nok find-route( $routes, '/', 'a', '/', 1   ), q{Can't find /a/1};
	nok find-route( $routes, '/', 'a', '/', 'c' ), q{Can't find /a/c};
	nok find-route( $routes, '/', 1,   '/', 'b' ), q{Can't find /1/b};
	nok find-route( $routes, '/', 1,   '/', 1   ), q{Can't find /1/1};
	nok find-route( $routes, '/', 1,   '/', 'c' ), q{Can't find /1/c};
	nok find-route( $routes, '/', 'c', '/', 'b' ), q{Can't find /c/b};
	nok find-route( $routes, '/', 'c', '/', 1   ), q{Can't find /c/1};
	nok find-route( $routes, '/', 'c', '/', 'c' ), q{Can't find /c/c};
	}, q{/(all) vs. permutations of 2 terms};

subtest sub
	{
	my $routes = {};

	add-route( $routes, 1, '/', 'a', '/' );
	add-route( $routes, 2, '/', Int, '/' );
	add-route( $routes, 3, '/', Str, '/' );

	nok find-route( $routes, '/', 'a', '/', 'b' ), q{Can't find /a/b};
	nok find-route( $routes, '/', 'a', '/', 1   ), q{Can't find /a/1};
	nok find-route( $routes, '/', 'a', '/', 'c' ), q{Can't find /a/c};
	nok find-route( $routes, '/', 1,   '/', 'b' ), q{Can't find /1/b};
	nok find-route( $routes, '/', 1,   '/', 1   ), q{Can't find /1/1};
	nok find-route( $routes, '/', 1,   '/', 'c' ), q{Can't find /1/c};
	nok find-route( $routes, '/', 'c', '/', 'b' ), q{Can't find /c/b};
	nok find-route( $routes, '/', 'c', '/', 1   ), q{Can't find /c/1};
	nok find-route( $routes, '/', 'c', '/', 'c' ), q{Can't find /c/c};
	}, q{/(all)/ vs. permutations of 2 terms};

subtest sub
	{
	my $routes = {};

	add-route( $routes, 21, '/', Int, '/', 'b' );
	add-route( $routes, 22, '/', Int, '/', Int );
	add-route( $routes, 23, '/', Int, '/', Str );
	add-route( $routes, 31, '/', Str, '/', 'b' );
	add-route( $routes, 32, '/', Str, '/', Int );
	add-route( $routes, 33, '/', Str, '/', Str );

	is find-route( $routes, '/', 'a', '/', 'b' ), 31, q{Can find /a/b};
	is find-route( $routes, '/', 'a', '/', 1   ), 32, q{Can find /a/1};
	is find-route( $routes, '/', 'a', '/', 'c' ), 33, q{Can find /a/c};
	is find-route( $routes, '/', 1,   '/', 'b' ), 21, q{Can find /1/b};
	is find-route( $routes, '/', 1,   '/', 1   ), 22, q{Can find /1/1};
	is find-route( $routes, '/', 1,   '/', 'c' ), 23, q{Can find /1/c};
	is find-route( $routes, '/', 'c', '/', 'b' ), 31, q{Can find /c/b};
	is find-route( $routes, '/', 'c', '/', 1   ), 32, q{Can find /c/1};
	is find-route( $routes, '/', 'c', '/', 'c' ), 33, q{Can find /c/c};
	}, q{/#/(all) and /*/(all)};

subtest sub
	{
	my $routes = {};

	add-route( $routes, 11, '/', 'a', '/', 'b' );
	add-route( $routes, 12, '/', 'a', '/', Int );
	add-route( $routes, 13, '/', 'a', '/', Str );
	add-route( $routes, 31, '/', Str, '/', 'b' );
	add-route( $routes, 32, '/', Str, '/', Int );
	add-route( $routes, 33, '/', Str, '/', Str );

	is find-route( $routes, '/', 'a', '/', 'b' ), 11, q{Can find /a/b};
	is find-route( $routes, '/', 'a', '/', 1   ), 12, q{Can find /a/1};
	is find-route( $routes, '/', 'a', '/', 'c' ), 13, q{Can find /a/c};
	is find-route( $routes, '/', 1,   '/', 'b' ), 31, q{Can find /1/b};
	is find-route( $routes, '/', 1,   '/', 1   ), 32, q{Can find /1/1};
	is find-route( $routes, '/', 1,   '/', 'c' ), 33, q{Can find /1/c};
	is find-route( $routes, '/', 'c', '/', 'b' ), 31, q{Can find /c/b};
	is find-route( $routes, '/', 'c', '/', 1   ), 32, q{Can find /c/1};
	is find-route( $routes, '/', 'c', '/', 'c' ), 33, q{Can find /c/c};
	}, q{/a/(all) and /*/(all)};

subtest sub
	{
	my $routes = {};

	add-route( $routes, 11, '/', 'a', '/', 'b' );
	add-route( $routes, 12, '/', 'a', '/', Int );
	add-route( $routes, 13, '/', 'a', '/', Str );
	add-route( $routes, 21, '/', Int, '/', 'b' );
	add-route( $routes, 22, '/', Int, '/', Int );
	add-route( $routes, 23, '/', Int, '/', Str );

	is find-route( $routes, '/', 'a', '/', 'b' ), 11, q{Can find /a/b};
	is find-route( $routes, '/', 'a', '/', 1   ), 12, q{Can find /a/1};
	is find-route( $routes, '/', 'a', '/', 'c' ), 13, q{Can find /a/c};
	is find-route( $routes, '/', 1,   '/', 'b' ), 21, q{Can find /1/b};
	is find-route( $routes, '/', 1,   '/', 1   ), 22, q{Can find /1/1};
	is find-route( $routes, '/', 1,   '/', 'c' ), 23, q{Can find /1/c};
	nok find-route( $routes, '/', 'c', '/', 'b' ), q{Can't find /c/b};
	nok find-route( $routes, '/', 'c', '/', 1   ), q{Can't find /c/1};
	nok find-route( $routes, '/', 'c', '/', 'c' ), q{Can't find /c/c};
	}, q{/a/(all) and /#/(all)};

subtest sub
	{
	my $routes = {};

	add-route( $routes, 11, '/', 'a', '/', 'b' );
	add-route( $routes, 12, '/', 'a', '/', Int );
	add-route( $routes, 13, '/', 'a', '/', Str );
	add-route( $routes, 21, '/', Int, '/', 'b' );
	add-route( $routes, 22, '/', Int, '/', Int );
	add-route( $routes, 23, '/', Int, '/', Str );
	add-route( $routes, 31, '/', Str, '/', 'b' );
	add-route( $routes, 32, '/', Str, '/', Int );
	add-route( $routes, 33, '/', Str, '/', Str );

	is find-route( $routes, '/', 'a', '/', 'b' ), 11, q{Can find /a/b};
	is find-route( $routes, '/', 'a', '/', 1   ), 12, q{Can find /a/1};
	is find-route( $routes, '/', 'a', '/', 'c' ), 13, q{Can find /a/c};
	is find-route( $routes, '/', 1,   '/', 'b' ), 21, q{Can find /1/b};
	is find-route( $routes, '/', 1,   '/', 1   ), 22, q{Can find /1/1};
	is find-route( $routes, '/', 1,   '/', 'c' ), 23, q{Can find /1/j};
	is find-route( $routes, '/', 'c', '/', 'b' ), 31, q{Can find /c/b};
	is find-route( $routes, '/', 'c', '/', 1   ), 32, q{Can find /c/1};
	is find-route( $routes, '/', 'c', '/', 'c' ), 33, q{Can find /c/c};
	}, q{All permutations of 2 terms};

done-testing;
