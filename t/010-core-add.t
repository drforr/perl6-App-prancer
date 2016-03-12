use v6;
use Test;
use App::Prancer::Core;

plan 35;

my $r = App::Prancer::Core.new;

#
# Start with 1 argument, go up to 4.
#
ok $r.add( 'GET', 1, '/' ), q{Add '/'};
throws-like { $r.add( 'GET', 1, '/' ) },
	Exception,
	message => /exists/,
	q{Adding '/' a second time throws an Exception};

ok $r.add( 'GET', 10, '/', 'a' ), q{Add '/a'};
ok $r.add( 'GET', 11, '/', Int ), q{Add '/#(Int)'};
ok $r.add( 'GET', 12, '/', Str ), q{Add '/#(Str)'};
ok $r.add( 'GET', 13, '/', Array ), q{Add '/#(Array)'};

subtest sub
	{
	plan 4;

	throws-like { $r.add( 'GET', 1, '/', 'a' ) },
		Exception,
		message => /exists/,
		q{Adding '/a' a second time throws an Exception};
	throws-like { $r.add( 'GET', 1, '/', Int ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Int)' a second time throws an Exception};
	throws-like { $r.add( 'GET', 1, '/', Str ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Str)' a second time throws an Exception};
	throws-like { $r.add( 'GET', 1, '/', Array ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Array)' a second time throws an Exception};
	},
	q{Throw exceptions for 2 terms};

ok $r.add( 'GET', 100, '/', 'a', '/' ), q{Add '/a/'};
ok $r.add( 'GET', 101, '/', Int, '/' ), q{Add '/#(Int)/'};
ok $r.add( 'GET', 102, '/', Str, '/' ), q{Add '/#(Str)/'};
ok $r.add( 'GET', 103, '/', Array, '/' ), q{Add '/#(Array)'};

subtest sub
	{
	plan 4;

	throws-like { $r.add( 'GET', 1, '/', 'a', '/' ) },
		Exception,
		message => /exists/,
		q{Adding '/a/' a second time throws an Exception};
	throws-like { $r.add( 'GET', 1, '/', Int, '/' ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Int)/' a second time throws an Exception};
	throws-like { $r.add( 'GET', 1, '/', Str, '/' ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Str)/' a second time throws an Exception};
	throws-like { $r.add( 'GET', 1, '/', Array, '/' ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Array)/' a second time throws an Exception};
	},
	q{Throw exceptions for 3 terms};

# Only one level of combinatorics, though.
#
ok $r.add( 'GET', 1000, '/', 'a', '/', 'b' ), q{Add '/a/b'};
ok $r.add( 'GET', 1001, '/', 'a', '/', Int ), q{Add '/a/#(Int)'};
ok $r.add( 'GET', 1002, '/', 'a', '/', Str ), q{Add '/a/#(Str)'};
ok $r.add( 'GET', 1003, '/', 'a', '/', Array ), q{Add '/a/#(Array)'};

subtest sub
	{
	plan 4;

	throws-like { $r.add( 'GET', 1, '/', 'a', '/', 'b' ) },
		Exception,
		message => /exists/,
		q{Adding '/a/b' a second time throws an Exception};
	throws-like { $r.add( 'GET', 1, '/', 'a', '/', Int ) },
		Exception,
		message => /exists/,
		q{Adding '/a/#(Int)' a second time throws an Exception};
	throws-like { $r.add( 'GET', 1, '/', 'a', '/', Str ) },
		Exception,
		message => /exists/,
		q{Adding '/a/#(Str)' a second time throws an Exception};
	throws-like { $r.add( 'GET', 1, '/', 'a', '/', Array ) },
		Exception,
		message => /exists/,
		q{Adding '/a/#(Array)' a second time throws an Exception};
	},
	q{Throw exceptions for 4 terms starting with '/a'};

ok $r.add( 'GET', 1010, '/', Int, '/', 'b' ), q{Add '/#(Int)/b'};
ok $r.add( 'GET', 1011, '/', Int, '/', Int ), q{Add '/#(Int)/#(Int)'};
ok $r.add( 'GET', 1012, '/', Int, '/', Str ), q{Add '/#(Int)/#(Str)'};
ok $r.add( 'GET', 1013, '/', Int, '/', Array ), q{Add '/#(Int)/#(Array)'};

subtest sub
	{
	plan 4;

	throws-like { $r.add( 'GET', 1, '/', Int, '/', 'b' ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Int)/b' a second time};
	throws-like { $r.add( 'GET', 1, '/', Int, '/', Int ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Int)/#(Int)' a second time};
	throws-like { $r.add( 'GET', 1, '/', Int, '/', Str ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Int)/#(Str)' a second time};
	throws-like { $r.add( 'GET', 1, '/', Int, '/', Array ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Int)/#(Array)' a second time};
	},
	q{Throw exceptions for 4 terms starting with '/#(Int)'};

ok $r.add( 'GET', 1020, '/', Str, '/', 'b' ), q{Add '/#(Str)/b'};
ok $r.add( 'GET', 1021, '/', Str, '/', Int ), q{Add '/#(Str)/#(Int)'};
ok $r.add( 'GET', 1022, '/', Str, '/', Str ), q{Add '/#(Str)/#(Str)'};
ok $r.add( 'GET', 1023, '/', Str, '/', Array ), q{Add '/#(Str)/#(Array)'};

subtest sub
	{
	plan 4;

	throws-like { $r.add( 'GET', 1, '/', Str, '/', 'b' ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Str)/b' a second time};
	throws-like { $r.add( 'GET', 1, '/', Str, '/', Int ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Str)/#(Int)' a second time};
	throws-like { $r.add( 'GET', 1, '/', Str, '/', Str ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Str)/#(Str)' a second time};
	throws-like { $r.add( 'GET', 1, '/', Str, '/', Array ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Str)/#(Array)' a second time};
	},
	q{Throw exceptions for 4 terms starting with '/#(Str)'};

ok $r.add( 'GET', 1030, '/', Array, '/', 'b' ), q{Add '/#(Array)/b'};
ok $r.add( 'GET', 1031, '/', Array, '/', Int ), q{Add '/#(Array)/#(Int)'};
ok $r.add( 'GET', 1032, '/', Array, '/', Str ), q{Add '/#(Array)/#(Str)'};
throws-like { $r.add( 'GET', 1, '/', Array, '/', Array ) },
	Exception,
	message => /two/,
	q{Can't add a route with two Arrays};

subtest sub
	{
	plan 4;

	throws-like { $r.add( 'GET', 1, '/', Array, '/', 'b' ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Array)/b' a second time};
	throws-like { $r.add( 'GET', 1, '/', Array, '/', Int ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Array)/#(Int)' a second time};
	throws-like { $r.add( 'GET', 1, '/', Array, '/', Str ) },
		Exception,
		message => /exists/,
		q{Adding '/#(Array)/#(Str)' a second time};
	throws-like { $r.add( 'GET', 1, '/', Array, '/', Array ) },
		Exception,
		message => /two/,
		q{Still can't add a route with two Arrays};
	},
	q{Throw exceptions for 4 terms starting with '/#(Array)'};

subtest sub
	{
	plan 4;

	my $r = App::Prancer::Core.new;

	ok $r.add( 'GET', 1, '/a' ),
		q{Add '/a'};
	ok $r.add( 'GET', 1, '/a/' ),
		q{Add '/a/'};
	ok $r.add( 'GET', 1, '/', 'b/' ),
		q{Add '/b/'};
	ok $r.add( 'GET', 1, '/a', '/b' ),
		q{Add '/a/b'};
	},
	q{Slashes allowed as part of literals};

subtest sub
	{
	plan 4;

	my $r = App::Prancer::Core.new;

	ok $r.add( 'GET', 1, 'a' ),
		q{Add '/a'};
	ok $r.add( 'GET', 1, Int ),
		q{Add '/#(Int)'};
	ok $r.add( 'GET', 1, Str ),
		q{Add '/#(Str)'};
	ok $r.add( 'GET', 1, Array ),
		q{Add '/#(Array)'};
	},
	q{Can add single-element routes without slashes};

subtest sub
	{
	plan 16;

	my $r = App::Prancer::Core.new;

	ok $r.add( 'GET', 1, 'a', 'a' ),
		q{Add '/a/a'};
	ok $r.add( 'GET', 1, 'a', Int ),
		q{Add '/a/#(Int)'};
	ok $r.add( 'GET', 1, 'a', Str ),
		q{Add '/a/#(Str)'};
	ok $r.add( 'GET', 1, 'a', Array ),
		q{Add '/a/#(Array)'};

	ok $r.add( 'GET', 1, Int, 'a' ),
		q{Add '/#(Int)/a'};
	ok $r.add( 'GET', 1, Int, Int ),
		q{Add '/#(Int)/#(Int)'};
	ok $r.add( 'GET', 1, Int, Str ),
		q{Add '/#(Int)/#(Str)'};
	ok $r.add( 'GET', 1, Int, Array ),
		q{Add '/#(Int)/#(Array)'};

	ok $r.add( 'GET', 1, Str, 'a' ),
		q{Add '/#(Str)/a'};
	ok $r.add( 'GET', 1, Str, Int ),
		q{Add '/#(Str)/#(Int)'};
	ok $r.add( 'GET', 1, Str, Str ),
		q{Add '/#(Str)/#(Str)'};
	ok $r.add( 'GET', 1, Str, Array ),
		q{Add '/#(Str)/#(Array)'};

	ok $r.add( 'GET', 1, Array, 'a' ),
		q{Add '/#(Array)/a'};
	ok $r.add( 'GET', 1, Array, Int ),
		q{Add '/#(Array)/#(Int)'};
	ok $r.add( 'GET', 1, Array, Str ),
		q{Add '/#(Array)/#(Str)'};
	throws-like { $r.add( 'GET', 1, Array, Array ) },
		Exception,
		message => /two/,
		q{Still can't add a route with two Arrays};
	},
	q{Can add two-element routes without slashes};

done-testing;
