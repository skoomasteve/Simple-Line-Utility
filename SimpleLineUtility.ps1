
# ==============   Simple Line Utility  =====================
#
#
#---- MIT LICENSE Copyright 2019 ---Author:  Steven Soward
#



#-- establishes the date/time format for use later in the temp filename

$date = Get-Date -Format 'MM-dd-yyyy.HH.mm'


# --this "add-type" line has to be added ad the beginning of the script to use "messagebox" in regular powershell execution, otherwise it will only work in ps ise.
Add-Type -AssemblyName PresentationFramework

#_____________  --intro message box:
$userresponse=[System.Windows.MessageBox]::Show('This Utility will trim/expand the lines text file (i.e. csv, txt, xml) file to a specific length 

You can also convert the line endings (EOL) to Uinux if desired.

Press OK to Choose the input File', 'Simple Line Utility','okcancel')
if ($UserResponse -eq "ok" ) 
{

#Yes activity

} 

else 

{ 

exit

} 



#_____________  --this opens the 'choose file' dialogue: 
Function Get-FileName($initialDirectory) {
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog

$OpenFileDialog.initialDirectory = $initialDirectory
$OpenFileDialog.filter = "All files (*.*)| *.*"
if ($OpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) 
{ $OpenFileDialog.FileName }

else

{exit}

$Global:SelectedFile = $OpenFileDialog.FileName

} #end function Get-FileName



Get-FileName


#_____________  --this asks the user what the desired line lenghth is for the output file

Add-Type -AssemblyName Microsoft.VisualBasic
$desiredlength = [Microsoft.VisualBasic.Interaction]::InputBox('Enter The Desired Line Length', 'Simple Line Utility - Choose Line Length', "-Numeric Value-") 
if ($desiredlength -eq "" ) 
{

exit

} 

else 

{ 

#nothing

} 

#_____________  --this asks the user what the desired output filename is

Add-Type -AssemblyName Microsoft.VisualBasic
$desiredfilename = [Microsoft.VisualBasic.Interaction]::InputBox('Enter The Desired Output Filename and File Extension:', 'Simple Line Utility - Choose Output Filename', "-- yourfile.csv, yourfile.txt, or yourfile.sql--") 
if ($desiredfilename -eq "" ) 
{

exit

} 

else 

{ 

#nothing

} 



$linelength = ($desiredlength)-(1)


## ------ Looks at the designated input file and saves it to a temp file


Get-Content -Path $SelectedFile >> C:\Users\$env:UserName\Desktop\INCOMPLETE$desiredfilename-$date.txt






#_______________________________-- Pads or Truncates Line Size if it's Less than $_______________

$calculatedpad = ($linelength)-($_.length)


Get-Content C:\Users\$env:UserName\Desktop\INCOMPLETE$desiredfilename-$date.txt | ForEach {

    If ($_.Length -lt $linelength) {

        $_.padright($calculatedpad) 
        $notif = 'The file has been padded and placed on your desktop'

    } Else {

       

        $_.Substring(0,$linelength)  
        $notif = 'The file has been truncated and placed on your desktop'

    }
    #________________________________ --- saves the final version of the file --- ______________________
} | Out-File C:\Users\$env:UserName\Desktop\$desiredfilename


#_______________________________________ --- Cleans up the Temp File --- _________________________

Remove-Item -path C:\Users\$env:UserName\Desktop\* -include INCOMPLETE$desiredfilename-*.txt


$fileforeolcovert = "C:\Users\$env:UserName\Desktop\$desiredfilename"



<#______Truncate if line size Greater than $ (this is not needed since I've included $_.Substring(0,$linelength) in the if/else statement above)_____________________________

Get-Content C:\Users\$env:UserName\Desktop\INCOMPLETE$desiredfilename-$date.txt | ForEach {

    If ($_.Length -gt $linelength) {

        $_.Substring(0,$linelength)

    } Else {

        $_

    }
    #________________________________ --- save the final version of the file --- ______________________
} | Out-File C:\Users\$env:UserName\Desktop\$desiredfilename.txt



#_______________________________________ --- Clean up the Temp File --- _________________________

Remove-Item -path C:\Users\$env:UserName\Desktop\* -include INCOMPLETE$desiredfilename-*.txt

#>

###___________removes extra blank line(s) from bottom__________

$Newtext = (Get-Content -Path $fileforeolcovert -Raw) -replace "(?s)`r`n\s*$"
[system.io.file]::WriteAllText($fileforeolcovert,$Newtext)


#_____________--- ask about EOL text box --- ________

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
$eolresponse=[Microsoft.VisualBasic.Interaction]::MsgBox("Do you want to convert the output file to contain Unix Line Endings (EOL)?",'YesNoCancel,Question', "Simple Line Utility - Convert EOL")
if ($eolresponse -eq "yes" ) 
{

$filecontent = [IO.File]::ReadAllText($fileforeolcovert) -replace "`r`n", "`n"
[IO.File]::WriteAllText($fileforeolcovert, $filecontent)
$notif += "
Additionally, Line endings have been converted to Unix."


} 

else 

{ 

#exit

} 



#_________--- converts eol to unix --- __________

#$filecontent = [IO.File]::ReadAllText($fileforeolcovert) -replace "`r`n", "`n"
#[IO.File]::WriteAllText($fileforeolcovert, $filecontent)

#_______________________________________ --- Ending Notification --- _________________________

$userresponseend=[System.Windows.MessageBox]::Show("$notif", 'Simple Line Utility - Conversion Complete','ok')
if ($UserResponseend -eq "ok" ) 
{

#Yes activity

} 

else 

{ 

exit

} 
