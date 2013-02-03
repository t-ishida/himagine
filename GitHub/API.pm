package GitHub::API;
use strict;
use Exporter;
use JSON qw/decode_json/;
use Net::GitHub;
use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
our @ISA          = qw (Exporter);
our @EXPORT       = qw/searchRepos searchIssues/;
my $reposSearchUrl = 'https://api.github.com/legacy/repos/search';
my $issueSearchUrl = 'https://api.github.com/repos';
my $userUrl        = 'https://api.github.com/user';
my $TOKEN          = '';
my $USER_REAL_ID   = '';

sub login {
  my $github = Net::GitHub->new ( login => shift, pass => shift );
  my $oauth = $github->oauth;
  my $o = $oauth->create_authorization( {
    #scopes => ['public_repo', 'delete_rep'], #['user', 'public_repo', 'repo', 'gist'],
    scopes => ['public_repo'], 
    note   => 'test purpose',
  });
  $TOKEN = $o->{token};
  my $user = decode_json ( get ( $userUrl . '?access_token=' . $TOKEN ) ); 
  $USER_REAL_ID = $user->{id};
}

sub getUserId { 
  return $USER_REAL_ID ;
}

sub setUserId { 
  $USER_REAL_ID = shift;
}

sub getToken { 
  return $TOKEN;
}

sub setToken {
  $TOKEN = shift;
}

sub searchRepos {
  my $tmp = getJson ( $reposSearchUrl . '/' . shift  . '?per_page=10&access_token=' . $TOKEN );
  #my @tmp_arr = ();
  #push @tmp_arr, $tmp->{repositories}[$_]  for 0..5;
  #$tmp->{repositories} = \@tmp_arr;
  return $tmp;
}

sub searchIssues {
  return getJson ( $issueSearchUrl . '/' . shift  . '/' . shift . '/issues' . '?access_token=' . $TOKEN );
}

sub getJson {
  my $url = shift;
  my $content =   get ( $url ) or return [];
  my $result =  decode_json ( $content );
  return $result;
}

sub fork {
  my $target_rep = shift;
  my $url     = 'https://api.github.com/repos/' . $target_rep->{owner} . '/'. $target_rep->{name} . '/forks?access_token=' . $TOKEN;
  my $request = POST($url, []);
  my $ua = LWP::UserAgent->new;
  $ua->timeout(30);
  my $response = $ua->request($request);

  if ($response->is_success) {
    return decode_json ( $response->content );
  } else {
    die $response->status_line, "\n";
  }
}

sub delete {
  return '';
  my $target_rep = shift;
  my $url     = 'https://api.github.com/repos/' . $target_rep->{owner} . '/'. $target_rep->{name} . '/?access_token=' . $TOKEN;
  my $request = new HTTP::Request ( DELTE => $url );
  my $ua = LWP::UserAgent->new;
  $ua->timeout(30);
  my $response = $ua->request($request);
  if ( !$response->is_success ) {
    die $response->status_line, "\n";
  }
}

sub clone {
  system 'git clone http://github.com/' . shift . '/' . shift . ' ' . shift; 
}
1;
