use v6;
use Test;
use App::Prancer::Handler :testing;
use App::Prancer::Routes;

plan 18;

subtest sub
	{
	plan 6;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 1, '/' ), q{Add '/'};
	throws-like { $r.add( 'GET', 1, '/' ) },
		Exception,
		message => /exists/,
		q{Adding '/' a second time throws an Exception};

	ok $r.add( 'GET', 1, '/', 'a' ), q{Add '/a'};
	throws-like { $r.add( 'GET', 1, '/', 'a' ) },
		Exception,
		message => /exists/,
		q{Adding '/a' a second time throws an Exception};

	ok $r.add( 'GET', 1, '/', 'a', '/' ), q{Add '/a/'};
	throws-like { $r.add( 'GET', 1, '/', 'a', '/' ) },
		Exception,
		message => /exists/,
		q{Adding '/a/' a second time throws an Exception};
	},
	q{Inserting multiples of a route raises a warning};

subtest sub
	{
	plan 27;

	my $r = App::Prancer::Routes.new;

	is-deeply $r.routes.<GET>, { },
		q{Null hypothesis};

	ok $r.add( 'GET', 1, '/' ), q{Add '/'};

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { '' => 1 } },
		q{Inserted '/'};

	ok $r.add( 'GET', 2, '/', 'a' ), q{Add '/a'};

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''  => 1,
		    'a' => { '' => 2 } } },
		q{Inserted '/a'};

	ok $r.add( 'GET', 100, '/', Str ), q{Add '/*'};

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { '' => 2 },
		    '#(Str)' => { '' => 100 } } },
		q{Inserted '/*'};

	ok $r.add( 'GET', 1000, '/', Int ), q{Add '/#'};

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { '' => 2 },
		    '#(Str)' => { '' => 100 },
		    '#(Int)' => { '' => 1000 } } },
		q{Inserted '/1'};

	ok $r.add( 'GET', 4, '/', 'b' ), q{Add '/b'};

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { '' => 2 },
		    '#(Str)' => { '' => 100 },
		    '#(Int)' => { '' => 1000 },
		    'b'      => { '' => 4 } } },
		q{Inserted '/b'};

	ok $r.add( 'GET', 5, '/', 'c', '/' ), q{Add '/c/'};

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100 },
		    '#(Int)' => { ''  => 1000 },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { '' => 5 } } } },
		q{Inserted '/c/'};

	ok $r.add( 'GET', 101, '/', Str, '/' ), q{Add '/*/'};

	is-deeply $r.routes.<GET>,
		{ '/' =>
		  { ''       => 1,
		    'a'      => { ''  => 2 },
		    '#(Str)' => { ''  => 100,
		                  '/' => { '' => 101 } },
		    '#(Int)' => { ''  => 1000 },
		    'b'      => { ''  => 4 },
		    'c'      => { '/' => { '' => 5 } } } },
		q{Inserted '/*/'};

	ok $r.add( 'GET', 1001, '/', Int, '/' ), q{Add '/#/'};

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
		q{Inserted '/1/'};

	ok $r.add( 'GET', 7, '/', 'd', '/', 'e' ), q{Add '/d/e'};

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
		q{Inserted '/d/e'};

	ok $r.add( 'GET', 102, '/', Str, '/', 'f' ), q{Add '/*/f'};

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
		q{Inserted '/*/f'};

	ok $r.add( 'GET', 1002, '/', Int, '/', 'f' ), q{Add '/#/f'};

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
		q{Inserted '/*/f'};

	ok $r.add( 'GET', 103, '/', 'g', '/', Str ), q{Add '/g/*'};

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
		q{Inserted '/g/*'};

	ok $r.add( 'GET', 104, '/', Str, '/', Str ), q{Add '/*/*'};

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
		q{Inserted '/*/*'};

	},
	q{Inserted shortest routes first};

