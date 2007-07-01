package WWW::Mooos::Scraper::Scrape;

=pod

=head1 NAME

WWW::Mooos::Scraper::Scrape - WWW::Mooos::Scraper scraping module

=head1 VERSION

0.01

=head1 DESCRIPTION

WWW::Mooos::Scraper scraping module

=cut

use strict;
use warnings;
use base qw(Class::Accessor);
use Carp;
use Sub::Install;
use WWW::Mooos::Scraper::Util qw(
                                _entry_time2datetime
                                _get_entry_type
                                _get_mooos_page_url
                                _h2z
                                _strip
                                _uri
                                _utf8_encode
                                );

__PACKAGE__->mk_ro_accessors(qw(mooos uri));

our $VERSION = 0.01;

sub import {

    my $class = shift;
    map { 
        Sub::Install::install_sub({ 
                code => sub { croak("$_ is abstract method") },
                as   => $_
            })
    } qw(scrape_uri scrape_run);
}

=pod

=head1 METHOD

=head2 new

Create instance

Example: 

  my $valid = WWW::Mooos::Scraper::Scrape->new( mooos => $mooos, uri => WWW::Mooos::Scraper::Util::_uri($WWW::Mooos::Scraper::MOOOS_BASE_URL) );

=cut

sub new {

    my($class, %args) = @_;
    if(ref($args{mooos}) ne "WWW::Mooos::Scraper"){
        croak("args.mooos is not WWW::Mooos::Scraper instance");
    }
    return bless {
        "mooos"   => $args{mooos},
        "uri"     => _uri($args{uri}),
    }, $class || ref $class;
}

=pod

=head2 scrape

Mooos scrape

Example:

  my $res = $scrape->scrape(%param);

=cut

sub scrape {

    my($self, %param) = @_;
    my $uri = $self->scrape_uri(%param);
    my $res;
    eval { $res = $self->scrape_run($uri) };
    if($@){
        my $error = $@;
        $res = { error => $error };
    }else{
        $res = $self->scrapef($res);
    }
    return $res;
}

=pod

=head2 scrapef

format scrape_run result

Example:

  my $res = $scrape->scrape_run($uri);
  my $res = $scrape->scrapef($res);

=cut

sub scrapef {

    my($self, $ref) = @_;
    my $reftype = ref $ref;
    if($reftype eq "ARRAY"){
        $ref = [ map { $self->scrapef($_) } @{$ref} ];
    }elsif($reftype eq "HASH"){
        my $tmp = {};
        while(my($key, $val) = each %{$ref}){

            $key = $self->scrapef($key);
            $val = $self->scrapef($val);
            
            if($key eq "entry_time"){
                $val = _entry_time2datetime($val, $self->mooos->time, $self->mooos->time_zone);
            }elsif($key eq "entry_type"){
                $val = _get_entry_type($val);
            }elsif($key eq "mooos_page_url"){
                $val = _get_mooos_page_url($val, $self->uri->clone);
            }elsif($key eq "page_url" || $key eq "thumbnail_url"){
                $val = _uri($val);
            }

            $tmp->{$key} = $val;
        }
        $ref = $tmp;
    }elsif($reftype eq "SCALAR"){
        $ref = \$self->scrapef(${$ref});
    }elsif(!$reftype && $ref){

        # final point
        $ref = _utf8_encode($ref);
        $ref = _h2z($ref);
        $ref = _strip($ref);
    }
    return $ref;
}

=head1 ACCESSOR METHOD

=head2 mooos

Get WWW::Mooos::Scraper instance

Example:

  $mooos = $self->mooos;

=head2 uri

Get URI instance

Example:

  $uri = $self->uri;

=head1 ABSTRACT METHOD

=head2 scrape_uri

=head2 scrape_run

=cut

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

