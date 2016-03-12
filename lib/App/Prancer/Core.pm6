=begin pod

=head1 App::Prancer::Core

Insert, display and search for application routes.

=head1 Synopsis

    use App::Prancer::Core;

    my $routes = App::Prancer::Core.new;
    $routes.add( 'GET', 1, '/', 'a' );
    $routes.add( 'GET', 2, '/', Str );
    say $routes.find( 'GET', '/a' ); # 1
    say $routes.list( 'GET' );

=head1 Documentation

Add, find and display Prancer routes.

=over

=item add( $info, '/', 'a' )

Add a route '/a' to the internal trie. C<$info> can be anything you like, and
is untyped. In real-world usage this would contain a Routine object and likely
more information about calling semantics and whatnot. It's untyped for testing
so that we can pass simple integers in to prove that the object going in is
what comes out.

=item find( '/a' )

Find a route '/a' in the internal trie, and return its associated info.

=item list()

Return a list of all routes in the trie, compressed from the internal structure
into a list of strings.

=back

=end pod

class App::Prancer::Core
	{
my class Route-Info { };
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
		my ( $head, @tail ) = @terms;

		# Perl 6 allows objects as keys, and by all rights $head here
		# should be allowed to remain unmodified.
		#
		# This causes problems downstream, specifically when trying to
		# debug the internals because I'm always forgetting to add
		# .perl or .gist to my debug commands. And I think that it's
		# important that this core data structure should be able to
		# be printed out without modifications.
		#
		# So I'm going to transform bare 'Str' and 'Int' and whatever
		# values into '#(Str)', '#(Int)' and '#(whatever)' values
		# for ease of reading. Besides, AFAIK '#' is illegal inside
		# the path portion of URLs because it's an URL anchor.
		# 
		if @tail
			{
			if $routes.{$head}
				{
				if $routes.{$head} ~~ Int:D or
					$routes.{$head} ~~ Route-Info
					{
					$routes.{$head} =
						{ '' => $routes.{$head} };
					}
				}
			else
				{
				$routes.{$head} = { };
				}
			return add-route( $routes.{$head}, $node, @tail );
			}
		elsif $routes.{$head}
			{
			if $routes.{$head} ~~ Int:D or
				$routes.{$head} ~~ Route-Info
				{
				$routes.{$head} = { '' => $routes.{$head} };
				}
			else
				{
				return False if $routes.{$head}{''};
				$routes.{$head}{''} = $node
				}
			}
		else
			{
			$routes.{$head} = { '' => $node }
			}
		return True;
		}

	method add( Str $method, $node, *@terms )
		{
		fail "Cannot add empty route!" unless @terms;
		fail "Cannot add route with two Arrays!"
			if (grep { $_ ~~ Array }, @terms ).elems > 1;

		my @x;
		for @terms -> $x
			{
			my $v;
			if $x ~~ Str:D  { $v = $x }
			elsif $x ~~ Int { $v = '#(Int)' }
			elsif $x ~~ Str { $v = '#(Str)' }
			elsif $x ~~ Array { $v = '#(Array)' }
			@x.append( $v )
			}

		my @final-terms;
		for @x -> $term
			{
			my @terms =
				grep { $_ ne '' },
				map { ~$_ },
				$term.split( /\/+/, :v );
			@final-terms.push( '/' ) if
				@final-terms and
				@final-terms[*-1] ne '/' and
				@terms[0] ne '/';
			@final-terms.append( @terms );
			}
		@final-terms.unshift( '/' ) if @final-terms[0] ne '/';

		add-route( $.routes.{$method}, $node, @final-terms ) or
			fail "Path " ~ join( '',
				grep { $_ ne '' },
				map { $_.perl },
				@final-terms
			) ~ " already exists!";
		}

	# Int is a subset of Str, so match on that type first.
	#
	sub find-element( $trie, $element )
		{
		return $trie.{$element} if $trie.{$element};
		return $trie.{'#(Int)'} if $trie.{'#(Int)'} and +$element;
		return $trie.{'#(Str)'} if $trie.{'#(Str)'};

		return False;
		}

	method find( Str $method, Str:D $URL )
		{
		my $trie = $.routes.{$method};
		return False unless $trie and $URL and $URL ~~ /^\//;

		my @path = grep { $_ ne '' }, $URL.split( /\// );
		my $rv = $trie;
		my $deepest-array;
		for @path -> $element
			{
			$deepest-array = $rv.{'/'}.{'#(Array)'} if
				$rv.{'/'}.{'#(Array)'};
			$rv = find-element( $rv.{'/'}, $element );
			last unless $rv;
			}
		unless $rv
			{
			$rv = $deepest-array if $deepest-array;
			}

		if $URL ~~ m{\/$}
			{
			return $rv.{'/'}.{''} if $rv.{'/'}.{''};
			}
		else
			{
			return $rv.{''} if $rv.{''}
			}
		}

	sub list-routes( $trie )
		{
		my @routes;
		@routes.append( '/' )
			if $trie.{'/'}.{''};

		for $trie.{'/'}.keys.sort -> $e
			{
			my $temp = $trie.{'/'}{$e};
			@routes.append( "/$e" )
				if $temp.{''};
			@routes.append(
				map { "/$e$_" }, list-routes( $temp ) )
				if $temp.{'/'};
			}
		return @routes;
		}

	method list( Str $method )
		{
		return list-routes( $.routes.{$method} );
		}
	}
