package main

import (
    "bytes"
    "encoding/json"
    "fmt"
    "io/ioutil"
    "os"
    "os/exec"
    "path/filepath"
    "time"
)

type Config struct {
    GitRepoPath string `json:"gitRepoPath"`
    GitUsername string `json:"gitUsername"`
    GitToken    string `json:"gitToken"`
}

func main() {
    // Load configuration
    var config Config
    if err := loadConfig("config.json", &config); err != nil {
        fmt.Println("Error loading config:", err)
        return
    }

    const nixosDir = "/etc/nixos/"
    timestamp := time.Now().Format("20060102-150405")
    newDirPath := filepath.Join(config.GitRepoPath, timestamp)

    // Create new directory
    if err := os.MkdirAll(newDirPath, 0755); err != nil {
        fmt.Println("Error creating directory:", err)
        return
    }

    // Scan for .nix files and process them
    var markdownContents bytes.Buffer
    markdownContents.WriteString("# Nix Configuration Files\n\n")

    files, err := ioutil.ReadDir(nixosDir)
    if err != nil {
        fmt.Println("Error reading NixOS directory:", err)
        return
    }

    for _, file := range files {
        if filepath.Ext(file.Name()) == ".nix" {
            processFile(nixosDir, newDirPath, file, &markdownContents)
        }
    }

    // Write markdown file
    mdFilePath := filepath.Join(newDirPath, "README.md")
    if err := ioutil.WriteFile(mdFilePath, markdownContents.Bytes(), 0644); err != nil {
        fmt.Println("Error writing markdown file:", err)
        return
    }

    // Git operations
    if err := gitOperations(config, timestamp); err != nil {
        fmt.Println("Error with git operations:", err)
        return
    }

    fmt.Println("Nix configuration files have been successfully pushed to the git repository.")
}

func loadConfig(filePath string, config *Config) error {
    configFile, err := os.Open(filePath)
    if err != nil {
        return err
    }
    defer configFile.Close()

    return json.NewDecoder(configFile).Decode(config)
}

func processFile(sourceDir, destDir string, fileInfo os.FileInfo, markdownContents *bytes.Buffer) {
    sourcePath := filepath.Join(sourceDir, fileInfo.Name())
    destPath := filepath.Join(destDir, fileInfo.Name())

    content, err := ioutil.ReadFile(sourcePath)
    if err != nil {
        fmt.Printf("Error reading file '%s': %v\n", fileInfo.Name(), err)
        return
    }

    if err := ioutil.WriteFile(destPath, content, 0644); err != nil {
        fmt.Printf("Error writing file '%s': %v\n", fileInfo.Name(), err)
        return
    }

    markdownContents.WriteString(fmt.Sprintf("## %s\n", fileInfo.Name()))
    markdownContents.WriteString("```\n")
    markdownContents.WriteString(string(content) + "\n")
    markdownContents.WriteString("```\n\n")
}

func gitOperations(config Config, messageSuffix string) error {
    cmdDir := config.GitRepoPath
    os.Chdir(cmdDir) // Change working directory to repo path

    gitAdd := exec.Command("git", "add", ".")
    if err := gitAdd.Run(); err != nil {
        return fmt.Errorf("git add failed: %v", err)
    }

    gitCommit := exec.Command("git", "commit", "-m", fmt.Sprintf("Add Nix configuration files for %s", messageSuffix))
    if err := gitCommit.Run(); err != nil {
        return fmt.Errorf("git commit failed: %v", err)
    }

    // Setup environment for Git authentication
    gitPush := exec.Command("git", "push")
    gitPush.Env = append(os.Environ(),
        fmt.Sprintf("GIT_ASKPASS=echo %s", config.GitToken),
        "GIT_TERMINAL_PROMPT=0", // Disable git prompt
    )

    if err := gitPush.Run(); err != nil {
		    return fmt.Errorf("git push failed: %v", err)
}

return nil

