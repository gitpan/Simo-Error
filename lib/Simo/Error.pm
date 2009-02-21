package Simo::Error;

use warnings;
use strict;
use Carp;

our $VERSION = '0.01_01';

# accessor

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
    my ( $proto, %args ) = @_;
    my $class = ref $proto || $proto;
    my $self = \%args;
    return bless $self, $class;
}

{
    my $old_err_str = '';
    my $cash_err_obj;
    
    sub create_from_err_str{
        my ( $self, $err_str ) = @_;
        return unless $err_str;
        
        if( $err_str eq $old_err_str ){
             return $cash_err_obj;
        }
        
        my $err_hash = $self->_create_err_hash( $err_str );
        
        my $err_obj = Simo::Error->new( %{ $err_hash } );
        
        $old_err_str = $err_str;
        $cash_err_obj = $err_obj;
        return $err_obj;
    }
}

sub _create_err_hash{
    my ( $self, $err_str_and_pos ) = @_;
    
    my $err_str;
    my $pos;
    my $is_simo_err = 1;
    
    my @token;
    if( $err_str_and_pos =~ /^Error: \{( [^{}]*? )\}(.*)$/s ){
        $err_str = $1;
        $pos = $2 || '';
        
        $err_str = '' if $err_str eq '  '; # case: no args;
        my $phase = 'key';
        
        OUTER: while( 1 ){
            last if $err_str eq '';
            
            if( $phase eq 'key' ){
                if( $err_str =~ s/ (\w+) => // ){
                    push @token, $1;
                    $phase = 'value';
                }
                else{
                    $is_simo_err = 0;
                    last;
                }
            }
            elsif( $phase eq 'value' ){
                if( $err_str =~ s/^'// ){
                    my $single_quote_pos;
                    my $search_pos = 0;
                    
                    while( 1 ){
                        $single_quote_pos = index( $err_str, "'", $search_pos );
                        if( $single_quote_pos == -1 ){
                            $is_simo_err = 0;
                            last OUTER;
                        }
                        else{
                            if( substr( $err_str, $single_quote_pos - 1, 1) eq '\\' ){
                                $search_pos = $single_quote_pos + 1;
                                next;
                            }
                            
                            my $value = substr( $err_str, 0, $single_quote_pos );
                            $value =~ s/\\'/'/g;
                            push @token, $value;
                            $err_str = substr( $err_str, $single_quote_pos + 2 );
                            $phase = 'key';
                            last;
                        }
                    }
                }
                else{
                    $is_simo_err = 0;
                    last;
                }
            }
        }
    }
    else{
        $is_simo_err = 0;
    }
    
    my $err_hash = {};
    if( $is_simo_err ){
        $err_hash = { @token };
        my $type = delete $err_hash->{ type } || '';
        my $msg = delete $err_hash->{ msg } || '';
        $pos =~ s/\n/ /g;
        
        my $info = $err_hash;
        $err_hash = { type => $type, msg => $msg, pos => $pos, info => $info };
    }
    else{
        $err_hash = { type => 'unknown', msg => $err_str_and_pos, pos => '', info => {} };
    }
    
    return $err_hash;
}

sub create_err_str{
    my ( $self, @args ) = @_;
    @args = %{ $args[0] } if ref $args[0] eq 'HASH';
    
    croak "key-value pairs must be passed to 'create_err_str'." if @args % 2;
    
    my %args = @args;
    
    my $err_str = qq/Error: { /;
    
    while( my ( $key, $value ) = splice( @args, 0, 2 ) ){
        croak "Key must be word charcter." unless $key =~ /^\w+$/;
        $err_str .= qq/$key => /;
        $value =~ s/'/\\'/g;
        $err_str .= qq/'$value', /;
    }
    
    $err_str =~ s/, $//;
    
    $err_str .= qq/ }/;
    
    return $err_str;
}

=head1 NAME

Simo::Error - Error object for Simo

=head1 VERSION

Version 0.01_01

=cut

=head1 DESCRIPTION

Simo::Error provide structured error system to Simo.

You can create structure err message.

If err is ocuured, You can get err object;

=cut

=head1 SYNOPSIS

    use Simo::Error;
    
    # create structured error string
    my $err_str = Simo::Error->create_err_str( 
        type => 'err_type',
        msg => 'message',
        a => 'some 1';
        b => 'some 2';
    );
    
    # $err_str is 
    # "Error: { type => 'err_type', msg => 'message' }"
    
    # this can use with croak or die;
    eval{
        croak $err;
    }
    
    # get err object
    my $err_obj = Simo::Error->create_from_err_str( $@ );
    
    # check err
    if( $err_obj ){
        if( $err_obj->type eq 'err_type' ){
            my $msg = $err_obj->msg;
            my $pos = $err_obj->pos; # error occured place, which 'croak' create.
            my $info = $err_obj->info; # other than type, msg, pos is packed into info.
            
            my $a = $info->{ a };
            my $b = $ingo->{ b };
        }
    }

=head1 CLASS METHOD

=head2 create_err_str

create structured error string.

    my $err_str = Simo::Error->create_err_str( 
        type => 'err_type',
        msg => 'message'
    );

Structured error stirng is like

    Error: { type => 'err_type', msg => 'message' }

You can convert this stuructured error string to error object
by using create_from_err_str.

This method is used with croak or die.

    croak Simo::Error->create_err_str( 
        type => 'err_type',
        msg => 'message'
    );
    
=cut


=head1 ACCESSOR

=head2 type

is error type.

=head2 msg

is error message

=head2 pos

is position in which error is occured.

You do not have to specify this attr in create_err_str argument.

pos is automatically set, parsing croak message or die message.

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
        pos => 'position error occured',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );

=head2 create_from_err_str

is create Simo::Error object parsing error sting

Error string is usually created by create_err_str method.

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
