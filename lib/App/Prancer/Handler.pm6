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

class App::Prancer::Handler
	{
	has Bool $!trace = False;
	has Str  $!static-directory = 'static';

	use Crust::Runner;

	has Bool $.available = False;

	sub B13-available( $machine, $r )
		{
		return $machine.available ?? 'B12' !! 503
		}
	sub B12-known-method( $machine, $r )
		{
		return ($r.<REQUEST_METHOD> ~~
			  <DELETE GET HEAD OPTIONS PATCH POST PUT>.any)
			  ?? 'B11' !! 501
		}
	constant QUERY-LENGTH-LIMIT = 1024;
	sub B11-uri-too-long( $machine, $r )
		{
		return $r.<QUERY_STRING>.chars > QUERY-LENGTH-LIMIT
			?? 414 !! 'B10'
		}
	sub B10-method-allowed-on-resource( $machine, $r )
		{
my $x = True;
return $x ?? 'B09' !! 405
		}
	sub B09-malformed( $machine, $r )
		{
my $x = False;
return $x ?? 400 !! 'B08'
		}
	sub B08-authorized( $machine, $r )
		{
my $x = True;
return $x ?? 'B07' !! 401
		}
	sub B07-forbidden( $machine, $r )
		{
my $x = True;
return $x ?? 'B07' !! 401
		}
	sub B06-unsupported-content-header( $machine, $r )
		{
my $x = False;
return $x ?? 501 !! 'B05'
		}
	sub B05-unknown-content-type( $machine, $r )
		{
my $x = True;
return $x ?? 'B07' !! 401
		}
	sub B04-request-entity-too-large( $machine, $r )
		{
my $x = False;
return $x ?? 413 !! 'B03'
		}
	sub B03-OPTIONS( $machine, $r )
		{
my $x = False;
return $x ?? 200 !! 'C03'
		}
	sub C03-Accept-exists( $machine, $r )
		{
my $x = True;
return $x ?? 'C04' !! 'D04'
		}
	sub C04-Aceptable-media-type-available( $machine, $r )
		{
my $x = True;
return $x ?? 'C04' !! 406
		}
	sub D04-Accept-Language-exists( $machine, $r )
		{
my $x = True;
return $x ?? 'D05' !! 'E05'
		}
	sub D05-Acceptable-language-available( $machine, $r )
		{
my $x = True;
return $x ?? 'E05' !! 406
		}
	sub E05-Accept-Charset-exists( $machine, $r )
		{
my $x = True;
return $x ?? 'E06' !! 'F06'
		}
	sub E06-Acceptable-charset-available( $machine, $r )
		{
my $x = True;
return $x ?? 'F06' !! 406
		}
	sub F06-Accept-Encoding-exists( $machine, $r )
		{
my $x = True;
return $x ?? 'F07' !! 'G07'
		}
	sub F07-Acceptable-encoding-available( $machine, $r )
		{
my $x = True;
return $x ?? 'G07' !! 406
		}
	sub G07-Resource-exists( $machine, $r )
		{
my $x = True;
return $x ?? 'G08' !! 'H07'
		}
	sub G08-If-Match-exists( $machine, $r )
		{
my $x = True;
return $x ?? 'G09' !! 'H10'
		}
	sub G09-If-Match-star-exists( $machine, $r )
		{
my $x = True;
return $x ?? 'G11' !! 'H10'
		}
	sub G11-Etag-in-If-Match( $machine, $r )
		{
my $x = True;
return $x ?? 'H10' !! 412
		}
	sub H07-If-Match-star-exists( $machine, $r )
		{
my $x = True;
return $x ?? 'G11' !! 'H10'
		}

	has %.state-machine =
		(
		B13 => &B13-available,				# B13-> B12, 503
		B12 => &B12-known-method,			# B12-> B11, 501
		B11 => &B11-uri-too-long,			# B11-> 414, B10
		B10 => &B10-method-allowed-on-resource,		# B10-> B09, 405
		B09 => &B09-malformed,				# B09-> 400, B08
		B08 => &B08-authorized,				# B08-> B07, 401
		B07 => &B07-forbidden,				# B07-> 403, B06
		B06 => &B06-unsupported-content-header,		# B06-> 501, B05
		B05 => &B05-unknown-content-type,		# B05-> 415, B04
		B04 => &B04-request-entity-too-large,		# B04-> 413, B03
		B03 => &B03-OPTIONS,				# B03-> 200, C03
		C03 => &C03-Accept-exists,			# C03-> C04, D04
		C04 => &C04-Aceptable-media-type-available,	# C04-> D04, 406
		D04 => &D04-Accept-Language-exists,		# D04-> D05, E05
		D05 => &D05-Acceptable-language-available,	# D05-> E05, 406
		E05 => &E05-Accept-Charset-exists,		# E05-> E06, F06
		E06 => &E06-Acceptable-charset-available,	# E06-> F06, 406
		F06 => &F06-Accept-Encoding-exists,		# F06-> F07, G07
		F07 => &F07-Acceptable-encoding-available,	# F07-> G07, 406
		G07 => &G07-Resource-exists,			# G07-> G08, H07
		G08 => &G08-If-Match-exists,			# G08-> G09, H10
		G09 => &G09-If-Match-star-exists,		# G09-> G11, H10
		G11 => &G11-Etag-in-If-Match,			# G11-> H10, 412
		H07 => &H07-If-Match-star-exists,		# H07-> 412, I07
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
				@args.append( $path-element );
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

	my %handler =
		(
		DELETE  => { },
		GET     => { },
		HEAD    => { },
		OPTIONS => { },
		PATCH   => { },
		POST    => { },
		PUT     => { },
		);

	multi sub trait_mod:<is>( Routine $r, :$handler! ) is export
		{
		my $info = routine-to-handler( $r );
		return unless $info.<name> ~~
			      <DELETE GET HEAD OPTIONS PATCH POST PUT>.any;
return if @( $info.<arguments> ) != 1;
return if $info.<name> ne 'GET';
## For the moment, sort into literals and one string-ish handler

if $info.<arguments>.[0] ~~ Str
	{
	%handler<GET><literal>{ $info.<arguments>.[0] } = $r;
	say "Loading route '$info.<arguments>.[0]'";
	}
else
	{
	%handler<GET><string> = $r;
	say "Loading route '/Str \$x'";
	}

		}

	sub MIME-type( $filename )
		{
		return 'text/plain' unless $filename ~~ / \.( .+ ) $/;
		my %MIME-type =
			(
			'html'  => 'text/html',
			'htm'   => 'text/html',
			'xhtml' => 'text/html',
			'jpg'	=> 'image/jpeg',
			'png'	=> 'image/png',
			);
		return %MIME-type{$0} if %MIME-type{$0};
		return 'text/plain';
		}

	sub serve-static( Str $static-directory, $env )
		{
		my $file = $static-directory ~ $env.<PATH_INFO>;
		$env.<PATH_INFO> ~~ / \.( .+ ) $/;
		my $MIME-type = MIME-type( $file );
		if $file.IO.e
			{
			return 200,
				[ 'Content-Type' => $MIME-type ],
				[ $file.IO.slurp ]
			}
		}

constant MAX-ITERATIONS = 10;
	method make-app()
		{
		my $trace-on = $!trace;
		return sub ( $env )
			{
			my $static = serve-static( $!static-directory, $env );
			return $static if $static;

			my $state = 'B13';
my $iterations = MAX-ITERATIONS;
			while $state !~~ Int
				{
#say $state;
				unless %.state-machine{$state}
					{
			say "Fell off end of state machine!";
			last;
					}
				$state = %.state-machine{$state}.( self, $env );
last if $iterations-- <= 0;
				}
say "Ended in state $state";
say "Tracing" if $trace-on;

			my @path = ( $env.<PATH_INFO> );
			my $content;

			if @path and %handler<GET><literal>{@path[0]}
				{
				$content = %handler<GET><literal>{@path[0]}(|@path);
				}
			elsif @path and %handler<GET><string>
				{
				$content = %handler<GET><string>(|@path);
				}
			else
				{
				$content = 'Fallback';
				}

			return	200,
				[ 'Content-Type' => 'text/plain' ],
				[ $content ];
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
		}

	sub prance( :$trace = False, :$verbose = False ) is export
		{
		my $app = App::Prancer::Handler.new;
		$app.prance( $trace );
		}
	}
