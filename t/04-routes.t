use v6;

use Test;
use Crust::Test;
use App::Prancer::Routes :testing;

# Don't worry about route ordering, that was taken care of in
# 03-route-utils.t

my class BlogID   is Int {};
my class UserName is Str {};

#`(
multi GET( '/' ) is route { 'GET / HTTP/1.0 OK' }
multi GET( '/', 'a' ) is route { 'GET /a HTTP/1.0 OK' }
multi GET( '/', 'b' ) is route { 'GET /b HTTP/1.0 OK' }
multi GET( '/', Int $x ) is route { "GET /#$x HTTP/1.0 OK" }
multi GET( '/', Str $x ) is route { "GET /*$x HTTP/1.0 OK" }
multi GET( '/', 'a', '/' ) is route { 'GET /a/ HTTP/1.0 OK' }
multi GET( '/', 'b', '/' ) is route { 'GET /b/ HTTP/1.0 OK' }
multi GET( '/', Int $x, '/' ) is route { "GET /#$x/ HTTP/1.0 OK" }
multi GET( '/', Str $x, '/' ) is route { "GET /*$x/ HTTP/1.0 OK" }
)
multi GET( '/', 'blog', '/', BlogID $x, ) is route
	{ "GET /blog/#(BlogID)$x HTTP/1.0 OK" }

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
#`(
		is content-from( $cb, 'GET', '/' ),
			q{GET / HTTP/1.0 OK},
			q{GET /};
		is content-from( $cb, 'GET', '/a' ),
			q{GET /a HTTP/1.0 OK},
			q{GET /a};
		is content-from( $cb, 'GET', '/b' ),
			q{GET /b HTTP/1.0 OK},
			q{GET /b};
		is content-from( $cb, 'GET', '/1' ),
			q{GET /#1 HTTP/1.0 OK},
			q{GET /#1};
		is content-from( $cb, 'GET', '/c' ),
			q{GET /*c HTTP/1.0 OK},
			q{GET /*c};
		is content-from( $cb, 'GET', '/a/' ),
			q{GET /a/ HTTP/1.0 OK},
			q{GET /a/};
		is content-from( $cb, 'GET', '/b/' ),
			q{GET /b/ HTTP/1.0 OK},
			q{GET /b/};
		is content-from( $cb, 'GET', '/1/' ),
			q{GET /#1/ HTTP/1.0 OK},
			q{GET /#1/};
		is content-from( $cb, 'GET', '/c/' ),
			q{GET /*c/ HTTP/1.0 OK},
			q{GET /*c/};
)
		is content-from( $cb, 'GET', '/blog/1234' ),
			q{GET /blog/#(BlogID)1234 HTTP/1.0 OK},
			q{GET /blog/#1234};
		},
	app => &app;

done-testing;
