<?php
    // Connect to the database
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "omc_tower_db";
    
    // function to find all the non active sensors from the last 24 hours and update them accrodingally
    function detectMissingSensors($conn)
    {
        $sensors = array();
        $missingSensors = array();
        $sql = "SELECT DISTINCT sns2.id, sns2.face FROM sensor as sns2
                LEFT join(
                SELECT DISTINCT sns.id as id FROM sensor as sns
                right JOIN sensor_data on sns.id = sensor_data.sensor_id
                where sensor_data.timestamp > DATE_SUB(NOW(), INTERVAL 24 HOUR)) as active
                on sns2.id = active.id
                where active.id is null";
        $result = $conn->query($sql);
        $missingSensors = array();
        while ($row = $result->fetch_assoc()) 
        {
            $missingSensors[] = array(
                'id' => $row['id'],
                'face' => $row['face']
            );
            $unactiveSql = "UPDATE `sensor` SET `is_existing`= 0 WHERE id = " . $row["id"];
            $conn->query($unactiveSql);
        }
        
        $conn->close();
        return $missingSensors;
    }

    //funciton to set a sensor as active
    function updateToActive($conn, $id)
    {
        $unactiveSql = "UPDATE `sensor` SET `is_active`= 1 WHERE id = " . $id;
        $conn->query($unactiveSql);

    }

    //funciton to aggregate all sensor data and insert into table, runs hourly
    function aggregate_hourly($conn)
    {
        $sql = "
                SELECT date(temps.timestamp) as date, HOUR(temps.timestamp) as hour,sns.face as face, ROUND(AVG(temps.temperature_value), 2) as average_temperature
                from sensor_data as temps
                join sensor as sns on temps.sensor_id = sns.id
                where temps.timestamp > DATE_SUB(NOW(), INTERVAL 1 HOUR)
                group by date(temps.timestamp), HOUR(temps.timestamp), sns.face";

        $result = $conn->query($sql);

        while ($row = $result->fetch_assoc()) 
        {
            $aggregatedDataSql = "
            INSERT INTO `hourly_temperature` (`id`, `face`, `date`, `temperature_value`, `hour`) 
            VALUES (NULL, '" . $row["face"] . "', '" . $row["date"] . "', '" . $row["average_temperature"] . "', '" . $row["hour"] . "')";
            $conn->query($aggregatedDataSql);
        }
        $conn->close();
    }

    // Function to detect malfunctioning sensors
    function detectMalfunctioningSensors($conn)
    {
        $sensors = array();
        $malfunctioningSensors = array();

        $sql = "select sns.id, sns.face, sns.timestamp, face.avg_temp as avg_temp, face.std_temp as std_temp, sns.sensor_temp as sensor_temp, ABS(sns.sensor_temp - face.avg_temp) as dive
        from(
        select sensor.id as id, sensor.face as face, sensor_data.timestamp as timestamp, avg(sensor_data.temperature_value) as sensor_temp
        from sensor_data join sensor on sensor_data.sensor_id = sensor.id
        group by sensor.id, sensor.face, sensor_data.timestamp  
        ORDER BY `sensor_data`.`timestamp` DESC) sns
        JOIN
        (SELECT sns.face as face, sensor_data.timestamp as timestamp , avg(sensor_data.temperature_value) as avg_temp, STD(sensor_data.temperature_value) as std_temp
        FROM `sensor_data` 
        join sensor sns on sns.id = sensor_data.sensor_id
        group by sns.face, sensor_data.timestamp 
        ORDER BY `sensor_data`.`timestamp` DESC limit 10) face
        on sns.face = face.face and sns.timestamp = face.timestamp and ABS(sns.sensor_temp - face.avg_temp) > 1.2*face.std_temp";
        
        $result = $conn->query($sql);
        
        while ($row = $result->fetch_assoc()) 
        {
            $malfunctioningSensors[] = array(
                'sensor_id' => $row['id'],
                'sensor_face' => $row['face'],
                'face_avg' => $row['avg_temp'],
                'face_std' => $row['std_temp'],
                'sensor_avg' => $row['sensor_temp']);

            $malfunctionSql = "INSERT INTO sensor_malfunction (id,sensor_id, malfunction) VALUES (NULL, ". $row['id']. ",1)";
            $conn->query($malfunctionSql);
        }
    
        return $malfunctioningSensors;
    }

    // Get all malfunctioning sensors
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $_SERVER['REQUEST_URI'] === '/omc/atower/index.php/malfunctioning-sensors')
    {
        $conn = new mysqli($servername, $username, $password, $dbname);
        $malfunctioningSensors = detectMalfunctioningSensors($conn);
        $conn->close();
        header('Content-Type: application/json');
        http_response_code(201);
        echo json_encode($malfunctioningSensors);
        exit();
    }
    
    
    // Add a new sensor
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_SERVER['REQUEST_URI'] === '/omc/atower/index.php/add-sensor')
    {
            $data = json_decode(file_get_contents('php://input'), true);

            if (isset($data['face']) && in_array($data['face'], ["S", "E", "N", "W"])) 
            {

                $conn = new mysqli($servername, $username, $password, $dbname);
                $face = $conn->real_escape_string($data['face']);
                $sql = "INSERT INTO sensor (face) VALUES ('$face')";
                
                if ($conn->query($sql)) {
                    $response = array('message' => 'Sensor added successfully.');
                    http_response_code(201);
                } else {
                    $response = array('message' => 'Error adding the sensor.');
                    http_response_code(500);
                }
                
                $conn->close();
            } 
            else
            {
                $response = array('message' => 'Invalid face value.');
                http_response_code(400);
            }
        
        header('Content-Type: application/json');
        echo json_encode($response);
        exit();
    }

    // Insert sensor data
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_SERVER['REQUEST_URI'] === '/omc/atower/index.php/insert-sensor-data') 
    {
        $data = json_decode(file_get_contents('php://input'), true);
        if (isset($data['id']) && isset($data['face']) && isset($data['temperature']) && isset($data['timestamp'])) 
        {
            $conn = new mysqli($servername, $username, $password, $dbname);
            $id = intval($data['id']);
            $face = $conn->real_escape_string($data['face']);
            $temperature = doubleval($data['temperature']);
            $timestamp = $conn->real_escape_string($data['timestamp']);

            $sql_pre = "select * from sensor where id = $id and face LIKE '" . $face . "'";
            $result = mysqli_query($conn, $sql_pre);

            $sql_ins = "INSERT INTO sensor_data (sensor_id, timestamp, temperature_value) VALUES ($id, FROM_UNIXTIME($timestamp), $temperature)";
            echo ($sql_ins);
            if ($conn->query($sql_ins) && mysqli_num_rows($result) == 1) 
            {
                $row = $result->fetch_assoc();
                if($row['is_active'] == 0) // in case sensor was unactive, update to active
                {
                    updateToActive($conn, $row['id']);
                }
                $response = array('message' => 'Sensor data inserted successfully.');
                http_response_code(201);
            }
            else 
            {
                $response = array('message' => 'Error inserting sensor data.');
                http_response_code(500);
            }
            
            $conn->close();
        }
        else 
        {
            $response = array('message' => 'Invalid sensor data.');
            http_response_code(400);
        }
        
        header('Content-Type: application/json');
        echo json_encode($response);
        exit();
    }


    // Get aggregated hourly temperature for each face the last week
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $_SERVER['REQUEST_URI'] === '/omc/atower/index.php/hourly-temperature') 
    {
        $conn = new mysqli($servername, $username, $password, $dbname);
        
        $sql = "
                SELECT date(temps.timestamp) as date, HOUR(temps.timestamp) as hour,sns.face as face, ROUND(AVG(temps.temperature_value), 2) as average_temperature
                from sensor_data as temps
                join sensor as sns on temps.sensor_id = sns.id
                where temps.timestamp > DATE_SUB(NOW(), INTERVAL 24*7 HOUR)
                group by date(temps.timestamp), HOUR(temps.timestamp), sns.face";
        
        $result = $conn->query($sql);
        $aggregatedData = array();

        while ($row = $result->fetch_assoc()) 
        {
                $aggregatedData[] = array(
                'face' => $row['face'],
                'average_temperature' => $row['average_temperature'],
                'hour_timestamp' => $row['hour'],
                'date_timestamp' => $row['date']
            );
        }

        $conn->close();
        header('Content-Type: application/json');
        echo json_encode($aggregatedData);
        exit();

    }

    // find all missing sensors, based on last 24 hours
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $_SERVER['REQUEST_URI'] === '/omc/atower/index.php/detect-missing-sensors') 
    {
        $conn = new mysqli($servername, $username, $password, $dbname);
        $missingSensors = detectMissingSensors($conn);
        header('Content-Type: application/json');

        http_response_code(201);
        echo json_encode($missingSensors);
        exit();
    }

    // aggregate data for sensor during the last hour
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $_SERVER['REQUEST_URI'] === '/omc/atower/index.php/update_hourly') 
    {
        $conn = new mysqli($servername, $username, $password, $dbname);
        aggregate_hourly($conn);
        $response = array('message' => 'aggregated data inserted successfully.');
        http_response_code(201);

        header('Content-Type: application/json');
        echo json_encode($response);
        exit();
    }
    

    // If no endpoint matches, return a 404 response
    http_response_code(200);
?>