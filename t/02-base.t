use v6;

use Test;
use Crust::Test;
use App::Prancer::Handler;

plan 1;
my @result; multi GET( '/' ) is handler { '/' }
multi GET( '/one' ) is handler { '/one' }
multi GET( '/two' ) is handler { '/two' }
multi GET( Str $three ) is handler { '/$three' }
multi GET( '/one', '/fish' ) is handler { '/one/fish' }
multi GET( '/two', Str $fish ) is handler { '/two/$fish' }
multi GET( Str $red, '/fish' ) is handler { '/$red/fish' }
multi GET( Str $blue, Str $fish ) is handler { '/$blue/$fish' }

my $p = App::Prancer::Handler.new;

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
		is content-from( $cb, 'GET', "http://localhost/blue/fish" ),
		   '/$blue/$fish', '/$blue/$fish';
		},
	app => $p.make-app;

done-testing;
