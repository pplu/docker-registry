#!/usr/bin/env perl

use Data::Dumper;
use Docker::Registry::ECR;
use Docker::Registry::Auth::ECR;

my $r = Docker::Registry::ECR->new(
  account_id => '000000000000',
  region => 'eu-central-1',
);
$r->caller->debug(1);

print Dumper($r->repositories);

print Dumper($r->repository_tags(repository => 'test2-registry'));
