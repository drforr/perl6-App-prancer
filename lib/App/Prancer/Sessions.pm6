=begin pod

=head1 App::Prancer::Sessions

Insert, display and search for user sessions.

=head1 Synopsis

    use App::Prancer::Sessions;

    my $sessions = App::Prancer::Sessions.new;
    $id = $sessions.add( $scalar );
    $sessions.set( $id, $scalar );
    $scalar = $sessions.find( $id );
    $list = $sessions.list;

=head1 Documentation

Add, find and display Prancer session objects.

=over

=item add( $scalar )

Add a scalar (serialized Perl 6 object) to a session cache, and return that
newly-created session's ID.

=item set( $id, $scalar )

Set session ID C<$id> to C<$scalar>. The method returns the ID it was passed
as a convenience.

=item find( $id )

Find a session with ID C<$id>, and return its serialized form.

=item list()

Return a list of all sessions in the cache.

=back

=end pod

use Digest::HMAC;
use Digest;
use Digest::SHA;

class App::Prancer::Sessions
	{
	has $.sessions = { };

	sub session-ID( )
		{
		my $rand = ~1.rand;
		return hmac-hex("key", $rand, &md5)
		}

	method add( $scalar )
		{
		my $id = session-ID;
		$.sessions.{$id} = $scalar;
		return $id
		}

	method set( $id, $scalar )
		{
		$.sessions.{$id} = $scalar;
		return $id;
		}

	method find( $id )
		{
		return $.sessions.{$id}
		}

	method list( )
		{
		return $.sessions.perl
		}
	}
