
# Prints welcome logo
function PrintLogo
{
  Write-Host "     _____  ____    ____  ______      ______    " 
  Write-Host "    |_   _||_   \  /   _||_   _ \   .' ___  |   "
  Write-Host "      | |    |   \/   |    | |_) | / .'   \_|   "
  Write-Host "  _   | |    | |\  /| |    |  __'. | |   ____   "
  Write-Host " | |__' |   _| |_\/_| |_  _| |__) |\ \`.___]  | "
  Write-Host " \`.____.'  |_____||_____||_______/  \`._____.' "
  Write-Host "----------------------------------------------"
  Write-Host "      JMBG number analyzer by mer0vech"
  Write-Host "----------------------------------------------"
}

# Calculates checksum by formula:
# m = 11 − (( 7×(a + g) + 6×(b + h) + 5×(c + i) + 4×(d + j) + 3×(e + k) + 2×(f + l) ) mod 11)
# where:
# DDMMYYYRRBBBK -> abcdefghijklm
# If 1 <= m <= 9, then K = m
# If 10 <= m <= 11, then K = 0
function CalculateChecksum($num)
{
    Write-Output ""

    $x=  7 * ($num.Substring(0,1) + $num.Substring(6,1))
    $x+= 6 * ($num.Substring(1,1) + $num.Substring(7,1))
    $x+= 5 * ($num.Substring(2,1) + $num.Substring(8,1)) 
    $x+= 4 * ($num.Substring(3,1) + $num.Substring(9,1))
    $x+= 3 * ($num.Substring(4,1) + $num.Substring(10,1))
    $x+= 2 * ($num.Substring(5,1) + $num.Substring(11,1))

    $m=$num.Substring(12,1)
    $mod=$x % 11
    $diff=11 - $mod

    if ( $m -eq 0 -And $mod -eq 0 -Or $m -eq $diff ) {
        return $true
    } else {
        return $false
    }
}

# Checks if input is properly passed and if it is an unsigned number.
function ValidateInput($num)
{        
    if ( $num.GetType().Name -eq "String" -And ($num -match "^\d{13}$") ) {
        return $true
    } else {
        return $false
    }
}

# Extracts the year from the JMBG number and converts it
# from 3 digit to 4 digit number.
function GetYear($num)
{
    $yyy=$num.Substring(4,3)
    $year=""

    if ( $yyy -gt 900 ) {
        $year="1$yyy"
    } else {
        $year="2$yyy"
    }

    return $year
}

