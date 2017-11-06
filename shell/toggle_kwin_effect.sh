#!/usr/bin/env bash

# Effects:
# diminactive                Dim Inactive Windows
# kwin4_effect_dialogparent  Dialogue Box Parent

/usr/bin/qdbus org.kde.KWin /Effects toggleEffect "$1"
