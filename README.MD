# JMBG analyzer

## About

JMBG analyzer is a script used for analyzing the unique personal numbers of 
the residents of the former Socialist Federal Republic of Yugoslavia and the
countries formed by it's dissolution. The number is still in use in all of 
the descendant countries, except Croatia.

## Installation and use

Clone the repo onto your computer:
```sh
git clone https://github.com/mer0vech/jmbganalyzer
```
cd to the "jmbganalyzer" directory.

### UNIX-like systems
Make the script executable:
```sh
chmod +x jmbg.sh
```
Run the script, passing the JMBG number as an argument.
(replace NNNN... with the actual number):
```sh
./jmbg.sh NNNNNNNNNNNNN
```
The script is POSIX-compliant, so it should run on any POSIX-compliant system.

### Windows systems
Run the script, passing the JMBG number as an argument encoled in double quotes.
(Replace NNNNNNNNNNNNN with the actual number)
```powershell
.\jmbg.ps1 "NNNNNNNNNNNNN"
```

## Contributing

Contributions are always welcome. MAke yourself at home. :)

## Licence

ISC licence. See "COPYING" file.

