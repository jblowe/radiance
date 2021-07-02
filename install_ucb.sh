#!/usr/bin/env bash
#set -e
#set -x
tenant=$1
portal_config_file=$2
current_directory=`pwd`
extra_dir="../extras"

WHOLE_LIST="bampfa botgarden cinefiles pahma ucjeps"

cd portal

# check the command line parameters

if [[ ! $WHOLE_LIST =~ .*${tenant}.* || "$tenant" == "" ]]
then
  echo "1st argument must be one of '${WHOLE_LIST}'"
  echo "$0 tenant <optional portal config file>"
  exit
fi

if [ ! -d "${extra_dir}" ]; then
  echo "Can't find directory '${extra_dir}'. Please verify name and location"
  echo "This script must be executed from the base dir of the ucb blacklight customization (i.e. radiance)"
  echo "$0 tenant <optional portal config file>"
  exit
fi

# 'customize' the code in the extras directory
perl -i -pe "s/#TENANT#/${tenant}/g" ${extra_dir}/default/*/* 2>&1

# now apply customizations, if any

rsync -av ${extra_dir}/default .
rsync -av ${extra_dir}/{$tenant} .