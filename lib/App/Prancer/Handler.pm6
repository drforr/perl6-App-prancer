=begin pod

=head1 App::Prancer::Handler

Lets you define your own custom route handlers using nothing but a
C<is handler> trait.

=head1 Synopsis

    use App::Prancer::Handler;

    multi GET( 'posts', Int:D $page ) is handler
        { "<html><head/><body>Page $page of posts</body></html>" }

=head1 Documentation

You can define HTTP/1.1 URLs as ordinary Perl 6 subroutines. Name the method
the same as the HTTP/1.1 method you want to capture, and give the URL as the
first argument of your subroutine. To keep clutter to a minimum, each of the
sample handler blocks will simply return an exact copy of their URL, excepting
a few cases where we want to point out differences.

    GET /posts HTTP/1.1 # can be captured as:
    multi GET( 'posts' ) is handler
      { return "/posts" }

If your URL has more than one path element in them, you can use the C</>
path separator, or list the two path elements as separate arguments.

    multi GET( 'posts/page' ) is handler { }
    multi GET( 'posts', 'page' ) is handler
      { return "/posts/page" }

are the same handler. If you want to use more of a REST-style URL, you can
use ordinary Perl parameters as part of your parameter list.

    GET /posts/DrForr HTTP/1.1
    multi GET( 'posts', Str:D $username ) is handler
      { return "/posts/$username" }

You can use regular expressions in your URLs as well, just use a constraint as
you normally would in Perl 6. Regular expression matches are tried first,
followed by any catchall terms you may have supplied.

    GET /team/jersey-devils HTTP/1.1
    multi GET( 'team', Str:D $team where { /\w+\-\w+/ } ) is handler
      { return "/team/$team (hyphenated)" }
    multi GET( 'team', Str:D $team ) is handler
      { return "/team/$team" }

Last, but not least, wildcards are also just Perl variables. If you want to
match anything, just declare a parameter with no types. Or if you want to
match anything under a given URL, declare an array which will be filled with
the rest of the path. Not a slurpy array though, that does something different.

    GET /path/to/my/deeply-buried-avatar.png HTTP/1.1
    multi GET( 'path', $to, @path-to-avatar ) is handler
      { return "/path/$to/@path-to-avatar" }

=head1 Ordering

=head1 Query arguments

Of course, any method can take arguments afterward. You can generally access
those in two ways. Declare a C<$QUERY> parameter if you want to capture all
of the arguments from the URL. Note that this is a C<Hash::MultiValue> object
because there may be more than one instance of an argument in the URL. There
probably shouldn't be, but there's no accounting for taste, or malicious users
trying to inject data.

    GET /post/?slug=my_amazing_post&id=1 HTTP/1.1
    multi GET( 'post', $QUERY ) is handler
      { return "/post/?slug=$QUERY.<slug>\&id=$QUERY.<id>" }

Your existing HTML may already pass in an argument named C<QUERY>, so feel free
to use the destructuring-bind version of the call, if that's the case. Or just
check the global %QUERY hash. (This may change, once I figure out a better way
to pass out-of-band information to your function.)

    GET /post/?slug=my_amazing_post&id=1 HTTP/1.1
    multi GET( 'post', [ $slug, $id ] ) is handler
      { return "/post/?slug=$slug\&id=$id" }

=head1 Form parameters

It's common for forms to have parameters in their bodies, so we pass back
either C<$BODY> for that, or pass the variables back to the destructuring-bind
arguments.

    POST /post HTTP/1.1 [slug=value, id=value]
    multi POST( 'post', $QUERY ) is handler
      { return "/post/?slug=$QUERY.<slug>\&id=$QUERY.<id>" }
    multi POST( 'post', [ $slug, $id ] ) is handler
      { return "/post/?slug=$slug\&id=$id" }

=head1 Fallback

Ultimately if none of these methods work for your URL, you can always ask to
have the original L<Crust> C<$env> variable passed to you:

    POST /post HTTP/1.1 [slug=value, id=value]
    multi POST( 'post', $CRUST_ENV ) is handler
      { return "/post/?slug=$CRUST_ENV.post_parameters.<slug>" }

=head1 Calling order

Generally L<Prancer> tries to call the most specific method it can for a given
URL. Literal parameters (C<'foo'>) are tried first, followed by regular
expressions, then types, followed by untyped parameters. If all else fails,
the array fallbacks are checked. If those should fail, it looks in the C<static>
directory for files to serve, otherwise it throws a 404 message.

When it's been integrated it'll use Riak's WebMachine state diagram to actually
handle the return codes, that's an eventual improvement.

=end pod

