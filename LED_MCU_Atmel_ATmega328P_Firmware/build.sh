#!/usr/bin/env bash
#
#
# File name     : build.sh
# Description   : This shell script is used to build current embedded system project.
# 
#


if [[ -n "$(which avr-g++)" ]]; then
    CXX=avr-g++
    CXX_PATH="$(dirname $(which avr-g++))"
else
    echo
    echo "Firstly, try to install the cross-compiler: avr-g++"
    echo "$ sudo apt install gcc-avr avr-libc"
    echo "then execute ./build.sh"
    exit 1
fi


echo
echo "Building with             : build.sh"
echo "Using the tool            : $CXX"
echo "Remove the bin directory  : bin/"
rm -frv bin/
echo "Create bin directory      : bin/"
mkdir -p bin


echo
echo "Assemble  : crt0.s to bin/crt0.o"
$CXX -mmcu=atmega328p -fsigned-char -x assembler -c crt0.s -o bin/crt0.o

echo
echo "Compile   : all .cpp source files into bin/*.o"
$CXX -mmcu=atmega328p -fsigned-char -O2 -std=c++14 -I. -c led.cpp -o bin/led.o
$CXX -mmcu=atmega328p -fsigned-char -O2 -std=c++14 -I. -c main.cpp -o bin/main.o

echo
echo "Link      : objects to bin/led.elf"
$CXX -mmcu=atmega328p -nostartfiles -nostdlib -Wl,-Tavr.ld,-Map,bin/led.map bin/led.o bin/main.o -o bin/led.elf