subtest sub
	{
	plan 14;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 104,  '/', Str, '/', Str ), q{Add '/*/*'};
	ok $r.add( 'GET', 103,  '/', 'g', '/', Str ), q{Add '/g/*'};
	ok $r.add( 'GET', 1002, '/', Int, '/', 'f' ), q{Add '/#/f'};
	ok $r.add( 'GET', 102,  '/', Str, '/', 'f' ), q{Add '/*/f'};
	ok $r.add( 'GET', 7,    '/', 'd', '/', 'e' ), q{Add '/d/e'};
	ok $r.add( 'GET', 1001, '/', Int, '/' ), q{Add '/#/'};
	ok $r.add( 'GET', 101,  '/', Str, '/' ), q{Add '/*/'};
	ok $r.add( 'GET', 5,    '/', 'c', '/' ), q{Add '/c/'};
	ok $r.add( 'GET', 4,    '/', 'b' ), q{Add '/b'};
	ok $r.add( 'GET', 1000, '/', Int ), q{Add '/#'};
	ok $r.add( 'GET', 100,  '/', Str ), q{Add '/*'};
	ok $r.add( 'GET', 2,    '/', 'a' ), q{Add '/a'};
	ok $r.add( 'GET', 1,    '/' ), q{Add '/'};

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
		q{Inserted '/*/*'};

	},
	q{Inserted longest routes first};

subtest sub
	{
	plan 14;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 104,  '/', Str, '/', Str ), q{Add '/*/*'};
	ok $r.add( 'GET', 103,  '/g', '/', Str ), q{Add '/g/*' as '/g' / *};
	ok $r.add( 'GET', 1002, '/', Int, '/f' ), q{Add '/#/f' as '/' # '/f'};
	ok $r.add( 'GET', 102,  '/', Str, '/f' ), q{Add '/*/f' as '/' * '/f'};
	ok $r.add( 'GET', 7,    '/d', '/e' ), q{Add '/d/e' as '/d' '/e'};
	ok $r.add( 'GET', 1001, '/', Int, '/' ), q{Add '/#/'};
	ok $r.add( 'GET', 101,  '/', Str, '/' ), q{Add '/*/'};
	ok $r.add( 'GET', 5,    '/c', '/' ), q{Add '/c/' as '/c' '/'};
	ok $r.add( 'GET', 4,    '/b' ), q{Add '/b' as '/b'};
	ok $r.add( 'GET', 1000, '/', Int ), q{Add '/#'};
	ok $r.add( 'GET', 100,  '/', Str ), q{Add '/*'};
	ok $r.add( 'GET', 2,    '/a' ), q{Add '/a' as '/a'};
	ok $r.add( 'GET', 1,    '/' ), q{Add '/'};

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
		q{Inserted '/*/*'};

	},
	q{Inserted longest routes first, moving the '/' into the literals};

subtest sub
	{
	plan 14;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 104,  '/', Str, '/', Str ), q{Add '/*/*'};
	ok $r.add( 'GET', 103,  '/', 'g/', Str ), q{Add '/g/*' as '/' 'g/' *};
	ok $r.add( 'GET', 1002, '/', Int, '/', 'f' ), q{Add '/#/f' as '/' # '/f'};
	ok $r.add( 'GET', 102,  '/', Str, '/', 'f' ), q{Add '/*/f' as '/' * '/f'};
	ok $r.add( 'GET', 7,    '/', 'd/', 'e' ), q{Add '/d/e' as '/' 'd/' 'e'};
	ok $r.add( 'GET', 1001, '/', Int, '/' ), q{Add '/#/'};
	ok $r.add( 'GET', 101,  '/', Str, '/' ), q{Add '/*/'};
	ok $r.add( 'GET', 5,    '/', 'c/' ), q{Add '/c/' as '/', 'c/'};
	ok $r.add( 'GET', 4,    '/', 'b' ), q{Add '/b' as '/', 'b'};
	ok $r.add( 'GET', 1000, '/', Int ), q{Add '/#'};
	ok $r.add( 'GET', 100,  '/', Str ), q{Add '/*'};
	ok $r.add( 'GET', 2,    '/', 'a' ), q{Add '/a' as '/', 'a'};
	ok $r.add( 'GET', 1,    '/' ), q{Add '/'};

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
		q{Inserted '/*/*'};

	},
	q{Inserted longest routes first, moving the '/' into the back};

