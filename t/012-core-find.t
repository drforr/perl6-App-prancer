use v6;
use Test;
use App::Prancer::Core;

plan 1;

subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	nok $r.find( 'GET', '/' ), q{'/'};

	nok $r.find( 'GET', '/a' ), q{Search for '/a'};
	nok $r.find( 'GET', '/1' ), q{Search for '/1'};

	nok $r.find( 'GET', '/a/' ), q{Search for '/a/'};
	nok $r.find( 'GET', '/1/' ), q{Search for '/1/'};

	nok $r.find( 'GET', '/a/a' ), q{Search for '/a/a'};
	nok $r.find( 'GET', '/a/1' ), q{Search for '/a/1'};
	},
	q{No routes};

subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, '/' );
	is $r.find( 'GET', '/' ), 1, q{Default route finds '/'};

	nok $r.find( 'GET', '/a' ), q{Search for '/a'};
	nok $r.find( 'GET', '/1' ), q{Search for '/1'};

	nok $r.find( 'GET', '/a/' ), q{Search for '/a/'};
	nok $r.find( 'GET', '/1/' ), q{Search for '/1/'};

	nok $r.find( 'GET', '/a/a' ), q{Search for '/a/a'};
	nok $r.find( 'GET', '/a/1' ), q{Search for '/a/1'};
	},
	q{Default route};

subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, '/a' );
	nok $r.find( 'GET', '/' ), q{Search for '/'};

	is $r.find( 'GET', '/a' ), 1, q{Search for '/a'};
	nok $r.find( 'GET', '/1' ), q{Search for '/1'};

	nok $r.find( 'GET', '/a/' ), q{Search for '/a/'};
	nok $r.find( 'GET', '/1/' ), q{Search for '/1/'};

	nok $r.find( 'GET', '/a/a' ), q{Search for '/a/a'};
	nok $r.find( 'GET', '/a/1' ), q{Search for '/a/1'};
	},
	q{Route '/a'};

subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, '/1' );
	nok $r.find( 'GET', '/' ), q{Search for '/'};

	nok $r.find( 'GET', '/a' ), q{Search for '/a'};
	is $r.find( 'GET', '/1' ), 1, q{Search for '/1'};

	nok $r.find( 'GET', '/a/' ), q{Search for '/a/'};
	nok $r.find( 'GET', '/1/' ), q{Search for '/1/'};

	nok $r.find( 'GET', '/a/a' ), q{Search for '/a/a'};
	nok $r.find( 'GET', '/a/1' ), q{Search for '/a/1'};
	},
	q{Route '/1'};

subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, Int );
	nok $r.find( 'GET', '/' ), q{Search for '/'};

	nok $r.find( 'GET', '/a' ), q{Search for '/a'};
	is $r.find( 'GET', '/1' ), 1, q{Search for '/1'};

	nok $r.find( 'GET', '/a/' ), q{Search for '/a/'};
	nok $r.find( 'GET', '/1/' ), q{Search for '/1/'};

	nok $r.find( 'GET', '/a/a' ), q{Search for '/a/a'};
	nok $r.find( 'GET', '/a/1' ), q{Search for '/a/1'};
	},
	q{Route '/#(Int)'};

subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, Str );
	nok $r.find( 'GET', '/' ), q{Search for '/'};

	is $r.find( 'GET', '/a' ), 1, q{Search for '/a'};
	is $r.find( 'GET', '/1' ), 1, q{Search for '/1'};

	nok $r.find( 'GET', '/a/' ), q{Search for '/a/'};
	nok $r.find( 'GET', '/1/' ), q{Search for '/1/'};

	nok $r.find( 'GET', '/a/a' ), q{Search for '/a/a'};
	nok $r.find( 'GET', '/a/1' ), q{Search for '/a/1'};
	},
	q{Route '/#(Str)'};

subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, Array );
	nok $r.find( 'GET', '/' ), q{Search for '/'};

	is $r.find( 'GET', '/a' ), 1, q{Search for '/a'};
	is $r.find( 'GET', '/1' ), 1, q{Search for '/1'};

	nok $r.find( 'GET', '/a/' ), q{Search for '/a/'};
	nok $r.find( 'GET', '/1/' ), q{Search for '/1/'};

	is $r.find( 'GET', '/a/a' ), 1, q{Search for '/a/a'};
	is $r.find( 'GET', '/a/1' ), 1, q{Search for '/a/1'};
	},
	q{Route '/#(Array)'};

