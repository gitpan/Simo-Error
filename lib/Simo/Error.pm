package Simo::Error;

our $VERSION = '0.0206';

use warnings;
use strict;
use Carp;
use overload '""' => sub{
    my $self = shift;
    return $self->msg . $self->pos;
};

### accessor
sub type{
    my $self = shift;
    
    if( @_ ){
        my $old = $self->{ type };
        $self->{ type } = $_[0];
        return $old;
    }
    else{
        return $self->{ type };
    }
}

sub msg{
    my $self = shift;
    
    if( @_ ){
        my $old = $self->{ msg };
        $self->{ msg } = $_[0];
        return $old;
    }
    else{
        return $self->{ msg };
    }
}

sub pkg{
    my $self = shift;
    
    if( @_ ){
        my $old = $self->{ pkg };
        $self->{ pkg } = $_[0];
        return $old;
    }
    else{
        return $self->{ pkg };
    }
}

sub attr{
    my $self = shift;
    
    if( @_ ){
        my $old = $self->{ attr };
        $self->{ attr } = $_[0];
        return $old;
    }
    else{
        return $self->{ attr };
    }
}

sub val{
    my $self = shift;
    
    if( @_ ){
        my $old = $self->{ val };
        $self->{ val } = $_[0];
        return $old;
    }
    else{
        return $self->{ val };
    }
}

sub pos{
    my $self = shift;
    
    if( @_ ){
        my $old = $self->{ pos };
        $self->{ pos } = $_[0];
        return $old;
    }
    else{
        return $self->{ pos };
    }
}

sub info{
    my $self = shift;
    
    if( @_ ){
        my $old = $self->{ info };
        $self->{ info } = $_[0];
        return $old;
    }
    else{
        return $self->{ info };
    }
}

sub new{
    my ( $proto, @args ) = @_;

    # bless
    my $self = {};
    my $pkg = ref $proto || $proto;
    bless $self, $pkg;
    
    # check args
    @args = %{ $args[0] } if ref $args[0] eq 'HASH';
    croak 'key-value pairs must be passed to new.' if @args % 2;
    
    # set args
    while( my ( $attr, $val ) = splice( @args, 0, 2 ) ){
        croak "Invalid key '$attr' is passed to new." unless $self->can( $attr );
        
        no strict 'refs';
        $self->$attr( $val );
    }
    
    $self->type( 'unknown' ) unless defined $self->type;
    $self->msg( '' ) unless defined $self->msg;
    $self->info( {} ) unless defined $self->info;
    
    local $Carp::CarpLevel += 1;
    $self->pos( Carp::shortmess("") ) unless defined $self->pos;
    
    return $self;
}

# die with Simo::Error object
sub throw{
    my $self = shift;
    local $Carp::CarpLevel += 1;
    my $err_obj = $self->new( @_ );
    die $err_obj;
}

=head1 NAME

Simo::Error - Error object for Simo

=head1 VERSION

Version 0.0206

=cut

=head1 

=head1 DESCRIPTION

Simo::Error provide structured error system to Simo.

You can create structure err message.

If err is ocuured, You can get err object;

=cut

=head1 CAUTION

Simo::Error is yet experimental stage.

=cut

=head1 SYNOPSIS

    use Simo::Error;
    
    # create error object;
    my $err_str = Simo::Error->new( 
        type => 'err_type',
        msg => 'message',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );
    
    # throw err
    Simo::Error->throw( 
        type => 'err_type',
        msg => 'message',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );

=head1 ACCESSOR

You can contain variouse error information.

=head2 type

is error type.

=head2 msg

is error message

=head2 pos

is position in which error is occured.

You do not have to specify this attr in create_err_str argument.

pos is automatically set, parsing croak message or die message.

=head2 pkg

is package name

=head2 attr

is attr name

=head2 val

is attr value

=head3 info

is information other than type, msg or pos.

This is hash ref.

=cut

=head1 METHOD

=head2 new

is constructor;

    my $err_obj = Simo::Error->new(
        type => 'err_type',
        msg => 'message',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );

=head2 throw

thorw error.

    Simo::Error->throw( 
        type => 'err_type',
        msg => 'message',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );
    
This is same as

    die Simo::Error->new( 
        type => 'err_type',
        msg => 'message',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );

=head1 AUTHOR

Yuki Kimoto, C<< <kimoto.yuki at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-simo-error at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Simo-Error>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Simo::Error


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Simo-Error>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Simo-Error>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Simo-Error>

=item * Search CPAN

L<http://search.cpan.org/dist/Simo-Error/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Yuki Kimoto, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Simo::Error