subtest sub
	{
	plan 14;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 104,  '/', Str, '/', Str ),
		q{Add '/*/*' as '/' * '/' *};
	ok $r.add( 'GET', 103,  '/g/',  Str ), q{Add '/g/*' as '/g/' *};
	ok $r.add( 'GET', 1002, '/', Int, '/f' ), q{Add '/#/f' as '/' # '/f'};
	ok $r.add( 'GET', 102,  '/', Str, '/f' ), q{Add '/*/f' as '/' * '/f'};
	ok $r.add( 'GET', 7,    '/d/e' ), q{Add '/d/e' as '/d/e'};
	ok $r.add( 'GET', 1001, '/', Int, '/' ), q{Add '/#/' as '/' # '/'};
	ok $r.add( 'GET', 101,  '/', Str, '/' ), q{Add '/*/' as '/' * '/'};
	ok $r.add( 'GET', 5,    '/c/' ), q{Add '/c/' as '/c/'};
	ok $r.add( 'GET', 4,    '/b' ), q{Add '/b' as '/b'};
	ok $r.add( 'GET', 1000, '/', Int ), q{Add '/#'};
	ok $r.add( 'GET', 100,  '/', Str ), q{Add '/*'};
	ok $r.add( 'GET', 2,    '/a' ), q{Add '/a' as '/a'};
	ok $r.add( 'GET', 1,    '/' ), q{Add '/'};

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
		q{Inserted '/*/*'};

	},
	q{Inserted longest routes first, compressing literals maximally};

subtest sub
	{
	plan 15;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 10001,'/', 'h', '/', 'i', '/', 'j' ), q{Add '/h/i/j'};
	ok $r.add( 'GET', 104,  '/', Str, '/', Str ), q{Add '/*/*'};
	ok $r.add( 'GET', 103,  '/', 'g', '/', Str ), q{Add '/g/*'};
	ok $r.add( 'GET', 1002, '/', Int, '/', 'f' ), q{Add '/#/f'};
	ok $r.add( 'GET', 102,  '/', Str, '/', 'f' ), q{Add '/*/f'};
	ok $r.add( 'GET', 7,    '/', 'd', '/', 'e' ), q{Add '/d/e'};
	ok $r.add( 'GET', 1001, '/', Int, '/' ), q{Add '/#/'};
	ok $r.add( 'GET', 101,  '/', Str, '/' ), q{Add '/*/'};
	ok $r.add( 'GET', 5,    '/', 'c', '/' ), q{Add '/c/'};
	ok $r.add( 'GET', 4,    '/', 'b' ), q{Add '/b'};
	ok $r.add( 'GET', 1000, '/', Int ), q{Add '/#'};
	ok $r.add( 'GET', 100,  '/', Str ), q{Add '/*'};
	ok $r.add( 'GET', 2,    '/', 'a' ), q{Add '/a'};
	ok $r.add( 'GET', 1,    '/' ), q{Add '/'};

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
		'/h/i/j'
		], q{List routes};

	},
	q{List routes};

