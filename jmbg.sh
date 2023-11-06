#!/bin/sh

# Prints welcome logo
print_logo()
{
  printf "\n"
  echo "     _____  ____    ____  ______      ______    " 
  echo "    |_   _||_   \  /   _||_   _ \   .' ___  |   "
  echo "      | |    |   \/   |    | |_) | / .'   \_|   "
  echo "  _   | |    | |\  /| |    |  __'. | |   ____   "
  echo " | |__' |   _| |_\/_| |_  _| |__) |\ \`.___]  | "
  echo " \`.____.'  |_____||_____||_______/  \`._____.' "
  printf "----------------------------------------------"
  printf "\n      JMBG number analyzer by mer0vech\n"
  printf "----------------------------------------------\n"
}

# Calculates checksum by formula:
# m = 11 − (( 7×(a + g) + 6×(b + h) + 5×(c + i) + 4×(d + j) + 3×(e + k) + 2×(f + l) ) mod 11)
# where:
# DDMMYYYRRBBBK -> abcdefghijklm
# If 1 <= m <= 9, then K = m
# If 10 <= m <= 11, then K = 0
#
checksum()
{
  num=$1

  let "apg = $( printf "%s\n" "$num" | cut -c 1 ) + $( printf "%s\n" "$num" | cut -c 7 )"
  let "bph = $( printf "%s\n" "$num" | cut -c 2 ) + $( printf "%s\n" "$num" | cut -c 8 )"
  let "cpi = $( printf "%s\n" "$num" | cut -c 3 ) + $( printf "%s\n" "$num" | cut -c 9 )"
  let "dpj = $( printf "%s\n" "$num" | cut -c 4 ) + $( printf "%s\n" "$num" | cut -c 10 )"
  let "epk = $( printf "%s\n" "$num" | cut -c 5 ) + $( printf "%s\n" "$num" | cut -c 11 )"
  let "fpl = $( printf "%s\n" "$num" | cut -c 6 ) + $( printf "%s\n" "$num" | cut -c 12 )"
  let "X = 7 * $apg + 6 * $bph + 5 * $cpi + 4 * $dpj + 3 * $epk + 2 * $fpl"
  let "M = $X % 11"
  let "D = 11 - $M"
  let "K = $( printf "%s\n" "$num" | cut -c 13 )"
  
  if [ "$M" = 0 ] && [ "$K" = 0 ] || [ "$K" = "$D" ]  
  then 
    return 1;
  else
    return 0;
  fi

}

# Decomposes the number into component blocks
# and assigns the block to coresponding variables.
# 'DD-MM-YYY-RR-BBB-K'
# DD    - day of birth
# MM    - month of birth
# YYY   - year of birth
# RR    - political region of birth (before 1976,
#         region where first registered)
# BBB   - unique number within region
# K     - checksum
decompose()
{
  num=$1
  dd=$( printf "%s\n" "$num" | cut -c 1,2 )
  mm=$( printf "%s\n" "$num" | cut -c 3,4 )
  yyy=$( printf "%s\n" "$num" | cut -c 5,6,7 )
  rr=$( printf "%s\n" "$num" | cut -c 8,9 )
  bbb=$( printf "%s\n" "$num" | cut -c 10,11,12 )
  k=$( printf "%s\n" "$num" | cut -c 13 )
  
}

# Checks if input is a valid unsigned number
check_if_number()
{
  num=$1
  evaluation=$(expr "$num" : "\([0-9]*\)")
  if [ "$num" = "$evaluation" ]
  then
    return 1;
  else
    return 0;
  fi
}

# Check if input number has 13 digits
check_number_length()
{
  num=$1
  evaluation="${#num}"
  if [ "$evaluation" = 13 ]
  then
    return 1;
  else
    return 0;
  fi
}

