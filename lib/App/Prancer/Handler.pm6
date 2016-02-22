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

=end pod

use App::Prancer::StateMachine;

constant HTTP-REQUEST-METHODS = <DELETE GET HEAD OPTIONS PATCH POST PUT>;
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

my %MIME-type =
	(
	'html'  => 'text/html',
	'htm'   => 'text/html',
	'xhtml' => 'text/html',
	'jpg'	=> 'image/jpeg',
	'png'	=> 'image/png',
	);

class App::Prancer::Handler
	{
	has Bool $!verbose          = False;
	has Bool $!trace            = False;
	has Str  $!static-directory = 'static';

	use Crust::Runner;
	my $state-machine = App::Prancer::StateMachine.new;

	method MIME-type( $filename )
		{
		return 'text/plain' unless $filename ~~ / \.( .+ ) $/;
		return %MIME-type{$0} if %MIME-type{$0};
		return 'text/plain';
		}

	method serve-static( Str $static-directory, $env )
		{
		my $file = $static-directory ~ $env.<PATH_INFO>;
		my $MIME-type = self.MIME-type( $file );

		if $file.IO.e and not $file.IO.d
			{
			return 200,
				[ 'Content-Type' => $MIME-type ],
				[ $file.IO.slurp ]
			}
		}

	method find-in-trie( $trie, @path )
		{
		my $temp = $trie;
		my @args;

		for @path -> $element
			{
			if $temp{"/$element"}
				{
				$temp = $temp{"/$element"};
				push @args, $element;
				}
			elsif $temp{'*(Str)*'}
				{
				$temp = $temp{'*(Str)*'};
				push @args, Str;
				}
			else
				{
				return
				}

			return unless $temp
			}
		return unless $temp;

		my $r = $temp{'*(Routine)*'};

		return [ $r, @args ];
		}

	method display-handlers( )
		{
		return unless $!verbose;

		say self.display-trie(%handler{$_}, $_) for %handler.keys;
		}

	method make-app( )
		{
		self.display-handlers;

		return sub ( $env )
			{
			my $static =
				self.serve-static( $!static-directory, $env );
			return $static if $static;

			my $return-code = $state-machine.run( $env );

			my @path = 
				map { "/$_" },
				$env.<PATH_INFO>.split( '/', :skip-empty );
			@path = '/' unless @path;
			my $content = "DEFAULT";

			my ( $r, $args ) =
				self.find-in-trie(
					%handler{$env.<REQUEST_METHOD>},
					@path
				);
			my @final-args;
			for @path Z @( $args ) -> $arg
				{
				if $arg.[1] ~~ Str:D
					{
					push @final-args, $arg.[0]
					}
				elsif $arg.[0] ~~ /^\/(.+)$/
					{
					push @final-args, ~$0
					}
				else
					{
					push @final-args, ''
					}
				}

			$content = $r(|@final-args) if $r;

			return	200,
				[ 'Content-Type' => 'text/plain' ],
				[ $content ];
			}
		}

	method prance( $verbose, $trace )
		{
		my $runner = Crust::Runner.new;

		$!verbose = $verbose;
		$!trace   = $trace;

		$runner.run( self.make-app );
		}

	method display-trie( $trie, $prefix ) returns Str
		{
		my Str $str;

		for $trie.keys.sort -> $key
			{
			if $trie.{$key} ~~ Sub
				{
				$str ~= "Path $prefix $key\n";
				}
			else
				{
				$str ~= self.display-trie( $trie.{$key}, $prefix ~ ' ' ~ $key );
				}
			}
		return $str;
		}
	}

sub insert-into-trie( $t, @path, $r )
	{
	my ( $head, @rest ) = @path;

	if $head
		{
		if $t.{$head}.defined
			{
			insert-into-trie( $t.{$head}, @rest, $r )
			}
		elsif $head
			{
			$t.{$head} = { '*(Routine)*' => $r }
			}
		}
	else
		{
		$t.{'*(Routine)*'} = $r
		}
	}

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
say $param;
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

	return
		{
		name      => $r.name,
		arguments => @args,
		routine   => $r
		}
	}

multi sub trait_mod:<is>( Routine $r, :$handler! ) is export
	{
	my $info   = routine-to-handler( $r );
	my $method = $info.<name>;

	return unless $method ~~ HTTP-REQUEST-METHODS.any;

	my @wildcard =
		map { $_ ~~ Str ?? $_ !! '*(Str)*' },
		@( $info.<arguments> );
	insert-into-trie( %handler{$method}, @wildcard, $r );
	}

sub prance( ) is export
	{
	my $verbose = False;
	my $trace   = False;
	my $app     = App::Prancer::Handler.new;

	$verbose = True if %*ENV<VERBOSE> and %*ENV<VERBOSE> != 0;
	$trace   = True if %*ENV<TRACE>   and %*ENV<TRACE>   != 0;
	$app.prance( $verbose, $trace );
	}
