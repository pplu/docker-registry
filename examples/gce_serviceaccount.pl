#!/usr/bin/env perl

use Data::Dumper;
use Docker::Registry::GCE;
use Docker::Registry::Auth::GCEServiceAccount;

my $sa = Docker::Registry::Auth::GCEServiceAccount->new();

my $r = Docker::Registry::GCE->new(
  project_id => 'project_id',
  auth => $sa_auth,
);

$r->caller->debug(1);

print Dumper($r->repositories);

print Dumper($r->repository_tags(repository => 'repo'));
