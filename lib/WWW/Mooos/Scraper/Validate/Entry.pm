package WWW::Mooos::Scraper::Validate::Entry;

use strict;
use warnings;
use base qw(WWW::Mooos::Scraper::Validate);

our $VERSION = 0.01;

sub validate_map {

    my $self = shift;
    my %map = (
        url        => [ "require", "url", [ "length", 256 ] ],
        comment    => [ "require", [ "length", 2500 ] ],
        entry_type => [ "require", [ "regex", qr/^(positive|negative)$/ ] ],
    );
    return \%map;
}


sub validate_message {

    my $self = shift;
    my %message = (
        url        => { 
            "require" => "value is empty",
            "url"     => "invalid url string",
            "length"  => "within 256 bytes",
        },
        comment    => {
            "require" => "value is empty",
            "length"  => "within 2500 bytes",
        },
        entry_type => {
            "require" => "value is empty",
            "regex"   => "invalid entry type. positive or negative",
        }
    );
    return \%message;
}

1;

