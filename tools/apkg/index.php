<?php
/* 
<! -- <pre>
// echo exec('for i in `sudo /usr/bin/aptly repo list -raw` ; do sudo /usr/bin/aptly repo show --with-packages=true $i ; done');
echo system('for i in `sudo /usr/bin/aptly repo list -raw` ; do sudo /usr/bin/aptly repo show --with-packages=true $i ; done');
</pre>
--> 
*/

require 'Slim/Slim.php';
if (file_exists(gethostname().'-config.php')) {
  require gethostname().'-config.php';
} else {
  require 'config.php';
}

$metadata = array("hostname" => HOSTNAME,"description" => DESCRIPTION,);

$app = new Slim();


$app->get('/', 'print_help');
$app->get('/repos', 'repos_list');
$app->get('/repos/full', 'repos_full');

function print_help() {
    echo "api rest\n";
}


$app->run();

/**
 * @api {get} /repos Get the list of available repositories
 * @apiName repos_list
 * @apiGroup Repo
 *
 * @apiParam none none
 *
 * @apiSuccess {String} hostname Hostname of the package building server
 * @apiSuccess {String} description Description of the Datacenter
 * @apiSuccess {String} repos List of available repositories
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *        "hostname": "deviris1",
 *        "description": "IRIS Datacenter",
 *        "repos": [
 *            "iris-conf",
 *            "prod",
 *            "staging"
 *         ]
 *     }
 */
function repos_list() {
  //echo system('for i in `sudo /usr/bin/aptly repo list -raw` ; do sudo /usr/bin/aptly repo show --with-packages=true $i ; done');
  global $metadata;
  exec('sudo /usr/bin/aptly repo list -raw',$repolist,$rc);
  $repos = array("repos" => array_values($repolist));
  //print_r($repos);
  //echo '{"message": ' . json_encode("hola mundo") . '}';
  print json_encode(array_merge($metadata,$repos));
}

/**
 * @api {get} /repos/full Get all the packages from all repositories
 * @apiName repos_full
 * @apiGroup Repo
 *
 * @apiParam none none
 *
 * @apiSuccess {String} hostname Hostname of the package building server
 * @apiSuccess {String} description Description of the Datacenter
 * @apiSuccess {String} repo Name of the repository
 * @apiSuccess {String} packages List of available packages for that repo
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *        "hostname": "deviris1",
 *        "description": "IRIS Datacenter",
 *        "repo": [
 *            "name" : "prod",
 *            "packages" : [
 *            ...
 *            ]
 *         ...
 *         ]
 *     }
 */
function repos_full() {
  global $metadata;
  exec('sudo /usr/bin/aptly repo list -raw',$repolist,$rc);
  $repos = array();
  foreach($repolist as $rp){
    $cmd ="sudo /usr/bin/aptly repo show --with-packages=true ".$rp;
    $cmd = $cmd.' | sed -n \'/^Packages:/,$p\' |egrep -v Packages | tr -d \' \'';
    exec($cmd ,$pkgs,$rc);
    $packages = array("packages" => array_values($pkgs));
    $pkg_arr = array("name"=> $rp,"packages" => array_values($pkgs));
    array_push($repos,$pkg_arr);
  }
  $repos_all = array("repo" => array_values($repos));
  print json_encode(array_merge($metadata,$repos_all));
}
?>
