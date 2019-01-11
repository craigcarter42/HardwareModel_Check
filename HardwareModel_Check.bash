#!/usr/bin/env bash
user_name=`id -un`
args=$1

HardwareModelCheck() {
    echo " -- HardwareModel_Check: RUN"
    if [ -e "/Users/$user_name/Library/Logs/iPhone Updater Logs/iPhoneUpdater.log" ]; then
        grep "HardwareModel" /Users/$user_name/Library/Logs/iPhone\ Updater\ Logs/iPhoneUpdater* >> /Users/$user_name/HardwareModels/modelsFound.txt
        echo " ---- EOF" >> /Users/$user_name/HardwareModels/modelsFound.txt
    else
        echo " -- HardwareModel_Check: ERROR (2)"
        exit
    fi
}

args_check() {
if [ "$args" == "--open" ]; then
    if [ -e /Users/$user_name/HardwareModels/modelsFound.txt ]; then
        HardwareModelCheck
        open /Users/$user_name/HardwareModels/modelsFound.txt
    else
        echo " -- HardwareModel_Check: ERROR (0)"
        exit
    fi
elif [ "$args" == "--purge" ]; then
    if [ -e /Users/$user_name/HardwareModels/modelsFound.txt ]; then
        rm /Users/$user_name/HardwareModels/modelsFound.txt
        echo " -- HardwareModel_Check: PURGE"
    else
        echo " -- HardwareModel_Check: ERROR (1)"
        exit
    fi
elif [ "$args" == "--help" ]; then
        echo ":: find all models of iPhones that have been update on this machone"
        echo ":: args:"
        echo "  --open    --    open file after collecting models"
        echo "  --purge   --    remove existing file"
        echo "  --help    --    list of possible commands"
        echo ":: error codes:"
        echo "  error (0)     --    modelsFound.txt could not be opened"
        echo "  error (1)     --    modelsFound.txt could not be removed"
        echo "  error (2)     --    no iPhone update logs found"
else
    HardwareModelCheck
fi
}

run() {
    echo " -- HardwareModel_Check: START"
    args_check
}

if [ -e /Users/$user_name/HardwareModels ]; then
    run
else
    mkdir /Users/$user_name/HardwareModels
    run
fi

