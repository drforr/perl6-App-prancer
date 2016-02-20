class App::Prancer::StateMachine
	{
	constant QUERY-LENGTH-LIMIT = 1024;
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
	sub B11-uri-too-long( $machine, $r )
		{
return False;
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
		{ return $r.<method> eq 'OPTIONS' }
	sub C03-Accept-exists( $machine, $r )
		{ return ?$r.<HTTP_ACCEPT> }
	sub C04-Acceptable-media-type-available( $machine, $r )
		{
return True;
		}
	sub D04-Accept-Language-exists( $machine, $r )
		{ return ?$r.<HTTP_ACCEPT_LANGUAGE> }
	sub D05-Acceptable-language-available( $machine, $r )
		{
return True;
		}
	sub E05-Accept-Charset-exists( $machine, $r )
		{ return ?$r.<HTTP_ACCEPT_CHARSET> }
	sub E06-Acceptable-charset-available( $machine, $r )
		{
return True;
		}
	sub F06-Accept-Encoding-exists( $machine, $r )
		{ return ?$r.<HTTP_ACCEPT_ENCODING> }
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
		{ return $r.<REQUEST_METHOD> eq 'PUT' }
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
		return $r.<REQUEST_METHOD> eq 'GET' or
			$r.<REQUEST_METHOD> eq 'HEAD'
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
		{ return $r.<method> eq 'POST' }
	sub L13-If-Modified-Since-exists( $machine, $r )
		{
return False;
		}
	sub L14-If-Modified-Since-is-valid-date( $machine, $r )
		{
return False;
		}
	sub L15-If-Modified-Since-after-Now( $machine, $r )
		{
return False;
		}
	sub L17-Last-Modified-after-If-Modified-Since( $machine, $r )
		{
return False;
		}
	sub M05-POST( $machine, $r )
		{ return $r.<method> eq 'POST' }
	sub M07-Server-permits-POST-to-missing-resource( $machine, $r )
		{
return False;
		}
	sub M16-DELETE( $machine, $r )
		{ return $r.<method> eq 'DELETE' }
	sub M20-Delete-enacted( $machine, $r )
		{
return False;
		}
	sub N05-Server-permits-POST-to-missing-resource( $machine, $r )
		{
return False;
		}
	sub N11-Redirect( $machine, $r )
		{
return False;
		}
	sub N16-POST( $machine, $r )
		{ return $r.<REQUEST_METHOD> eq 'POST' }
	sub O14-Conflict( $machine, $r )
		{
return False;
		}
	sub O16-PUT( $machine, $r )
		{ return $r.<REQUEST_METHOD> eq 'PUT' }
	sub O18-Multiple-representations( $machine, $r )
		{
return False;
		}
	sub O20-Response-includes-an-entity( $machine, $r )
		{
return False;
		}
	sub P03-Conflict( $machine, $r )
		{
return False;
		}
	sub P11-New-resource( $machine, $r )
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
		L13 =>
			{
			node => &L13-If-Modified-Since-exists,
			true => 'L14',
			false => 'M16'
			},
		L14 =>
			{
			node => &L14-If-Modified-Since-is-valid-date,
			true => 'L15',
			false => 'M16'
			},
		L15 =>
			{
			node => &L15-If-Modified-Since-after-Now,
			true => 'M16',
			false => 'L17'
			},
		L17 =>
			{
			node => &L17-Last-Modified-after-If-Modified-Since,
			true => 'M16',
			false => 304
			},
		M05 =>
			{
			node => &M05-POST,
			true => 'N05',
			false => 410
			},
		M07 =>
			{
			node => &M07-Server-permits-POST-to-missing-resource,
			true => 'N11',
			false => 404
			},
		M16 =>
			{
			node => &M16-DELETE,
			true => 'M20',
			false => 'N16'
			},
		M20 =>
			{
			node => &M20-Delete-enacted,
			true => 'O20',
			false => 202
			},
		N05 =>
			{
			node => &N05-Server-permits-POST-to-missing-resource,
			true => 'N11',
			false => 410
			},
		N11 =>
			{
			node => &N11-Redirect,
			true => 303,
			false => 'P11'
			},
		N16 =>
			{
			node => &N16-POST,
			true => 'N11',
			false => 'O16'
			},
		O14 =>
			{
			node => &O14-Conflict,
			true => 409,
			false => 'P11'
			},
		O16 =>
			{
			node => &O16-PUT,
			true => 'O14',
			false => 'O18'
			},
		O18 =>
			{
			node => &O18-Multiple-representations,
			true => 300,
			false => 'O16'
			},
		O20 => 
			{
			node => &O20-Response-includes-an-entity,
			true => 204,
			false => 'O18'
			},
		P03 =>
			{
			node => &P03-Conflict,
			true => 409,
			false => 'P11'
			},
		P11 =>
			{
			node => &P11-New-resource,
			true => 201,
			false => 'O20'
			},
		);

constant MAX-ITERATIONS = 10;
	method run( $env )
		{
#say $env;
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
