#!/usr/bin/env bash
user_name=`id -un`
args1=$1
args2=$2
mode="s"

# m -- prints out message
# e -- prints out error message and exits
output() {
    if [ "$mode" == "v" ]; then
        if [ "$1" == "e" ]; then
            echo " -- HardwareModel_Check: $2"
            exit
        elif [ "$1" == "m" ]; then
            echo " -- HardwareModel_Check: $2"
        elif [ "$mode" == "s" ]; then
            : # Carry On.
        elif [ "$1" == "l" ]; then
            echo ":: results"
            echo "$2"
        else
            echo " -- HardwareModel_Check: Unknown Mode: "
        fi
    fi
}


# Step -- 4
HardwareModelCheck() {
    output "m" "run"
    if [ -e "/Users/$user_name/Library/Logs/iPhone Updater Logs/iPhoneUpdater.log" ]; then
        results=`grep -h " 'HardwareModel' returned \w*'" /Users/$user_name/Library/Logs/iPhone\ Updater\ Logs/iPhoneUpdater*`
        echo "$results" >> /Volumes/new-tools/modelsFound.txt
        echo " ---- EOF" >> /Volumes/new-tools/modelsFound.txt
        output "l" "$results"
        output "m" "end"
    else
        output "e" "ERROR (2)"
    fi
}


# Step -- 3
args_check() {
    output "m" "start"
    if [ "$args1" == "--open" ] || [ "$args2" == "--open" ]; then
        if [ -e /Users/$user_name/HardwareModels/modelsFound.txt ]; then
            HardwareModelCheck
            open /Users/$user_name/HardwareModels/modelsFound.txt
        else
            output "m" "ERROR (0)"
        fi
    elif [ "$args1" == "--purge" ] || [ "$args2" == "--purge" ]; then
        if [ -e /Users/$user_name/HardwareModels/modelsFound.txt ]; then
            rm /Users/$user_name/HardwareModels/modelsFound.txt
            output "m" "purge"
        else
            output "e" "ERROR (1)"
        fi
    elif [ "$args1" == "--help" ]; then
            echo ":: find all models of iPhones that have been update on this machine"
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


# Step -- 2
setup() {
    if [ -d /Users/$user_name/HardwareModels ]; then
        args_check
    else
        output "m" "HardwareModels directory created"
        mkdir /Users/$user_name/HardwareModels
        args_check
fi
}


# Step -- 1
launch() {
    if [ "$args1" == "--v" ] || [ "$args2" == "--v" ]; then
        mode="v"
        output "m" "mode: verbose"
        args_check
    else
        args_check
    fi
}


# -- Start
launch

