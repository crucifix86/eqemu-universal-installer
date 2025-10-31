#!/usr/bin/env bash

if test -f "loginserver"; then
   ./loginserver &
fi

if test -f "./shared_memory"; then
   ./shared_memory
fi

if test -f "./world"; then
   ./world &
fi

if test -f "./eqlaunch"; then
   ./eqlaunch zone &
fi

if test -f "./ucs"; then
   ./ucs &
fi

if test -f "./queryserv"; then
   ./queryserv &
fi
