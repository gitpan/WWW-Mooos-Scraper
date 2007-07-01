package WWW::Mooos::Scraper::Validate::Readers;

use strict;
use warnings;
use base qw(WWW::Mooos::Scraper::Validate);

our $VERSION = 0.01;

sub validate_map {

    my $self = shift;
    my %map = ( page => [ "skip", [ "regex", qr/^\d{1,}$/ ] ] );
    return \%map;
}


sub validate_message {

    my $self = shift;
    my %message = ( page => { regex => "it is not a value of one or more" } );
    return \%message;
}

1;

