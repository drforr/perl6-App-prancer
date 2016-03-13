use v6;
use Test;
use App::Prancer::Core;

plan 0;

diag "*** Must get arrays working at some point.";
diag "*** But for the moment they're a distraction.";

#`(
subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, Array );
	nok $r.find( 'GET', '/' ), q{Fail to find '/'};

	is $r.find( 'GET', '/a' ), 1, q{Find '/a'};
	is $r.find( 'GET', '/1' ), 1, q{Find '/1'};

	nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
	nok $r.find( 'GET', '/1/' ), q{Fail to find '/1/'};

	is $r.find( 'GET', '/a/a' ), 1, q{Find '/a/a'};
	is $r.find( 'GET', '/a/1' ), 1, q{Find '/a/1'};
	},
	q{Route '/#(Array)'};

subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, Array, '/' );
	nok $r.find( 'GET', '/' ), q{Fail to find '/'};

	nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
	nok $r.find( 'GET', '/1' ), q{Fail to find '/1'};

	is $r.find( 'GET', '/a/' ), 1, q{Find '/a/'};
	is $r.find( 'GET', '/1/' ), 1, q{Find '/1/'};

	nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
	nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
	},
	q{Route '/#(Array)/'};

subtest sub
	{
	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, '/a', Array );
		nok $r.find( 'GET', '/a/' ),
			 q{Fail to find '/a/'};

		is $r.find( 'GET', '/a/a' ), 1,
			 q{Find '/a/a'};
		is $r.find( 'GET', '/a/1' ), 1,
			 q{Find '/a/1'};

		nok $r.find( 'GET', '/a/a/' ),
			 q{Fail to find '/a/a/'};
		nok $r.find( 'GET', '/a/1/' ),
			 q{Fail to find '/a/1/'};

		is $r.find( 'GET', '/a/a/a' ), 1,
			 q{Find '/a/a/a'};
		is $r.find( 'GET', '/a/a/1' ), 1,
			 q{Find '/a/a/1'};
		},
		q{Route '/a/#(Array)'};

	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, '/1', Array );
		nok $r.find( 'GET', '/1/' ),
			q{Fail to find '/1/'};

		is $r.find( 'GET', '/1/a' ), 1,
			q{Find '/1/a'};
		is $r.find( 'GET', '/1/1' ), 1,
			q{Find '/1/1'};

		nok $r.find( 'GET', '/1/a/' ),
			q{Fail to find '/1/a/'};
		nok $r.find( 'GET', '/1/1/' ),
			q{Fail to find '/1/1/'};

		is $r.find( 'GET', '/1/a/a' ), 1,
			q{Find '/1/a/a'};
		is $r.find( 'GET', '/1/a/1' ), 1,
			q{Find '/1/a/1'};
		},
		q{Route '/1/#(Array)'};

	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, '/#(Int)', Array );
		nok $r.find( 'GET', '/1/' ),
			q{Fail to find '/#(Int)/'};

		is $r.find( 'GET', '/1/a' ), 1,
			q{Find '/#(Int)/a'};
		is $r.find( 'GET', '/1/1' ), 1,
			q{Find '/#(Int)/1'};

		nok $r.find( 'GET', '/1/a/' ),
			q{Fail to find '/#(Int)/a/'};
		nok $r.find( 'GET', '/1/1/' ),
			q{Fail to find '/#(Int)/1/'};

		is $r.find( 'GET', '/1/a/a' ), 1,
			q{Find '/#(Int)/a/a'};
		is $r.find( 'GET', '/1/a/1' ), 1,
			q{Find '/#(Int)/a/1'};
		},
		q{Route '/#(Int)/#(Array)'};

	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, '/#(Str)', Array );
		nok $r.find( 'GET', '/a/' ),
			q{Fail to find '/#(Str)/'};

		is $r.find( 'GET', '/a/a' ), 1,
			q{Find '/#(Str)/a'};
		is $r.find( 'GET', '/a/1' ), 1,
			q{Find '/#(Str)/1'};

		nok $r.find( 'GET', '/a/a/' ),
			q{Fail to find '/#(Str)/a/'};
		nok $r.find( 'GET', '/a/1/' ),
			q{Fail to find '/#(Str)/1/'};

		is $r.find( 'GET', '/a/a/a' ), 1,
			q{Find '/#(Str)/a/a'};
		is $r.find( 'GET', '/a/a/1' ), 1,
			q{Find '/#(Str)/a/1'};
		},
		q{Route '/#(Str)/#(Array)'};

