#!/usr/bin/env perl

use Data::Dumper;
use Docker::Registry::Gitlab;
use Docker::Registry::Auth::Gitlab;

my $repo = $ARGV[0];

my $r = Docker::Registry::Gitlab->new(
    username     => 'username',
    access_token => 'personaltoken',
    defined $repo ? (repo => $repo) : (),
);

$r->caller->debug(1);

if (defined $repo) {
    print Dumper($r->repository_tags(repository => $repo));
}
else {
    my $repos = $r->repositories;
    print Dumper($repos);

    foreach my $r (@{ $repos->repositories }) {
        print Dumper($r->repository_tags(repository => $r));
    }
}
