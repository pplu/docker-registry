#!/usr/bin/env perl
use strict;
use warnings;
use Test::Spec;
use Test::Spec::Mocks;
use JSON::MaybeXS 'encode_json';

use Docker::Registry::V2;
use Docker::Registry::Request;
use Docker::Registry::Response;


describe "'n' parameter" => sub {
  my $d = Docker::Registry::V2->new(
      url => 'https://my.awesome.registry',
  );
  my $repository = 'my-repository';
  my ($expected_request, $stubbed_response);

  describe "When it is not passed" => sub {
    before each => sub {
      $expected_request = _request({ repository => $repository });
      $stubbed_response = _response();
      $d->caller
        ->expects('send_request')
        ->with_deep($expected_request)
        ->returns($stubbed_response);
    };

    it 'is not added to the request & the result is correctly parsed' => sub {
      my $result = $d->repository_tags(repository => $repository);
      cmp_ok($result->name, 'eq', $repository);
      is_deeply($result->tags, ['v1','v2']);
    };
  };

  describe "When it is passed" => sub {
    before each => sub {
      $expected_request = _request({ repository => $repository, n => 101 });
      $stubbed_response = _response({ n => 101 });
      $d->caller
        ->expects('send_request')
        ->with_deep($expected_request)
        ->returns($stubbed_response);
    };

    it 'is added to the request & the result is correctly parsed' => sub {
      my $result = $d->repository_tags(repository => $repository, n => 101);
      cmp_ok($result->name, 'eq', $repository);
      is_deeply($result->tags, [map { "v$_" } (1..101)]);
    };
  };
};

runtests unless caller;


sub _request {
  my $args = shift;

  my $url = join '/', 'https://my.awesome.registry', 'v2', $args->{repository}, 'tags/list';

  return Docker::Registry::Request->new(
    method => 'GET',
    url => $args->{n}
      ? "$url?n=$args->{n}"
      : $url,
  );
}


sub _response {
  my $args = shift;
  my $n = $args->{n} || 2;

  return Docker::Registry::Response->new(
    status => 200,
    headers => {
      'docker-distribution-api-version' => 'registry/2.0',
      'date' => 'Wed, 21 Oct 2015 07:28:00 GMT',
      'transfer-encoding' => 'chunked',
      'content-type' => 'text/plain; charset=utf-8',
      'connection' => 'keep-alive',
    },
    content => $args->{content}
      ? encode_json($args->{content})
      : encode_json({ name => 'my-repository', tags =>  [map { "v$_" } (1..$n)] }),
  );
}
