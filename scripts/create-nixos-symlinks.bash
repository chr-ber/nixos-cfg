sudo rm /etc/nixos/configuration.nix
sudo rm /etc/nixos/hardware-configuration.nix

if [ ! -d "~/nixos-cfg/hosts/$(hostname)" ]; then
    echo "Host directory does not exist"
    exit 1
fi

if [ ! -f "~/nixos-cfg/hosts/$(hostname)/configuration.nix" ]; then
    echo "Configuration file does not exist"
    exit 1
else
    sudo ln -s ~/nixos-cfg/hosts/$(hostname)/configuration.nix /etc/nixos/configuration.nix
fi

if [ ! -f "~/nixos-cfg/hosts/$(hostname)/hardware-configuration.nix" ]; then
    echo "Hardware configuration file does not exist"
    exit 1
else   
    sudo ln -s ~/nixos-cfg/hosts/$(hostname)/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
fi