use v6;

use Readline;
use Test;

plan 17;

my $r = Readline.new;

lives-ok { my $rv = $r.initialize },
         'initialize';

subtest sub {
  my $readable = False;

#  lives-ok { $r.function-dumper( $readable ) }, # XXX Noisy
#           'function-dumper lives';
  lives-ok { $r.macro-dumper( $readable ) },
           'macro-dumper lives';
#  lives-ok { $r.variable-dumper( $readable ) }, # XXX Noisy
#           'variable-dumper lives';
}, 'dumpers';

subtest sub {
  my $prompt = 'readline$ ';

  lives-ok { my $rv = $r.set-prompt( $prompt ) },
           'set-prompt lives';
  lives-ok { my $rv = $r.expand-prompt( $prompt ) },
           'expand-prompt lives';
  lives-ok { my $rv = $r.on-new-line-with-prompt },
           'on-new-line-with-prompt lives';
  lives-ok { $r.save-prompt },
           'save-prompt lives';
  lives-ok { $r.restore-prompt },
           'restore-prompt lives';
}, 'prompt';

subtest sub {
  my $str = 'foo';
  my $filename = 'test.txt';
  my $src-offset;
  my $offset = 0;
#  my $p-offset = \$src-offset;

  lives-ok { my $rv = $r.tilde-expand( $str ) },
           'tilde-expand lives';
  lives-ok { my $rv = $r.tilde-expand-word( $filename ) },
           'tilde-expand-word lives';
#  lives-ok { my $rv = $r.tilde-find-word( $str, $offset, $p-offset ) }; # XXX Wrap the pointer
#           'tilde-find-word lives';
}, 'tilde';

subtest sub {
  my $meta-flag = 1; # XXX Fix the type
  my $terminal-name = 'vt100';

  lives-ok { $r.prep-terminal( $meta-flag ) },
           'prep-terminal lives';
  lives-ok { $r.deprep-terminal },
           'deprep-terminal lives';
  lives-ok { my $rv = $r.reset-terminal( $terminal-name ) },
           'reset-terminal';
#  lives-ok { $r.resize-terminal }, # XXX Noisy
#           'resize-terminal lives';
}, 'terminal';

subtest sub {
  my $readline-state;
  lives-ok { my $rv = $r.reset-line-state },
           'reset-line-state lives';
#  lives-ok { $r.free-line-state }, # XXX Noisy
#           'free-line-state lives';
#  lives-ok { my $rv = $r.save-state( $readline-state ) },
#           'save-state lives';
#  lives-ok { my $rv = $r.restore-state( $readline-state ) },
#           'save-state lives';
}, 'state';

subtest sub {
  lives-ok { $r.free-undo-list },
           'free-undo-list lives';
  lives-ok { my $rv = $r.do-undo },
           'do-undo lives';
  lives-ok { my $rv = $r.begin-undo-group },
           'begin-undo-group lives';
  lives-ok { my $rv = $r.end-undo-group },
           'end-undo-group lives';
}, 'undo';

subtest sub {
  my $name = 'foo';
  sub my-callback( Int $a, Int $b ) returns Int { 0 };

#  lives-ok { $r.list-funmap-names }, # XXX Noisy
#           'list-funmap-names lives';
#  lives-ok { my $rv = $r.add-funmap-entry( $name, &my-callback ) }, # XXX Blows chunks in valgrind
#           'add-funmap-entry lives';
  lives-ok { my @rv = $r.funmap-names },
           'funmap-names lives';
}, 'funmap';

subtest sub {
  my ( $rows, $cols ) = ( 80, 24 );

  lives-ok { $r.set-screen-size( $rows, $cols ) },
           'set-screen-size';
#  lives-ok { $r.get-screen-size( \$rows, \$cols ) }, # XXX Rewrite
#           'get-screen-size lives';
  lives-ok { $r.reset-screen-size },
           'reset-screen-size lives';
}, 'screen';

subtest sub {
  my $text = 'food';
  my ( $start, $end ) = ( 1, 2 );

  lives-ok { my $rv = $r.insert-text( $text ) },
           'insert-text lives';
  lives-ok { my $rv = $r.delete-text( $start, $end ) },
           'delete-text lives';
  lives-ok { my $rv = $r.kill-text( $start, $end ) },
           'kill-text lives';
  lives-ok { my $rv = $r.copy-text( $start, $end ) },
           'copy-text lives';
}, 'text';

