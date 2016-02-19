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

multi GET( ) is handler { '/' }

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
		is content-from( $cb, 'GET', '/' ), '/';

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

done-testing;
