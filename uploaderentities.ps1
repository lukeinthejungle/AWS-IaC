$fileName='test.txt'
$fileDestination = 'C:/....'
$graphqlPath='C:/...'
$path=$graphqlPath +'/' + $fileName
$destination=$fileDestination +'/' + $fileName
$file= Get-Content -Path $path -Raw
$parsed = AWSModelConverter.exe $path $destination



aws iotthingsgraph  upload-entity-definitions --document file://$destination