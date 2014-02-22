# Perl script to count the network level TCP Flag bit

# Write a program that count TCP flag bit (SYN, SYN-ACK, RST,FIN-ACK)and number of GET request from client to server.

#!/usr/bin/perl -w
use LWP::Simple;
use Getopt::Long;
use String::Util 'trim';
my  $trace_file_dir;
my $csv_file_dir;
# open directory 
GetOptions("s=s" =>\$trace_file_dir, 
	   "d=s" =>\$csv_file_dir,
) or die "Wrong arugment, use -s <source dir> -d <destination dir> \n";
die "Missing -source file directory!" unless $trace_file_dir;
opendir(SRC_DIR,$trace_file_dir) or die $!;
open($CSV1,">$csv_file_dir/sess1.csv") || die "Can't open CSV :$!";
print ($CSV1 " ,page 1,,,,, ,page 2,,,,, ,page 3,,,,, ,page 4,,,,, ,page 5,,,,"."\n");
print ($CSV1 " ,GET,SYN,SYN-ACK,RST,FIN-ACK, ,
GET,SYN,SYN-ACK,RST,FIN-ACK,
,GET,SYN,SYN-ACK,RST,FIN-ACK,,
GET,SYN,SYN-ACK,RST,FIN-ACK,,
GET,SYN,SYN-ACK,RST,FIN-ACK"."\n");
close $CSV1 or die "$!";
# open three file to save the data
open($CSV2,">$csv_file_dir/sess2.csv") || 
ie "Can't open CSV :$!";
print ($CSV2 " ,page 1,,,,, ,page 2,,,,, ,page 3,,,,, ,
page 4,,,,, ,page 5,,,,"."\n");
print ($CSV2 " ,GET,SYN,SYN-ACK,RST,FIN-ACK, 
,GET,SYN,SYN-ACK,RST,FIN-ACK,
,GET,SYN,SYN-ACK,RST,FIN-ACK,,
GET,SYN,SYN-ACK,RST,FIN-ACK,,
GET,SYN,SYN-ACK,RST,FIN-ACK"."\n");
close $CSV2 or die "$!";
open($CSV3,">$csv_file_dir/sess3.csv") 
|| die "Can't open CSV :$!";
print ($CSV3 " ,page 1,,,,, ,page 2,,,,, ,page 3,,,,, ,
page 4,,,,, ,page 5,,,,"."\n");
print ($CSV3 " ,GET,SYN,SYN-ACK,RST,FIN-ACK, 
,GET,SYN,SYN-ACK,RST,FIN-ACK,
,GET,SYN,SYN-ACK,RST,FIN-ACK,,
GET,SYN,SYN-ACK,RST,FIN-ACK,,
GET,SYN,SYN-ACK,RST,FIN-ACK"."\n");
close $CSV3 or die "$!";
my @lines = ();
while(my $trace_file = readdir(SRC_DIR)){
	@lines = ();
	get_page_load_time($trace_file);
}
closedir(SRC_DIR);
sub get_network_params_values{
my $page_id = $_[0];
my $start_sess = $_[1];
my $end_sess = $_[2];
my $line_no;
my $count = $start_sess;
my $check_start = 0;
my $check_end = 0;
my $check_last = $start_sess;
my @base_array = ();
my $count_flag=0;
my $count_flag_syn=0;
my $count_flag_syn_ack=0;
my $count_flag_rst=0;
my $count_flag_fin_ack=0;
#my $count_flag_fin_ack=0;
for ($line_no = $start_sess; $line_no <= $end_sess; $line_no++){
$line = $lines[$line_no];
if($page_id == 1)
 {
#check three web session
if($line =~ /www\.webqoe1\.com/ or $line =~ /www\.webqoe2\.com/ or $line =~ /www\.webqoe3\.com/ and $check_start == 0) 
{
$i = $line_no;				
while($lines[$i] !~ /GET \/images\/favicon1.ico/)
{
$line = $lines[$i];
#count number of GET request
if($line =~ /GET/ )
{
$count_flag ++;
}
 if($line =~ /192.168.0.101/ && $line =~ /10.0.1.1/ && $line =~ /\[SYN\]/ ) 
{                                 
          #count number of SYN 
$count_flag_syn ++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ && $line =~ /\[SYN,\ ACK\]/ ) 
{                                 
           #count number of SYN-ACK
 $count_flag_syn_ack++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ && $line =~ /\[RST\]/ ) 
{                                 
          #count number of RST
$count_flag_rst++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ && $line =~ /\[FIN,\ ACK\]/ ) 
{                                 
           #count number of FIN-ACK
 $count_flag_fin_ack++;
 }
$i++;
}	
print("HTTP Request = $count_flag \n");
print("TCP flag(SYN) bit is= $count_flag_syn \n");
print("TCP flag bit(SYN, ACK) is= $count_flag_syn_ack \n");
print("TCP flag bit(RST) is=  $count_flag_rst \n");
print("TCP flag bit(FIN, ACK) is=  $count_flag_fin_ack \n");
push(@base_array, $count_flag,$count_flag_syn, $count_flag_syn_ack, 
$count_flag_rst, $count_flag_fin_ack);
	$check_start = 1;					
	} 
}
#Count TCP flag bits for page 2
if($page_id == 2)
{
my $count_flag=0;
my $count_flag_syn=0;
my $count_flag_syn_ack=0;
my $count_flag_rst=0;
my $count_flag_fin_ack=0;
if($line =~ /GET \/category_home.php/ and $check_start == 0){	
## page 2 counting 
$i = $line_no;				
while($lines[$i] !~ /GET \/images\/favicon2.ico/)
{
$line = $lines[$i];
         #count number of GET
if($line =~ /GET/ ){
$count_flag ++;
 }
 if($line =~ /192.168.0.101/ && $line =~ /10.0.1.1/ 
 && $line !~/192.168.0.100/ &&$line =~ /\[SYN\]/ ) 
{ 
#count number of SYN                                
 $count_flag_syn ++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 & $line =~ /\[SYN,\ ACK\]/ ) 
{                                 
#count number of SYN-ACK
 $count_flag_syn_ack++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[RST\]/ ) 
{                         
#count number of RST        
 $count_flag_rst++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[FIN,\ ACK\]/ ) 
{                                 
 $count_flag_fin_ack++;
 }
$i++;
}	
print("HTTP Request = $count_flag \n");
print("TCP flag(SYN) bit is= $count_flag_syn \n");
print("TCP flag bit(SYN, ACK) is= $count_flag_syn_ack \n");
print("TCP flag bit(RST) is=  $count_flag_rst \n");
print("TCP flag bit(FIN, ACK) is=  $count_flag_fin_ack \n");
push(@base_array, $count_flag,$count_flag_syn, 
$count_flag_syn_ack, $count_flag_rst, $count_flag_fin_ack);
  $check_start = 1;					
} 				
}		
#Count for page 3 TCP flag bits and GET
if($page_id == 3)
{
my $count_flag=0;
my $count_flag_syn=0;
my $count_flag_syn_ack=0;
my $count_flag_rst=0;
my $count_flag_fin_ack=0;
#start of the page
if($line =~ /GET \/product_details.php/ and $check_start == 0){	
$i = $line_no;	
#end of the page 3			
while($lines[$i] !~ /GET \/images\/favicon3.ico/)
{
$line = $lines[$i];
if($line =~ /GET/ ){
#number of GET                      
 $count_flag ++;
}
 if($line =~ /192.168.0.101/ && $line =~ /10.0.1.1/ 
 && $line !~/192.168.0.100/ &&$line =~ /\[SYN\]/ ) 
{ 
#count number of SYN                                
 $count_flag_syn ++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[SYN,\ ACK\]/ ) 
{                                 
#count number of SYN-ACK
 $count_flag_syn_ack++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[RST\]/ ) 
{ 
#count number of RST                                
 $count_flag_rst++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[FIN,\ ACK\]/ ) 
{                                 
#count number of FIN-ACK
 $count_flag_fin_ack++;
 }
$i++;
}	
print("HTTP Request = $count_flag \n");
print("TCP flag(SYN) bit is= $count_flag_syn \n");
print("TCP flag bit(SYN, ACK) is= $count_flag_syn_ack \n");
print("TCP flag bit(RST) is=  $count_flag_rst \n");
print("TCP flag bit(FIN, ACK) is=  $count_flag_fin_ack \n");
push(@base_array,$count_flag, $count_flag_syn, $count_flag_syn_ack, 
$count_flag_rst,$count_flag_fin_ack);
	 $check_start = 1;					
	} 
	}
# Count TCP flag bits and GET request in page 4
if($page_id == 4)
{
my $count_flag=0;
my $count_flag_syn=0;
my $count_flag_syn_ack=0;
my $count_flag_rst=0;
my $count_flag_fin_ack=0;
if( $line =~ /GET \/checkout.php/ and $check_start == 0){
  $i = $line_no;				
while($lines[$i] !~ /GET \/images\/favicon4.ico/)
{
$line = $lines[$i];
if($line =~ /GET/ ){                           
#count number of GET request
 $count_flag ++;
 }
 if($line =~ /192.168.0.101/ && $line =~ /10.0.1.1/ 
 && $line !~/192.168.0.100/ &&$line =~ /\[SYN\]/ ) 
{                                 
#count number of SYN  
$count_flag_syn ++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[SYN,\ ACK\]/ ) 
{                                 
#count number of SYN-ACK
$count_flag_syn_ack++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[RST\]/ ) 
{                                 
#count number of RST
 $count_flag_rst++;
}
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[FIN,\ ACK\]/ ) 
{                                 
#count number of FIN-ACK 
$count_flag_fin_ack++;
 }
$i++;
}	
print("HTTP Request = $count_flag \n");
print("TCP flag(SYN) bit is= $count_flag_syn \n");
print("TCP flag bit(SYN, ACK) is= $count_flag_syn_ack \n");
print("TCP flag bit(RST) is=  $count_flag_rst \n");
print("TCP flag bit(FIN, ACK) is=  $count_flag_fin_ack \n");
push(@base_array, $count_flag, $count_flag_syn, 
$count_flag_syn_ack, $count_flag_rst, $count_flag_fin_ack);
$check_start = 1;
} 
}		
# Count TCP flag bits and GET request in page 5
if($page_id == 5)
{
my $count_flag=0;
my $count_flag_syn=0;
my $count_flag_syn_ack=0;
my $count_flag_rst=0;
my $count_flag_fin_ack=0;
if($line =~ /GET \/thank_you.php/ and $check_start == 0){
$i = $line_no;				
while($lines[$i] !~ /GET \/images\/favicon5.ico/)
{
$line = $lines[$i];
if($line =~ /GET/ ){
$count_flag ++;
}
 if($line =~ /192.168.0.101/ && $line =~ /10.0.1.1/ 
 && $line !~/192.168.0.100/ &&$line =~ /\[SYN\]/ ) 
{   
#count number of GET                              
 $count_flag_syn ++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[SYN,\ ACK\]/ ) 
{                                 
#count number of SYN-ACK
 $count_flag_syn_ack++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[RST\]/ ) 
{                                 
#count number of RST
 $count_flag_rst++;
 }
 if($line =~ /10.0.1.1/ && $line =~ /192.168.0.101/ 
 && $line =~ /\[FIN,\ ACK\]/ ) 
{                   
#count number of FIN-ACK              
 $count_flag_fin_ack++;
 }
$i++;
}	
print("HTTP Request = $count_flag \n");
print("TCP flag(SYN) bit is= $count_flag_syn \n");
print("TCP flag bit(SYN, ACK) is= $count_flag_syn_ack \n");
print("TCP flag bit(RST) is=  $count_flag_rst \n");
print("TCP flag bit(FIN, ACK) is=  $count_flag_fin_ack \n");
push(@base_array, $count_flag, $count_flag_syn, 
$count_flag_syn_ack, $count_flag_rst, $count_flag_fin_ack);
$check_start = 1;
} 						
}
}
return @base_array;
}
sub getTimeStamp{
my $line = $_[0];
my $timestamp = substr($line,8,12);
return trim($timestamp);
}
sub get_page_load_time
{	
my $trace_file = $_[0];
	print "Scanning ".$trace_file."....\n\n";
	open($FILE, "<$trace_file_dir$trace_file") 
	|| die "Can't open $trace_file:$!";
	while ($line = <$FILE>){
		push(@lines,$line);
	}
	close $FILE or die "$!";
  	my $sess_id;
	my $page_id;
	my $start_sess;
	my $end_sess;
        my $count = 0;
     #Three web session
	for($sess_id = 1; $sess_id <= 3;$sess_id++)
      {
	 if($sess_id == 1)
       {
	 foreach $line (@lines)
         {
	  if($line =~ /www.webqoe1.com/) 
        #session 1
          {
           $start_sess = $count;
       	  }
	  if($line =~ /www.webqoe2.com/)
         #session 2 
         {
	  $end_sess = $count - 1;
	  last;
	  }
	  $count++;
	 }
      	write_to_csv1($sess_id,$start_sess,$end_sess,$trace_file);
      } 
$count = 0;
 if($sess_id == 2)
       {
	 foreach $line (@lines)
         {
	  if($line =~ /www.webqoe2.com/)
          {
           $start_sess = $count;
          }
	  if($line =~ /www.webqoe3.com/)
        #session 1
        {
	  $end_sess = $count - 1;
	  last;
	  }
	  $count++;
	 }
write_to_csv2($sess_id,$start_sess,$end_sess,$trace_file);
     } 
 $count = 0;
 if($sess_id == 3)
       {
	 foreach $line (@lines)
         {
        # session 3
	  if($line =~ /www.webqoe3.com/)
          {
           $start_sess = $count;
	   $end_sess = $#lines;
	   last;
          }
	  $count++;
	 }
	write_to_csv3($sess_id,$start_sess,$end_sess,$trace_file);
	      } 
    }
}
# Write session 1 TCP flags bits into csv1
sub write_to_csv1
{
  my $sess_id = $_[0];
  my $start_sess = $_[1];
  my $end_sess = $_[2];
  my @user_id = split('\.',$_[3]);
  my @network_params = ();
  open($CSV1,">>$csv_file_dir/sess1.csv") || die "Can't open CSV :$!";
    for($page_id=1; $page_id<=5; $page_id++)
     {
	push(@network_params,get_network_params_values($page_id,$start_sess,$end_sess));
     }
	if(@network_params)
       { 
		$get1 = $network_params[0]; 
		$syn1 = $network_params[1];
		$syn_ack1 = $network_params[2];
		$rst1 = $network_params[3];
		$fin_ack1 = $network_params[4];
		$get2 = $network_params[5]; 
		$syn2 = $network_params[6];
		$syn_ack2 = $network_params[7];
		$rst2 = $network_params[8];
		$fin_ack2 = $network_params[9];
		$get3 = $network_params[10]; 
		$syn3 = $network_params[11];
		$syn_ack3 = $network_params[12];
		$rst3 = $network_params[13];
		$fin_ack3 = $network_params[14];
		$get4 = $network_params[15]; 
		$syn4 = $network_params[16];
		$syn_ack4 = $network_params[17];
		$rst4 = $network_params[18];
		$fin_ack4 = $network_params[19];
		$get5 = $network_params[20]; 
		$syn5 = $network_params[21];
		$syn_ack5 = $network_params[22];
		$rst5 = $network_params[23];
		$fin_ack5 = $network_params[24];
		print ($CSV1 $user_id[0].", $get1, $syn1, $syn_ack1, 
		$rst1, $fin_ack1, ,$get2, $syn2, $syn_ack2, $rst2, $fin_ack2, , 
		$get3, $syn3, $syn_ack3, $rst3, $fin_ack3, ,$get4, $syn4, 
		$syn_ack4, $rst4, $fin_ack4, , $get5, $syn5, $syn_ack5, 
		$rst5, $fin_ack5 "."\n");
	}
close $CSV1 or die "$!";
}
# Write session 2 TCP flags bits into csv2
sub write_to_csv2
{
  my $sess_id = $_[0];
  my $start_sess = $_[1];
  my $end_sess = $_[2];
  my @user_id = split('\.',$_[3]);
  my @network_params = ();
  open($CSV2,">>$csv_file_dir/sess2.csv") || die "Can't open CSV :$!";
  for($page_id=1; $page_id<=5; $page_id++)
     {
	push(@network_params,get_network_params_values
	($page_id,$start_sess,$end_sess));
     }
	if(@network_params)
       {
		$get1 = $network_params[0]; 
		$syn1 = $network_params[1];
		$syn_ack1 = $network_params[2];
		$rst1 = $network_params[3];
		$fin_ack1 = $network_params[4];
		$get2 = $network_params[5]; 
		$syn2 = $network_params[6];
		$syn_ack2 = $network_params[7];
		$rst2 = $network_params[8];
		$fin_ack2 = $network_params[9];
		$get3 = $network_params[10]; 
		$syn3 = $network_params[11];
		$syn_ack3 = $network_params[12];
		$rst3 = $network_params[13];
		$fin_ack3 = $network_params[14];
		$get4 = $network_params[15]; 
		$syn4 = $network_params[16];
		$syn_ack4 = $network_params[17];
		$rst4 = $network_params[18];
		$fin_ack4 = $network_params[19];
		$get5 = $network_params[20]; 
		$syn5 = $network_params[21];
		$syn_ack5 = $network_params[22];
		$rst5 = $network_params[23];
		$fin_ack5 = $network_params[24];
		print ($CSV2 $user_id[0].", $get1, $syn1, $syn_ack1, $rst1, 
		$fin_ack1, ,$get2, $syn2, $syn_ack2, $rst2, $fin_ack2, , 
		$get3, $syn3, $syn_ack3, $rst3, $fin_ack3, ,$get4, $syn4, 
		$syn_ack4, $rst4, $fin_ack4, , $get5, $syn5, $syn_ack5, 
		$rst5, $fin_ack5 "."\n");
	}
  close $CSV2 or die "$!";
}
 # Write session 3 TCP flags bits into csv3
sub write_to_csv3
{
  my $sess_id = $_[0];
  my $start_sess = $_[1];
  my $end_sess = $_[2];
  my @user_id = split('\.',$_[3]);
  my @network_params = ();
  open($CSV3,">>$csv_file_dir/sess3.csv") || die "Can't open CSV :$!";
  for($page_id=1; $page_id<=5; $page_id++)
     {
	push(@network_params,get_network_params_values($page_id,
	$start_sess,$end_sess));
     }		if(@network_params)
          {		
$get1 = $network_params[0]; 
		$syn1 = $network_params[1];
		$syn_ack1 = $network_params[2];
		$rst1 = $network_params[3];
		$fin_ack1 = $network_params[4];
		$get2 = $network_params[5]; 
		$syn2 = $network_params[6];
		$syn_ack2 = $network_params[7];
		$rst2 = $network_params[8];
		$fin_ack2 = $network_params[9];
		$get3 = $network_params[10]; 
		$syn3 = $network_params[11];
		$syn_ack3 = $network_params[12];
		$rst3 = $network_params[13];
		$fin_ack3 = $network_params[14];
		$get4 = $network_params[15]; 
		$syn4 = $network_params[16];
		$syn_ack4 = $network_params[17];
		$rst4 = $network_params[18];
		$fin_ack4 = $network_params[19];
		$get5 = $network_params[20]; 
		$syn5 = $network_params[21];
		$syn_ack5 = $network_params[22];
		$rst5 = $network_params[23];
		$fin_ack5 = $network_params[24];
		print ($CSV3 $user_id[0].", $get1, $syn1, $syn_ack1, 
		$rst1, $fin_ack1, ,$get2, $syn2, $syn_ack2, $rst2,
		$fin_ack2, , $get3, $syn3, $syn_ack3, $rst3, $fin_ack3, 
		,$get4, $syn4, $syn_ack4, $rst4, $fin_ack4, , $get5, 
		$syn5, $syn_ack5, $rst5, $fin_ack5 "."\n");
	}
  close $CSV3 or die "$!";
}