subtest sub {
  my $keymap;
  my $name = 'emacs';

  lives-ok { $keymap = $r.make-bare-keymap },
           'make-bare-keymap lives';
  lives-ok { my $copy-keymap = $r.copy-keymap( $keymap ) },
           'copy-keymap lives';
  lives-ok { my $keymap = $r.make-keymap },
           'make-keymap lives';
  lives-ok { $r.discard-keymap( $keymap ) },
           'discard-keymap lives';
  lives-ok { $r.free-keymap( $keymap ) },
           'free-keymap lives';
  lives-ok { my $keymap = $r.get-keymap-by-name( $name ) },
           'get-keymap-by-name lives';
  lives-ok { my $keymap = $r.get-keymap },
           'get-keymap lives';
  lives-ok { my $name = $r.get-keymap-name( $keymap ) },
           'get-keymap-name lives';
  lives-ok { $r.set-keymap( $keymap ) },
           'set-keymap lives';
}, 'keymap';

subtest sub {
  my $key = 'x';
  sub my-callback( Int $a, Int $b ) returns Int { }
  my $keyseq = 'xx';
  my $line = 'foo';

  subtest sub {
    my $keymap = $r.make-bare-keymap;
    my $index = 0;
    my $macro = 'xx';
    lives-ok { my $rv = $r.bind-key-in-map( $key, &my-callback, $keymap ) },
             'bind-key-in-map lives';
    lives-ok { my $rv = $r.bind-key-if-unbound-in-map(
                           $key, &my-callback, $keymap ) },
             'bind-key-if-unbound-in-map lives';
    lives-ok { my $rv = $r.bind-keyseq-in-map(
                           $keyseq, &my-callback, $keymap ) },
             'bind-keyseq-in-map lives';
#    lives-ok { my $rv = $r.bind-keyseq-if-unbound-in-map( # XXX Blows chunks under valgrid by cascading to rl_generic_bind
#                           $keyseq, &my-callback, $keymap ) },
#             'bind-keyseq-if-unbound-in-map lives';
#    lives-ok { my $rv = $r.generic-bind( $index, $keyseq, $line, $keymap ) }, # XXX Blows chunks under valgrind
#             'generic-bind lives';
    lives-ok { my $rv = $r.macro-bind( $keyseq, $macro, $keymap ) },
             'macro-bind lives';
  }, 'bind keymaps';
#  lives-ok { my $rv = $r.bind-key( $key, &my-callback ) }, # XXX Blows chunks under valgrind
#           'bind-key lives';
#  lives-ok { my $rv = $r.bind-key-if-unbound( $key, &my-callback ) }, # XXX Blows chunks under valgrind
#           'bind-key-if-unbound lives';
#  lives-ok { my $rv = $r.bind-keyseq( $keyseq, &my-callback ) }, # XXX Blows chunks under valgrind by cascading to rl_generic_bind
#           'bind-keyseq lives';
#  lives-ok { my $rv = $r.bind-keyseq-if-unbound( $keyseq, &my-callback ) }, # XXX Blows chunks under valgrind by cascading to rl_generic_bind
#           'bind-keyseq-if-unbound lives';
#  lives-ok { my $rv = $r.parse-and-bind( $line ) }, # XXX Blows chunks in valgrind by cascading to rl_generic_bind
#           'parse-and-bind lives';
}, 'bind';

subtest sub {
  my $key = 'x';
  my $keymap = $r.make-bare-keymap;
  sub my-callback( Int $a, Int $b ) returns Int { }

#  lives-ok { my $rv = $r.unbind-key( $key ) }, # XXX Blows chunks under valgrind?
#           'unbind-key lives';
  lives-ok { my $rv = $r.unbind-key-in-map( $key, $keymap ) },
           'unbind-key-in-map lives';
  lives-ok { my $rv = $r.unbind-function-in-map( &my-callback, $keymap ) },
           'unbind-function-in-map lives';
}, 'unbind';

