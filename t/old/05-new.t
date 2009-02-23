use Test::More 'no_plan';
use strict;
use warnings;

use Simo::Error;

{
   
    my $obj = Simo::Error->new( type => 1 );
    is_deeply( $obj, { type => 1 } );
    isa_ok( $obj, 'Simo::Error' );
    
    my $obj2 = $obj->new( type => 2  );
    is_deeply( $obj2, { type => 2 } );
    isa_ok( $obj2, 'Simo::Error' );
}
