#!/bin/bash

SLEEPTIME=${1:-1}

while : ; do
  ./cerberus.sh
  sleep $SLEEPTIME
done
