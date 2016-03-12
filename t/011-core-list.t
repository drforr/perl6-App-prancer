use v6;
use Test;
use App::Prancer::Core;

plan 27;

my $r = App::Prancer::Core.new;

is-deeply
	[ $r.list('GET') ],
	[ ],
	q{Empty core has no routes};

ok $r.add( 'GET', 1, '/' ), q{Add '/'};
is-deeply
	[ $r.list('GET') ],
	[ '/' ],
	q{Default route is listed};

ok $r.add( 'GET', 1, '/', 'a' ), q{Add '/a'};
is-deeply
	[ $r.list('GET') ],
	[ '/', '/a' ],
	q{'/a' was added};

ok $r.add( 'GET', 1, '/', Int ), q{Add '/#(Int)'};
is-deeply
	[ $r.list('GET') ],
	[ '/', '/#(Int)', '/a' ],
	q{'/#(Int)' was added};

ok $r.add( 'GET', 1, '/', Str ), q{Add '/#(Str)'};
is-deeply
	[ $r.list('GET') ],
	[ '/', '/#(Int)', '/#(Str)', '/a' ],
	q{'/#(Str)' was added};

ok $r.add( 'GET', 1, '/', Array ), q{Add '/#(Array)'};
is-deeply
	[ $r.list('GET') ],
	[ '/', '/#(Array)', '/#(Int)', '/#(Str)', '/a' ],
	q{'/#(Array)' was added};

ok $r.add( 'GET', 1, '/', 'a', '/' ), q{Add '/a/'};
is-deeply
	[ $r.list('GET') ],
	[ '/', '/#(Array)', '/#(Int)', '/#(Str)', '/a', '/a/' ],
	q{'/a/' was added};

ok $r.add( 'GET', 1, '/', Int, '/' ), q{Add '/#(Int)/'};
is-deeply
	[ $r.list('GET') ],
	[ '/', '/#(Array)', '/#(Int)', '/#(Int)/', '/#(Str)', '/a', '/a/' ],
	q{'/#(Int)/' was added};

ok $r.add( 'GET', 1, '/', Str, '/' ), q{Add '/#(Str)/'};
is-deeply
	[ $r.list('GET') ],
	[ '/',
          '/#(Array)',
          '/#(Int)',
          '/#(Int)/',
          '/#(Str)',
          '/#(Str)/',
          '/a',
          '/a/'
        ],
	q{'/#(Str)/' was added};

ok $r.add( 'GET', 1, '/', Array, '/' ), q{Add '/#(Array)/'};
is-deeply
	[ $r.list('GET') ],
	[ '/',
          '/#(Array)',
          '/#(Array)/',
          '/#(Int)',
          '/#(Int)/',
          '/#(Str)',
          '/#(Str)/',
          '/a',
          '/a/'
        ],
	q{'/#(Array)/' was added};

ok $r.add( 'GET', 1, '/', 'a', '/', 'b' ), q{Add '/a/b'};
is-deeply
	[ $r.list('GET') ],
	[ '/',
          '/#(Array)',
          '/#(Array)/',
          '/#(Int)',
          '/#(Int)/',
          '/#(Str)',
          '/#(Str)/',
          '/a',
          '/a/',
          '/a/b'
        ],
	q{'/a/b' was added};

ok $r.add( 'GET', 1, '/', 'a', '/', '#(Int)' ), q{Add '/a/#(Int)'};
is-deeply
	[ $r.list('GET') ],
	[ '/',
          '/#(Array)',
          '/#(Array)/',
          '/#(Int)',
          '/#(Int)/',
          '/#(Str)',
          '/#(Str)/',
          '/a',
          '/a/',
          '/a/#(Int)',
          '/a/b'
        ],
	q{'/a/#(Int)' was added};

ok $r.add( 'GET', 1, '/', 'a', '/', '#(Str)' ), q{Add '/a/#(Str)'};
is-deeply
	[ $r.list('GET') ],
	[ '/',
          '/#(Array)',
          '/#(Array)/',
          '/#(Int)',
          '/#(Int)/',
          '/#(Str)',
          '/#(Str)/',
          '/a',
          '/a/',
          '/a/#(Int)',
          '/a/#(Str)',
          '/a/b'
        ],
	q{'/a/#(Str)' was added};

ok $r.add( 'GET', 1, '/', 'a', '/', '#(Array)' ), q{Add '/a/#(Array)'};
is-deeply
	[ $r.list('GET') ],
	[ '/',
          '/#(Array)',
          '/#(Array)/',
          '/#(Int)',
          '/#(Int)/',
          '/#(Str)',
          '/#(Str)/',
          '/a',
          '/a/',
          '/a/#(Array)',
          '/a/#(Int)',
          '/a/#(Str)',
          '/a/b'
        ],
	q{'/a/#(Str)' was added};

done-testing;
