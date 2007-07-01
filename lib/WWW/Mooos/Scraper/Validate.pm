package WWW::Mooos::Scraper::Validate;

=pod

=head1 NAME

WWW::Mooos::Scraper::Validate - WWW::Mooos::Scraper input validate module

=head1 VERSION

0.01

=head1 DESCRIPTION

WWW::Mooos::Scraper input validate module

=cut

use strict;
use warnings;
use base qw(Class::Accessor);
use Carp;
use Readonly;
use Sub::Install;

__PACKAGE__->mk_ro_accessors(qw(mooos));

our $VERSION = 0.01;

=pod

=head1 VALIDATE METHOD

Defined in %WWW::Mooos::Scraper::Validate::VALIDATE_METHOD

=head2 length

Length check

Example:

  # in WWW::Mooos::Scraper::Validate::validate_map
  param1 => [ [ "length", 30] ], # max 30
  param2 => [ [ "length", 0, 30] ], # between 0 and 30

=head2 regex

Regex check

Example:

  param1 => [ [ "regex", qr/^foo$/ ] ],

=head2 require

Require check

Example:

  param1 => [ "require" ],

=head2 skip

When check value is undef, other checks are not done

Example:

  # when param1 is not undef, length and regex check done
  param1 => [ "skip", [ "length", 30 ], [ "regex", qr/bar/ ]  ],

=head2 url

URL regex check

Example:

  param1 => [ "url" ],

=cut

Readonly my %VALIDATE_METHOD => (

    "length"  => sub {
                    my($self, $val, $args) = @_;
                    my($min, $max, $flag);
                    my $length = length $val;
                    if(scalar @{$args} == 2){
                        ($min, $max) = @{$args};
                        $flag = ($length <= $max && $length > $min) ? 1 : 0;
                    }else{
                        $max = $args->[0];
                        $flag = ($length <= $max) ? 1 : 0;
                    }
                    return $flag;
                },

    "regex"   => sub {
                    my($self, $val, $args) = @_;
                    return ($val =~ $args->[0]) ? 1 : 0;
                },

    "require" => sub {
                    my($self, $val) = @_;
                    return ($val ne "") ? 1 : 0;
                },
    "skip"    => sub { "skip" },

    "url"     => sub {
                    my($self, $val) = @_;
                    return ($val =~ /^s?https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+$/) ? 1 : 0;
                },
);


sub import {

    my $class = shift;
    map { 
        Sub::Install::install_sub({ 
                code => sub { croak("$_ is abstract method") },
                as   => $_
            })
    } qw(validate_map validate_message);
}

=pod

=head1 METHOD

=head2 new

Create instance

Example: 

  my $valid = WWW::Mooos::Scraper::Validate->new( mooos => $mooos );

=cut

sub new {

    my($class, %args) = @_;
    if(ref($args{mooos}) ne "WWW::Mooos::Scraper"){
        croak("args.mooos is not WWW::Mooos::Scraper instance");
    }
    return bless { mooos => $args{mooos} }, $class || ref $class;
}

=pod

=head2 validate

input validate

Example:

  my($p, $e) = $valid->validate(%param);
  if(keys %{$e}){
    # error trap
  }

=cut

sub validate {

    my($self, %param) = @_;
    my(%error, %check);

    my $validate_map     = $self->validate_map;
    my $validate_message = $self->validate_message;

    LOOP_VALIDATE_MAP:
    foreach my $key(keys %{$validate_map}){

        my $meths = $validate_map->{$key};
        LOOP_VALIDATE_METHOD:
        foreach my $m(@{$meths}){

            my $unless = 0;
            my $val    = "";
            my($meth, $meth_args);
            if(ref($m) eq "ARRAY"){
                $meth      = shift @{$m};
                $meth_args = $m;
            }else{
                $meth      = $m;
            }

            if($meth =~ /^\!(.+)$/){
                $unless = 1;
                $meth   = $1;
            }

            $val = $param{$key} if exists $param{$key};
            last if $meth eq "skip" && $val eq "";

            my $answer = $VALIDATE_METHOD{$meth}->($self, $val, $meth_args);

            if(!$answer && !$unless){
                
                $check{$key} = $validate_message->{$key}->{$meth};
                last;
            }

        } # end of LOOP_VALIDATE_METHOD:

    } # end of LOOP_VALIDATE_MAP:

    if(keys %check){

        %error = (
                error => "input data error",
                param => \%check
            );
    }
    return \%param, \%error;
}

=head1 ACCESSOR METHOD

=head2 mooos

Get WWW::Mooos::Scraper instance

Example:

  $mooos = $self->mooos;

=cut

=head1 ABSTRACT METHOD

=head2 validate_map

=head2 validate_message

1;

__END__

=head1 SEE ALSO

L<Class::Accessor> L<Readonly> L<Sub::Install>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software.
You can redistribute it and/or modify it under the same terms as perl itself.

Copyright (C) 2007 Akira Horimoto

=cut

