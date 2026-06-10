#!/bin/bash

pipewire &
sleep 3 && pipewire-pulse &
sleep 3 && wireplumber &