#`(
[ERROR] [8272] [5] HTTP_ACCEPT  text/html,application/xhtml+xml,application/xml;
q=0.9,*/*;q=0.8
HTTP_ACCEPT_ENCODING    gzip, deflate
HTTP_ACCEPT_LANGUAGE    en-US,en;q=0.5
HTTP_CACHE_CONTROL      max-age=0
HTTP_CONNECTION keep-alive
HTTP_HOST       127.0.0.1:5000
HTTP_USER_AGENT Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:38.0) Gecko/20100101 
Firefox/38.0
PATH_INFO       /
QUERY_STRING
REQUEST_METHOD  GET
REQUEST_URI     /
SCRIPT_NAME
SERVER_NAME     127.0.0.1
SERVER_PORT     5000
SERVER_PROTOCOL HTTP/1.1
p6sgi.errors    <STDERR>
p6sgi.input
p6sgi.url-scheme        http
p6sgix.io       IO::Socket::Async<139621116757968>   in method throw at gen/moar
/m-CORE.setting line 20061
)

class App::Prancer::Handler
	{
	has Bool $!trace = False;
	has Str  $!static-directory = 'static/';

	use Crust::Runner;

	has Bool $.available = False;

	sub M-available( $machine, $r )
		{
		return $machine.available ?? 'B12' !! 503
		}
	sub M-known-method( $machine, $r )
		{
		return ($r.<REQUEST_METHOD> ~~
			  <DELETE GET HEAD OPTIONS PATCH POST PUT>.any)
			  ?? 'B11' !! 501
		}
	constant QUERY-LENGTH-LIMIT = 1024;
	sub M-uri-too-long( $machine, $r )
		{
		return $r.<QUERY_STRING>.chars > QUERY-LENGTH-LIMIT
			?? 414 !! 'B10'
		}
	sub M-method-allowed-on-resource( $machine, $r )
		{
my $x = True;
return $x ?? 'B09' !! 405
		}
	sub M-malformed( $machine, $r )
		{
my $x = False;
return $x ?? 400 !! 'B08'
		}
	sub M-authorized( $machine, $r )
		{
my $x = True;
return $x ?? 'B07' !! 401
		}
	sub M-forbidden( $machine, $r )
		{
my $x = True;
return $x ?? 'B07' !! 401
		}
	sub M-unsupported-content-header( $machine, $r )
		{
my $x = False;
return $x ?? 501 !! 'B05'
		}
	sub M-unknown-content-type( $machine, $r )
		{
my $x = True;
return $x ?? 'B07' !! 401
		}
	sub M-request-entity-too-large( $machine, $r )
		{
my $x = False;
return $x ?? 413 !! 'B03'
		}
	sub M-OPTIONS( $machine, $r )
		{
my $x = False;
return $x ?? 200 !! 'C03'
		}

	has %.state-machine =
		(
		B13 => &M-available,			# B13 -> B12 or 503
		B12 => &M-known-method,			# B12 -> B11 or 501
		B11 => &M-uri-too-long,			# B11 -> 414 or B10
		B10 => &M-method-allowed-on-resource,	# B10 -> B09 or 405
		B09 => &M-malformed,			# B09 -> 400 or B08
		B08 => &M-authorized,			# B08 -> B07 or 401
		B07 => &M-forbidden,			# B07 -> 403 or B06
		B06 => &M-unsupported-content-header,	# B06 -> 501 or B05
		B05 => &M-unknown-content-type,		# B05 -> 415 or B04
		B04 => &M-request-entity-too-large,	# B04 -> 413 or B03
		B03 => &M-OPTIONS,			# B03 -> 200 or C03
		);

	sub routine-to-handler( Routine $r )
		{
		my $name      = $r.name;
		my $signature = $r.signature;
		my @params    = $signature.params;
		my @args;

		for $signature.params -> $param
			{
			if $param.name
				{
				@args.push( [ $param.type => $param.name ] )
				}
			else
				{
				my $path-element;

				# XXX Not sure why this is necessary, except for
				# XXX $param.constraints being a junction
				#
				for $param.constraints -> $constraint
					{
					$path-element = $constraint;
					last;
					}
				my @path = $path-element.split( '/', :skip-empty );
				@args.append( @path );
				}
			}
		@args = ( Nil ) if !@args;

		return
			{
			name      => $r.name,
			arguments => @args,
			routine   => $r
			}
		}

	my $trie = {};
	my %handler =
		(
		DELETE  => [ ],
		GET     => [ ],
		HEAD    => [ ],
		OPTIONS => [ ],
		PATCH   => [ ],
		POST    => [ ],
		PUT     => [ ],
		);

#`( Ignoring regex, Int and Str for the moment:

GET / HTML/1.1 OK
GET /post HTML/1.1 OK
GET /post/2016/02/my_post HTML/1.1 OK

)

	sub insert-routine( @args, $r )
		{
		$trie.{@args[0]} = $r;
		}

	multi sub trait_mod:<is>( Routine $r, :$handler! ) is export
		{
		$trie.<x> = 1;
		my $info = routine-to-handler( $r );
		return unless $info.<name> ~~
			      <DELETE GET HEAD OPTIONS PATCH POST PUT>.any;
		}

constant MAX-ITERATIONS = 10;
	method make-app()
		{
		my $trace-on = $!trace;
		return sub ( $env )
			{
my $state = 'B13';
my $iterations = MAX-ITERATIONS;
while $state !~~ Int
	{
say $state;
unless %.state-machine{$state}
	{
say "Fell off end of state machine!";
last;
	}
	$state = %.state-machine{$state}.( self, $env );
last if $iterations-- <= 0;
	}
say $state;
say "Tracing" if $trace-on;
			return	200,
				[ 'Content-Type' => 'text/plain' ],
				[ "Fallback" ]
			}
		}

	method prance( $trace )
		{
		$!trace = $trace;
		my $runner = Crust::Runner.new;
		$!available = True;
		$runner.run( self.make-app );
		}

	method display-routes()
		{
		for my $trie.keys -> $key
			{
			}
		}

	sub prance( :$trace = False, :$verbose = False ) is export
		{
		my $app = App::Prancer::Handler.new;
#		$app.display-routes if $verbose;
say $trie if $verbose;
say $trie;
		$app.prance( $trace );
		}
	}
