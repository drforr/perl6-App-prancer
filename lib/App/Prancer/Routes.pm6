=begin pod

=head1 App::Prancer::Routes

Lets you define your own custom route using nothing but a
C<is route> trait.

=head1 Synopsis

    use App::Prancer::Routes;

    multi GET( 'posts', Int:D $page ) is route
        { "<html><head/><body>Page $page of posts</body></html>" }

=head1 Documentation

You can define HTTP/1.1 URLs as ordinary Perl 6 subroutines. Name the method
the same as the HTTP/1.1 method you want to capture, and give the URL as the
first argument of your subroutine. To keep clutter to a minimum, each of the
sample route blocks will simply return an exact copy of their URL, excepting
a few cases where we want to point out differences.

    GET /posts HTTP/1.1 # can be captured as:
    multi GET( 'posts' ) is route
      { return "/posts" }

If your URL has more than one path element in them, you can use the C</>
path separator, or list the two path elements as separate arguments.

    multi GET( 'posts/page' ) is route { }
    multi GET( 'posts', 'page' ) is route
      { return "/posts/page" }

are the same route. If you want to use more of a REST-style URL, you can
use ordinary Perl parameters as part of your parameter list.

    GET /posts/DrForr HTTP/1.1
    multi GET( 'posts', Str:D $username ) is route
      { return "/posts/$username" }

You can use regular expressions in your URLs as well, just use a constraint as
you normally would in Perl 6. Regular expression matches are tried first,
followed by any catchall terms you may have supplied.

    GET /team/jersey-devils HTTP/1.1
    multi GET( 'team', Str:D $team where { /\w+\-\w+/ } ) is route
      { return "/team/$team (hyphenated)" }
    multi GET( 'team', Str:D $team ) is route
      { return "/team/$team" }

Last, but not least, wildcards are also just Perl variables. If you want to
match anything, just declare a parameter with no types. Or if you want to
match anything under a given URL, declare an array which will be filled with
the rest of the path. Not a slurpy array though, that does something different.

    GET /path/to/my/deeply-buried-avatar.png HTTP/1.1
    multi GET( 'path', $to, @path-to-avatar ) is route
      { return "/path/$to/{@path-to-avatar.join('/')}" }

=head1 Ordering

=head1 Arguments

=head2 Query arguments

Of course, any method can take query arguments. The simplest way to address
this is by including them as optional parameters.

    GET /post/?slug=my_amazing_post&id=1 HTTP/1.1
    multi GET( 'post', :$slug, :$id ) is route
      { return "/post/?slug=$slug\&id=$id" }

Or, if you'd prefer not to clutter up your argument list, you can use the
C<$*QUERY> variable that L<Prancer> provides. This will be a
C<Hash::MultiValue> object as keys can occur multiple times in a given query.

    GET /post/?slug=my_amazing_post&id=1 HTTP/1.1
    multi GET( 'post' ) is route
      { return "/post/?slug=$*QUERY.<slug>\&id=$*QUERY.<id>" }

=head2 Form parameters

Likewise, C<POST> methods have form content, so look for that in the C<$*BODY>
argument.

    POST /post HTTP/1.1 [slug=value, id=value]
    multi POST( 'post' ) is route
      { return "/post/?slug=$*BODY.<slug>\&id=$*BODY.<id>" }

=head2 Cookies

If you need session management, you can use C<App::Prancer::Plugin::Session>
and add C<$*SESSION> to manipulate user sessions. Otherwise use C<$*COOKIES>
to view and update cookies.

=head1 Fallback

Ultimately if none of these methods work for your URL, you can always ask to
have the original L<Crust> C<$env> variable passed to you in C<%*ENV>:

    POST /post HTTP/1.1 [slug=value, id=value]
    multi POST( 'post' ) is route
      { return "/post/?slug=$*ENV.post_parameters.<slug>" }

=head1 Calling order

=over

=item Static files

=item Dynamic routes with only literal terms

=item Dynamic routes with C<Int> variables

=item Dynamic routes with C<Str> variables

=item Otherwise a 404 File Not Found response is returned.

=back

Parameters are checked from left to right, so if two or more route can match
a given path, the one that matches the first term wins. Take a look at
C<find-route> in L<App::Prancer::Routes> for more information, or see the test
suite.

=end pod

use Crust::Runner;
use Crust::MIME;
use App::Prancer::Core;
use App::Prancer::Sessions;
use App::Prancer::StateMachine;

#my $uri = URI.new( "$env.<p6sgi.url-scheme>://$env.<REMOTE_HOST>$env.<PATH_INFO>?$env.<QUERY_STRING>" );

#constant HTTP-REQUEST-METHODS =
#	<DELETE GET HEAD OPTIONS PATCH POST PUT>;

our $PRANCER-INTERNAL-ROUTES   = App::Prancer::Core.new;
our $PRANCER-INTERNAL-SESSIONS = App::Prancer::Sessions.new;
our $PRANCER-STATE-MACHINE     = App::Prancer::StateMachine.new;

sub routine-to-route( Routine $r )
	{
	my @parameters;

	for $r.signature.params -> $param
		{
		next if $param.optional;

		my $rv;
		if $param.name { $rv = '#(' ~ $param.type.perl ~ ')' }
		else           { $rv = param-to-string( $param ) }

		@parameters.append( $rv );
		}

	return @parameters
	}

sub param-to-string( $param )
	{
	my $path-element;

	# XXX Not sure why this is necessary, except for
	# XXX $param.constraints being a junction
	#
	for $param.constraints -> $constraint
		{
		return $constraint;
		}
	}

my class Route-Info
	{
	has Routine $.r;
	has @.args;
	has @.optional-args;
	has %.map;
	}

