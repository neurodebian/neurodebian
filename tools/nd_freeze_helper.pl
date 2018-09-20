#!/usr/bin/perl
# Simple web client for retrieving neurodebian snapshot information.
# Code adapted from: https://www.oreilly.com/openbook/webclient/ch04.html
#
# This script covers the duties normally performed by wget, curl, and/or sed,
# any of which may not be installed on the target OS.

require 5.002;
use Socket;

sub get_www_content {
  my ($dest, $port, $file) = @_;
  my $proto = getprotobyname('tcp');
  socket(F, PF_INET, SOCK_STREAM, $proto);
  my $sin = sockaddr_in($port,inet_aton($dest));
  connect(F, $sin) || return undef;
  my $old_fh = select(F); 
  $| = 1;
  select($old_fh);
  print F "GET /$file HTTP/1.0\n\n";
  $/ = undef;
  $contents = <F>;
  close(F);
  return $contents;
}

if ($#ARGV != 2) {
  print "Usage: $0 hostname port file\n";
  print "\n Returns the HTTP output from a web server.\n\n";
  exit(-1);
}

$contents = get_www_content($ARGV[0], $ARGV[1], $ARGV[2]);

# This is a knock on the snapshot door. Nothing of value in the content.
if ($ARGV[0] eq 'neuro.debian.net') {
  exit(0)
}

# If the target page is redirected, get the contents of the new page.
if ($contents =~ /The resource has been moved to http:\/\/[0-9\.]+:5002\/(archive\/neurodebian\/\d{8}T\d{6}Z\/)/) {
  $contents = get_www_content($ARGV[0], $ARGV[1], $1);
}

# Search for and return the timestamp of the next snapshot after this one.
if ($contents =~ /\/archive\/neurodebian\/([0-9TZ]+)\/">next/) {
  print $1;
}
 
exit(0);