subtest sub {
  my $history = 'foo';
  my $HISTORY-STATE;
  my $timestamp = '2015-01-01 00:00:00';
  my $index = 0;
  my $HIST-ENTRY;
  my $line = 'foo';
  my $data = 'foo data';
  my $dir = 0;
  my $filename = 'doesnt-exist.txt';
  my ( $from, $to ) = ( 1, 2 );

  lives-ok { $r.using-history },
           'using-history lives';
  lives-ok { $r.add-history( $history ) },
           'add-history lives';
  lives-ok { $HISTORY-STATE = $r.history-get-history-state },
           'history-get-history-state lives';
  lives-ok { $r.history-set-history-state( $HISTORY-STATE ) },
           'history-set-history-state lives';
  lives-ok { $r.add-history-time( $timestamp ) },
           'add-history-time lives';
  lives-ok { $HIST-ENTRY = $r.remove-history( $index ) },
           'remove-history lives';
  lives-ok { my $rv = $r.free-history-entry( $HIST-ENTRY ) },
           'free-history-entry lives';
  lives-ok { my $HIST-ENTRY = $r.replace-history-entry(
                                 $index, $line, $data ) },
           'replace-history-entry lives';
  lives-ok { $r.clear-history },
           'clear-history lives';
  subtest sub {
    lives-ok { my $rv = $r.history-is-stifled },
             'history-is-stifled lives';
    lives-ok { $r.stifle-history( 0 ) },
             'stifle-history lives';
    lives-ok { $r.unstifle-history },
             'unstifle-history lives';
  }, 'Stifling';

  #
  # The next few calls don't like having an empty history list, fill it.
  #
  $r.add-history( $history );
  lives-ok { my @rv = $r.history-list },
           'history-list lives';
  lives-ok { my $index = $r.where-history },
           'where-history lives';
  lives-ok { my $HIST-ENTRY = $r.current-history( $index ) },
           'current-history lives';
  lives-ok { my $HIST-ENTRY = $r.history-get( $index ) },
           'history-get lives';
  $HIST-ENTRY = $r.current-history( $index );
  lives-ok { my $rv = $r.history-get-time( $HIST-ENTRY ) },
           'history-get-time lives';
  lives-ok { my $size = $r.history-total-bytes },
           'history-total-bytes lives';
  lives-ok { my $rv = $r.history-set-pos( $index ) },
           'history-set-pos lives';
  lives-ok { my $HIST-ENTRY = $r.next-history },
           'next-history lives';
  lives-ok { my $HIST-ENTRY = $r.previous-history },
           'previous-history lives';
  lives-ok { my $rv = $r.history-search( $line, $index ) },
           'history-search lives';
  lives-ok { my $rv = $r.history-search-prefix( $line, $index ) },
           'history-search-prefix lives';
  lives-ok { my $rv = $r.history-search-pos( $line, $index, $dir ) },
           'history-search-pos lives';
  lives-ok { my $rv = $r.read-history( $filename ) },
           'read-history lives';
  lives-ok { my $rv = $r.read-history-range( $filename, $from, $to ) },
           'read-history-range lives';
####  lives-ok { my $rv = $r.write-history( Str $filename ) },
####           'write-history lives';
####  lives-ok { my $rv = $r.append-history( $offset, $filename ) };
####           'append-history lives';
####  lives-ok { my $rv = $r.history-truncate-file( $filename, $nLines ) },
####           'history-truncate-file lives';
#  lives-ok { my $rv = $r.history-expand( $string, Pointer[Str] $output ) returns Int };
#  lives-ok { my $rv = $r.history-arg-extract( $from, $to, $line ) },
#           'history-arg-extract lives';
#  lives-ok { my $rv = $r.get-history-event( $line, Pointer[Int] $cIndex, Str $delimiting-quote ) returns Str }; # XXX fix later
  lives-ok { my @rv = $r.history-tokenize( $line ) }, # XXX fix later
           'history-tokenize lives';
}, 'history';

subtest sub {
  my $username = 'jgoff';
  my $filename = 'sample.txt';
  my $index = 0;

#  lives-ok { my $rv = $r.username-completion-function(
#                         $username, $index ) }; # XXX doesn't exist?
#  lives-ok { my $rv = $r.filename-completion-function (
#                         $filename, $index ) }; # XXX Doesn't exist?
#  lives-ok { my $rv = $r.completion-mode(
#                         Pointer[&callback (Int, Int --> Int)] $cfunc ) };
}, 'completion';

#subtest sub {
#  lives-ok { $r.callback-handler-install( Str $prompt, &callback (Str) ) };
#  lives-ok { $r.callback-read-char };
#  lives-ok { $r.callback-handler-remove };
#}, 'callback';

