sub main::lib_upload_file
{
my($SubDebug) = $main::SubID{lib_upload_file}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
use CGI qw(:standard);
$CGI::POST_MAX=1024 * 10000;  
$|=1;
my($cgi) = new CGI;
	
    my $BytesRead=0;
    my $Size='';
    my $Buff='';
    my $StartTime;
    my $TimeTook;
    my $FilePath='';
    my $FileName='';
    my $WriteFile='';

    my($Dir) = undef;
    my($Extention) = undef;
    my($Ext) = undef;
    my($FileData)=$cgi->param("$_[0]");
    $FilePath= $_[1];
    my($Ovewrite) = $_[2];

($SubDebug == 1) ? DebugOut("File Upload Parameters: \$_[0]=\"$_[0]\" \$FilePath=\"$FilePath\"") : 0;       

    unless ($FilePath){return 0};

    if ($Ovewrite == 0)
    {
        if (-e $FilePath)
        {
        ($SubDebug == 1) ? DebugOut("FAILED: Will not ovewrite: \"$FilePath\"") : 0;       
        return 0;
        };
    };
	
    if (!open(WFD,">$FilePath"))
    {
	($SubDebug == 1) ? DebugOut("FAILED: Cannot Open for Writing: \"$FilePath\"") : 0;       
        return 0;
    };

    $StartTime=time();
    while ($BytesRead=read($FileData,$Buff,2096))
    {
        $Size += $BytesRead;
        binmode WFD;
        print WFD $Buff;
    };

    close(WFD);

    if ((stat $FilePath)[7] <= 0)
    {
	($SubDebug == 1) ? DebugOut("FAILED: Could not upload: Size is ZERO!: \"$FilePath\"") : 0;       
        unlink($FilePath);
        return 0;
    }
    else
    {

        $TimeTook=time()-$StartTime;
	($SubDebug == 1) ? DebugOut("OK - Upload took $TimeTook sec.") : 0;       
   };
$main::Config{UploadedFileSize} = $Size;
$main::Config{UploadedFileName} = $FilePath;
($SubDebug == 1) ? DebugOut("OK - Uploaded size: $Size bytes.") : 0;       
return 1;
};

1;