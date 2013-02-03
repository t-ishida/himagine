package Himagine::Web;
use strict;
use LWP::UserAgent;
use HTTP::Request::Common qw /POST/;
use JSON qw/decode_json/;

my $BASE_URL = 'http://github-kirin.com:8000/user_issue/save';

## @uid=54685
## @issue_id=673
## @owner=facebook
## @repository=tornado
## comment=helloworld
sub post {
  my %params = @_;
  my $request = POST($BASE_URL, [%params]);
  my $ua = LWP::UserAgent->new;
  $ua->timeout(30);
  my $response = $ua->request($request);

  if ($response->is_success) {
    return decode_json ( $response->content );
  } else {
    die $response->status_line, "\n";
  }

}
