use strict;
use warnings;

use 5.014001;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "A client for talking to Docker Registries",
  "AUTHOR" => "Jose Luis Mart\x{ed}nez <joseluis.martinez\@capside.com>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Docker-Registry",
  "LICENSE" => "apache",
  "MIN_PERL_VERSION" => "5.014001",
  "NAME" => "Docker::Registry",
  "PREREQ_PM" => {
    "HTTP::Headers" => 0,
    "HTTP::Tiny" => 0,
    "IO::Socket::SSL" => 0,
    "JSON::MaybeXS" => 0,
    "MIME::Base64" => 0,
    "Moo" => 0,
    "Throwable::Error" => 0,
    "Types::Standard" => 0,
    "namespace::autoclean" => 0
  },
  "TEST_REQUIRES" => {
    "Import::Into" => "1.002003",
    "Sub::Override" => 0,
    "Test::Deep" => 0,
    "Test::Exception" => 0,
    "Test::Lib" => 0,
    "Test::More" => 0,
    "Test::Most" => 0,
    "Test::Spec" => 0,
    "Test::Spec::Mocks" => 0
  },
  "VERSION" => "0.08",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "HTTP::Headers" => 0,
  "HTTP::Tiny" => 0,
  "IO::Socket::SSL" => 0,
  "Import::Into" => "1.002003",
  "JSON::MaybeXS" => 0,
  "MIME::Base64" => 0,
  "Moo" => 0,
  "Sub::Override" => 0,
  "Test::Deep" => 0,
  "Test::Exception" => 0,
  "Test::Lib" => 0,
  "Test::More" => 0,
  "Test::Most" => 0,
  "Test::Spec" => 0,
  "Test::Spec::Mocks" => 0,
  "Throwable::Error" => 0,
  "Types::Standard" => 0,
  "namespace::autoclean" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
