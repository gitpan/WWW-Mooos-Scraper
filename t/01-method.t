use Test::More tests => 2;

use strict;
use WWW::Mooos::Scraper;

my $mooos = WWW::Mooos::Scraper->new;

# accessor method
can_ok($mooos, qw(time_zone time));

# request method
can_ok($mooos, qw(readers search entry));

