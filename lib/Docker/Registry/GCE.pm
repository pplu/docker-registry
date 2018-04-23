package Docker::Registry::GCE;
  use Moose;
  extends 'Docker::Registry::V2';

  has project_id => (is => 'ro', isa => 'Str', required => 1);

  has '+url' => (lazy => 1, default => sub {
    my $self = shift;
    'https://gcr.io';
  });

1;