# Extracts date of birth using the first five digits
# of the JMBG number.
get_birth_date()
{
  day=""
  month=""
  year=""

  day=${dd}
  case $mm in
    01) month="JAN" ;;
    02) month="FEB" ;;
    03) month="MAR" ;;
    04) month="APR" ;;
    05) month="MAY" ;;
    06) month="JUN" ;;
    07) month="JUL" ;;
    08) month="AUG" ;;
    09) month="SEP" ;;
    10) month="OCT" ;;
    11) month="NOV" ;;
    12) month="DEC" ;;
  esac

  if [ $yyy -gt 900 ]
  then
    year="1${yyy}"
  else
    year="2${yyy}"
  fi

  printf "\nDate of birth: %s - %s - %s\n" "$day" "$month" "$year"
}

# Extracts birth region using digits 8 and 9 of the JMBG.
# Those born before 1977 have designated region by
# location of the first registration.
get_region()
{

  if [ $rr -gt 59 ] && [ $rr -lt 70 ]
  then
    printf "Designated citizen with temporary residence."
  elif [ $rr -gt 9 ]
  then
    printf "Political region of "
    if [ $year -lt 1977 ]
    then
      printf "first registration:\n"
    else
      printf "birth:\n"
    fi
  fi

  if [ $rr -gt 0 ] && [ $rr -lt 9 ]
  then
    printf "Designated foreigner registered in "
    case $rr in
      01) printf "Bosnia and Herzegovina." ;;
      02) printf "Montenegro." ;;
      03) printf "Croatia." ;;
      04) printf "Macedonia." ;;
      05) printf "Slovenia." ;;
      06) printf "Central Serbia." ;;
      07) printf "Vojvodina." ;;
      08) printf "Kosovo." ;;
    esac
  elif [ $rr -eq 0 ] || [ $rr -eq 9 ]
  then
    printf "Designated naturalized citizen without republican citizenship.\n"
  elif [ $rr -gt 9 ] && [ $rr -lt 20 ]
  then
    printf "Republic of Bosnia and Herzegovina - "
    case $rr in
      10) printf "Banja Luka." ;;
      11) printf "Bihać." ;;
      12) printf "Doboj." ;;
      13) printf "Goražde." ;;
      14) printf "Livno." ;;
      15) printf "Mostar." ;;
      16) printf "Prijedor." ;;
      17) printf "Sarajevo." ;;
      18) printf "Tuzla." ;;
      19) printf "Zenica." ;;
    esac
  elif [ $rr -gt 19 ] && [ $rr -lt 30 ]
  then
    printf "Republic of Montenegro - "
    case $rr in
      21) printf "Podgorica, Danilovgrad, Kolašin." ;;
      22) printf "Bar, Ulcinj." ;;
      23) printf "Budva, Kotor, Tivat." ;;
      24) printf "Herceg Novi." ;;
      25) printf "Cetinje." ;;
      26) printf "Nikšić, Plužine, Šavnik." ;;
      27) printf "Berane, Rožaje, Plav, Andrijevica." ;;
      28) printf "Bijelo Polje, Mojkovac." ;;
      29) printf "Pljevlja, Žabljak." ;;
    esac
  elif [ $rr -gt 29 ] && [ $rr -lt 40 ]
  then
    printf "Republic of Croatia - "
    case $rr in
      30) printf "Osijek (Slavonia)." ;;
      31) printf "Bjelovar, Virovitica, Koprivnica, Pakrac (Podravina)." ;;
      32) printf "Varaždin (Međimurje)." ;;
      33) printf "Zagreb." ;;
      34) printf "Karlovac (Kordun)." ;;
      35) printf "Gospić (Lika)." ;;
      36) printf "Rijeka, Pula, Gorski kotar (Istria and Croatian Littoral)." ;;
      37) printf "Sisak (Banovina)." ;;
      38) printf "Split, Zadar, Šibenik, Dubrovnik (Dalmatia)." ;;
      39) printf "Croatian Zagorje and mixed use." ;;
    esac
    printf "\nNOTE: Croatia no longer uses the JMBG system."
  elif [ $rr -gt 40 ] && [ $rr -lt 50 ]
  then
    printf "Republic of Macedonia - "
    case $rr in
      41) printf "Bitola." ;;
      42) printf "Kumanovo." ;;
      43) printf "Ohrid." ;;
      44) printf "Prilep." ;;
      45) printf "Skopje." ;;
      46) printf "Strumica." ;;
      47) printf "Tetovo." ;;
      48) printf "Veles." ;;
      49) printf "Štip." ;;
    esac
  elif [ $rr -eq 50 ]
  then
    printf "Republic of Slovenia."
  elif [ $rr -gt 69 ] && [ $rr -lt 80 ]
  then
    printf "Republic of Serbia (Central Serbia) - "
    case $rr in
      70) printf "Registered abroad at a diplomatic/consular post." ;;
      71) printf "Belgrade (City of Belgrade)." ;;
      72) printf "Šumadija and Pomoravlje (Šumadija and Pomoravlje districts)." ;;
      73) printf "Niš (Nišava, Pirot and Toplica districts)." ;;
      74) printf "Southern Morava (Jablanica and Pčinja districts)." ;;
      75) printf "Zaječar (Žaječar and Bor districts)." ;;
      76) printf "Podunavlje (Podunavlje and Braničevo districts)." ;;
      77) printf "Podrinje and Kolubara (Mačva and Kolubara districts)." ;;
      78) printf "Kraljevo (Raška, Moravica and Rasina districts)." ;;
      79) printf "Užice (Zlatibor district)." ;;
    esac
  elif [ $rr -gt 79 ] && [ $rr -lt 90 ]
  then
    printf "Republic of Serbia (Province of Vojvodina) - "
    case $rr in
      80) printf "Novi Sad (South Bačka district)." ;;
      81) printf "Sombor (West Bačka district)." ;;
      82) printf "Subotica (North Bačka district)." ;;
      84) printf "Kikinda (North Banat district)." ;;
      85) printf "Zrenjanin (Central Banat district)." ;;
      86) printf "Pančevo (South Banat district)." ;;
      87) printf "Vršac (South Banat district)." ;;
      88) printf "Ruma (Syrmia district)." ;;
      89) printf "Sremska Mitrovica (Syrmia district)." ;;
    esac
  elif [ $rr -gt 89 ] && [ $rr -lt 97 ]
  then
    printf "Republic of Serbia (Province of Kosovo) - "
    case $rr in
      91) printf "Priština (Kosovo district)." ;;
      92) printf "Kosovska Mitrovica (Kosovska Mitrovica district)." ;;
      93) printf "Peć (Peć district)." ;;
      94) printf "Đakovica (Peć district)." ;;
      95) printf "Prizren (Prizren district)." ;;
      96) printf "Gnjilane (Kosovo-Pomoravlje district)." ;;
    esac
  fi
  
  printf "\n"
}

# Extracts persons sex based on three-digit unique number
# within JMBG (digits 10, 11 and 12).
get_sex()
{
  sex=""
  if [ $bbb -lt 500 ]
  then
    sex="M"
  else
    sex="F"
  fi

  printf "Sex: %s\n\n" "$sex"
}



print_logo

jmbg=$1

check_if_number $jmbg
isanumber=$?

check_number_length $jmbg
iscorrectsize=$?

if [ "$isanumber" = 1 -a "$iscorrectsize" = 1 ]
then
  checksum $jmbg
  isvalid=$?
  if [ "$isvalid" = 1 ]
  then
    printf "\nJMBG: %s successfully validated...\n" "$jmbg"
  else
    printf "\nJMBG: %s is not valid.\nProgram will terminate...\n" "$jmbg" ; exit ;
  fi
else
  printf "\nInvalid input.\nProgram will terminate...\n" ; exit ; 
fi

decompose $jmbg
get_birth_date
get_sex 
get_region 

printf "\n"
