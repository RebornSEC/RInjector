#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;
use Image::ExifTool;
use Getopt::Long;
use File::Basename;
use Pod::Usage;

# Version and author information
our $VERSION = '2.0.0';
our $AUTHOR = 'Enhanced by AI - Original by RebornSEC';

# Configuration
my %config = (
    file     => '',
    image    => '',
    field    => 'Model',
    output   => '',
    verbose  => 0,
    help     => 0,
    version  => 0,
    list     => 0,
    backup   => 1,
);

# Available metadata fields for injection
my @available_fields = qw(
    Model Make Software Copyright Artist ImageDescription
    UserComment Comment DocumentName PageName
);

# Parse command line options
GetOptions(
    'file|f=s'      => \$config{file},
    'image|i=s'     => \$config{image},
    'field|d=s'     => \$config{field},
    'output|o=s'    => \$config{output},
    'verbose|v'     => \$config{verbose},
    'help|h'        => \$config{help},
    'version|V'     => \$config{version},
    'list|l'        => \$config{list},
    'no-backup'     => sub { $config{backup} = 0 },
) or pod2usage(2);

# Handle special options
if ($config{help}) {
    pod2usage(-exitval => 0, -verbose => 2);
}

if ($config{version}) {
    print "RInjector v$VERSION\n";
    print "Author: $AUTHOR\n";
    exit 0;
}

if ($config{list}) {
    print "Available metadata fields for injection:\n";
    print "  $_\n" for @available_fields;
    exit 0;
}

# Print banner
print_banner();

# Validate required arguments
unless ($config{file} && $config{image}) {
    print STDERR "Error: Both --file and --image are required\n";
    pod2usage(1);
}

# Validate field selection
unless (grep { $_ eq $config{field} } @available_fields) {
    print STDERR "Error: Invalid field '$config{field}'\n";
    print STDERR "Use --list to see available fields\n";
    exit 1;
}

# Set output file if not specified
$config{output} ||= $config{image};

# Main execution
eval {
    inject_shell_into_image(\%config);
    print "[+] Injection completed successfully!\n";
};

if ($@) {
    print STDERR "[-] Error: $@\n";
    exit 1;
}

# === SUBROUTINES ===

sub print_banner {
    print <<"BANNER";

+-----------------------------------------------+
   Enhanced Shell to JPEG Injector v$VERSION
   Original by RebornSEC - Enhanced with AI
+-----------------------------------------------+

BANNER
}

sub validate_file {
    my ($file, $type) = @_;
    
    unless (-e $file) {
        die "$type file '$file' does not exist";
    }
    
    unless (-r $file) {
        die "$type file '$file' is not readable";
    }
    
    return 1;
}

sub validate_image {
    my ($image) = @_;
    
    validate_file($image, 'Image');
    
    # Check if it's actually an image file
    my $exiftool = Image::ExifTool->new();
    my $info = $exiftool->ImageInfo($image);
    
    unless ($info && %$info) {
        die "File '$image' does not appear to be a valid image";
    }
    
    return 1;
}

sub read_shell_file {
    my ($file) = @_;
    
    validate_file($file, 'Shell');
    
    open my $fh, '<', $file or die "Cannot open shell file '$file': $!";
    
    my $content = do {
        local $/;
        <$fh>;
    };
    
    close $fh;
    
    unless ($content) {
        die "Shell file '$file' is empty";
    }
    
    return $content;
}

sub create_backup {
    my ($file) = @_;
    
    my $backup_file = $file . '.backup.' . time();
    
    if (system("cp", $file, $backup_file) == 0) {
        print "[+] Backup created: $backup_file\n" if $config{verbose};
        return $backup_file;
    } else {
        warn "Warning: Could not create backup of '$file'\n";
        return undef;
    }
}

sub inject_shell_into_image {
    my ($config) = @_;
    
    print "[+] Validating files...\n" if $config->{verbose};
    
    # Validate input files
    validate_image($config->{image});
    my $shell_content = read_shell_file($config->{file});
    
    print "[+] Image file: $config->{image}\n";
    print "[+] Shell file: $config->{file}\n";
    print "[+] Target field: $config->{field}\n";
    print "[+] Output file: $config->{output}\n";
    
    # Create backup if requested and modifying original
    if ($config->{backup} && $config->{output} eq $config->{image}) {
        create_backup($config->{image});
    }
    
    # Copy to output file if different from input
    if ($config->{output} ne $config->{image}) {
        if (system("cp", $config->{image}, $config->{output}) != 0) {
            die "Failed to copy image to output location";
        }
        print "[+] Image copied to output location\n" if $config->{verbose};
    }
    
    print "[+] Injecting shell code into metadata...\n" if $config->{verbose};
    
    # Inject the shell code
    my $exiftool = Image::ExifTool->new();
    
    # Configure ExifTool
    $exiftool->Options(
        IgnoreMinorErrors => 1,
        PrintConv => 0,
    );
    
    # Extract current info for logging
    if ($config->{verbose}) {
        $exiftool->ExtractInfo($config->{output});
        my $current_value = $exiftool->GetValue($config->{field});
        if ($current_value) {
            print "[+] Current $config->{field} value: " . substr($current_value, 0, 50) . "...\n";
        }
    }
    
    # Set the new value
    my $result = $exiftool->SetNewValue($config->{field}, $shell_content);
    unless ($result) {
        die "Failed to set new value for field '$config->{field}'";
    }
    
    # Write the changes
    my $write_result = $exiftool->WriteInfo($config->{output});
    unless ($write_result) {
        my $error = $exiftool->GetValue('Error');
        die "Failed to write metadata: " . ($error || 'Unknown error');
    }
    
    print "[+] Shell code successfully injected into $config->{field} field\n";
    
    # Display statistics
    if ($config->{verbose}) {
        my $file_size = -s $config->{output};
        my $content_length = length($shell_content);
        print "[+] Output file size: $file_size bytes\n";
        print "[+] Injected content length: $content_length bytes\n";
    }
    
    return 1;
}

__END__

=head1 NAME

RInjector.pl - Enhanced Shell Code to JPEG Metadata Injector

=head1 SYNOPSIS

RInjector.pl [OPTIONS]

=head1 DESCRIPTION

RInjector.pl is an enhanced tool for injecting shell code into JPEG image metadata.
This can be useful for various purposes including steganography and penetration testing.

=head1 OPTIONS

=over 4

=item B<-f, --file> FILE

Path to the shell script file to inject (required)

=item B<-i, --image> FILE

Path to the JPEG image file (required)

=item B<-d, --field> FIELD

Metadata field to inject into (default: Model)
Use --list to see available fields

=item B<-o, --output> FILE

Output file path (default: same as input image)

=item B<-v, --verbose>

Enable verbose output

=item B<-l, --list>

List available metadata fields for injection

=item B<--no-backup>

Disable automatic backup creation when modifying original file

=item B<-h, --help>

Show this help message

=item B<-V, --version>

Show version information

=back

=head1 EXAMPLES

Basic injection:
  perl RInjector.pl --file shell.php --image photo.jpg

Inject into specific field:
  perl RInjector.pl -f payload.sh -i image.jpg -d Copyright

Save to different file:
  perl RInjector.pl -f script.py -i original.jpg -o modified.jpg

Verbose mode:
  perl RInjector.pl -f shell.pl -i test.jpg -v

=head1 REQUIREMENTS

=over 4

=item * Perl 5.10 or higher

=item * Image::ExifTool module

=back

=head1 AUTHOR

Enhanced by AI - Original by RebornSEC

=head1 VERSION

2.0.0

=cut
