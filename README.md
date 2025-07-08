# Daily Note - CLI Note Writer

Daily Note / **daily** is a CLI note writer that just works. Its quick and like that. I like to write notes/todos as quickly as possible before forgetting
something important and just stores it for later.

It's nothing impressive but damn its useful.

## Usage

``` 
    daily write todos.25.07.08  # This allows you to write a note in markdown right from the terminal(duh) 

    daily get todos.25.07.08.md # Outputs the content of the note
    
    daily list # Lists all your notes(again, duh) 
``` 

## Installation

Its a binary, just download it, add to a know path and just use it. But for those who don't know:

1º Download the binary in the release page (if ts available) 

2º Follow the code commands below

```bash 
mkdir -p .local/bin 

export PATH="$HOME/.local/bin"

mv ~/Downloads/daily ~/.local/bin 

# Run this at .local/bin 

chmod +x daily

# Run this to setup the notes directory

daily setup
```

### Installation from source 

Download the project files by cloning it or downloading the source code, build the code, and move it to a know directory

## Creator Notes 

Daily it's a WLR(Write-Read-List) a afternoon project, if you're going to critize it, fuck you.
