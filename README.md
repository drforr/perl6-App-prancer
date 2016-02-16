Prancer
=======

Prancer is a minimalist web framework.

Load Prancer, write a few function, and call prance(). That's it in a nutshell.
It uses Crust to do the heavy lifting, but that does mean that it's P6SGI
compliant.

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
