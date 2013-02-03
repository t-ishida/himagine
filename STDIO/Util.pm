package STDIO::Util;
use strict;
use Exporter;
our @ISA = qw (Exporter);
our @EXPORT = qw( say yesNo getLine );

sub say { 
  print shift, "\n";
}

sub yesNo {
  return getLine ( shift . '[Y/n]') =~ /Yes|y/i;
}

sub getLine {
  my $line      = shift;
  my $validator = shift;
  my $result = '';
  while ( !$result ) {
    say ( $line );
    print ' > ';
    $result = <STDIN>;
    chomp $result;
    $result = '' if $validator && !$validator->( $result );
  }
  return $result;
}
1;
