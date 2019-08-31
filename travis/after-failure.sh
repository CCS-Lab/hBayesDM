#!/bin/bash

# Scripts for R
if [ "$TARGET" = "R" ]; then
  cat hBayesDM.Rcheck/00*

# Otherwise
else
  echo 'No after-failure job required'
fi

