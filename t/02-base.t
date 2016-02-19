use v6;

use Test;
use Crust::Test;
use App::Prancer::Handler;
my $p = App::Prancer::Handler.new;

$Crust::Test::Impl = "MockHTTP";

sub content-from( $cb, $method, $URL )
	{
	my $req = HTTP::Request.new( GET => $URL );
	my $res = $cb($req);
	return $res.content.decode;
	}

multi GET( '/foo' ) is handler { '/foo' }
multi GET( Str $x ) is handler { '/*' }

multi GET( '/foo', '/foo' ) is handler { '/foo/foo' }
multi GET( '/foo', Str $x ) is handler { '/foo/*' }
multi GET( Str $x, '/foo' ) is handler { '/*/foo' }
multi GET( Str $x, Str $y ) is handler { '/*/*' }

multi GET( '/foo', '/foo', '/foo' ) is handler { '/foo/foo/foo' }
multi GET( '/foo', '/foo', Str $x ) is handler { '/foo/foo/*' }
multi GET( '/foo', Str $x, '/foo' ) is handler { '/foo/*/foo' }
multi GET( '/foo', Str $x, Str $y ) is handler { '/foo/*/*' }
multi GET( Str $x, '/foo', '/foo' ) is handler { '/*/foo/foo' }
multi GET( Str $x, '/foo', Str $y ) is handler { '/*/foo/*' }
multi GET( Str $x, Str $y, '/foo' ) is handler { '/*/*/foo' }
multi GET( Str $x, Str $y, Str $z ) is handler { '/*/*/*' }

test-psgi
	client => -> $cb
		{
		is content-from( $cb, 'GET', '/' ), 'DEFAULT';

		is content-from( $cb, 'GET', '/foo' ), '/foo';
		is content-from( $cb, 'GET', '/bar' ), '/*';

		is content-from( $cb, 'GET', '/foo/foo' ), '/foo/foo';
		is content-from( $cb, 'GET', '/foo/bar' ), '/foo/*';
		is content-from( $cb, 'GET', '/bar/foo' ), '/*/foo';
		is content-from( $cb, 'GET', '/bar/bar' ), '/*/*';

		is content-from( $cb, 'GET', '/foo/foo/foo' ), '/foo/foo/foo';
		is content-from( $cb, 'GET', '/foo/foo/bar' ), '/foo/foo/*';
		is content-from( $cb, 'GET', '/foo/bar/foo' ), '/foo/*/foo';
		is content-from( $cb, 'GET', '/foo/bar/bar' ), '/foo/*/*';
		is content-from( $cb, 'GET', '/bar/foo/foo' ), '/*/foo/foo';
		is content-from( $cb, 'GET', '/bar/foo/bar' ), '/*/foo/*';
		is content-from( $cb, 'GET', '/bar/bar/foo' ), '/*/*/foo';
		is content-from( $cb, 'GET', '/bar/bar/bar' ), '/*/*/*';
		},
	app => $p.make-app;

#`(

plan 1;

#Path  * !              # Str $three
#Path  * * !            # Str $blue Str $Fish
#Path  * /fish !        # Str $red '/fish'
#Path  / !              # '/'
#Path  /one !           # '/one'
#Path  /one /fish !     # '/one' '/fish'
#Path  /two !           # '/two'
#Path  /two * !         # '/two' Str $fish


multi GET( '/' ) is handler { '/' }
multi GET( '/one' ) is handler { '/one' }
multi GET( '/two' ) is handler { '/two' }
multi GET( Str $three ) is handler { '/$three' }
multi GET( '/one', '/fish' ) is handler { '/one/fish' }
multi GET( '/two', Str $fish ) is handler { '/two/$fish' }
multi GET( Str $red, '/fish' ) is handler { '/$red/fish' }
multi GET( Str $blue, Str $Fish ) is handler { '/$blue/$Fish' }

my $p = App::Prancer::Handler.new;

$Crust::Test::Impl = "MockHTTP";

sub content-from( $cb, $method, $URL )
	{
	my $req = HTTP::Request.new( GET => $URL );
	my $res = $cb($req);
	return $res.content.decode;
	}

#`(

'/':
'/one':
'/two':
'/three':
'/one/fish':
'/two/fish':
'/red/fish': 
'/blue/fish': 

)

test-psgi
	client => -> $cb
		{

		is content-from( $cb, 'GET', "http://localhost/" ),
		   '/', '/';

		is content-from( $cb, 'GET', "http://localhost/one" ),
		   '/one', '/one';

		is content-from( $cb, 'GET', "http://localhost/two" ),
		   '/two', '/two';

		is content-from( $cb, 'GET', "http://localhost/three" ),
		   '/$three', '/$three';

		is content-from( $cb, 'GET', "http://localhost/one/fish" ),
		   '/one/fish', '/one/fish';

		is content-from( $cb, 'GET', "http://localhost/two/fish" ),
		   '/two/$fish', '/two/$fish';

		is content-from( $cb, 'GET', "http://localhost/red/fish" ),
		   '/$red/fish', '/$red/fish';

		# Keep the rhyme going, use case sensitivity.
		#
		is content-from( $cb, 'GET', "http://localhost/blue/Fish" ),
		   '/$blue/$Fish', '/$blue/$Fish';
		},
	app => $p.make-app;
)

done-testing;
