try {
    $connString = "Data Source=localhost;Database=Movies;Trusted_Connection=True;Persist Security Info=False;"
    # $connString = "Data Source=localhost,port;Database=Movies;User ID=아이디;Password=비밀번호"
    # $connString = "Persist Security Info=False;User ID=*****;Password=*****;Initial Catalog=AdventureWorks;Server=MySqlServer;Encrypt=True;" 

    #Create a SQL connection object
    $conn = New-Object System.Data.SqlClient.SqlConnection $connString

    #Attempt to open the connection
    $conn.Open()
    if ($conn.State -eq "Open") {
        Write-Host "Test connection successful"
        $conn.Close()
    }
}
catch {
    Write-Host "Test Connection Fail"
}
