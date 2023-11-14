# nixconfigs

A collection of my NixOS configurations, as well as my ``.bashrc``.

Additionally, my configbuilder app. Runs on go, and can generate a configuration.nix file with nix snippet imports. To run configbuilder:

``sudo ./configbuilder``.

Code for configbuilder is as follows

```
package main

import (
    "fmt"
    "os"
    "os/exec"

    "github.com/AlecAivazis/survey/v2"
)

const githubRepoURL = "https://raw.githubusercontent.com/soltros/nixconfigs/main/desktop/"
const nixosDir = "/etc/nixos/"

var moduleChoices = []string{
    "bootloader.nix",
    "budgie.nix",
    "cinnamon.nix",
    "deepin.nix",
    "derriks-apps.nix",
    "gnome-shell.nix",
    "intel-support.nix",
    "kde-flatpak-fix.nix",
    "kde-plasma.nix",
    "mate.nix",
    "networking.nix",
    "nvidia-support.nix",
    "pantheon-packages.nix",
    "pantheon.nix",
    "pipewire-support.nix",
    "podman-support.nix",
    "tailscale-support.nix",
    "timezone-localization.nix",
    "unfree-packages.nix",
    "user-account.nix",
    "virtualization-support.nix",
    "xfce4.nix",
    "flatpak.nix",
    "printer.nix",
    "keymap.nix",
    "garbagecollection.nix",
}

func downloadModules(selectedModules []string) {
    for _, module := range selectedModules {
        url := githubRepoURL + module
        outputPath := nixosDir + module
        fmt.Printf("Downloading %s...\n", module)
        cmd := exec.Command("wget", url, "-O", outputPath)
        err := cmd.Run()
        if err != nil {
            fmt.Printf("Failed to download %s: %s\n", module, err)
        }
    }
}

func generateConfigurationNix(selectedModules []string) {
    configFile := nixosDir + "configuration.nix"

    file, err := os.Create(configFile)
    if err != nil {
        fmt.Println("Error creating configuration.nix:", err)
        return
    }
    defer file.Close()

    // Updated structure of the configuration.nix file with an empty system packages section
    basicStructure := `{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
%s
    ];

  # Add your custom configurations here

  # System packages
  environment.systemPackages = with pkgs; [
  ];

  # This value determines the NixOS release with which your system is to be compatible.
  # Update it according to your NixOS version.
  system.stateVersion = "20.03"; # Edit according to your NixOS version
}
`

    moduleLines := ""
    for _, module := range selectedModules {
        moduleLines += fmt.Sprintf("      ./%s\n", module)
    }

    configContent := fmt.Sprintf(basicStructure, moduleLines)

    _, err = file.WriteString(configContent)
    if err != nil {
        fmt.Println("Error writing to configuration.nix:", err)
        return
    }

    fmt.Println("configuration.nix generated.")
}


func mainMenu() {
    var selectedModules []string
    prompt := &survey.MultiSelect{
        Message: "Select Nix Modules:",
        Options: moduleChoices,
    }
    survey.AskOne(prompt, &selectedModules, nil)

    downloadModules(selectedModules)
    generateConfigurationNix(selectedModules)
}

func main() {
    mainMenu()
}

```