subtest sub {
  my $username = 'jgoff';
  my $filename = 'sample.txt';
  my $index = 0;

#  lives-ok { my $rv = $r.username-completion-function( $username, $index ) }; # XXX doesn't exist?
#  lives-ok { my $rv = $r.filename-completion-function ( $filename, $index ) }; # XXX Doesn't exist?
#  lives-ok { my $rv = $r.completion-mode( Pointer[&callback (Int, Int --> Int)] $cfunc ) };
}, 'completion';

##subtest sub {
##  lives-ok { my $rv = $r.function-of-keyseq( $keyseq, $map, Pointer[Int] $type ) returns &callback (Int, Int --> Int) };
##  lives-ok { my $rv = $r.invoking-keyseqs-in-map( Pointer[&callback (Int, Int --> Int)] $p-cmd, Keymap $map ) returns CArray[Str] };
##  lives-ok { my $rv = $r.invoking-keyseqs( Pointer[&callback (Int, Int --> Int)] $p-cmd ) returns CArray[Str] };
##}, 'keyseq';

##
## These tests apparently mess with terminal settings. They pass, though.
##
##subtest sub {
##  lives-ok { my $rv = $r.set-signals }, 'set-signals lives';
##  lives-ok { my $rv = $r.clear-signals }, 'clear-signals lives';
##  lives-ok { $r.cleanup-after-signal }, 'cleanup-after-signal lives';
##  lives-ok { $r.reset-after-signal }, 'reset-after-signal lives';
##}, 'signal';

subtest sub {
####  lives-ok { my $rv = $r.readline( Str $prompt ) returns Str };
####  lives-ok { my $rv = $r.ding }; # XXX Don't annoy the user.
##  lives-ok { my $rv = $r.add-defun( Str $str, &callback (Int, Int --> Int), Str $key ) returns Int };
##  lives-ok { my $rv = $r.variable-value( Str $variable ) returns Str };
##  lives-ok { $r.set-key( Str $str, &callback (Int, Int --> Int), Keymap $map ) };
##  lives-ok { my $rv = $r.named-function( Str $s ) returns &callback (Int, Int --> Int) };
  my $filename = 'doesnt-exist.txt';
  my $macro = 'xx';
  my ( $start, $end ) = ( 1, 2 );
  lives-ok { $r.read-init-file( $filename ) },
           'read-init-file lives';
  lives-ok { $r.push-macro-input( $macro ) },
         'push-macro-input lives';
  lives-ok { my $rv = $r.modifying( $start, $end ) },
           'modifying lives';
##  lives-ok { $r.redisplay }, # XXX Noisy
##           'redisplay lives';
##  lives-ok { my $rv = $r.on-new-line }, # XXX Noisy
##           'on-new-line lives';
##  lives-ok { my $rv = $r.forced-update-display }, # XXX Noisy
##           'forced-update-display lives';
##  lives-ok { my $rv = $r.clear-message }, # XXX Noisy
##           'clear-message lives';
##  lives-ok { my $rv = $r.crlf }, # XXX Noisy
##           'crlf lives';
  my $c = 'x';
  my $line = 'foo';
  my $clear-undo = 1;
  my $keymap = $r.make-bare-keymap;
  my $cap = 'termcap.1';
  my $len = 1;
  my $timeout = 3;
##  lives-ok { my $rv = $r.show-char( $c ) }, # XXX Noisy
##           'show-char lives';
  lives-ok { $r.replace-line( $line, $clear-undo ) },
           'replace-line';
  lives-ok { $r.tty-set-default-bindings( $keymap ) },
           'tty-set-default-bindings lives';
  lives-ok { $r.tty-unset-default-bindings( $keymap ) },
           'tty-unset-default-bindings lives';
  lives-ok { my $rv = $r.get-termcap( $cap ) },
           'get-termcap lives';
  lives-ok { my $rv = $r.extend-line-buffer( $len ) },
           'extend-line-buffer lives';
  lives-ok { my $rv = $r.alphabetic( $c ) },
           'alphabetic lives';
###  lives-ok { $r.free( Pointer $mem ) }
###           'free lives';
  lives-ok { my $rv = $r.set-paren-blink-timeout( $timeout ) },
           'set-paren-blink-timeout lives';
  my $what-to-do = 1;
  lives-ok { my $rv = $r.complete-internal( $what-to-do ) },
           'complete-internal lives';
}, 'Miscellaneous';
