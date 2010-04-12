<?php

/* Fergus Morrow 2010 - GNU GPL - "Do what you like, you saw it here first!"
**
** query.php - queries the database for videos and then outputs a nice clean XML file
** for the Objective-C iPhone application to parse and generate the viewer for. :)
*/

/* connect to db */
$user="root";
$password="root";
$database="database";


mysql_connect(localhost,$user,$password);
@mysql_select_db($database) or die( "Unable to select database");

// generate XML file from db 
$query="SELECT * FROM vod";
$result=mysql_query($query);  //get all the data from the "vod" table
$num=mysql_numrows($result); //get the number of rows
$i=0;


echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
echo "<videos>";

while ($i < $num) {

	$id=mysql_result($result,$i,"id");			//id = think primary key
	$title=mysql_result($result,$i,"title");	//get the title
	$vurl=mysql_result($result,$i,"vurl");		//get the url
	$feat=mysql_result($result,$i,"feat");		//is it featured?
	$image=mysql_result($result,$i,"image"); 	//get the URL for the preview image

	echo "<video id='$id'><title>$title</title><vurl>$vurl</vurl><feat>$feat</feat><image>$image</image></video>";

	$i++;
}

echo "</videos>";

/*

CREATE TABLE `database`.`vod` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'primary key ',
`title` VARCHAR( 32 ) NOT NULL COMMENT 'title of the video',
`vurl` VARCHAR( 256 ) NOT NULL COMMENT 'absolute URL of video',
`feat` VARCHAR( 4 ) NOT NULL COMMENT 'YES or NO',
`rating` TINYINT NOT NULL COMMENT 'Out of 5'
) ENGINE = MYISAM ;

*/

?>