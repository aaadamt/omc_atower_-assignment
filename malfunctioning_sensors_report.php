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
         <th>Sensor ID</th>
         <th>Face</th>
         <th>Average temprature</th>
         </tr>
        <?php

            $apiUrl = 'http://localhost/omc/atower/index.php/malfunctioning-sensors';

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $apiUrl);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            $responseJson = curl_exec($ch);
            //echo($responseJson);
            curl_close($ch);
            $sensors = json_decode($responseJson,true);
            //$temps = $responseArray["data"];
            if(count($sensors) != 0)
            {
                foreach ($sensors as $sensor) 
                {
                        echo("<tr>");
                            echo "<td>" . $sensor['sensor_id'] . "</td>";
                            echo "<td>" . $sensor['sensor_face'] . "</td>";
                            echo "<td>" . $sensor['sensor_avg'] . "</td>";
                        echo("<tr>");
                }
            }
        ?>
</table>
</body>
</html>
