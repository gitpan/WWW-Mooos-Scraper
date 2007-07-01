use 5.008000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'WWW::Mooos::Scraper',
    VERSION_FROM      => 'lib/WWW/Mooos/Scraper.pm', # finds $VERSION
    PREREQ_PM         => {

    'Class::Accessor'    => 0.30,
    'DateTime'           => 0.37,
    'HTTP::Request'      => 1.40,
    'LWP::UserAgent'     => 2.033,
    'Readonly'           => 1.03,
    'Sub::Install'       => 0.924,
    'UNIVERSAL::require' => 0.11,
    'URI'                => 1.35,
    'Web::Scraper'       => 0.07,

    }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/WWW/Mooos/Scraper.pm', # retrieve abstract from module
       AUTHOR         => 'Akira Horimoto <kurt0027@gmail.com>') : ()),
);