# Extracts birth region using digits 8 and 9 of the JMBG.
# Those born before 1977 have designated region by
# location of the first registration.
function GetRegion($params)
{
    Write-Host ""
    $rr=[int]$params[0].Substring(7,2)
    $year=$params[1]

    if ( $rr -gt 59 -And $rr -lt 70 ) {
        Write-Host "Designated citizen with temporary residence."
    } elseif ( $rr -gt 9 ) {
        Write-Host "Political region of " -NoNewline
        if ( $year -lt 1977 ) {
            Write-Host "first registration: "
        } else {
            Write-Host "birth: "
        }
    }

    if ( $rr -gt 0 -And $rr -lt 9 ) {
        Write-Host "Designated foreigner registered in " -NoNewline
        switch ($rr)
        {
            "01" { Write-Host "Bosnia and Herzegovina."; Break }
            "02" { Write-Host "Montenegro."; Break }
            "03" { Write-Host "Croatia."; Break }
            "04" { Write-Host "Macedonia."; Break }
            "05" { Write-Host "Slovenia."; Break }
            "06" { Write-Host "Central Serbia."; Break }
            "07" { Write-Host "Vojvodina."; Break }
            "08" { Write-Host "Kosovo."; Break }
        }
    } elseif ( $rr -eq 0 -Or $rr -eq 9 ) {
        Write-Host "Designated naturalized citizen without republican citizenship."
    } elseif ( $rr -gt 9 -And $rr -lt 20 ) {
        Write-Host "Republic of Bosnia and Herzegovina - " -NoNewline
        switch ($rr)
        {
            "10" { Write-Host "Banja Luka."; Break }
            "11" { Write-Host "Bihać."; Break }
            "12" { Write-Host "Doboj."; Break }
            "13" { Write-Host "Goražde."; Break }
            "14" { Write-Host "Livno."; Break }
            "15" { Write-Host "Mostar."; Break }
            "16" { Write-Host "Prijedor."; Break }
            "17" { Write-Host "Sarajevo."; Break }
            "18" { Write-Host "Tuzla."; Break }
            "19" { Write-Host "Zenica."; Break }
        }
    } elseif ( $rr -gt 19 -And $rr -lt 30 ) {
        Write-Host "Republic of Montenegro - " -NoNewline
        switch ($rr)
        {
            "21" { Write-Host "Podgorica, Danilovgrad, Kolašin."; Break }
            "22" { Write-Host "Bar, Ulcinj."; Break }
            "23" { Write-Host "Budva, Kotor, Tivat."; Break }
            "24" { Write-Host "Herceg Novi."; Break }
            "25" { Write-Host "Cetinje."; Break }
            "26" { Write-Host "Nikšić, Plužine, Šavnik."; Break }
            "27" { Write-Host "Berane, Rožaje, Plav, Andrijevica."; Break }
            "28" { Write-Host "Bijelo Polje, Mojkovac."; Break }
            "29" { Write-Host "Pljevlja, Žabljak."; Break }
        }
    } elseif ( $rr -gt 29 -And $rr -lt 40 ) {
        Write-Host "Republic of Croatia - " -NoNewline
        switch ($rr)
        {
            "30" { Write-Host "Osijek (Slavonia)."; Break }
            "31" { Write-Host "Bjelovar, Virovitica, Koprivnica, Pakrac (Podravina)."; Break }
            "32" { Write-Host "Varaždin (Međimurje)."; Break }
            "33" { Write-Host "Zagreb."; Break }
            "34" { Write-Host "Karlovac (Kordun)."; Break }
            "35" { Write-Host "Gospić (Lika)."; Break }
            "36" { Write-Host "Rijeka, Pula, Gorski kotar (Istria and Croatian Littoral)."; Break }
            "37" { Write-Host "Sisak (Banovina)."; Break }
            "38" { Write-Host "Split, Zadar, Šibenik, Dubrovnik (Dalmatia)."; Break }
            "39" { Write-Host "Croatian Zagorje and mixed use."; Break }
        }
        Write-Host "NOTE: Croatia no longer uses the JMBG system."
    } elseif ( $rr -gt 40 -And $rr -lt 50 ) {
        Write-Host "Republic of Macedonia - " -NoNewline
        switch ($rr)
        {
            "41" { Write-Host "Bitola."; Break }
            "42" { Write-Host "Kumanovo."; Break }
            "43" { Write-Host "Ohrid."; Break }
            "44" { Write-Host "Prilep."; Break }
            "45" { Write-Host "Skopje."; Break }
            "46" { Write-Host "Strumica."; Break }
            "47" { Write-Host "Tetovo."; Break }
            "48" { Write-Host "Veles."; Break }
            "49" { Write-Host "Štip."; Break }
        }
    } elseif ( $rr -eq 50 ) {
        Write-Host "Republic of Slovenia."
    } elseif ( $rr -gt 69 -And $rr -lt 80 ) {
        Write-Host "Republic of Serbia (Central Serbia) - " -NoNewline
        switch ($rr)
        {
            "70" { Write-Host "Registered abroad at a diplomatic/consular post."; Break }
            "71" { Write-Host "Belgrade (City of Belgrade)."; Break }
            "72" { Write-Host "Šumadija and Pomoravlje (Šumadija and Pomoravlje districts)."; Break }
            "73" { Write-Host "Niš (Nišava, Pirot and Toplica districts)."; Break }
            "74" { Write-Host "Southern Morava (Jablanica and Pčinja districts)."; Break }
            "75" { Write-Host "Zaječar (Žaječar and Bor districts)."; Break }
            "76" { Write-Host "Podunavlje (Podunavlje and Braničevo districts)."; Break }
            "77" { Write-Host "Podrinje and Kolubara (Mačva and Kolubara districts)."; Break }
            "78" { Write-Host "Kraljevo (Raška, Moravica and Rasina districts)."; Break }
            "79" { Write-Host "Užice (Zlatibor district)."; Break }
        }
    } elseif ( $rr -gt 79 -And $rr -lt 90 ) {
        Write-Host "Republic of Serbia (Province of Vojvodina) - " -NoNewline
        switch ($rr) 
        {
            "80" { Write-Host "Novi Sad (South Bačka district)."; Break }
            "81" { Write-Host "Sombor (West Bačka district)."; Break }
            "82" { Write-Host "Subotica (North Bačka district)."; Break }
            "84" { Write-Host "Kikinda (North Banat district)."; Break }
            "85" { Write-Host "Zrenjanin (Central Banat district)."; Break }
            "86" { Write-Host "Pančevo (South Banat district)."; Break }
            "87" { Write-Host "Vršac (South Banat district)."; Break }
            "88" { Write-Host "Ruma (Syrmia district)."; Break }
            "89" { Write-Host "Sremska Mitrovica (Syrmia district)."; Break }
        }
    } elseif ( $rr -gt 89 -And $rr -lt 97 ) {
        Write-Host "Republic of Serbia (Province of Kosovo) - " -NoNewline
        switch ($rr)
        {
            "91" { Write-Host "Priština (Kosovo district)."; Break }
            "92" { Write-Host "Kosovska Mitrovica (Kosovska Mitrovica district)."; Break }
            "93" { Write-Host "Peć (Peć district)."; Break }
            "94" { Write-Host "Đakovica (Peć district)."; Break }
            "95" { Write-Host "Prizren (Prizren district)."; Break }
            "96" { Write-Host "Gnjilane (Kosovo-Pomoravlje district)."; Break }
        }
    }
  
  Write-Host ""
}


