$url='https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1-flatjar.jar'
$jarfile3='c:/logstash/logstash.jar'
$cmdfile='c:/logstash/logstash.cmd'
$confile = 'c:/logstash/logstash.conf'
$dir='c:/logstash'
$sincedb='c:/logstash/sincedb'

if (!(Test-Path -path $dir)) {New-Item $dir -Type Directory}
if (!(Test-Path -path $sincedb)) {New-Item $sincedb -Type Directory}

Get-ChocolateyWebFile 'logstash' 'c:/logstash/logstash.jar' $url $url
$cmdcontent = @"
set HOME=c:/logstash/sincedb
cd /d c:\logstash
java.exe -Xmx512M -jar logstash.jar agent --config logstash*.conf --log logstash.log
"@

if (!(Test-Path ($confile)))
{
echo "Dropping a sample logstash.conf file"
Set-Content $cmdfile $cmdcontent -Encoding ASCII
$confcontent = @"
input {
  stdin {}
}

output {
   stdout {}
}
"@
}


if ($serviceinfo = Get-Service "Logstash" -ErrorAction SilentlyContinue)
{
	if ($serviceinfo.status -ne 'Running')
	{
		if ($serviceinfo.status -eq 'Stopped')
		{
			echo "Service found and is stopped. Deleting."
			echo "Delete Service"

			sc.exe \\localhost delete "Logstash"
			nssm install "Logstash" C:\logstash\logstash.cmd
		}
	}
	else
	{
		echo "Stop Service"
		sc.exe \\localhost stop "Logstash"
		echo "Delete Service"
		sc.exe \\localhost delete "Logstash"
		echo "Installing Service"
		nssm install "Logstash" C:\logstash\logstash.cmd

	}
}
else
{
	echo "Installing Logstash Service"
	nssm install "Logstash" C:\logstash\logstash.cmd
}