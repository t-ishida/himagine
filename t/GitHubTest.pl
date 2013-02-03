use strict;
use GitHub::API;
use Himagine::Web;

# GitHub::API::login();
# GitHub::API::fork ( {
#		'owner' => 'mixi-inc',
#		'name' => 'Android-Device-Compatibility',
#});
# GitHub::API::delete ({
#	'owner' => 't-ishida',
#	'name' => 'MySQLTuner-perl',
#});


Himagine::Web::post ( 
  uid => '999',
  issue_id => 1,
  owner => 't-ishida',
  repository => 'DBPatch',
  comment => 'hoge',
);
