<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exchange rates UI</title>

    <link rel="stylesheet" href="styles.css">
	<title>OMC assignment</title>
</head>
<body>
    
   <table>
      <tr>
         <th>Face</th>
         <th>Average temperature</th>
         <th>Date timestamp</th>
         <th>Hour timestamp</th>
         </tr>
        <?php

            $apiUrl = 'http://localhost/omc/atower/index.php/hourly-temperature';

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $apiUrl);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            $responseJson = curl_exec($ch);
            //echo($responseJson);
            curl_close($ch);
            $temps = json_decode($responseJson,true);
            //$temps = $responseArray["data"];
            if(count($temps) != 0)
            {
                foreach ($temps as $temp) 
                {
                        echo("<tr>");
                            echo "<td>" . $temp['face'] . "</td>";
                            echo "<td>" . $temp['average_temperature'] . "</td>";
                            echo "<td>" . $temp['hour_timestamp'] . "</td>";
                            echo "<td>" . $temp['date_timestamp'] . "</td>";
                        echo("<tr>");
                }
            }
        ?>
</table>
</body>
</html>
