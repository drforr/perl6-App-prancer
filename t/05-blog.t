use v6;

use Test;
use Crust::Test;
use App::Prancer::Routes;
#my $p = App::Prancer::Handler.new;

$Crust::Test::Impl = "MockHTTP";

#`(
sub content-from( $cb, $method, $URL )
	{
	my $req = HTTP::Request.new( GET => $URL );
	my $res = $cb($req);
	return $res.content.decode;
	}

# Root of the site.
#
multi GET( '' ) is route { '/' }

# Check single-element URL
#
multi GET( '/foo'                ) is route { '/foo'                        }
multi GET( '/post', Str :$format ) is route { "/post?format=%QUERY<format>" }
multi GET( 'bare'                ) is route { '/bare'                       }
multi GET( Int $x                ) is route { "/#{$x}"                      }
multi GET( Str $x                ) is route { "/\${$x}"                     }

# Check that a single argument can be broken in twain.
#
multi GET( '/join/join'   ) is route { "/join/join" }

# Check the permutations of two arguments
#
multi GET( '/foo', '/foo' ) is route { "/foo/foo"   }
multi GET( '/foo', 'bare' ) is route { "/foo/bare"  }
multi GET( '/foo', Str $x ) is route { "/foo/{$x}"  }
multi GET( 'bare', '/foo' ) is route { "/bare/foo"  }
multi GET( 'bare', 'bare' ) is route { "/bare/bare" }
multi GET( 'bare', Str $x ) is route { "/bare/{$x}" }
multi GET( Str $x, '/foo' ) is route { "/{$x}/foo"  }
multi GET( Str $x, 'bare' ) is route { "/{$x}/bare" }
multi GET( Str $x, Str $y ) is route { "/{$x}/{$y}" }

# And permutations of three, but simpler this time, otherwise m**n explosion
#
multi GET( '/foo', '/foo', '/foo' ) is route { "/foo/foo/foo" }
multi GET( '/foo', '/foo', Str $x ) is route { "/foo/foo/{$x}" }
multi GET( '/foo', Str $x, '/foo' ) is route { "/foo/{$x}/foo" }
multi GET( '/foo', Str $x, Str $y ) is route { "/foo/{$x}/{$y}" }
multi GET( Str $x, '/foo', '/foo' ) is route { "/{$x}/foo/foo" }
multi GET( Str $x, '/foo', Str $y ) is route { "/{$x}/foo/{$y}" }
multi GET( Str $x, Str $y, '/foo' ) is route { "/{$x}/{$y}/foo" }
multi GET( Str $x, Str $y, Str $z ) is route { "/{$x}/{$y}/{$z}" }

test-psgi
	client => -> $cb
		{
		is content-from( $cb, 'GET', '/' ), '/';

		subtest sub
			{
			plan 7;

			is content-from( $cb, 'GET', '/foo'  ),
				'/foo';
			is content-from( $cb, 'GET', '/post?format=JSON'  ),
				'/post?format=JSON';
			is content-from( $cb, 'GET', '/user?format=JSON'  ),
				'/user?format=JSON';
			is content-from( $cb, 'GET', '/bare' ),
				'/bare';
			is content-from( $cb, 'GET', '/2016' ),
				'/#2016';
			is content-from( $cb, 'GET', '/bar'  ),
				'/$bar';

			is content-from( $cb, 'GET', '/join/join'   ),
			   '/join/join';
			}, q{Single-element route};

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
			}, q{Two-element route};

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
			}, q{Three-element route};
		},
	app => $p.make-app;
)

done-testing;
