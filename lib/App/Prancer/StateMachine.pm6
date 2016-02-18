class App::Prancer::StateMachine
	{
#	has Bool $.available = False;
	has Bool $.trace = False;

	sub B13-available( $machine, $r )
		{
		#return $machine.available;
		return True
		}
	sub B12-known-method( $machine, $r )
		{
		return $r.<REQUEST_METHOD> ~~
			  <DELETE GET HEAD OPTIONS PATCH POST PUT>.any
		}
	constant QUERY-LENGTH-LIMIT = 1024;
	sub B11-uri-too-long( $machine, $r )
		{
		return $r.<QUERY_STRING>.chars > QUERY-LENGTH-LIMIT
		}
	sub B10-method-allowed-on-resource( $machine, $r )
		{
return True;
		}
	sub B09-malformed( $machine, $r )
		{
return False;
		}
	sub B08-authorized( $machine, $r )
		{
return True;
		}
	sub B07-forbidden( $machine, $r )
		{
return True;
		}
	sub B06-unsupported-content-header( $machine, $r )
		{
return False;
		}
	sub B05-unknown-content-type( $machine, $r )
		{
return True;
		}
	sub B04-request-entity-too-large( $machine, $r )
		{
return False;
		}
	sub B03-OPTIONS( $machine, $r )
		{
return False;
		}
	sub C03-Accept-exists( $machine, $r )
		{
return True;
		}
	sub C04-Acceptable-media-type-available( $machine, $r )
		{
return True;
		}
	sub D04-Accept-Language-exists( $machine, $r )
		{
return True;
		}
	sub D05-Acceptable-language-available( $machine, $r )
		{
return True;
		}
	sub E05-Accept-Charset-exists( $machine, $r )
		{
return True;
		}
	sub E06-Acceptable-charset-available( $machine, $r )
		{
return True;
		}
	sub F06-Accept-Encoding-exists( $machine, $r )
		{
return True;
		}
	sub F07-Acceptable-encoding-available( $machine, $r )
		{
return True;
		}
	sub G07-Resource-exists( $machine, $r )
		{
return True;
		}
	sub G08-If-Match-exists( $machine, $r )
		{
return True;
		}
	sub G09-If-Match-star-exists( $machine, $r )
		{
return True;
		}
	sub G11-Etag-in-If-Match( $machine, $r )
		{
return True;
		}
	sub H07-If-Match-star-exists( $machine, $r )
		{
return True;
		}
	sub H10-If-Unmodified-Since-exists( $machine, $r )
		{
return True;
		}
	sub H11-If-Unmodified-Since-is-valid-date( $machine, $r )
		{
return True;
		}
	sub H12-Last-Modified-after-If-Unmodified-Since( $machine, $r )
		{
return True;
		}
	sub I04-Server-desires-different-uri( $machine, $r )
		{
return False;
		}
	sub I07-PUT( $machine, $r )
		{
		}
	sub I12-If-None-Match-exists( $machine, $r )
		{
return False;
		}
	sub I13-If-None-Match-star-exists( $machine, $r )
		{
return False;
		}
	sub J18-GET-or-HEAD( $machine, $r )
		{
return True;
		}
	sub K05-Resource-Moved-Permanently( $machine, $r )
		{
return False;
		}
	sub K07-Resource-previously-existed( $machine, $r )
		{
return False;
		}
	sub K13-Etag-in-If-None-Match( $machine, $r )
		{
return False;
		}
	sub L05-Resource-moved-temporarily( $machine, $r )
		{
return False;
		}
	sub L07-POST( $machine, $r )
		{
return False;
		}

	has %.graph =
		(
		B13 =>
			{
			node => &B13-available,
			true => 'B12',
			false => 503
			},
		B12 =>
			{
			node =>  &B12-known-method,
			true => 'B11',
			false => 501
			},
		B11 =>
			{
			node =>  &B11-uri-too-long,
			true => 414,
			false => 'B10'
			},
		B10 =>
			{
			node =>  &B10-method-allowed-on-resource,
			true => 'B09',
			false => 405
			},
		B09 =>
			{
			node =>  &B09-malformed,
			true => 400,
			false => 'B08'
			},
		B08 =>
			{
			node =>  &B08-authorized,
			true => 'B07',
			false => 401
			},
		B07 =>
			{
			node =>  &B07-forbidden,
			true => 403,
			false => 'B06'
			},
		B06 =>
			{
			node =>  &B06-unsupported-content-header,
			true => 501,
			false => 'B05'
			},
		B05 =>
			{
			node =>  &B05-unknown-content-type,
			true => 415,
			false => 'B04'
			},
		B04 =>
			{
			node =>  &B04-request-entity-too-large,
			true => 413,
			false => 'B03'
			},
		B03 =>
			{
			node =>  &B03-OPTIONS,
			true => 200,
			false => 'C03'
			},
		C03 =>
			{
			node =>  &C03-Accept-exists,
			true => 'C04',
			false => 'D04'
			},
		C04 =>
			{
			node =>  &C04-Acceptable-media-type-available,
			true => 'D04',
			false => 406
			},
		D04 =>
			{
			node =>  &D04-Accept-Language-exists,
			true => 'D05',
			false => 'E05'
			},
		D05 =>
			{
			node =>  &D05-Acceptable-language-available,
			true => 'E05',
			false => 406
			},
		E05 =>
			{
			node =>  &E05-Accept-Charset-exists,
			true => 'E06',
			false => 'F06'
			},
		E06 =>
			{
			node =>  &E06-Acceptable-charset-available,
			true => 'F06',
			false => 406
			},
		F06 =>
			{
			node =>  &F06-Accept-Encoding-exists,
			true => 'F07',
			false => 'G07'
			},
		F07 =>
			{
			node =>  &F07-Acceptable-encoding-available,
			true => 'G07',
			false => 406
			},
		G07 =>
			{
			node =>  &G07-Resource-exists,
			true => 'G08',
			false => 'H07'
			},
		G08 =>
			{
			node =>  &G08-If-Match-exists,
			true => 'G09',
			false => 'H10'
			},
		G09 =>
			{
			node =>  &G09-If-Match-star-exists,
			true => 'G11',
			false => 'H10'
			},
		G11 =>
			{
			node =>  &G11-Etag-in-If-Match,
			true => 'H10',
			false => 412
			},
		H07 =>
			{
			node =>  &H07-If-Match-star-exists,
			true => 412,
			false => 'I07'
			},
		H10 =>
			{
			node =>  &H10-If-Unmodified-Since-exists,
			true => 'H11',
			false => 'I12'
			},
		H11 =>
			{
			node =>  &H11-If-Unmodified-Since-is-valid-date,
			true => 'H12',
			false => 'I12'
			},
		H12 =>
			{
			node => &H12-Last-Modified-after-If-Unmodified-Since,
			true => 412,
			false => 'I12'
			},
		I04 =>
			{
			node => &I04-Server-desires-different-uri,
			true => 301,
			false => 'P03'
			},
		I07 =>
			{
			node => &I07-PUT,
			true => 'I04',
			false => 'K07'
			},
		I12 =>
			{
			node => &I12-If-None-Match-exists,
			true => 'I13',
			false => 'L13'
			},
		I13 =>
			{
			node => &I13-If-None-Match-star-exists,
			true => 'J18',
			false => 'K13'
			},
		J18 =>
			{
			node => &J18-GET-or-HEAD,
			true => 304,
			false => 412
			},
		K05 =>
			{
			node => &K05-Resource-Moved-Permanently,
			true => 301,
			false => 'L05'
			},
		K07 =>
			{
			node => &K07-Resource-previously-existed,
			true => 'K05',
			false => 'L07'
			},
		K13 =>
			{
			node => &K13-Etag-in-If-None-Match,
			true => 'J18',
			false => 'L13'
			},
		L05 =>
			{
			node => &L05-Resource-moved-temporarily,
			true => 307,
			false => 'L05'
			},
		L07 =>
			{
			node => &L07-POST,
			true => 'M07',
			false => 404
			},
		);

constant MAX-ITERATIONS = 10;
	method run( $env )
		{
		my $state = 'B13';
my $iterations = MAX-ITERATIONS;
		while $state !~~ Int
			{
#say $state;
			unless %.graph{$state}
				{
		say "Fell off end of state machine!";
		last;
				}
			$state = %.graph{$state}<node>.( self, $env )
				?? %.graph{$state}<true>
				!! %.graph{$state}<false>;
last if $iterations-- <= 0;
			}
#say "Ended in state $state";
#say "Tracing" if $.trace;
		}
	}