#`(
subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, Array, '/' );
	nok $r.find( 'GET', '/' ), q{Search for '/'};

	nok $r.find( 'GET', '/a' ), q{Search for '/a'};
	nok $r.find( 'GET', '/1' ), q{Search for '/1'};

	is $r.find( 'GET', '/a/' ), 1, q{Search for '/a/'};
	is $r.find( 'GET', '/1/' ), 1, q{Search for '/1/'};

	nok $r.find( 'GET', '/a/a' ), q{Search for '/a/a'};
	nok $r.find( 'GET', '/a/1' ), q{Search for '/a/1'};
	},
	q{Route '/#(Array)'};
)

##`(
#plan 20;
#
#subtest sub
#	{
#	plan 29;
#
#	is-deeply $r.routes.<GET>, { },
#		q{Null hypothesis};
#
#	ok $r.add( 'GET', 1, '/' ), q{Add '/'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { '' => 1 } },
#		q{Inserted '/'};
#
#	ok $r.add( 'GET', 2, '/', 'a' ), q{Add '/a'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''  => 1,
#		    'a' => { '' => 2 } } },
#		q{Inserted '/a'};
#
#	ok $r.add( 'GET', 100, '/', Str ), q{Add '/#(Str)'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''       => 1,
#		    'a'      => { '' => 2 },
#		    '#(Str)' => { '' => 100 } } },
#		q{Inserted '/#(Str)'};
#
#	ok $r.add( 'GET', 1000, '/', Int ), q{Add '/#(Int)'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''       => 1,
#		    'a'      => { '' => 2 },
#		    '#(Str)' => { '' => 100 },
#		    '#(Int)' => { '' => 1000 } } },
#		q{Inserted '/1'};
#
#	ok $r.add( 'GET', 10000, '/', Array ), q{Add '/#(Array)'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { '' => 2 },
#		    '#(Str)'   => { '' => 100 },
#		    '#(Int)'   => { '' => 1000 },
#		    '#(Array)' => { '' => 10000 } } },
#		q{Inserted '/*'};
#
#	ok $r.add( 'GET', 4, '/', 'b' ), q{Add '/b'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { '' => 2 },
#		    '#(Str)'   => { '' => 100 },
#		    '#(Int)'   => { '' => 1000 },
#		    '#(Array)' => { '' => 10000 },
#		    'b'        => { '' => 4 } } },
#		q{Inserted '/b'};
#
#	ok $r.add( 'GET', 5, '/', 'c', '/' ), q{Add '/c/'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { ''  => 2 },
#		    '#(Str)'   => { ''  => 100 },
#		    '#(Int)'   => { ''  => 1000 },
#		    '#(Array)' => { ''  => 10000 },
#		    'b'        => { ''  => 4 },
#		    'c'        => { '/' => { '' => 5 } } } },
#		q{Inserted '/c/'};
#
#	ok $r.add( 'GET', 101, '/', Str, '/' ), q{Add '/#(Str)/'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { ''  => 2 },
#		    '#(Str)'   => { ''  => 100,
#		                    '/' => { '' => 101 } },
#		    '#(Int)'   => { ''  => 1000 },
#		    '#(Array)' => { ''  => 10000 },
#		    'b'        => { ''  => 4 },
#		    'c'        => { '/' => { '' => 5 } } } },
#		q{Inserted  '/*/'};
#                           
#	ok $r.add( 'GET',  1001, '/', Int, '/' ), q{Add '/#(Int)/'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { ''  => 2 },
#		    '#(Str)'   => { ''  => 100,
#		                    '/' => { '' => 101 } },
#		    '#(Int)'   => { ''  => 1000,
#		                    '/' => { '' => 1001 } },
#		    '#(Array)' => { ''  => 10000 },
#		    'b'        => { ''  => 4 },
#		    'c'        => { '/' => { '' => 5 } } } },
#		q{Inserted '/1/'};
#
#	ok $r.add( 'GET', 7, '/', 'd', '/', 'e' ), q{Add '/d/e'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { ''  => 2 },
#		    '#(Str)'   => { ''  => 100,
#		                    '/' => { '' => 101 } },
#		    '#(Int)'   => { ''  => 1000,
#  		                    '/' => { '' => 1001 } },
#		    '#(Array)' => { ''  => 10000 },
#		    'b'        => { ''  => 4 },
#		    'c'        => { '/' => { ''  => 5 } },
#		    'd'        => { '/' => { 'e' => { '' => 7 } } } } },
#		q{Inserted '/d/e'};
#
#	ok $r.add( 'GET', 102, '/', Str, '/', 'f' ), q{Add '/#(Str)/f'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { ''  => 2 },
#		    '#(Str)'   => { ''  => 100,
#		                    '/' => { ''  => 101,
#		                             'f' => { '' => 102 } } },
#		    '#(Int)'   => { ''  => 1000,
#		                    '/' => { '' => 1001 } },
#		    '#(Array)' => { ''  => 10000 },
#		    'b'        => { ''  => 4 },
#		    'c'        => { '/' => { ''  => 5 } },
#		    'd'        => { '/' => { 'e' => { '' => 7 } } } } },
#		q{Inserted '/*/f'};
#
#	ok $r.add( 'GET', 1002, '/', Int, '/', 'f' ), q{Add '/#(Int)/f'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { ''  => 2 },
#		    '#(Str)'   => { ''  => 100,
#		                    '/' => { ''  => 101,
#		                             'f' => { '' => 102 } } },
#		    '#(Int)'   => { ''  => 1000,
#		                    '/' => { ''  => 1001,
#		                             'f' => { '' => 1002 } } },
#		    '#(Array)' => { ''  => 10000 },
#		    'b'        => { ''  => 4 },
#		    'c'        => { '/' => { ''  => 5 } },
#		    'd'        => { '/' => { 'e' => { '' => 7 } } } } },
#		q{Inserted '/*/f'};
#
#	ok $r.add( 'GET', 103, '/', 'g', '/', Str ), q{Add '/g/#(Str)'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { ''  => 2 },
#		    '#(Str)'   => { ''  => 100,
#		                    '/' => { ''  => 101,
#		                             'f' => { '' => 102 } } },
#		    '#(Int)'   => { ''  => 1000,
#		                    '/' => { ''  => 1001,
#		                             'f' => { '' => 1002 } } },
#		    '#(Array)' => { ''  => 10000 },
#		    'b'        => { ''  => 4 },
#		    'c'        => { '/' => { ''       => 5 } },
#		    'd'        => { '/' => { 'e'      => { '' => 7 } } },
#		    'g'        => { '/' => { '#(Str)' => { '' => 103 } } } } },
#		q{Inserted '/g/*'};
#
#	ok $r.add( 'GET', 104, '/', Str, '/', Str ), q{Add '/#(Str)/#(Str)'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { ''  => 2 },
#		    '#(Str)'   => { ''  => 100,
#		                    '/' => { ''       => 101,
#		                             'f'      => { '' => 102 },
#		                             '#(Str)' => { '' => 104 } } },
#		    '#(Int)'   => { ''  => 1000,
#		                    '/' => { ''  => 1001,
#		                             'f' => { '' => 1002 } } },
#		    '#(Array)' => { ''  => 10000 },
#		    'b'        => { ''  => 4 },
#		    'c'        => { '/' => { ''       => 5 } },
#		    'd'        => { '/' => { 'e'      => { '' => 7 } } },
#		    'g'        => { '/' => { '#(Str)' => { '' => 103 } } } } },
#		q{Inserted '/#(Str)/#(Str)'};
#	},
#	q{Inserted shortest routes first};
#
#subtest sub
#	{
#	plan 15;
#
#	my $r = App::Prancer::Core.new;
#
#	ok $r.add( 'GET', 104,   '/', Str, '/', Str ), q{Add '/#(Str)/#(Str)'};
#	ok $r.add( 'GET', 103,   '/', 'g', '/', Str ), q{Add '/g/#(Str)'};
#	ok $r.add( 'GET', 1002,  '/', Int, '/', 'f' ), q{Add '/#(Int)/f'};
#	ok $r.add( 'GET', 102,   '/', Str, '/', 'f' ), q{Add '/#(Str)/f'};
#	ok $r.add( 'GET', 7,     '/', 'd', '/', 'e' ), q{Add '/d/e'};
#	ok $r.add( 'GET', 1001,  '/', Int, '/' ), q{Add '/#(Int)/'};
#	ok $r.add( 'GET', 101,   '/', Str, '/' ), q{Add '/#(Str)/'};
#	ok $r.add( 'GET', 5,     '/', 'c', '/' ), q{Add '/c/'};
#	ok $r.add( 'GET', 4,     '/', 'b' ), q{Add '/b'};
#	ok $r.add( 'GET', 10000, '/', Array ), q{Add '/#(Array)'};
#	ok $r.add( 'GET', 1000,  '/', Int ), q{Add '/#(Int)'};
#	ok $r.add( 'GET', 100,   '/', Str ), q{Add '/#(Str)'};
#	ok $r.add( 'GET', 2,     '/', 'a' ), q{Add '/a'};
#	ok $r.add( 'GET', 1,     '/' ), q{Add '/'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { ''  => 2 },
#		    '#(Str)'   => { ''  => 100,
#		                    '/' => { ''       => 101,
#		                             'f'      => { '' => 102 },
#		                             '#(Str)' => { '' => 104 } } },
#		    '#(Int)'   => { ''  => 1000,
#		                    '/' => { ''  => 1001,
#		                             'f' => { '' => 1002 } } },
#		    '#(Array)' => { ''  => 10000 },
#		    'b'        => { ''  => 4 },
#		    'c'        => { '/' => { ''       => 5 } },
#		    'd'        => { '/' => { 'e'      => { '' => 7 } } },
#		    'g'        => { '/' => { '#(Str)' => { '' => 103 } } } } },
#		q{Inserted '/*/*'};
#	},
#	q{Inserted longest routes first};
#
#subtest sub
#	{
#	plan 15;
#
#	my $r = App::Prancer::Core.new;
#
#	ok $r.add( 'GET', 104,  '/', Str, '/', Str ),
#		q{Add '/#(Str)/#(Str)'};
#	ok $r.add( 'GET', 103,  '/g', '/', Str ),
#		q{Add '/g/#(Str)' as '/g' / #(Str)};
#	ok $r.add( 'GET', 1002, '/', Int, '/f' ),
#		q{Add '/#(Int)/f' as '/' #(Int) '/f'};
#	ok $r.add( 'GET', 102,  '/', Str, '/f' ),
#		q{Add '/#(Str)/f' as '/' #(Str) '/f'};
#	ok $r.add( 'GET', 7,    '/d', '/e' ),
#		q{Add '/d/e' as '/d' '/e'};
#	ok $r.add( 'GET', 1001, '/', Int, '/' ),
#		q{Add '/#(Int)/'};
#	ok $r.add( 'GET', 101,  '/', Str, '/' ),
#		q{Add '/#(Str)/'};
#	ok $r.add( 'GET', 5,    '/c', '/' ),
#		q{Add '/c/' as '/c' '/'};
#	ok $r.add( 'GET', 4,    '/b' ),
#		q{Add '/b' as '/b'};
#	ok $r.add( 'GET', 10000, '/', Array ),
#		q{Add '/#(Array)'};
#	ok $r.add( 'GET', 1000, '/', Int ),
#		q{Add '/#(Int)'};
#	ok $r.add( 'GET', 100,  '/', Str ),
#		q{Add '/#(Str)'};
#	ok $r.add( 'GET', 2,    '/a' ),
#		q{Add '/a' as '/a'};
#	ok $r.add( 'GET', 1,    '/' ),
#		q{Add '/'};
#
#	is-deeply $r.routes.<GET>,
#		{ '/' =>
#		  { ''         => 1,
#		    'a'        => { ''  => 2 },
#		    '#(Str)'   => { ''  => 100,
#		                    '/' => { ''       => 101,
#		                             'f'      => { '' => 102 },
#		                             '#(Str)' => { '' => 104 } } },
#		    '#(Int)'   => { ''  => 1000,
#		                    '/' => { ''  => 1001,
#		                             'f' => { '' => 1002 } } },
#		    '#(Array)' => { ''  => 10000 },
#		    'b'        => { ''  => 4 },
#		    'c'        => { '/' => { ''       => 5 } },
#		    'd'        => { '/' => { 'e'      => { '' => 7 } } },
#		    'g'        => { '/' => { '#(Str)' => { '' => 103 } } } } },
#		q{Inserted '/#(Str)Str)'};
#	},
#	q{Inserted longest routes first, moving the '/' into the literals};

done-testing;
