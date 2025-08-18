# RInjector v2.0.0

Enhanced Shell Code to JPEG Metadata Injector - Original by RebornSEC

## Description

RInjector is a powerful Perl tool for injecting shell code into JPEG image metadata. This enhanced version provides robust error handling, multiple injection options, and modern Perl best practices.

## Features

### ✨ New in v2.0.0

- **Modern Perl practices** with strict/warnings
- **Comprehensive error handling** and input validation
- **Multiple metadata fields** for injection (not just "Model")
- **Automatic backup creation** (can be disabled)
- **Flexible output options** (save to different file)
- **Verbose mode** for detailed operation logging
- **Command-line argument parsing** with GetOpt::Long
- **Built-in help system** with Pod::Usage
- **File existence and format validation**
- **Professional code structure** with subroutines

### Available Metadata Fields

- Model (default)
- Make
- Software
- Copyright
- Artist
- ImageDescription
- UserComment
- Comment
- DocumentName
- PageName

## Requirements

- Perl 5.10 or higher
- Image::ExifTool module

### Installing Dependencies

```bash
# Ubuntu/Debian
sudo apt-get install libimage-exiftool-perl

# CentOS/RHEL
sudo yum install perl-Image-ExifTool

# Using CPAN
cpan Image::ExifTool
```

## Usage

### Basic Usage

```bash
# Simple injection (creates backup automatically)
perl RInjector.pl --file shell.php --image photo.jpg

# Short form
perl RInjector.pl -f payload.sh -i image.jpg
```

### Advanced Usage

```bash
# Inject into specific metadata field
perl RInjector.pl -f shell.py -i photo.jpg -d Copyright

# Save to different output file
perl RInjector.pl -f script.pl -i original.jpg -o modified.jpg

# Verbose mode for detailed logging
perl RInjector.pl -f payload.php -i test.jpg -v

# Disable automatic backup
perl RInjector.pl -f shell.sh -i photo.jpg --no-backup

# List available metadata fields
perl RInjector.pl --list
```

### Help and Information

```bash
# Show help
perl RInjector.pl --help

# Show version
perl RInjector.pl --version
```

## Command Line Options

| Option | Short | Description |
|--------|-------|-------------|
| `--file` | `-f` | Path to shell script file (required) |
| `--image` | `-i` | Path to JPEG image file (required) |
| `--field` | `-d` | Metadata field to inject into (default: Model) |
| `--output` | `-o` | Output file path (default: same as input) |
| `--verbose` | `-v` | Enable verbose output |
| `--list` | `-l` | List available metadata fields |
| `--no-backup` | | Disable automatic backup creation |
| `--help` | `-h` | Show help message |
| `--version` | `-V` | Show version information |

## Examples

### Penetration Testing

```bash
# Inject PHP web shell into image
perl RInjector.pl -f webshell.php -i innocent_photo.jpg -d Software

# Inject reverse shell into multiple fields
perl RInjector.pl -f reverse_shell.sh -i image.jpg -d Artist -v
```

### Steganography

```bash
# Hide script in image metadata
perl RInjector.pl -f secret_script.py -i cover_image.jpg -d UserComment

# Create modified copy with injected payload
perl RInjector.pl -f payload.js -i original.jpg -o modified.jpg
```

## Security Notes

⚠️ **Important**: This tool is designed for legitimate security testing and educational purposes. The enhanced version includes validation to prevent common mistakes, but users are responsible for:

- Using the tool only on systems they own or have explicit permission to test
- Understanding local laws and regulations regarding security testing
- Properly securing any files created with injected payloads

## Error Handling

The enhanced version provides detailed error messages for common issues:

- File not found or not readable
- Invalid image format
- Empty shell files
- Invalid metadata field selection
- Write permission issues

## Changelog

### v2.0.0
- Complete rewrite with modern Perl practices
- Added comprehensive error handling
- Multiple metadata field support
- Automatic backup functionality
- Flexible output options
- Verbose logging mode
- Built-in help system
- Input validation and file format checking

### v1.0.0
- Original version by RebornSEC
- Basic injection into "Model" field

## Contributing

This enhanced version maintains compatibility with the original while adding significant functionality. Contributions are welcome for:

- Additional metadata field support
- New output formats
- Enhanced validation
- Performance improvements

## License

See LICENSE file for details.

## Author

RebornSEC

---

**Note**: Always test in a controlled environment first and ensure you have proper authorization before using this tool.