# For the moment, assume that @foo indicates the final list of elemenets.
#`(
	subtest sub
		{
		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, Array, 'a' );
			nok $r.find( 'GET', '/a/' ),
				 q{Fail to find '/#(Array)/'};

			is $r.find( 'GET', '/a/a' ), 1,
				q{Find '/#(Array)/a'};
			nok $r.find( 'GET', '/a/1' ),
				q{Fail to find '/#(Array)/1'};

			nok $r.find( 'GET', '/a/a/' ),
				q{Fail to find '/#(Array)/a/'};
			nok $r.find( 'GET', '/a/1/' ),
				q{Fail to find '/#(Array)/1/'};

			nok $r.find( 'GET', '/a/a/a' ),
				q{Fail to find '/#(Array)/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				q{Fail to find '/#(Array)/a/1'};
			},
			q{Route '/#(Array)/a'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, Array, '1' );
			nok $r.find( 'GET', '/a/' ),
				q{Fail to find '/#(Array)/'};

			nok $r.find( 'GET', '/a/a' ),
				q{Fail to find '/#(Array)/a'};
			is $r.find( 'GET', '/a/1' ), 1,
				q{Find '/#(Array)/1'};

			nok $r.find( 'GET', '/a/a/' ),
				q{Fail to find '/#(Array)/a/'};
			nok $r.find( 'GET', '/a/1/' ),
				q{Fail to find '/#(Array)/1/'};

			nok $r.find( 'GET', '/a/a/a' ),
				q{Fail to find '/#(Array)/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				q{Fail to find '/#(Array)/a/1'};
			},
			q{Route '/#(Array)/1'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, Array, Int );
			nok $r.find( 'GET', '/a/' ),
				q{Fail to find '/#(Array)/'};

			nok $r.find( 'GET', '/a/a' ),
				q{Fail to find '/#(Array)/a'};
			is $r.find( 'GET', '/a/1' ), 1,
				q{Find '/#(Array)/1'};

			nok $r.find( 'GET', '/a/a/' ),
				q{Fail to find '/#(Array)/a/'};
			nok $r.find( 'GET', '/a/1/' ),
				q{Fail to find '/#(Array)/1/'};

			nok $r.find( 'GET', '/a/a/a' ),
				q{Fail to find '/#(Array)/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				q{Fail to find '/#(Array)/a/1'};
			},
			q{Route '/#(Array)/#(Int)'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, Array, Str );
			nok $r.find( 'GET', '/a/' ),
				q{Fail to find '/#(Array)/'};

			is $r.find( 'GET', '/a/a' ), 1,
				q{Find '/#(Array)/a'};
			is $r.find( 'GET', '/a/1' ), 1,
				q{Find '/#(Array)/1'};

			nok $r.find( 'GET', '/a/a/' ),
				q{Fail to find '/#(Array)/a/'};
			nok $r.find( 'GET', '/a/1/' ),
				q{Fail to find '/#(Array)/1/'};

			nok $r.find( 'GET', '/a/a/a' ),
				q{Fail to find '/#(Array)/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				q{Fail to find '/#(Array)/a/1'};
			},
			q{Route '/#(Array)/#(Str)'};

		# ( Array, Array ) is illegal, skipping.

		},
		q{Two route elements, start with '/#(Array)'};
)
	},
	q{Two route elements};

subtest sub
	{
	subtest sub
		{
		plan 8;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, Array );
		$r.add( 'GET', 2, '/a/b/c/d' );

		is $r.find( 'GET', '/a' ), 1, q{Find '/a'};
		is $r.find( 'GET', '/a/b' ), 1, q{Find '/a/b'};
		is $r.find( 'GET', '/a/b/c' ), 1, q{Find '/a/b/c'};
		is $r.find( 'GET', '/a/b/c/d' ), 2, q{Find '/a/b/c/d'};

		nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
		nok $r.find( 'GET', '/a/b/' ), q{Fail to find '/a/b/'};
		nok $r.find( 'GET', '/a/b/c/' ), q{Fail to find '/a/b/c/'};
		nok $r.find( 'GET', '/a/b/c/d/' ), q{Fail to find '/a/b/c/d/'};
		},
		q{Just literal};

	subtest sub
		{
		plan 8;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, Array, '/' );
		$r.add( 'GET', 2, '/a/b/c/d/' );

		nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
		nok $r.find( 'GET', '/a/b' ), q{Fail to find '/a/b'};
		nok $r.find( 'GET', '/a/b/c' ), q{Fail to find '/a/b/c'};
		nok $r.find( 'GET', '/a/b/c/d' ), q{Fail to find '/a/b/c/d'};

		is $r.find( 'GET', '/a/' ), 1, q{Find '/a/'};
		is $r.find( 'GET', '/a/b/' ), 1, q{Find '/a/b/'};
		is $r.find( 'GET', '/a/b/c/' ), 1, q{Find '/a/b/c/'};
		is $r.find( 'GET', '/a/b/c/d/' ), 2, q{Find '/a/b/c/d/'};
		},
		q{Literal with trailing slash};
	},
	q{Literal vs. Array};

subtest sub
	{
	subtest sub
		{
		plan 8;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, '/a', Array );
		$r.add( 'GET', 2, '/a/b/c/d' );

		nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
		is $r.find( 'GET', '/a/b' ), 1, q{Find '/a/b'};
		is $r.find( 'GET', '/a/b/c' ), 1, q{Find '/a/b/c'};
		is $r.find( 'GET', '/a/b/c/d' ), 2, q{Find '/a/b/c/d'};

		nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
		nok $r.find( 'GET', '/a/b/' ), q{Fail to find '/a/b/'};
		nok $r.find( 'GET', '/a/b/c/' ), q{Fail to find '/a/b/c/'};
		nok $r.find( 'GET', '/a/b/c/d/' ), q{Fail to find '/a/b/c/d/'};
		},
		q{Array starts with literal};
	},
	q{Literal vs. Array starting with literal};
)

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

done-testing;
