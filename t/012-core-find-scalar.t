use v6;
use Test;
use App::Prancer::Core;

plan 7;

#
# Array tests are in the next file, this one's getting too long in the tooth.
#
subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	nok $r.find( 'GET', '/' ), q{Fail to find '/'};

	nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
	nok $r.find( 'GET', '/1' ), q{Fail to find '/1'};

	nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
	nok $r.find( 'GET', '/1/' ), q{Fail to find '/1/'};

	nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
	nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
	},
	q{No routes};

subtest sub
	{
	plan 7;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, '/' );
	is $r.find( 'GET', '/' ), 1, q{Finds '/'};

	nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
	nok $r.find( 'GET', '/1' ), q{Fail to find '/1'};

	nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
	nok $r.find( 'GET', '/1/' ), q{Fail to find '/1/'};

	nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
	nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
	},
	q{Default route};

subtest sub
	{
	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, '/a' );
		nok $r.find( 'GET', '/' ), q{Fail to find '/'};

		is $r.find( 'GET', '/a' ), 1, q{Find '/a'};
		nok $r.find( 'GET', '/1' ), q{Fail to find '/1'};

		nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
		nok $r.find( 'GET', '/1/' ), q{Fail to find '/1/'};

		nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
		nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
		},
		q{Route '/a'};

	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, '/1' );
		nok $r.find( 'GET', '/' ), q{Fail to find '/'};

		nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
		is $r.find( 'GET', '/1' ), 1, q{Find '/1'};

		nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
		nok $r.find( 'GET', '/1/' ), q{Fail to find '/1/'};

		nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
		nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
		},
		q{Route '/1'};

	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, Int );
		nok $r.find( 'GET', '/' ), q{Fail to find '/'};

		nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
		is $r.find( 'GET', '/1' ), 1, q{Find '/1'};

		nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
		nok $r.find( 'GET', '/1/' ), q{Fail to find '/1/'};

		nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
		nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
		},
		q{Route '/#(Int)'};

	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, Str );
		nok $r.find( 'GET', '/' ), q{Fail to find '/'};

		is $r.find( 'GET', '/a' ), 1, q{Find '/a'};
		is $r.find( 'GET', '/1' ), 1, q{Find '/1'};

		nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
		nok $r.find( 'GET', '/1/' ), q{Fail to find '/1/'};

		nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
		nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
		},
		q{Route '/#(Str)'};
	},
	q{Single route element};

subtest sub
	{
	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, '/a/' );
		nok $r.find( 'GET', '/' ), q{Fail to find '/'};

		nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
		nok $r.find( 'GET', '/1' ), q{Fail to find '/1'};

		is $r.find( 'GET', '/a/' ), 1, q{Find '/a/'};
		nok $r.find( 'GET', '/1/' ), q{Fail to find '/1/'};

		nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
		nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
		},
		q{Route '/a/'};

	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, '/1/' );
		nok $r.find( 'GET', '/' ), q{Fail to find '/'};

		nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
		nok $r.find( 'GET', '/1' ), q{Fail to find '/1'};

		nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
		is $r.find( 'GET', '/1/' ), 1, q{Find '/1/'};

		nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
		nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
		},
		q{Route '/1/'};

	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, Int, '/' );
		nok $r.find( 'GET', '/' ), q{Fail to find '/'};

		nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
		nok $r.find( 'GET', '/1' ), q{Fail to find '/1'};

		nok $r.find( 'GET', '/a/' ), q{Fail to find '/a/'};
		is $r.find( 'GET', '/1/' ), 1, q{Find '/1/'};

		nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
		nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
		},
		q{Route '/#(Int)/'};

	subtest sub
		{
		plan 7;

		my $r = App::Prancer::Core.new;

		$r.add( 'GET', 1, Str, '/' );
		nok $r.find( 'GET', '/' ), q{Fail to find '/'};

		nok $r.find( 'GET', '/a' ), q{Fail to find '/a'};
		nok $r.find( 'GET', '/1' ), q{Fail to find '/1'};

		is $r.find( 'GET', '/a/' ), 1, q{Find '/a/'};
		is $r.find( 'GET', '/1/' ), 1, q{Find '/1/'};

		nok $r.find( 'GET', '/a/a' ), q{Fail to find '/a/a'};
		nok $r.find( 'GET', '/a/1' ), q{Fail to find '/a/1'};
		},
		q{Route '/#(Str)/'};
	},
	q{Single route element with final slash};

