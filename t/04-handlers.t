use v6;

use Test;
use Crust::Test;
use App::Prancer::Handler :testing;

# Don't worry about handler ordering, that was taken care of in
# 03-handler-utils.t

multi GET( '/' ) is handler { 'GET / HTTP/1.0 OK' }
multi GET( '/', 'a' ) is handler { 'GET /a HTTP/1.0 OK' }
multi GET( '/', 'b' ) is handler { 'GET /b HTTP/1.0 OK' }
multi GET( '/', Int $x ) is handler { "GET /$x HTTP/1.0 OK" }
multi GET( '/', 'a', '/' ) is handler { 'GET /a/ HTTP/1.0 OK' }
multi GET( '/', 'b', '/' ) is handler { 'GET /b/ HTTP/1.0 OK' }

$Crust::Test::Impl = "MockHTTP";

sub content-from( $cb, $method, $URL )
	{
	my $req = HTTP::Request.new( GET => $URL );
	my $res = $cb($req);
	return $res.content.decode;
	}

test-psgi
	client => -> $cb
		{
		is content-from( $cb, 'GET', '/' ),
			q{GET / HTTP/1.0 OK},
			q{GET /};
		is content-from( $cb, 'GET', '/a' ),
			q{GET /a HTTP/1.0 OK},
			q{GET /a};
		is content-from( $cb, 'GET', '/b' ),
			q{GET /b HTTP/1.0 OK},
			q{GET /b};
#		is content-from( $cb, 'GET', '/1' ),
#			q{GET /#1 HTTP/1.0 OK},
#			q{GET /1};
		is content-from( $cb, 'GET', '/a/' ),
			q{GET /a/ HTTP/1.0 OK},
			q{GET /a/};
		is content-from( $cb, 'GET', '/b/' ),
			q{GET /b/ HTTP/1.0 OK},
			q{GET /b/};
		},
	app => &app;

done-testing;