sub URL-to-route-map( @names )
	{
	my $strung = '/' ~ @names.join( '/' );
	$strung ~~ s:g/\/+/\//;
	my %map;
	my @canon = grep { $_ ne '' }, map { ~$_ }, $strung.split( /\//, :v );
	my @value;
	for ^@names.elems -> $value
		{
		next unless @names[$value] ~~ /^\#/;

		@value.push( $value )
		}

	for ^@canon.elems -> $key
		{
		next unless @canon[$key] ~~ /^\#/;

		%map{$key} = shift @value
		}

	return %map
	}

multi sub trait_mod:<is>( Routine $r, :$route! ) is export(:testing,:MANDATORY)
	{
	my $name  = $r.name;
	my @names = routine-to-route( $r );
	my $path  = @names.join('/');
	$path ~~ s:g/\/+/\//;
	my @path  = grep { $_ ne '' }, map { ~$_ }, $path.split(/\//, :v);

	my %map = URL-to-route-map( @names );
	my @optional;
	for $r.signature.params -> $param
		{
		next unless $param.optional;
		$param.name ~~ /^\$(.+)/;
		@optional.push( '#(' ~ $param.type.^name ~ '):' ~ $param.name )
		}

	my $info = Route-Info.new(
		:r( $r ),
		:args( @names ),
		:map( %map ),
		:optional-args( @optional )
	);

	$PRANCER-INTERNAL-ROUTES.add( $name, $info, @path );
	}

# XXX Assign relative path correctly
constant ABSOLUT-KITTEH = "/home/jgoff/Repositories/perl6-App-prancer/theperlfisher.blogspot.ro/response-kittehs";
constant STATIC-DIRECTORY = "/home/jgoff/Repositories/perl6-App-prancer/theperlfisher.blogspot.ro/static";

use Crust::Request;
use Cookie::Baker;

sub make-optional-args( $info, $req )
	{
	my @optional-args;

	for $info.optional-args -> $optional
		{
		$optional ~~ /^\#\((.+)\)\:\$(.+)/;
		my $name = $1;
		my $value;
		if $0 eq 'Str'
			{
			$value = ~$req.query-parameters.{$1};
			}
		elsif $0 eq 'Int'
			{
			$value = +$req.query-parameters.{$1};
			}
		@optional-args.push( $name => $value );
		}
	return @optional-args
	}

sub app( $env ) is export(:testing,:ALL)
	{
	my ( @content, %header );
	my $req            = Crust::Request.new($env);
	my $request-method = $env.<REQUEST_METHOD>;
	say "$env.<REQUEST_METHOD> $env.<PATH_INFO>?$env.<QUERY_STRING>"
		if %*ENV<PRANCER-TRACE>;
	my @path;
	for $env.<PATH_INFO>.split(/\//, :v) -> $x
		{
		next if $x eq '';
		my $foo = $x;

		if $x ~~ Match
			{ $foo = ~$x }
		elsif $x ~~ /^'-'?\d+/
			{ $foo = +$x }

		@path.append( $foo )
		}

	my $info = $PRANCER-INTERNAL-ROUTES.find(
			$request-method, $env.<PATH_INFO> );

	if $info
		{
		my @args = $info.args;
		for $info.map.keys -> $arg
			{
			@args[$info.map.{$arg}] = @path[$arg]
			}

		my $*PRANCER-SESSION;
		my %cookies;
		if $env.<HTTP_COOKIE>
			{
			%cookies = crush-cookie( $env.<HTTP_COOKIE> );
			if %cookies<session>
				{
				$*PRANCER-SESSION =
					$PRANCER-INTERNAL-SESSIONS.find(
						%cookies<session> );
				}
			}

		if $env.<QUERY_STRING> ne '' and $info.optional-args.elems
			{
			my @optional-args = make-optional-args( $info, $req );

			@content = $info.r.( |@args, |%(@optional-args) );
			}
		else
			{
			@content = $info.r.( |@args );
			}

		if $*PRANCER-SESSION.defined
			{
			my $cookie;
			if %cookies<session>
				{
				my $current-id = %cookies<session>;
				$PRANCER-INTERNAL-SESSIONS.set(
					$current-id, $*PRANCER-SESSION );
				}
			else
				{
				my $new-id =
					$PRANCER-INTERNAL-SESSIONS.add(
						$*PRANCER-SESSION );
				$cookie = bake-cookie('session', $new-id );
				%header<Set-Cookie> = $cookie;
				}
			}

		%header<Content-Type> = 'text/html';
		}
	else
		{
		my $file = STATIC-DIRECTORY ~ $env.<PATH_INFO>;
		if $file.IO.e
			{
			my $MIME-type = Crust::MIME.mime-type( $file );
			if $MIME-type ~~ /text/
				{
				@content = ( $file.IO.slurp );
				}
			else
				{
				@content = ( $file.IO.slurp :bin );
				}

			%header<Content-Type> = $MIME-type;
			}
		else
			{
			my $response-code = $PRANCER-STATE-MACHINE.run($env);
			unless $response-code == 200
				{
				my $kitteh = ABSOLUT-KITTEH ~
					"/$response-code.jpg";
				@content = $kitteh.IO.slurp :bin;
				%header<Content-Type> = 'image/jpeg';
				}
			}
		}

	return 200, [ %header ], [ @content ]
	}

sub display() is export(:testing)
	{
	for $PRANCER-INTERNAL-ROUTES.available -> $method
		{
		say "$method:";
		.say for map { "  $_" }, $PRANCER-INTERNAL-ROUTES.list( $method );
		}
	}

sub prance() is export
	{
	my $runner = Crust::Runner.new;
	display if %*ENV<PRANCER-VERBOSE>;

	# Tell the state machine that the service is available.
	#
	$PRANCER-STATE-MACHINE.make-available;
	$runner.run( &app )
	}
