if [ -f /etc/nixos/configuration.nix ]; then
    sudo rm /etc/nixos/configuration.nix
else
    echo "Configuration file /etc/nixos/configuration.nix does not exist"
fi

if [ -f /etc/nixos/hardware-configuration.nix ]; then
    sudo rm /etc/nixos/hardware-configuration.nix
else
    echo "Hardware file /etc/nixos/hardware-configuration.nix does not exist"
fi

host_dir="$HOME/nixos-cfg/hosts/$(hostname)"

if [ ! -d "$host_dir" ]; then
    echo "Host directory $host_dir does not exist"
    exit 1
fi

config_file="$host_dir/configuration.nix"
hardware_file="$host_dir/hardware-configuration.nix"

if [ ! -f "$config_file" ]; then
    echo "Configuration file $config_file does not exist"
    exit 1
else
    sudo ln -s "$config_file" /etc/nixos/configuration.nix
fi

if [ ! -f "$hardware_file" ]; then
    echo "Hardware file $hardware_file does not exist"
    exit 1
else   
    sudo ln -s "$hardware_file" /etc/nixos/hardware-configuration.nix
fi

echo "Symlinks created successfully"