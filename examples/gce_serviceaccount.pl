#!/usr/bin/env perl

use Data::Dumper;
use Docker::Registry::GCE;
use Docker::Registry::Auth::GCEServiceAccount;

my $sa = Docker::Registry::Auth::GCEServiceAccount->new();

my $r = Docker::Registry::GCE->new(
  auth => $sa_auth,
);

$r->caller->debug(1);

my $repos = $r->repositories;
print Dumper($repos);

foreach my $repo (@{ $repos->repositories }) {
  print Dumper($r->repository_tags(repository => $repo));
}
