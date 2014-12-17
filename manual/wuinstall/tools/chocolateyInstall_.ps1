$packageName = 'wuinstall'

$user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'
$accept_content = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
$url = 'https://www.wuinstall.com/index.php/component/wuinstallcalc/?Itemid=108'
$url_download = 'https://license.wuinstall.com/trial.php'



[net.httpWebRequest] $req = [net.webRequest]::create($url)
$req.method = "GET"
$req.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
$req.UserAgent = $user_agent

$req.AllowAutoRedirect = $false
$req.TimeOut = 50000
$req.KeepAlive = $true
$req.Headers.Add("Keep-Alive: 300");

[net.httpWebResponse] $res = $req.getResponse()
$resst = $res.getResponseStream()
$sr = new-object IO.StreamReader($resst)
$result = $sr.ReadToEnd()
$res.close()
$cookies = $res.Headers['Set-Cookie']


$web = new-object net.webclient
$web.Headers.add("Cookie", $cookies)
$web.Headers.add("Accept", $accept_content)
$web.Headers.add("User-Agent",$user_agent)

$web.DownloadFile($url_download,'wuinstall.zip')
Install-ChocolateyZipPackage $packageName 'wuinstall.zip' "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"