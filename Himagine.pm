package Himagine;
use strict;
use FindBin;
use GitHub::API;
use Data::Dumper;
my $DATA_FILE_NAME = '.hima.data';
#
# ディレクトリ一覧を表示
#
sub showDirList {
  printf '[%' . (length scalar @_ ) . 'd]%s' . "\n", $_ + 1, $_[$_] for 0.. $#_;
}

sub separateValuesByDirName {
    my ( $owner, $rep_name, $issue_id ) = shift =~ /OWNER_(.+)_REP_(.+)_ISSUE_(.+)/;
    return ( owner => $owner, rep => $rep_name, issue => $issue_id );
}

#
# リポジトリ一覧の表示
#
sub showRepositoryList {
    my @repos   = @_;
    my %max_len = ();
    $max_len{index} = length @repos;
    for ( @repos ) {
      $max_len{name}     = length $_->{name}                if !$max_len{name}     or $max_len{name}     < length $_->{name};
      $max_len{issues}   = length ( @{$_->{issues}} . "" )  if !$max_len{issues}   or $max_len{issues}   < length ( @{$_->{issues}} . "" );
      $max_len{watchers} = length ( $_->{watchers}  . "" )  if !$max_len{watchers} or $max_len{watchers} < length ( $_->{watchers}. "" );
    }

    my $tmpl = '[%2d]%-' . $max_len{name} . 's W:%' . $max_len{watchers} . 'd I:%' .  $max_len{issues} . 'd';
    for ( my $i = 0; $i < @repos; $i++ ) {
      $_ = $repos[$i];
      printf "$tmpl\n", $i + 1, $_->{name}, $_->{watchers}, @{$_->{issues}} - 0;
    }
}

#
# 課題一覧の表示
#
sub showIssueList {
  my $target_rep = shift;
  my %max_len = ();
  $max_len{index} = length @{$target_rep->{issues}};
  for ( @{$target_rep->{issues}} ) {
    $max_len{title} = length $_->{title}        if !$max_len{title} or $max_len{title} < length $_->{title};
    $max_len{user}  = length $_->{user}{login}  if !$max_len{user}  or $max_len{user}  < length $_->{user}{login};
    $max_len{state} = length $_->{state}        if !$max_len{state} or $max_len{state} < length $_->{state};
  }
  my $tmpl = '[%2d]%-' . $max_len{title} . 's by %-' . $max_len{user} . 's state:%-' .  $max_len{state} . 's';

  for ( my $i = 0; $i < @{$target_rep->{issues}}; $i++ ) {
    $_ = $target_rep->{issues}[$i];
    printf  $tmpl . "\n", $i + 1 , $_->{title}, $_->{user}{login}, $_->{state};
  }
}

sub login {
  my $login = {};
  if ( -f $DATA_FILE_NAME ) {
    my $f;
    open $f, $DATA_FILE_NAME;
    my $content = join '', <$f>;
    close $content;
    eval $content;
    eval '$login = $VAR1';
  }
  
  if ( $login->{token} ) {
    GitHub::API::setToken ( $login->{token} );
    GitHub::API::setUserId ( $login->{userId} );
  }
  else {
    GitHub::API::login ( shift, shift );
    $login->{token} = GitHub::API::getToken();
    $login->{userId} = GitHub::API::getUserId();
    my $f;
    open $f, ' > ' . $DATA_FILE_NAME;
    print $f Dumper ( $login );
    close $f;
  }
}
1;