subtest sub
	{
	plan 14;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 10001, 'h', '/', 'i', '/', 'j' ), q{Add '/h/i/j'};
	ok $r.add( 'GET', 104,   Str, '/', Str ), q{Add '/*/*'};
	ok $r.add( 'GET', 103,   'g', '/', Str ), q{Add '/g/*'};
	ok $r.add( 'GET', 1002,  Int, '/', 'f' ), q{Add '/#/f'};
	ok $r.add( 'GET', 102,   Str, '/', 'f' ), q{Add '/*/f'};
	ok $r.add( 'GET', 7,     'd', '/', 'e' ), q{Add '/d/e'};
	ok $r.add( 'GET', 1001,  Int, '/' ), q{Add '/#/'};
	ok $r.add( 'GET', 101,   Str, '/' ), q{Add '/*/'};
	ok $r.add( 'GET', 5,     'c', '/' ), q{Add '/c/'};
	ok $r.add( 'GET', 4,     'b' ), q{Add '/b'};
	ok $r.add( 'GET', 1000,  Int ), q{Add '/#'};
	ok $r.add( 'GET', 100,   Str ), q{Add '/*'};
	ok $r.add( 'GET', 2,     'a' ), q{Add '/a'};

	is-deeply [ $r.list( 'GET' ) ],
		[
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
		'/h/i/j'
		], q{List routes};

	},
	q{List routes without leading '/'};

subtest sub
	{
	plan 11;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 10001, 'h', 'i', 'j' ), q{Add '/h/i/j'};
	ok $r.add( 'GET', 104,   Str, Str ), q{Add '/*/*'};
	ok $r.add( 'GET', 103,   'g', Str ), q{Add '/g/*'};
	ok $r.add( 'GET', 1002,  Int, 'f' ), q{Add '/#/f'};
	ok $r.add( 'GET', 102,   Str, 'f' ), q{Add '/*/f'};
	ok $r.add( 'GET', 7,     'd', 'e' ), q{Add '/d/e'};
	ok $r.add( 'GET', 4,     'b' ), q{Add '/b'};
	ok $r.add( 'GET', 1000,  Int ), q{Add '/#'};
	ok $r.add( 'GET', 100,   Str ), q{Add '/*'};
	ok $r.add( 'GET', 2,     'a' ), q{Add '/a'};

	is-deeply [ $r.list( 'GET' ) ],
		[
		'/#(Int)',
		'/#(Int)/f',
		'/#(Str)',
		'/#(Str)/#(Str)',
		'/#(Str)/f',
		'/a',
		'/b',
		'/d/e',
		'/g/#(Str)',
		'/h/i/j'
		], q{List routes};

	},
	q{List routes without any '/'};

