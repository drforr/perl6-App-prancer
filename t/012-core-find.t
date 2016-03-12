use v6;
use Test;
use App::Prancer::Core;

plan 7;

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
)
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

#`(
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
)
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

#`(
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
)
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

#`(
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
)
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

#`(
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
)
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

#`(
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
)
		},
		q{Two route elements, start with '/#(Str)'};

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

#`(
subtest sub
	{
	plan 4;

	my $r = App::Prancer::Core.new;

	$r.add( 'GET', 1, Array );
	$r.add( 'GET', 2, '/a/b/c/d' );

	is $r.find( 'GET', '/a' ), 1, q{Find '/a'};
	is $r.find( 'GET', '/a/b' ), 1, q{Find '/a/b'};
	is $r.find( 'GET', '/a/b/c' ), 1, q{Find '/a/b/c'};
	is $r.find( 'GET', '/a/b/c/d' ), 2, q{Find '/a/b/c/d'};
	},
	q{Array vs. a literal route};
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
