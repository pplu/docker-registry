#!/usr/bin/env perl

use Docker::Registry::V2;
use Test::More;

{
  my $f = Docker::Registry::CallObjectFormer->new;

  my $req = $f->params2request('TestCall', { n => 42, s => 'string1', url_param1 => 'up1', url_param2 => 'up2' });

  use Data::Dumper;
  print Dumper($req);

  cmp_ok($req->method, 'eq', 'GET');
  cmp_ok($req->url, 'eq', 'http://example.com/up1/more/up2/url');
  like($req->url, qr/n=42/);
  like($req->url, qr/s=string1/);
  
}

done_testing;

package Docker::Registry::Call::Repositories;
  use Moo;
  use Types::Standard qw/Int Str/;

  our $url_params = [ ];

  our $query_params = [
    { name => 'n', isa => Int },
    { name => 's', isa => Str },
  ];

  our $method = 'GET';
  our $uri = '{url_param1}/more/{url_param2}/url';

1;
