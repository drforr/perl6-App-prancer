=begin pod

=head1 App::Prancer::Routes

Insert, display and search for application routes.

=head1 Synopsis

    use App::Prancer::Routes;

    my $routes = App::Prancer::Routes.new;
    $routes.add( 1, '/', 'a' );
    $routes.add( 2, '/', Str );
    say $routes.find( '/', 'a' ); # 1

=head1 Documentation

Add, find and display Prancer routes.

=over

=item add( $info, '/', 'a' )

Add a route '/a' to the internal trie. C<$info> can be anything you like, and
is untyped. In real-world usage this would contain a Routine object and likely
more information about calling semantics and whatnot. It's untyped for testing
so that we can pass simple integers in to prove that the object going in is
what comes out.

=item find( '/', 'a' )

Find a route '/a' in the internal trie, and return its associated info.

=item list()

Return a list of all routes in the trie, compressed from the internal structure
into a list of strings.

=back

=end pod

class App::Prancer::Routes
	{
	has $.routes =
		{
		DELETE  => { },
		GET     => { },
		HEAD    => { },
		OPTIONS => { },
		PATCH   => { },
		POST    => { },
		PUT     => { },
		};

	sub add-route( $routes, $node, *@terms )
		{
		die "Shouldn't happen" unless @terms;
		my ( $head, @tail ) = @terms;

		#
		# Yes, this should be a proper uninitialized object, but that causes
		# all kinds of havoc with hash lookups and whatnot.
		#
		# Also, '#' is illegal in URLs because otherwise it's an anchor tag.
		#
		unless $head ~~ Str:D
			{
			$head = '#(' ~ $head.WHAT.perl ~ ')'
			}

		if @tail
			{
			if $routes.{$head}
				{
				if $routes.{$head} ~~ Int or
					$routes.{$head} ~~ Route-Info
					{
					$routes.{$head} = { '' => $routes.{$head} };
					}
				else
					{
					}
				}
			else
				{
				$routes.{$head} = { };
				}
			add-route( $routes.{$head}, $node, @tail );
			}
		elsif $routes.{$head}
			{
			if $routes.{$head} ~~ Int or $routes.{$head} ~~ Route-Info
				{
				$routes.{$head} = { '' => $routes.{$head} };
				}
			else
				{
				$routes.{$head}{''} = $node
				}
			}
		else
			{
			$routes.{$head} = { '' => $node }
			}
		return
		}
	method add( $method, $URL )
		{
		}
	}

#
# add-route can take either an Int or a Route-Info type.
# The Int type is for testing, the Route-Info is for real-world use.
#
sub add-route( Hash $routes, $node, *@terms ) is export(:testing)
	{
	die "Shouldn't happen" unless @terms;
	my ( $head, @tail ) = @terms;

	#
	# Yes, this should be a proper uninitialized object, but that causes
	# all kinds of havoc with hash lookups and whatnot.
	#
	# Also, '#' is illegal in URLs because otherwise it's an anchor tag.
	#
	unless $head ~~ Str:D
		{
		$head = '#(' ~ $head.WHAT.perl ~ ')'
		}

	if @tail
		{
		if $routes.{$head}
			{
			if $routes.{$head} ~~ Int or
				$routes.{$head} ~~ Route-Info
				{
				$routes.{$head} = { '' => $routes.{$head} };
				}
			else
				{
				}
			}
		else
			{
			$routes.{$head} = { };
			}
		add-route( $routes.{$head}, $node, @tail );
		}
	elsif $routes.{$head}
		{
		if $routes.{$head} ~~ Int or $routes.{$head} ~~ Route-Info
			{
			$routes.{$head} = { '' => $routes.{$head} };
			}
		else
			{
			$routes.{$head}{''} = $node
			}
		}
	else
		{
		$routes.{$head} = { '' => $node }
		}
	return
	}

sub find-element( $trie, $element )
	{
	return $trie.{$element} if $trie.{$element};
	return $trie.{'#(Int)'} if $trie.{'#(Int)'} and +$element;
	return $trie.{'#(Str)'} if $trie.{'#(Str)'};

	return False;
	}

sub find-route( Hash $trie, *@path ) is export(:testing)
	{
	return False if @path.elems == 0;

	if @path.elems == 1
		{
		return False unless $trie.{'/'}{''};
		return $trie.{'/'}{''}
		}

	my $rv = $trie;
	loop ( my $i = 0 ; $i < @path.elems; $i+=2 )
		{
		return False if @path[$i] ne '/';
		if @path[$i+1]
			{
			$rv = find-element( $rv.{'/'}, @path[$i+1] );
			}
		else
			{
			$rv = $rv.{'/'}
			}
		return unless $rv;
		}
	$rv = $rv.{'/'} if @path.elems % 2 == 1;
	return unless $rv;

	return $rv.{''} if $rv and $rv.{''};
	}

sub list-routes( $trie ) is export(:testing)
	{
	return '' unless $trie ~~ Hash;

	my @routes;
	for $trie.keys.sort -> $head
		{
		@routes.append( map { $head ~ $_ },
			list-routes( $trie.{$head} ) );
		}
	return @routes;
	}

multi sub trait_mod:<is>( Routine $r, :$handler! ) is export(:testing,:ALL)
	{
	my $name      = $r.name;
	my $signature = $r.signature;

	my @names = map { param-to-string( $_ ) }, $signature.params;
	my $path = @names.join('');
	my @path = grep { $_ ne '' }, map { ~$_ }, $path.split(/\//, :v);

	add-route(
		$PRANCER-INTERNAL-ROUTES.{$name},
		Route-Info.new(:r($r),:path(@path)),
		@path
		);
	}

sub app( $env ) is export(:testing,:ALL)
	{
	my $response-code = 200;
	my $MIME-type     = 'text/HTML';
	my @content       = '';
	my $file          = STATIC-DIRECTORY ~ $env.<PATH_INFO>;
#say $PRANCER-INTERNAL-ROUTES.<GET>.perl;
#say list-routes( $PRANCER-INTERNAL-ROUTES.<GET> );

	if $file.IO.e and not $file.IO.d
		{
		$response-code = 200;
		$MIME-type     = Crust::MIME.mime-type( $file );
		@content       = ( $file.IO.slurp );
		}
	else
		{
		my $request-method = $env.<REQUEST_METHOD>;
		my @path = grep { $_ ne '' },
			   map { ~$_ },
			   $env.<PATH_INFO>.split(/\//, :v);
		my $info = find-route(
			$PRANCER-INTERNAL-ROUTES.{$request-method}, @path );
		@content = $info.r.(|@path);
		}

	return	$response-code,
		[ 'Content-Type' => $MIME-type ],
		[ @content ];
	}

sub prance() is export
	{
	my $runner = Crust::Runner.new;
	$runner.run( &app )
	}
