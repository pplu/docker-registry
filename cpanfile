requires 'Moose';
requires 'JSON::MaybeXS';
requires 'HTTP::Tiny';
requires 'HTTP::Headers';
requires 'Throwable::Error';
requires 'IO::Socket::SSL';
requires 'Paws';

requires 'Crypt::JWT';
requires 'Path::Class';

on develop => sub {
  requires 'Dist::Zilla';
  requires 'Dist::Zilla::Plugin::Prereqs::FromCPANfile';
  requires 'Dist::Zilla::Plugin::VersionFromModule';
  requires 'Dist::Zilla::PluginBundle::Git';
};