subtest sub
	{
	subtest sub
		{
		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/a/a' );
			nok $r.find( 'GET', '/a/' ),
				 q{Fail to find '/a/'};

			is $r.find( 'GET', '/a/a' ), 1,
				 q{Find '/a/a'};
			nok $r.find( 'GET', '/a/1' ),
				 q{Fail to find '/a/1'};

			nok $r.find( 'GET', '/a/a/' ),
				 q{Fail to find '/a/a/'};
			nok $r.find( 'GET', '/a/1/' ),
				 q{Fail to find '/a/1/'};

			nok $r.find( 'GET', '/a/a/a' ),
				 q{Fail to find '/a/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				 q{Fail to find '/a/a/1'};
			},
			q{Route '/a/a'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/a/1' );
			nok $r.find( 'GET', '/a/' ),
				 q{Fail to find '/a/'};

			nok $r.find( 'GET', '/a/a' ),
				 q{Fail to find '/a/a'};
			is $r.find( 'GET', '/a/1' ), 1,
				 q{Find '/a/1'};

			nok $r.find( 'GET', '/a/a/' ),
				 q{Fail to find '/a/a/'};
			nok $r.find( 'GET', '/a/1/' ),
				 q{Fail to find '/a/1/'};

			nok $r.find( 'GET', '/a/a/a' ),
				 q{Fail to find '/a/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				 q{Fail to find '/a/a/1'};
			},
			q{Route '/a/1'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/a', Int );
			nok $r.find( 'GET', '/a/' ),
				 q{Fail to find '/a/'};

			nok $r.find( 'GET', '/a/a' ),
				 q{Fail to find '/a/a'};
			is $r.find( 'GET', '/a/1' ), 1,
				 q{Find '/a/1'};

			nok $r.find( 'GET', '/a/a/' ),
				 q{Fail to find '/a/a/'};
			nok $r.find( 'GET', '/a/1/' ),
				 q{Fail to find '/a/1/'};

			nok $r.find( 'GET', '/a/a/a' ),
				 q{Fail to find '/a/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				 q{Fail to find '/a/a/1'};
			},
			q{Route '/a/#(Int)'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/a', Str );
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

			nok $r.find( 'GET', '/a/a/a' ),
				 q{Fail to find '/a/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				 q{Fail to find '/a/a/1'};
			},
			q{Route '/a/#(Str)'};
		},
		q{Two route elements, start with '/a'};

	subtest sub
		{
		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/1/a' );
			nok $r.find( 'GET', '/1/' ),
				q{Fail to find '/1/'};

			is $r.find( 'GET', '/1/a' ), 1,
				q{Find '/1/a'};
			nok $r.find( 'GET', '/1/1' ),
				q{Fail to find '/1/1'};

			nok $r.find( 'GET', '/1/a/' ),
				q{Fail to find '/1/a/'};
			nok $r.find( 'GET', '/1/1/' ),
				q{Fail to find '/1/1/'};

			nok $r.find( 'GET', '/1/a/a' ),
				q{Fail to find '/1/a/a'};
			nok $r.find( 'GET', '/1/a/1' ),
				q{Fail to find '/1/a/1'};
			},
			q{Route '/1/a'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/1/1' );
			nok $r.find( 'GET', '/1/' ),
				q{Fail to find '/1/'};

			nok $r.find( 'GET', '/1/a' ),
				q{Fail to find '/1/a'};
			is $r.find( 'GET', '/1/1' ), 1,
				q{Find '/1/1'};

			nok $r.find( 'GET', '/1/a/' ),
				q{Fail to find '/1/a/'};
			nok $r.find( 'GET', '/1/1/' ),
				q{Fail to find '/1/1/'};

			nok $r.find( 'GET', '/1/a/a' ),
				q{Fail to find '/1/a/a'};
			nok $r.find( 'GET', '/1/a/1' ),
				q{Fail to find '/1/a/1'};
			},
			q{Route '/1/1'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/1', Int );
			nok $r.find( 'GET', '/1/' ),
				q{Fail to find '/1/'};

			nok $r.find( 'GET', '/1/a' ),
				q{Fail to find '/1/a'};
			is $r.find( 'GET', '/1/1' ), 1,
				q{Find '/1/1'};

			nok $r.find( 'GET', '/1/a/' ),
				q{Fail to find '/1/a/'};
			nok $r.find( 'GET', '/1/1/' ),
				q{Fail to find '/1/1/'};

			nok $r.find( 'GET', '/1/a/a' ),
				q{Fail to find '/1/a/a'};
			nok $r.find( 'GET', '/1/a/1' ),
				q{Fail to find '/1/a/1'};
			},
			q{Route '/1/#(Int)'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/1', Str );
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

			nok $r.find( 'GET', '/1/a/a' ),
				q{Fail to find '/1/a/a'};
			nok $r.find( 'GET', '/1/a/1' ),
				q{Fail to find '/1/a/1'};
			},
			q{Route '/1/#(Str)'};
		},
		q{Two route elements, start with '/1'};

	subtest sub
		{
		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/#(Int)/a' );
			nok $r.find( 'GET', '/1/' ),
				q{Fail to find '/#(Int)/'};

			is $r.find( 'GET', '/1/a' ), 1,
				q{Find '/#(Int)/a'};
			nok $r.find( 'GET', '/1/1' ),
				q{Fail to find '/#(Int)/1'};

			nok $r.find( 'GET', '/1/a/' ),
				q{Fail to find '/#(Int)/a/'};
			nok $r.find( 'GET', '/1/1/' ),
				q{Fail to find '/#(Int)/1/'};

			nok $r.find( 'GET', '/1/a/a' ),
				q{Fail to find '/#(Int)/a/a'};
			nok $r.find( 'GET', '/1/a/1' ),
				q{Fail to find '/#(Int)/a/1'};
			},
			q{Route '/#(Int)/a'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/#(Int)/1' );
			nok $r.find( 'GET', '/1/' ),
				q{Fail to find '/#(Int)/'};

			nok $r.find( 'GET', '/1/a' ),
				q{Fail to find '/#(Int)/a'};
			is $r.find( 'GET', '/1/1' ), 1,
				q{Find '/#(Int)/1'};

			nok $r.find( 'GET', '/1/a/' ),
				q{Fail to find '/#(Int)/a/'};
			nok $r.find( 'GET', '/1/1/' ),
				q{Fail to find '/#(Int)/1/'};

			nok $r.find( 'GET', '/1/a/a' ),
				q{Fail to find '/#(Int)/a/a'};
			nok $r.find( 'GET', '/1/a/1' ),
				q{Fail to find '/#(Int)/a/1'};
			},
			q{Route '/#(Int)/1'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/#(Int)', Int );
			nok $r.find( 'GET', '/1/' ),
				q{Fail to find '/#(Int)/'};

			nok $r.find( 'GET', '/1/a' ),
				q{Fail to find '/#(Int)/a'};
			is $r.find( 'GET', '/1/1' ), 1,
				q{Find '/#(Int)/1'};

			nok $r.find( 'GET', '/1/a/' ),
				q{Fail to find '/#(Int)/a/'};
			nok $r.find( 'GET', '/1/1/' ),
				q{Fail to find '/#(Int)/1/'};

			nok $r.find( 'GET', '/1/a/a' ),
				q{Fail to find '/#(Int)/a/a'};
			nok $r.find( 'GET', '/1/a/1' ),
				q{Fail to find '/#(Int)/a/1'};
			},
			q{Route '/#(Int)/#(Int)'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/#(Int)', Str );
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

			nok $r.find( 'GET', '/1/a/a' ),
				q{Fail to find '/#(Int)/a/a'};
			nok $r.find( 'GET', '/1/a/1' ),
				q{Fail to find '/#(Int)/a/1'};
			},
			q{Route '/#(Int)/#(Str)'};
		},
		q{Two route elements, start with '/#(Int)'};

	subtest sub
		{
		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/#(Str)/a' );
			nok $r.find( 'GET', '/a/' ),
				q{Fail to find '/#(Str)/'};

			is $r.find( 'GET', '/a/a' ), 1,
				q{Find '/#(Str)/a'};
			nok $r.find( 'GET', '/a/1' ),
				q{Fail to find '/#(Str)/1'};

			nok $r.find( 'GET', '/a/a/' ),
				q{Fail to find '/#(Str)/a/'};
			nok $r.find( 'GET', '/a/1/' ),
				q{Fail to find '/#(Str)/1/'};

			nok $r.find( 'GET', '/a/a/a' ),
				q{Fail to find '/#(Str)/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				q{Fail to find '/#(Str)/a/1'};
			},
			q{Route '/#(Str)/a'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/#(Str)/1' );
			nok $r.find( 'GET', '/a/' ),
				q{Fail to find '/#(Str)/'};

			nok $r.find( 'GET', '/a/a' ),
				q{Fail to find '/#(Str)/a'};
			is $r.find( 'GET', '/a/1' ), 1,
				q{Find '/#(Str)/1'};

			nok $r.find( 'GET', '/a/a/' ),
				q{Fail to find '/#(Str)/a/'};
			nok $r.find( 'GET', '/a/1/' ),
				q{Fail to find '/#(Str)/1/'};

			nok $r.find( 'GET', '/a/a/a' ),
				q{Fail to find '/#(Str)/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				q{Fail to find '/#(Str)/a/1'};
			},
			q{Route '/#(Str)/1'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/#(Str)', Int );
			nok $r.find( 'GET', '/a/' ),
				q{Fail to find '/#(Str)/'};

			nok $r.find( 'GET', '/a/a' ),
				q{Fail to find '/#(Str)/a'};
			is $r.find( 'GET', '/a/1' ), 1,
				q{Find '/#(Str)/1'};

			nok $r.find( 'GET', '/a/a/' ),
				q{Fail to find '/#(Str)/a/'};
			nok $r.find( 'GET', '/a/1/' ),
				q{Fail to find '/#(Str)/1/'};

			nok $r.find( 'GET', '/a/a/a' ),
				q{Fail to find '/#(Str)/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				q{Fail to find '/#(Str)/a/1'};
			},
			q{Route '/#(Str)/#(Int)'};

		subtest sub
			{
			plan 7;

			my $r = App::Prancer::Core.new;

			$r.add( 'GET', 1, '/#(Str)', Str );
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

			nok $r.find( 'GET', '/a/a/a' ),
				q{Fail to find '/#(Str)/a/a'};
			nok $r.find( 'GET', '/a/a/1' ),
				q{Fail to find '/#(Str)/a/1'};
			},
			q{Route '/#(Str)/#(Str)'};
		},
		q{Two route elements, start with '/#(Str)'};
	},
	q{Two route elements};

subtest sub
	{
	plan 2;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, Int );
	$r.add( 'GET', 2, '/a' );

	is $r.find( 'GET', '/a' ), 2, q{Find '/a'};
	is $r.find( 'GET', '/1' ), 1, q{Find '/1'};
	},
	q{Fallback to '/#(Int)'};

subtest sub
	{
	plan 3;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, Str );
	$r.add( 'GET', 2, '/a' );

	is $r.find( 'GET', '/a' ), 2, q{Find '/a'};
	is $r.find( 'GET', '/b' ), 1, q{Find '/b'};
	is $r.find( 'GET', '/1' ), 1, q{Find '/1'};
	},
	q{Fallback to '/#(Str)'};

done-testing;
