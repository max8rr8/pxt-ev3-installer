#!/bin/bash
IFS=$'\n'

bold='\033[1m'
normal='\033[0m'

curl -L https://github.com/maximmasterr/pxt-ev3-installer/raw/master/description

read -n 1 -r -p 'Do you want to install pxt-ev3 advanced edition [Y/n] ' answer
if [[ ${answer:0:1} != 'y' ]]
  then
  if [[ ${answer:0:1} != 'Y' ]]
    then
    echo 'Abort'
    exit
  fi
fi

echo -e '\n'
echo -e $bold'> Installing base version'$normal
echo -e  $bold'=> Downloading official pxt ev3'$normal
echo ''

rm -rf *
rm -rf .g*
rm -rf .c*
git clone https://github.com/microsoft/pxt-ev3.git .

echo ''
echo -e $bold'=> Installing deps'$normal
echo ''

npm i

echo -e '\n'
echo -e $bold'> Patching'$normal
echo -e  $bold'=> Downloading patches'$normal


rm -rf patches
mkdir patches
cd patches

for line in $(curl -L https://github.com/maximmasterr/pxt-ev3-installer/raw/master/patches)
do
  cmd=$(echo $line | cut -f1 -d"#" | tr -d ' ')
  if [ ! -z "$cmd" ] 
  then
    echo -e $bold'==> Downloading '$cmd$normal
    echo ''
    curl 'https://github.com/microsoft/pxt-ev3/compare/master...'$cmd'.patch' >> `echo $cmd | awk 'BEGIN {FS=":"; OFS="."} {print $2,$1,"patch"}'`
  fi
  
done

cd ..
echo -e  $bold'=> Applying patches'$normal

for patch in ./patches/*.patch
do
  echo -e $bold'==> Applying '$patch$normal
  git apply $patch
done


