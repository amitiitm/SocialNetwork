<?php

	$link = mysql_connect("localhost", "root", "sp110q");
	mysql_select_db("billing_production");
	$fd = fopen("/home/mohammad/area_code_infos.tab", "r");
  $lines = 0;
	//$s = time();
	while(!feof($fd)) {
		$lines = $lines + 1;
		
		
		$line = fgets($fd);
		$line = str_replace("\r", "", $line);
		$line = str_replace("\n","", $line);
		$line = str_replace("'","", $line);
		$line = str_replace('""',"", $line);
		
		$data = explode("\t", $line);
	
		
		if (sizeof($data) == 27) {
			$sql = "INSERT INTO `billing_production`.`area_code_infos` (`id`, `npa`, `nxx`, `county_pop`, `zipcode_count`, `zipcode_freq`, `lat`, `long`, `state`, `city`, `county`, `timezone`, `observes_dst`, `nxx_use_type`, `nxx_intro_version`, `zipcode`, `npa_new`, `fips`, `lata`, `overlay`, `ratecenter`, `switch_clli`, `msa_cbsa`, `msa_cbsa_code`, `ocn`, `company`, `coverage_area_name`, `npanxx`, `created_at`, `updated_at`) VALUES (NULL, '$data[0]','$data[1]','$data[2]','$data[3]','$data[4]','$data[5]','$data[6]','$data[7]','$data[8]','$data[9]','$data[10]','$data[11]','$data[12]','$data[13]','$data[14]','$data[15]','$data[16]','$data[17]','$data[18]','$data[19]','$data[20]','$data[21]','$data[22]','$data[23]','$data[24]','$data[25]','$data[26]', NULL, NULL)";
			$result = mysql_query($sql);
			//echo "$result\n";
			if (!$result) {
				echo mysql_error() . "\n";
			}
		} else {
			echo "$lines : " . sizeof(sizeof($data)) . "\n";
		}
    
	}
	echo "Lines: $lines\n"
	//$e = time();
	//echo "start:" . date("h:i", $s) . " end: " . date("h:i", $e) . "\n";
?>
