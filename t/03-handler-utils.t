use v6;
use Test;
use App::Prancer::Handler :testing;
use App::Prancer::Routes;

plan 12;

diag q{add-route};
diag q{list-routes};
diag q{find-route};

diag q{Insert routes shortest-first};
subtest sub
	{
	plan 14;

	my $r = App::Prancer::Routes.new;

	is-deeply $r.routes.<GET>, { },
		q{Null hypothesis};

	$r.add( 'GET', 1, '/' );

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { '' => 1 } },
		q{Insert '/'};

	$r.add( 'GET', 2, '/', 'a' );

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''  => 1,
		    'a' => { '' => 2 } } },
		q{Insert '/a'};

	$r.add( 'GET', 100, '/', Str );

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { '' => 2 },
		    '#(Str)' => { '' => 100 } } },
		q{Insert '/*'};

	$r.add( 'GET', 1000, '/', Int );

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { '' => 2 },
		    '#(Str)' => { '' => 100 },
		    '#(Int)' => { '' => 1000 } } },
		q{Insert '/1'};

	$r.add( 'GET', 4, '/', 'b' );

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { '' => 2 },
		    '#(Str)' => { '' => 100 },
		    '#(Int)' => { '' => 1000 },
		    'b'      => { '' => 4 } } },
		q{Insert '/b'};

	$r.add( 'GET', 5, '/', 'c', '/' );

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100 },
		    '#(Int)' => { ''  => 1000 },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { '' => 5 } } } },
		q{Insert '/c/'};

	$r.add( 'GET', 101, '/', Str, '/' );

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100,
		                  '/' => { '' => 101 } },
		    '#(Int)' => { ''  => 1000 },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { '' => 5 } } } },
		q{Insert '/*/'};

	$r.add( 'GET', 1001, '/', Int, '/' );

	is-deeply $r.routes.<GET>,
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

	$r.add( 'GET', 7, '/', 'd', '/', 'e' );

	is-deeply $r.routes.<GET>,
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

	$r.add( 'GET', 102, '/', Str, '/', 'f' );

	is-deeply $r.routes.<GET>,
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

	$r.add( 'GET', 1002, '/', Int, '/', 'f' );

	is-deeply $r.routes.<GET>,
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

	$r.add( 'GET', 103, '/', 'g', '/', Str );

	is-deeply $r.routes.<GET>,
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

	$r.add( 'GET', 104, '/', Str, '/', Str );

	is-deeply $r.routes.<GET>,
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

	},
	q{Structure inserted forward};

diag q{Insert trie elements longest-first because of potential vivification};

subtest sub
	{
	plan 1;

	my $r = App::Prancer::Routes.new;

	$r.add( 'GET', 104,  '/', Str, '/', Str );
	$r.add( 'GET', 103,  '/', 'g', '/', Str );
	$r.add( 'GET', 1002, '/', Int, '/', 'f' );
	$r.add( 'GET', 102,  '/', Str, '/', 'f' );
	$r.add( 'GET', 7,    '/', 'd', '/', 'e' );
	$r.add( 'GET', 1001, '/', Int, '/' );
	$r.add( 'GET', 101,  '/', Str, '/' );
	$r.add( 'GET', 5,    '/', 'c', '/' );
	$r.add( 'GET', 4,    '/', 'b' );
	$r.add( 'GET', 1000, '/', Int );
	$r.add( 'GET', 100,  '/', Str );
	$r.add( 'GET', 2,    '/', 'a' );
	$r.add( 'GET', 1,    '/' );

	is-deeply $r.routes.<GET>,
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

	},
	q{Structure inserted backward};