# Extracts date of birth using the first five digits
# of the JMBG number.
function GetBirthdate($params)
{
    $day=$params[0].Substring(0,2)
    $mm=$params[0].Substring(2,2)
    $year=$params[1]
    
    switch ($mm)
    {
        "01" {$month="JAN"; Break}
        "02" {$month="FEB"; Break}
        "03" {$month="MAR"; Break}
        "04" {$month="APR"; Break}
        "05" {$month="MAY"; Break}
        "06" {$month="JUN"; Break}
        "07" {$month="JUL"; Break}
        "08" {$month="AUG"; Break}
        "09" {$month="SEP"; Break}
        "10" {$month="OCT"; Break}
        "11" {$month="NOV"; Break}
        "12" {$month="DEC"; Break}
    }

    Write-Host "`nDate of birth: $day - $month - $year"
}

# Extracts persons sex based on three-digit unique number
# within JMBG (digits 10, 11 and 12).
function GetSex($num)
{
    $sex=""
    if ( $num.Substring(10,3) -lt 500 ) {
        $sex="M"
    } else {
        $sex="F"
    }

    Write-Host "Sex: $sex"
}


$userinput=$args[0]

PrintLogo
$isvalid=ValidateInput $userinput

if ( $isvalid ) {
    $checksumvalid=CalculateChecksum $userinput
    Write-Host "$checsumvalid"
    if ( $checksumvalid ) {
        Write-Host "JMBG: $userinput successfully validated..."
    } else {
        Write-Host "JMBG: $userinput is not valid. Program will terminate...`n"
        return
    }
} else {
    Write-Host "Invalid input. Program will terminate...`n"
    return
}

$year=GetYear $userinput
GetBirthdate $userinput, $year
GetSex $userinput
GetRegion $userinput, $year
