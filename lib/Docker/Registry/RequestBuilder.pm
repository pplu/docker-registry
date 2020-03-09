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
      $request = Docker::Registry::Request->new(
        method => 'GET',
        url => (join '/', $self->url, $self->api_base, '_catalog')
      );

    } elsif (ref($call) eq 'Docker::Registry::Call::RepositoryTags') {
      $request = Docker::Registry::Request->new(
        method => 'GET',
        url => (join '/', $self->url, $self->api_base, $call->repository, 'tags/list')
      );
    } else {
      Docker::Exception->throw(
        message => sprintf("Unknown call class: %s", ref($call)),
      );
    }

    return $request;
  }


1;
