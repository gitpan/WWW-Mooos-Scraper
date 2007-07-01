use Test::More skip_all => "At present, entry method test does skip";

use strict;
use WWW::Mooos::Scraper;

SKIP: {

    my $mooos = WWW::Mooos::Scraper->new;

    my $res = $mooos->entry( url => "http://www.mooos.net/", entry_type => "positive", comment => "it's cool!!" );

    ok(!exists $res->{error}, "not exists error");
    ok(exists $res->{success}, "exists success");
} # end of SKIP:

