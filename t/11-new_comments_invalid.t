use Test::More tests => 3;

use strict;
use WWW::Mooos::Scraper;

my $mooos = WWW::Mooos::Scraper->new;

my $res = $mooos->new_comments( page => "aaaa" );

ok(exists $res->{error}, "exists error");

ok(exists $res->{param}->{page}, "exists param > page");

is($res->{param}->{page}, "it is not a value of one or more", "page error message");


