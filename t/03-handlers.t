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

# Root of the site.
#
multi GET( '' ) is handler { '/' }

# Check single-element URL
#
multi GET( '/foo' ) is handler { '/foo' }
multi GET( 'bare' ) is handler { '/bare' }
multi GET( Int $x ) is handler { "/#{$x}" }
multi GET( Str $x ) is handler { "/{$x}" }

# Check that a single argument can be broken in twain.
#
multi GET( '/join/join'   ) is handler { "/join/join" }

# Check the permutations of two arguments
#
multi GET( '/foo', '/foo' ) is handler { "/foo/foo"   }
multi GET( '/foo', 'bare' ) is handler { "/foo/bare"  }
multi GET( '/foo', Str $x ) is handler { "/foo/{$x}"  }
multi GET( 'bare', '/foo' ) is handler { "/bare/foo"  }
multi GET( 'bare', 'bare' ) is handler { "/bare/bare" }
multi GET( 'bare', Str $x ) is handler { "/bare/{$x}" }
multi GET( Str $x, '/foo' ) is handler { "/{$x}/foo"  }
multi GET( Str $x, 'bare' ) is handler { "/{$x}/bare" }
multi GET( Str $x, Str $y ) is handler { "/{$x}/{$y}" }

# And permutations of three, but simpler this time, otherwise m**n explosion
#
multi GET( '/foo', '/foo', '/foo' ) is handler { "/foo/foo/foo" }
multi GET( '/foo', '/foo', Str $x ) is handler { "/foo/foo/{$x}" }
multi GET( '/foo', Str $x, '/foo' ) is handler { "/foo/{$x}/foo" }
multi GET( '/foo', Str $x, Str $y ) is handler { "/foo/{$x}/{$y}" }
multi GET( Str $x, '/foo', '/foo' ) is handler { "/{$x}/foo/foo" }
multi GET( Str $x, '/foo', Str $y ) is handler { "/{$x}/foo/{$y}" }
multi GET( Str $x, Str $y, '/foo' ) is handler { "/{$x}/{$y}/foo" }
multi GET( Str $x, Str $y, Str $z ) is handler { "/{$x}/{$y}/{$z}" }

test-psgi
	client => -> $cb
		{
		is content-from( $cb, 'GET', '/' ), '/';

		subtest sub
			{
			plan 5;

			is content-from( $cb, 'GET', '/foo'  ), '/foo';
			is content-from( $cb, 'GET', '/bare' ), '/bare';
			is content-from( $cb, 'GET', '/2016' ), '/#2016';
			is content-from( $cb, 'GET', '/bar'  ), '/bar';

			is content-from( $cb, 'GET', '/join/join'   ),
			   '/join/join';
			}, q{Single-element handlers};

		subtest sub
			{
			plan 9;

			is content-from( $cb, 'GET', '/foo/foo'   ),
			   '/foo/foo';
			is content-from( $cb, 'GET', '/foo/bare'  ),
			   '/foo/bare';
			is content-from( $cb, 'GET', '/foo/bar'   ),
			   '/foo/bar';
			is content-from( $cb, 'GET', '/bare/foo'  ),
			   '/bare/foo';
			is content-from( $cb, 'GET', '/bare/bare' ),
			   '/bare/bare';
			is content-from( $cb, 'GET', '/bare/bar'  ),
			   '/bare/bar';
			is content-from( $cb, 'GET', '/bar/foo'   ),
			   '/bar/foo';
			is content-from( $cb, 'GET', '/bar/bare'  ),
			   '/bar/bare';
			is content-from( $cb, 'GET', '/bar/bar'   ),
			   '/bar/bar';
			}, q{Two-element handlers};

		subtest sub
			{
			plan 8;

			is content-from( $cb, 'GET', '/foo/foo/foo' ),
			   '/foo/foo/foo';
			is content-from( $cb, 'GET', '/foo/foo/bar' ),
			   '/foo/foo/bar';
			is content-from( $cb, 'GET', '/foo/bar/foo' ),
			   '/foo/bar/foo';
			is content-from( $cb, 'GET', '/foo/bar/bar' ),
			   '/foo/bar/bar';
			is content-from( $cb, 'GET', '/bar/foo/foo' ),
			   '/bar/foo/foo';
			is content-from( $cb, 'GET', '/bar/foo/bar' ),
			   '/bar/foo/bar';
			is content-from( $cb, 'GET', '/bar/bar/foo' ),
			   '/bar/bar/foo';
			is content-from( $cb, 'GET', '/bar/bar/bar' ),
			   '/bar/bar/bar';
			}, q{Three-element handlers};
		},
	app => $p.make-app;

done-testing;
