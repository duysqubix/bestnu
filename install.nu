#!/usr/bin/env nu
let min_version = "1.76.0"
let req_commands = [cargo, rustc, zoxide, starship]
let dir = $nu.default-config-dir

def command_exists [cmd: string] int {
    let found = ((which $cmd) | length)
    $found
}

def install_package [crate: string] {
    # assume cargo is installed
    (cargo install $crate)
}

for $cmd in $req_commands {
    if ((command_exists $cmd) == 0) {
        print $"`($cmd)` not found, please install"
        exit  
    }
}

if ((rustc --version | split row ' ' | get 1 | into string) != $min_version) {
    print $"please update rust to ($min_version)"
}

# print (!(command_exists 'cargo'))
if ((command_exists 'cargo') == 1) {
    if ((command_exists 'zoxide') == 0) {
        print "Installing Zoxide..."
        install_package 'zoxide'
    }

    if ((command_exists 'starship') == 0) {
        print "Installing starship 🚀..."
        install_package 'starship'
    }
}

print "Installing nu configurations..."
cp -v --recursive --preserve [mode] nushell/* $dir