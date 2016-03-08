Prancer
=======

Prancer is a minimalist web framework.

You have to know how to do 4 things in order to write a Prancer web app:

* Load a module
* Write a function
* Call a function
* There is no 4th thing.

```
use Prancer::Handler;

multi GET( '/post' ) is route {
  return '<html><head>Post content here</head><body></html>';
}

prance;
```

Static files are served from the static/ directory. Dynamic routes are why
you have a web framework, so read on to learn how to listen for GET, POST
and PUT requests. There will be helpers later on for REST-style URLs,
pagination of data and other common web tasks. I'm trying to write things in
such a way that those can simply be Roles mixed in to the Handler class.

Declare your routes as Perl 6 functions. The function's name corresponds to
the HTTP method you want to respond to, and the function's parameters are
just the parts of the URL you want to respond to.

For instance, you could listen for a 'GET /post/2016/02/my-great-post HTTP/1.1'
request by creating a function like this:

```
multi GET( '/post/2016/02/my-great-post' ) is route { }
```

But that only listens for that particular post in that particular year. If you
want to listen for that post during any year, just replace 2016 and 02 with
regular Perl arguments like so:

```
multi GET( '/post', Int:D $year, Int:D $month, '/my-great-post' ) is route { }
```

You can listen for any post name by replacing '/my-great-post' with a string
argument thusly.

```
multi GET( '/post', Int:D $year, Int:D $month, Str:D $name ) {
  my $content = 'Static content here, this would be gotten from a DB.';
  return "<html><head>$year/$month - $name</head><body>$content</body></html>";
}
```

Add %QUERY to find out what arguments got passed along with the URL, or
%BODY if you want to find out what the body of a form had in it, or $ENV if you
just want the original Crust request.

Installation
============

* Using panda (a module management tool bundled with Rakudo Star):

```
    panda update && panda install Prancer
```

* Using ufo (a project Makefile creation script bundled with Rakudo Star) and make:

```
    ufo                    
    make
    make test
    make install
```

## Testing

To run tests:

```
    prove -e perl6
```

## Author

Jeffrey Goff, DrForr on #perl6, https://github.com/drforr/

## License

Artistic License 2.0
