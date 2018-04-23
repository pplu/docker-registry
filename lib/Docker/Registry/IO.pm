package Docker::Registry::IO;
  use Moose::Role;

  # load this "almost empty" class because
  # IO modules use $Docker::Registry::VERSION
  # in the User Agent
  use Docker::Registry;

  requires 'send_request';

1;