subtest sub
	{
	plan 7;

	my $r = App::Prancer::Routes.new;

	nok $r.find( 'GET', '/' ),
		q{Can't find route '/' with no routes specified};
	nok $r.find( 'GET', '/a' ),
		q{Can't find route '/a' with no routes specified};
	nok $r.find( 'GET', '/1' ),
		q{Can't find route '/1' with no routes specified};

	ok $r.add( 'GET', 1, '/' ), q{Add '/'};

	is $r.find( 'GET', '/' ), 1, q{Can find default route};
	nok $r.find( 'GET', '/a' ), q{Can't find route '/a' with default route};
	nok $r.find( 'GET', '/1' ), q{Can't find route '/1' with default route};

	},
	q{Find default route};

subtest sub
	{
	plan 14;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 1, '/' ), q{Add '/'};

	ok $r.add( 'GET', 2, '/', Str ), q{Add '/*'};

	is $r.find( 'GET', '/' ), 1, q{Can find default route};
	is $r.find( 'GET', '/a' ), 2, q{Can find route '/a' with wildcard};
	is $r.find( 'GET', '/1' ), 2, q{Can find route '/1' with wildcard};

	ok $r.add( 'GET', 3, '/', Int ), q{Add '/#'};

	is $r.find( 'GET', '/' ), 1, q{Can find default route};
	is $r.find( 'GET', '/a' ), 2, q{Can find route '/a' with '/*' wildcard};
	is $r.find( 'GET', '/1' ), 3, q{Can find route '/1' with '/#' wildcard};

	ok $r.add( 'GET', 4, '/', 'a' ), q{Add '/a'};

	is $r.find( 'GET', '/' ), 1, q{Can find default route};
	is $r.find( 'GET', '/b' ), 2, q{Can find route '/b' with '/*' wildcard};
	is $r.find( 'GET', '/1' ), 3, q{Can find route '/1' with '/#' wildcard};
	is $r.find( 'GET', '/a' ), 4, q{Can find route '/a' with '/a' route};

	},
	q{Find /foo routes};

subtest sub
	{
	plan 15;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 1, '/', 'a', '/' ), q{Add '/a/'};
	ok $r.add( 'GET', 2, '/', Int, '/' ), q{Add '/#/'};
	ok $r.add( 'GET', 3, '/', Str, '/' ), q{Add '/*/'};

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
	plan 12;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 1, '/', 'a' ), q{Add '/a'};
	ok $r.add( 'GET', 2, '/', Int ), q{Add '/#'};
	ok $r.add( 'GET', 3, '/', Str ), q{Add '/*'};

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
	plan 12;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 1, '/', 'a', '/' ), q{Add '/a/'};
	ok $r.add( 'GET', 2, '/', Int, '/' ), q{Add '/#/'};
	ok $r.add( 'GET', 3, '/', Str, '/' ), q{Add '/*/'};

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
	plan 15;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 21, '/', Int, '/', 'b' ), q{Add '/#/b/'};
	ok $r.add( 'GET', 22, '/', Int, '/', Int ), q{Add '/#/#/'};
	ok $r.add( 'GET', 23, '/', Int, '/', Str ), q{Add '/#/*/'};
	ok $r.add( 'GET', 31, '/', Str, '/', 'b' ), q{Add '/#/b/'};
	ok $r.add( 'GET', 32, '/', Str, '/', Int ), q{Add '/#/#/'};
	ok $r.add( 'GET', 33, '/', Str, '/', Str ), q{Add '/#/*/'};

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
	plan 15;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 11, '/', 'a', '/', 'b' ), q{Add '/a/b/'};
	ok $r.add( 'GET', 12, '/', 'a', '/', Int ), q{Add '/a/#/'};
	ok $r.add( 'GET', 13, '/', 'a', '/', Str ), q{Add '/a/*/'};
	ok $r.add( 'GET', 31, '/', Str, '/', 'b' ), q{Add '/*/b/'};
	ok $r.add( 'GET', 32, '/', Str, '/', Int ), q{Add '/*/#/'};
	ok $r.add( 'GET', 33, '/', Str, '/', Str ), q{Add '/*/*/'};

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
	plan 15;

	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 11, '/', 'a', '/', 'b' ), q{Add '/a/b/'};
	ok $r.add( 'GET', 12, '/', 'a', '/', Int ), q{Add '/a/#/'};
	ok $r.add( 'GET', 13, '/', 'a', '/', Str ), q{Add '/a/*/'};
	ok $r.add( 'GET', 21, '/', Int, '/', 'b' ), q{Add '/#/b/'};
	ok $r.add( 'GET', 22, '/', Int, '/', Int ), q{Add '/#/#/'};
	ok $r.add( 'GET', 23, '/', Int, '/', Str ), q{Add '/#/*/'};

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
	plan 18;
	my $r = App::Prancer::Routes.new;

	ok $r.add( 'GET', 11, '/', 'a', '/', 'b' ), q{Add '/a/b/'};
	ok $r.add( 'GET', 12, '/', 'a', '/', Int ), q{Add '/a/#/'};
	ok $r.add( 'GET', 13, '/', 'a', '/', Str ), q{Add '/a/*/'};
	ok $r.add( 'GET', 21, '/', Int, '/', 'b' ), q{Add '/#/b/'};
	ok $r.add( 'GET', 22, '/', Int, '/', Int ), q{Add '/#/#/'};
	ok $r.add( 'GET', 23, '/', Int, '/', Str ), q{Add '/#/*/'};
	ok $r.add( 'GET', 31, '/', Str, '/', 'b' ), q{Add '/*/b/'};
	ok $r.add( 'GET', 32, '/', Str, '/', Int ), q{Add '/*/#/'};
	ok $r.add( 'GET', 33, '/', Str, '/', Str ), q{Add '/*/*/'};

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
