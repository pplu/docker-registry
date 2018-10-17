package Docker::Registry::Call::Repositories;
  use Moo;
  use Types::Standard qw/Int/;

  our $url_params = [ ];

  our $query_params = [
    { name => 'n', isa => Int },
    { name => 'limit', isa => Int },
  ];

  our $method = 'GET';
  our $uri = '_catalog';

package Docker::Registry::Result::Repositories;
  use Moo;
  use Types::Standard qw/ArrayRef Str/;
  has repositories => (is => 'ro', isa => ArrayRef[Str]);

package Docker::Registry::Call::RepositoryTags;
  use Moo;
  use Types::Standard qw/Int Str/;

  our $url_params = [
    { name => 'repository', isa => Str, required => 1 },
  ];

  our $query_params = [
    { name => 'n', isa => Int },
    { name => 'limit', isa => Int },
  ];

  our $method = 'GET';
  our $uri = "{repository}/tags/list";


package Docker::Registry::Result::RepositoryTags;
  use Moo;
  use Types::Standard qw/ArrayRef Str/;
  has name => (is => 'ro', isa => Str, required => 1);
  has tags => (is => 'ro', isa => ArrayRef[Str], required => 1);

package Docker::Registry::CallObjectFormer;
  use Moo;
  use HTTP::Tiny;
  use Docker::Registry::Request;

  sub params2request {
    my ($self, $call, $base_url, $user_params) = @_;

    my $call_class = "Docker::Registry::Call::$call";

    my $params = { };
    foreach my $param (@{ $call_class::query_params }) {
      my $key = $param->{ name };
      my $value = $user_params->{ $key };
      next if (not defined $value);

      my $location = defined $param->{ location } ? $param->{ location } : $key;
      $params->{ $location } = $value;
    }
    my $url_params = {};
    foreach my $param (@{ $call_class::url_params }) {
      my $key = $param->{ name };
      my $value = $user_params->{ $key };
      next if (not defined $value);

      my $location = defined $param->{ location } ? $param->{ location } : $key;
      $url_params->{ $location } = $value;
    }

    my $method_ns = "$call::method";
    my $method = *$method_ns;
    my $uri_ns = "$call::uri";
    my $uri = *$uri_ns;
    my $url = join '/', $base_url, $uri;
    $url =~ s/\{([a-z0-9_-]+?)\}/$url_params->{ $1 }/ge;
use Data::Dumper;
print Dumper($params, $url_params, $method, $uri);

    my $request = Docker::Registry::Request->new(
      parameters => $params,
      method => $method,
      url => $url,
    );
    return $request;
  }

package Docker::Registry::ResultParser;
  use Moo;

  sub process_json_response {
    my ($self, $response) = @_;
    if ($response->status == 200) {
      my $struct = eval {
        $self->_json->decode($response->content);
      };
      if ($@) {
        Docker::Registry::Exception->throw({ message => $@ });
      }
      return $struct;
    } elsif ($response->status == 401) {
      Docker::Registry::Exception::Unauthorized->throw({
        message => $response->content,
        status  => $response->status,
      });
    } else {
      Docker::Registry::Exception::HTTP->throw({
        message => $response->content,
        status  => $response->status
      });
    }
  }

  sub result2return {
    my ($self, $method, $response) = @_;
    my $result_class = "Docker::Registry::Result::$method";
    my $result = $result_class->new($self->process_json_response($response));
    return $result;
  }

package Docker::Registry::V2;
  use Moo;
  use Types::Standard qw/Str ConsumerOf HasMethods/;

  has url => (is => 'ro', isa => Str, required => 1);
  has api_base => (is => 'ro', default => 'v2');

  has call_former => (is => 'ro', isa => HasMethods['params2request'], default => sub {
    Docker::Registry::CallObjectFormer->new;  
  });
  has io => (is => 'ro', isa => ConsumerOf['Docker::Registry::IO'], default => sub {
    require Docker::Registry::IO::Simple;
    Docker::Registry::IO::Simple->new;  
  });
  has auth => (is => 'ro', isa => ConsumerOf['Docker::Registry::Auth'], lazy => 1, builder => 'build_auth' );
  has result_parser => (is => 'ro', isa => HasMethods['result2return'], default => sub {
    Docker::Registry::ResultParser->new
  });

  sub build_auth {
    require Docker::Registry::Auth::None;
    Docker::Registry::Auth::None->new; 
  };

  use JSON::MaybeXS qw//;
  has _json => (is => 'ro', default => sub {
    JSON::MaybeXS->new;
  });

  sub _invoke {
    my ($self, $method, $params) = @_;
    my $url = sprintf('%s/%s', $self->url, $self->api_base);
    my $req = $self->call_former->params2request($method, $url, $params);
    $req = $self->auth->authorize($req);
    my $response = $self->io->send_request($req);
    return $self->result_parser->result2return($method, $response);
  }

  sub repositories {
    my $self = shift;
    # Inputs n, last
    #
    # GET /v2/_catalog
    #
    # Header next
    # {
    #   "repositories": [
    #     <name>,
    #     ...
    #   ]
    # }
    $self->_invoke('Repositories', { @_ });
  }

  sub repository_tags {
    my $self = shift;

    # n, last
    #GET /v2/$repository/tags/list
    #
    #{"name":"$repository","tags":["2017.09","latest"]}
    $self->_invoke('RepositoryTags', { @_ });
  }

  sub is_registry {
    my $self = shift;
    # GET /v2
    # if (200 or 401) and (header.Docker-Distribution-API-Version eq 'registry/2.0')
  }

  # Actionable failure conditions, covered in detail in their relevant sections,
  # are reported as part of 4xx responses, in a json response body. One or more 
  # errors will be returned in the following format:
  # {
  #  "errors:" [{
  #          "code": <error identifier>,
  #          "message": <message describing condition>,
  #          "detail": <unstructured>
  #      },
  #      ...
  #  ]
  # }

  # ECR: returns 401 error body as "Not Authorized"
  sub process_error {
    
  }

  sub request {
    
  }
1;
