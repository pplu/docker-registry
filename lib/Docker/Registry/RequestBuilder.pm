package Docker::Registry::RequestBuilder;
  use Moo;

  use Docker::Registry::Request;
  use Docker::Registry::Types qw(DockerRegistryURI);

  has url => (is => 'ro', coerce => 1, isa => DockerRegistryURI, required => 1);
  has api_base => (is => 'ro', default => 'v2');

  sub build_request {
    my ($self, $call) = @_;
    my $request;

    if (ref($call) eq 'Docker::Registry::Call::Repositories') {
      my $url = join '/', $self->url, $self->api_base, '_catalog';
      $url .= "?n=".$call->n  if($call->n);

      $request = Docker::Registry::Request->new(
        method => 'GET',
        url => $url,
      );

    } elsif (ref($call) eq 'Docker::Registry::Call::RepositoryTags') {
      my $url = join '/', $self->url, $self->api_base, $call->repository, 'tags/list';
      $url .= "?n=".$call->n  if($call->n);

      $request = Docker::Registry::Request->new(
        method => 'GET',
        url => $url,
      );
    } else {
      Docker::Exception->throw(
        message => sprintf("Unknown call class: %s", ref($call)),
      );
    }

    return $request;
  }


1;