subtest sub
	{
	plan 1;

	my $r = App::Prancer::Routes.new;

	$r.add( 'GET', 104,  '/', Str, '/', Str );
	$r.add( 'GET', 103,  '/', 'g', '/', Str );
	$r.add( 'GET', 1002, '/', Int, '/', 'f' );
	$r.add( 'GET', 102,  '/', Str, '/', 'f' );
	$r.add( 'GET', 7,    '/', 'd', '/', 'e' );
	$r.add( 'GET', 1001, '/', Int, '/' );
	$r.add( 'GET', 101,  '/', Str, '/' );
	$r.add( 'GET', 5,    '/', 'c', '/' );
	$r.add( 'GET', 4,    '/', 'b' );
	$r.add( 'GET', 1000, '/', Int );
	$r.add( 'GET', 100,  '/', Str );
	$r.add( 'GET', 2,    '/', 'a' );
	$r.add( 'GET', 1,    '/' );

	is-deeply [ $r.list( 'GET' ) ],
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

	},
	q{List routes};

subtest sub
	{
	my $r = App::Prancer::Routes.new;

	nok $r.find( 'GET', '/' ),
		q{Can't find route '/' with no routes specified};
	nok $r.find( 'GET', '/a' ),
		q{Can't find route '/a' with no routes specified};
	nok $r.find( 'GET', '/1' ),
		q{Can't find route '/1' with no routes specified};

	$r.add( 'GET', 1, '/' );
	diag q{Adding default route};

	is $r.find( 'GET', '/' ), 1, q{Can find default route};
	nok $r.find( 'GET', '/a' ), q{Can't find route '/a' with default route};
	nok $r.find( 'GET', '/1' ), q{Can't find route '/1' with default route};

	},
	q{Find default route};

subtest sub
	{
	my $r = App::Prancer::Routes.new;

	$r.add( 'GET', 1, '/' );
	diag q{Adding default route};

	$r.add( 'GET', 2, '/', Str );
	diag q{Adding '/*' route};

	is $r.find( 'GET', '/' ), 1, q{Can find default route};
	is $r.find( 'GET', '/a' ), 2, q{Can find route '/a' with wildcard};
	is $r.find( 'GET', '/1' ), 2, q{Can find route '/1' with wildcard};

	$r.add( 'GET', 3, '/', Int );
	diag q{Adding '/#' route};

	is $r.find( 'GET', '/' ), 1, q{Can find default route};
	is $r.find( 'GET', '/a' ), 2, q{Can find route '/a' with '/*' wildcard};
	is $r.find( 'GET', '/1' ), 3, q{Can find route '/1' with '/#' wildcard};

	$r.add( 'GET', 4, '/', 'a' );
	diag q{Adding '/a' route};

	is $r.find( 'GET', '/' ), 1, q{Can find default route};
	is $r.find( 'GET', '/b' ), 2, q{Can find route '/b' with '/*' wildcard};
	is $r.find( 'GET', '/1' ), 3, q{Can find route '/1' with '/#' wildcard};
	is $r.find( 'GET', '/a' ), 4, q{Can find route '/a' with '/a' route};

	},
	q{Find /foo routes};

diag "MUST ADD /a/ TESTS AS WELL.";

subtest sub
	{
	my $r = App::Prancer::Routes.new;

	$r.add( 'GET', 1, '/', 'a', '/' );
	$r.add( 'GET', 2, '/', Int, '/' );
	$r.add( 'GET', 3, '/', Str, '/' );

	is $r.find( 'GET', '/a/' ), 1, q{Can find /a/};
	is $r.find( 'GET', '/1/' ), 2, q{Can find /1/};
	is $r.find( 'GET', '/c/' ), 3, q{Can find /c/};

	nok $r.find( 'GET', '/a/b' ), q{Can't find /a/b};
	nok $r.find( 'GET', '/a/1' ), q{Can't find /a/1};
	nok $r.find( 'GET', '/a/c' ), q{Can't find /a/c};
	nok $r.find( 'GET', '/1/b' ), q{Can't find /1/b};
	nok $r.find( 'GET', '/1/1' ), q{Can't find /1/1};
	nok $r.find( 'GET', '/1/c' ), q{Can't find /1/c};
	nok $r.find( 'GET', '/c/b' ), q{Can't find /c/b};
	nok $r.find( 'GET', '/c/1' ), q{Can't find /c/1};
	nok $r.find( 'GET', '/c/c' ), q{Can't find /c/c};
	},
	q{/(all)/ vs. permutations of 2 terms};

subtest sub
	{
	my $r = App::Prancer::Routes.new;

	$r.add( 'GET', 1, '/', 'a' );
	$r.add( 'GET', 2, '/', Int );
	$r.add( 'GET', 3, '/', Str );

	nok $r.find( 'GET', '/a/b' ), q{Can't find /a/b};
	nok $r.find( 'GET', '/a/1' ), q{Can't find /a/1};
	nok $r.find( 'GET', '/a/c' ), q{Can't find /a/c};
	nok $r.find( 'GET', '/1/b' ), q{Can't find /1/b};
	nok $r.find( 'GET', '/1/1' ), q{Can't find /1/1};
	nok $r.find( 'GET', '/1/c' ), q{Can't find /1/c};
	nok $r.find( 'GET', '/c/b' ), q{Can't find /c/b};
	nok $r.find( 'GET', '/c/1' ), q{Can't find /c/1};
	nok $r.find( 'GET', '/c/c' ), q{Can't find /c/c};
	},
	q{/(all) vs. permutations of 2 terms};

subtest sub
	{
	my $r = App::Prancer::Routes.new;

	$r.add( 'GET', 1, '/', 'a', '/' );
	$r.add( 'GET', 2, '/', Int, '/' );
	$r.add( 'GET', 3, '/', Str, '/' );

	nok $r.find( 'GET', '/a/b' ), q{Can't find /a/b};
	nok $r.find( 'GET', '/a/1' ), q{Can't find /a/1};
	nok $r.find( 'GET', '/a/c' ), q{Can't find /a/c};
	nok $r.find( 'GET', '/1/b' ), q{Can't find /1/b};
	nok $r.find( 'GET', '/1/1' ), q{Can't find /1/1};
	nok $r.find( 'GET', '/1/c' ), q{Can't find /1/c};
	nok $r.find( 'GET', '/c/b' ), q{Can't find /c/b};
	nok $r.find( 'GET', '/c/1' ), q{Can't find /c/1};
	nok $r.find( 'GET', '/c/c' ), q{Can't find /c/c};
	},
	q{/(all)/ vs. permutations of 2 terms};

subtest sub
	{
	my $r = App::Prancer::Routes.new;

	$r.add( 'GET', 21, '/', Int, '/', 'b' );
	$r.add( 'GET', 22, '/', Int, '/', Int );
	$r.add( 'GET', 23, '/', Int, '/', Str );
	$r.add( 'GET', 31, '/', Str, '/', 'b' );
	$r.add( 'GET', 32, '/', Str, '/', Int );
	$r.add( 'GET', 33, '/', Str, '/', Str );

	is $r.find( 'GET', '/a/b' ), 31, q{Can find /a/b};
	is $r.find( 'GET', '/a/1' ), 32, q{Can find /a/1};
	is $r.find( 'GET', '/a/c' ), 33, q{Can find /a/c};
	is $r.find( 'GET', '/1/b' ), 21, q{Can find /1/b};
	is $r.find( 'GET', '/1/1' ), 22, q{Can find /1/1};
	is $r.find( 'GET', '/1/c' ), 23, q{Can find /1/c};
	is $r.find( 'GET', '/c/b' ), 31, q{Can find /c/b};
	is $r.find( 'GET', '/c/1' ), 32, q{Can find /c/1};
	is $r.find( 'GET', '/c/c' ), 33, q{Can find /c/c};
	},
	q{/#/(all) and /*/(all)};

subtest sub
	{
	my $r = App::Prancer::Routes.new;

	$r.add( 'GET', 11, '/', 'a', '/', 'b' );
	$r.add( 'GET', 12, '/', 'a', '/', Int );
	$r.add( 'GET', 13, '/', 'a', '/', Str );
	$r.add( 'GET', 31, '/', Str, '/', 'b' );
	$r.add( 'GET', 32, '/', Str, '/', Int );
	$r.add( 'GET', 33, '/', Str, '/', Str );

	is $r.find( 'GET', '/a/b' ), 11, q{Can find /a/b};
	is $r.find( 'GET', '/a/1' ), 12, q{Can find /a/1};
	is $r.find( 'GET', '/a/c' ), 13, q{Can find /a/c};
	is $r.find( 'GET', '/1/b' ), 31, q{Can find /1/b};
	is $r.find( 'GET', '/1/1' ), 32, q{Can find /1/1};
	is $r.find( 'GET', '/1/c' ), 33, q{Can find /1/c};
	is $r.find( 'GET', '/c/b' ), 31, q{Can find /c/b};
	is $r.find( 'GET', '/c/1' ), 32, q{Can find /c/1};
	is $r.find( 'GET', '/c/c' ), 33, q{Can find /c/c};
	},
	q{/a/(all) and /*/(all)};

subtest sub
	{
	my $r = App::Prancer::Routes.new;

	$r.add( 'GET', 11, '/', 'a', '/', 'b' );
	$r.add( 'GET', 12, '/', 'a', '/', Int );
	$r.add( 'GET', 13, '/', 'a', '/', Str );
	$r.add( 'GET', 21, '/', Int, '/', 'b' );
	$r.add( 'GET', 22, '/', Int, '/', Int );
	$r.add( 'GET', 23, '/', Int, '/', Str );

	is $r.find( 'GET', '/a/b' ), 11, q{Can find /a/b};
	is $r.find( 'GET', '/a/1' ), 12, q{Can find /a/1};
	is $r.find( 'GET', '/a/c' ), 13, q{Can find /a/c};
	is $r.find( 'GET', '/1/b' ), 21, q{Can find /1/b};
	is $r.find( 'GET', '/1/1' ), 22, q{Can find /1/1};
	is $r.find( 'GET', '/1/c' ), 23, q{Can find /1/c};
	nok $r.find( 'GET', '/c/b' ), q{Can't find /c/b};
	nok $r.find( 'GET', '/c/1' ), q{Can't find /c/1};
	nok $r.find( 'GET', '/c/c' ), q{Can't find /c/c};
	},
	q{/a/(all) and /#/(all)};

subtest sub
	{
	my $r = App::Prancer::Routes.new;

	$r.add( 'GET', 11, '/', 'a', '/', 'b' );
	$r.add( 'GET', 12, '/', 'a', '/', Int );
	$r.add( 'GET', 13, '/', 'a', '/', Str );
	$r.add( 'GET', 21, '/', Int, '/', 'b' );
	$r.add( 'GET', 22, '/', Int, '/', Int );
	$r.add( 'GET', 23, '/', Int, '/', Str );
	$r.add( 'GET', 31, '/', Str, '/', 'b' );
	$r.add( 'GET', 32, '/', Str, '/', Int );
	$r.add( 'GET', 33, '/', Str, '/', Str );

	is $r.find( 'GET', '/a/b' ), 11, q{Can find /a/b};
	is $r.find( 'GET', '/a/1' ), 12, q{Can find /a/1};
	is $r.find( 'GET', '/a/c' ), 13, q{Can find /a/c};
	is $r.find( 'GET', '/1/b' ), 21, q{Can find /1/b};
	is $r.find( 'GET', '/1/1' ), 22, q{Can find /1/1};
	is $r.find( 'GET', '/1/c' ), 23, q{Can find /1/j};
	is $r.find( 'GET', '/c/b' ), 31, q{Can find /c/b};
	is $r.find( 'GET', '/c/1' ), 32, q{Can find /c/1};
	is $r.find( 'GET', '/c/c' ), 33, q{Can find /c/c};
	},
	q{All permutations of 2 terms};

done-testing;
