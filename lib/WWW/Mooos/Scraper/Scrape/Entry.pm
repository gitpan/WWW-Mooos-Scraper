package WWW::Mooos::Scraper::Scrape::Entry;

use strict;
use warnings;
use base qw(WWW::Mooos::Scraper::Scrape);
use Carp;
use HTTP::Request;
use LWP::UserAgent;

our $VERSION = 0.02;


sub valid_param {

    my($self, %param) = @_;
}


sub scrape_uri {

    my($self, %param) = @_;
    my $uri = $self->uri->clone;
    my $path = "/entry.php";
    $uri->path($path);

    my $entry_type = delete $param{entry_type};
    $param{"${entry_type}.x"} = 1;
    $param{"${entry_type}.y"} = 1;

    $uri->query_form(\%param);

    return $uri;
}


# it is not a scrape method in reality...
sub scrape_run {

    my($self, $uri) = @_;

    my $ref;
    my($base_url, $content) = split /\?/, $uri->as_string;

    my $ua = LWP::UserAgent->new(agent => sprintf "%s/%.2f", __PACKAGE__, $VERSION);
    my $req = HTTP::Request->new(
                                POST => $base_url,
                                [ "Content-type" => "application/x-www-form-urlencoded" ],
                                $content
                                );
    my $res = $ua->request($req);
    
    # assumed [ success: response code 302 ]...
    # 302 response code returns when succeeding. things except the 302 return when failing. 
    my $code = $res->code;
    if($code == 302){
        $ref = { success => 1 };
    }else{
        $ref = { error => "unknown error: $code" };
    }
    return $ref;
}


1;

