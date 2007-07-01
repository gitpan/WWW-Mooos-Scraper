package WWW::Mooos::Scraper;

=pod

=head1 NAME

WWW::Mooos::Scraper - Mooos scraper module

=head1 VERSION

0.01

=head1 SYNOPSIS

  use WWW::Mooos::Scraper;
  use strict;

  my $mooos = WWW::Mooos::Scraper->new;
  my $res = $mooos->readers(page => 1);
  if(exists $res->{error}){
    die $res->{error};
  }
  
  foreach my $article(@{$res->{recent_articles}}){
    
     while(my($key, $val) = each %{$article}){
        printf "%-15s %s\n", $key, $val;
     }
  }

=head1 DESCRIPTION

Mooos is open message boards service.

It scrapes the content of this site. 

URL http://www.mooos.net/

=cut

use strict;
use warnings;
use 5.008000;
use base qw(Class::Accessor);
use Carp;
use Readonly;
use Sub::Install;
use UNIVERSAL::require;

__PACKAGE__->mk_accessors(qw(time_zone));
__PACKAGE__->mk_ro_accessors(qw(time));

our $VERSION = 0.01;

Readonly my $MOOOS_BASE_URL => "http://www.mooos.net/";
Readonly my $MOOOS_TIMEZONE => "Asia/Tokyo";
Readonly my %SCRAPE_PACKAGE => (
                            entry   => "Entry",
                            readers => "Readers",
                            search  => "Search"
                            );

sub import {

    while(my($key, $val) = each %SCRAPE_PACKAGE){

        my $code = sub {

            my($self, %param) = @_;
            my $v_pkg  = sprintf "%s::Validate::%s", __PACKAGE__, $val;
            my $s_pkg  = sprintf "%s::Scrape::%s", __PACKAGE__, $val;

            # %param validate
            $v_pkg->require or croak($UNIVERSAL::require::ERROR);
            my $valid  = $v_pkg->new( mooos => $self );
            my($p, $e) = $valid->validate(%param);
            return $e if keys %{$e};

            # scraping start
            $s_pkg->require or croak($UNIVERSAL::require::ERROR);
            my $scrape = $s_pkg->new( mooos => $self, uri => $MOOOS_BASE_URL );
            return $scrape->scrape(%param);
        };
        Sub::Install::install_sub({ code => $code, as => $key });
    }
}

=pod

=head1 METHOD

=head2 new

Create instance

Option:

  time_zone : your location time zone(default: Asia/Tokyo)

Example:

  my $mooos = WWW::Mooos::Scraper->new;

=cut


sub new {

    my($class, %args) = @_;
    return bless { 
        "time_zone" => $args{time_zone} || $MOOOS_TIMEZONE,
        "time"      => time,
    }, $class || ref $class;
}

=pod

=head2 entry

It enters it in url that wants to comment

Options:

  comment    : comment(require, utf8 string. but no utf8flag)
  entry_type : positive or negative(require)
  url        : url(require)

Example:

  my $res = $mooos->entry( comment => "comment string", entry_type => "positive", url => "http://your.want.to.comment.url/" );
  if(exists $res->{error}){
    # error trap!
    print Dumper($res);
    exit;
  }elsif(exists $res->{success}){
    # success. do something...
  }

=head2 readers

Get recent 10 articles

Option:

  page : page number(default 1)

Example:

  my $res = $mooos->readers( page => 1 );
  if(exists $res->{error}){
     # error trap!
     print Dumper($res);
     exit;
  }
  
  foreach my $article(@{$res}){
    
    print "page_title: " . $article->{page_title} . "\n";
    print "page_url: " . $article->{page_url} . "\n";             # URI instance
    print "comment_num: " . $article->{comment_num} . "\n";
    print "mooos_page_url: " . $article->{mooos_page_url} . "\n"; # URI instance
    print "entry_time: " . $article->{entry_time} . "\n";         # DateTime instance
    print "comment: " . $article->{comment} . "\n";
    print "entry_type: " . $article->{entry_type} . "\n";
    print "-" x 50;
    print "\n";
  }

=head2 search

Get url search 

Option:

  page : page number(default 1)
  url  : url(require)

Example:

  my $res = $mooos->search( page => 1, url => "http://your.want.to.search.url/" );
  if(exists $res->{error}){
     # error trap!
     print Dumper($res);
     exit;
  }
  
  print "page_title: " . $article->{page_title} . "\n";
  print "page_url: " . $article->{page_url} . "\n";             # URI instance
  print "thumbnail_url: " . $article->{thumbnail_url} . "\n";   # URI instance
  print "comment_num: " . $article->{comment_num} . "\n";
  foreach my $comment(@{$res->article_comments}){
    
    print "comment: " . $article->{comment} . "\n";
    print "entry_time: " . $article->{entry_time} . "\n";       # DateTime instance
    print "entry_type: " . $article->{entry_type} . "\n";
    print "-" x 50;
    print "\n";
  }

=head1 ACCESSOR METHOD

=head2 time_zone

Get/Set your location time zone

Example:

  $mooos->time_zone("Asia/Taipei");
  $time_zone = $mooos->time_zone;

=head2 time

Get timestamp

Example:

  $time = $mooos->time;

=cut

1;

__END__

=head1 SEE ALSO

L<Class::Accessor> L<Readonly> L<Sub::Install> L<UNIVERSAL::require>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software.
You can redistribute it and/or modify it under the same terms as perl itself.

Copyright (C) 2007 Akira Horimoto

=cut

