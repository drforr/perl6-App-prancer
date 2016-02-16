use v6;

=begin pod

=begin NAME

App::Prancer - Minimalist web framework along the lines of Dancer

=end NAME

=begin SYNOPSIS

    use App::Prancer;

    multi GET( '/' ) is handler
        { '<html><head /></head><body><a href="/post/jgoff">Post</a></html>' }

    multi GET( '/post', Str:D $username ) is handler
        { '<html><head></head><body>Post for $username!</body></html>' }

    multi POST( '/login', %QUERY ) is handler
        { '<html><head></head><body>Login $QUERY<username></body></html>' }

    prance;

=end SYNOPSIS

=begin DESCRIPTION

Sitting on top of the L<Crust> web layer, this provides a minimalist web
framework. In order to use it, you simply use the L<Prancer> handler module,
define some subroutines to create your L<Prancer> web application, and call the
C<prance()> main loop in order to start processing.

Any function that you add the C<is handler> trait to automatically becomes a
web handler. The C<Prancer> web application calls your handler when it finds
a matching route.

=end DESCRIPTION

=begin METHODS

Any of the standard HTTP/1.1 methods may be turned into a handler, simply by
putting C<is handler> after the signature. Likely you will need more than one
handler for a given HTTP method, so be sure to declare your functions with
C<multi> rather than the more common C<sub> or C<method> calls. Don't worry,
Perl will remind you if you forget to do so.

=item DELETE

=item GET

=item HEAD

=item OPTIONS

=tem POST

=item PUT

=item PATCH

=end METHODS

=end pod

class App::Prancer
	{
	}
