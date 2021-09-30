################################################################################################################################################################################################################
################################################################################################################################################################################################################

$path=$args[0]
write-host $path 

################################################################################################################################################################################################################
################################################################################################################################################################################################################




$jobs=aws glue  list-jobs| ConvertFrom-Json
Write-Output($jobs)
For ($i=0; $i -lt $jobs.JobNames.Length; $i++) 
{
    $jobName= $jobs.JobNames[$i]
    aws glue get-job --job-name $jobs.JobNames[$i] >  $path\$jobName.json
}

################################################################################################################################################################################################################
################################################################################################################################################################################################################


$redshifts=aws redshift describe-clusters | ConvertFrom-Json
Write-Output($redshifts)
$tables=@()
$identifier= ''
$databases=@()
$username=''

For ($i=0; $i -lt $redshifts.Clusters.Length; $i++) 
{
     
     $tables = aws redshift-data  list-tables --cluster-identifier $redshifts.Clusters[$i].ClusterIdentifier --database $redshifts.Clusters[$i].DBName --db-user   $redshifts.Clusters[$i].MasterUsername
     $databases = aws redshift-data  list-databases --cluster-identifier $redshifts.Clusters[$i].ClusterIdentifier --db-user  $redshifts.Clusters[$i].MasterUsername --database dev
     $identifier= $redshifts.Clusters[$i].ClusterIdentifier
     Write-Output($databases)
     $username=$redshifts.Clusters[$i].MasterUsername
     #Write-Output($var)
     
}

$tables=$tables  | ConvertFrom-Json
$databases = $databases   | ConvertFrom-Json
For ($u=0; $u -lt $databases.Databases.Length; $u++) 
{

    For ($i=0; $i -lt $tables.Tables.Length; $i++) 
    {
            $dbName=  $databases.Databases[$u]
            $tblName=$tables.Tables[$i].name
         $var2=aws redshift-data describe-table --cluster-identifier $identifier --database $databases.Databases[$u] --db-user $username --table $tables.Tables[$i].name > $path\$dbName_$tblName
         Write-Output($var2)
    }
}

################################################################################################################################################################################################################
################################################################################################################################################################################################################


$jobs=aws glue  list-jobs| ConvertFrom-Json
Write-Output($jobs)
For ($i=0; $i -lt $jobs.JobNames.Length; $i++) 
{
    $jobName= $jobs.JobNames[$i]
    aws glue get-job --job-name $jobs.JobNames[$i] >  $path\$jobName.json
}

################################################################################################################################################################################################################
################################################################################################################################################################################################################


$firehose=aws firehose list-delivery-streams  | ConvertFrom-Json

Write-Output($firehose)
For ($i=0; $i -lt $firehose.DeliveryStreamNames.Length; $i++) 
{
   $fileName=$firehose.DeliveryStreamNames[$i]
   $firehoseOutput=aws firehose describe-delivery-stream --delivery-stream-name $firehose.DeliveryStreamNames[$i] > $path\$fileName.json
   Write-Output($firehoseOutput)
}

################################################################################################################################################################################################################
################################################################################################################################################################################################################


 $tables=aws dynamodb list-tables| ConvertFrom-Json

 
For ($i=0; $i -lt $tables.TableNames.Length; $i++) 
{
    $tbl=$tables.TableNames[$i]
    $tableName=aws dynamodb describe-table  --table-name $tables.TableNames[$i] > $path\$tbl.json
    Write-Output($tableName)
}

################################################################################################################################################################################################################
################################################################################################################################################################################################################



$rules = aws iot list-topic-rules  | ConvertFrom-Json
Write-Output($rules)


For ($i=0; $i -lt $rules.rules.Length; $i++) 
{
    $myRule=$rules.rules[$i].ruleName
    $rule= aws iot get-topic-rule --rule-name $rules.rules[$i].ruleName > $path\$myRule.yaml
    Write-Output(   $rule)
}


################################################################################################################################################################################################################
################################################################################################################################################################################################################


