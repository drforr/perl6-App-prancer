use v6;

use Test;
use Crust::Test;
use App::Prancer::Routes :testing;

multi GET( '/' ) is route { 'GET / HTTP/1.1 OK' }

multi GET( '/regression-1', '/', Int $profile-ID ) is route
	{
	"GET /regression-1/$profile-ID HTTP/1.1 OK"
	}

multi GET( '/regression-1a', Int $profile-ID ) is route
	{
	"GET /regression-1a/$profile-ID HTTP/1.1 OK"
	}

multi GET( Int $x, '/', Int $y, '/',  'regression-2.html' ) is route
	{
	sprintf "GET /%04d/%02d/regression-2.html HTTP/1.1 OK", $x, $y
	}

multi GET( '/regression-3',
	   Str :$updated-min, Str :$updated-max, Int :$max-results ) is route
	{
	my $rest = "?updated-min=$updated-min" .
		   "\&updated-max=$updated-max" .
		   "\&max-results=$max-results";
	return "GET /regression-3$rest HTTP/1.1 OK";
	}

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
			q{GET / HTTP/1.1 OK},
			q{GET /};
		is content-from( $cb, 'GET',
				 '/regression-1/18252182597447689159' ),
			q{GET /regression-1/18252182597447689159 HTTP/1.1 OK},
			q{GET /regression-1/18252182597447689159};
		is content-from( $cb, 'GET',
				 '/regression-1a/18252182597447689159' ),
			q{GET /regression-1a/18252182597447689159 HTTP/1.1 OK},
			q{GET /regression-1a/18252182597447689159};
		is content-from( $cb, 'GET',
				 '/2016/02/regression-2.html' ),
			q{GET /2016/02/regression-2.html HTTP/1.1 OK},
			q{GET /2016/02/regression-2.html};
		is content-from( $cb, 'GET',
				 '/regression-3?updated-min=2016-01-01T00:00:00%2B02:00&updated-max=2017-01-01T00:00:00%2B02:00&max-results=6' ),
			q{GET /regression-3?updated-min=2016-01-01T00:00:00+02:00&updated-max=2017-01-01T00:00:00+02:00&max-results=6 HTTP/1.1 OK},
			q{GET /regression-3?updated-min=2016-01-01T00:00:00+02:00&updated-max=2017-01-01T00:00:00+02:00&max-results=6 HTTP/1.1 OK};
		},
	app => &app;

done-testing;
