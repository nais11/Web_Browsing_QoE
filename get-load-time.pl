
# Write a program that reads the 'txt' file with network traffic data generated from experiment.

#!/usr/bin/perl -w
use LWP::Simple;
use Getopt::Long;
use String::Util 'trim';
my  $trace_file_dir;
my $csv_file_dir;
GetOptions("s=s" =>\$trace_file_dir, 
	   "d=s" =>\$csv_file_dir,
) or die "Wrong arugment, use -s <source dir> -d <destination dir> \n";
die "Missing -source file directory!" unless $trace_file_dir;

opendir(SRC_DIR,$trace_file_dir) or die $!;

# file opening and write all value into csv file.

open($CSV1,">$csv_file_dir/sess1.csv") || die "Can't open CSV :$!";
print ($CSV1 " ,Page1,Page2,Page3,Page4,Page5"."\n");
close $CSV1 or die "$!";
open($CSV2,">$csv_file_dir/sess2.csv") || die "Can't open CSV :$!";
print ($CSV2 " ,Page1,Page2,Page3,Page4,Page5"."\n");
close $CSV2 or die "$!";
open($CSV3,">$csv_file_dir/sess3.csv") || die "Can't open CSV :$!";
print ($CSV3 " ,Page1,Page2,Page3,Page4,Page5"."\n"); 
close $CSV3 or die "$!";
my @lines = ();
while(my $trace_file = readdir(SRC_DIR)){
	@lines = ();
	get_page_load_time($trace_file);
}
closedir(SRC_DIR);
sub get_pcap_time_per_page{
my $page_id = $_[0];
my $start_sess = $_[1];
my $end_sess = $_[2];
my $line_no;
my $count = $start_sess;
my $check_start = 0;
my $check_end = 0;
my $check_last = $start_sess;
my @base_array = ();
for ($line_no = $start_sess; $line_no <= $end_sess; $line_no++){
$line = $lines[$line_no];
if($line =~ /192.168.0.101/)
	{
		if( $line =~ /10.0.1.1/){
			if($page_id == 1)
{


# starting time stamp for page 1

if($line =~ /GET \/ HTTP/ and $check_start == 0){			push(@base_array,getTimeStamp($line));
	$check_start = 1;					
} 

# ending time stamp for page 1

if ($line =~ /GET \/images\/favicon1.ico/ and $check_end == 0){	
for($i = $line_no ; $i >=$check_last; $i--){
if ($lines[$i] =~ /HTTP\/1.1 200 OK/)
        {						
	push(@base_array,getTimeStamp($lines[$i]));
	$check_end = 1;
	$check_last = $line_no;
	last;
            }
	}
	}

# starting time stamp for page 2

	if($page_id == 2){
	if($line =~ /GET \/category_home.php/ and $check_start == 0){	
         push(@base_array,getTimeStamp($line));
	$check_start = 1;					
          } 
# ending time stamp for page 2

	if ($line =~ /GET \/images\/favicon2.ico/ and $check_end == 0){	
          for($i = $line_no ; $i >=$check_last; $i--)
          {
	if ($lines[$i] =~ /HTTP\/1.1 200 OK/)
	{						
	 push(@base_array,getTimeStamp($lines[$i]));
	 $check_end = 1;
	 $check_last = $line_no;
	 last;
                    	}  
	    	}
		}
	 }
# starting time stamp for page 3
	
if($page_id == 3){
		if($line =~ /GET \/product_details.php/ and $check_start == 0){		push(@base_array,getTimeStamp($line));
		$check_start = 1;					
} 
# ending time stamp for page 3

	if ( $line =~ /GET \/images\/favicon3.ico/ and $check_end == 0){		for($i = $line_no ; $i >=$check_last; $i--){
		if ($lines[$i] =~ /HTTP\/1.1 200 OK/)
		  {			
push(@base_array,getTimeStamp($lines[$i]));
		$check_end = 1;
		$check_last = $line_no;
		last;
                        }  
		}						
}
		}
# starting time stamp for page 4		
if($page_id == 4){
		if( $line =~ /GET \/checkout.php/ and $check_start == 0){			push(@base_array,getTimeStamp($line));
		$check_start = 1;
		} 
# ending time stamp for page 4		
if ($line =~ /GET \/images\/favicon4.ico/ and $check_end == 0){		for($i = $line_no ; $i >=$check_last; $i--){
		if ($lines[$i] =~ /HTTP\/1.1 200 OK/) 
		{				
							 push(@base_array,getTimeStamp($lines[$i]));
	 $check_end = 1;
	 $check_last = $line_no;
	  last;
            }  
}
}
}
# starting time stamp for page 5 
if($page_id == 5){
if($line =~ /GET \/thank_you.php/ and $check_start == 0){			push(@base_array,getTimeStamp($line));
		$check_start = 1;
		} 
		if ($line =~ /GET \/images\/favicon5.ico/ and $check_end == 0){
                        for($i = $line_no ; $i >=$check_last; $i--){
# ending time stamp for page 5 
if ($lines[$i] =~ /HTTP\/1.1 200 OK/)
		 {						push(@base_array,getTimeStamp($lines[$i]));
		$check_end = 1;
		$check_last = $line_no;
		last;
                          }  
		}
		}
		}
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
	open($FILE, "<$trace_file_dir$trace_file") || die "Can't open $trace_file:$!";
	while ($line = <$FILE>){
		push(@lines,$line);
	}
	close $FILE or die "$!";
  	my $sess_id;
	my $page_id;
	my $start_sess;
	my $end_sess;
    my $count = 0;

# three web session 

	for($sess_id = 1; $sess_id <= 3;$sess_id++)
      {
# 1st web session 

	 if($sess_id == 1)
       {
	 foreach $line (@lines)
         {
	  if($line =~ /www.webqoe1.com/)
          {
           $start_sess = $count;
       	  }
	  if($line =~ /www.webqoe2.com/)
          {
	  $end_sess = $count - 1;
	  last;
	  }
	  $count++;
	 }
      	write_to_csv1($sess_id,$start_sess,$end_sess,$trace_file);
      } 
$count = 0;

#2nd web session

 if($sess_id == 2)
       {
	 foreach $line (@lines)
         {
	  if($line =~ /www.webqoe2.com/)
          {
           $start_sess = $count;
          }
	  if($line =~ /www.webqoe3.com/)
          {
	  $end_sess = $count - 1;
	  last;
	  }
	  $count++;
	 }
	write_to_csv2($sess_id,$start_sess,$end_sess,$trace_file);
	
      } 
 $count = 0;
#3rd web session 
 if($sess_id == 3)
       {
	 foreach $line (@lines)
         {
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
sub write_to_csv1
{
  my $sess_id = $_[0];
  my $start_sess = $_[1];
  my $end_sess = $_[2];
  my @user_id = split('\.',$_[3]);
  my @time_stamps = ();

#  write session 1 page load time into csv1 file  

  open($CSV1,">>$csv_file_dir/sess1.csv") || die "Can't open CSV :$!";
    for($page_id=1; $page_id<=5; $page_id++)
     {
	push(@time_stamps,get_pcap_time_per_page($page_id,$start_sess,$end_sess));
     }
	if(@time_stamps)
       {
		$load_time_page1 = $time_stamps[1] - $time_stamps[0];
		$load_time_page2 = $time_stamps[3] - $time_stamps[2];
		$load_time_page3 = $time_stamps[5] - $time_stamps[4];
		$load_time_page4 = $time_stamps[7] - $time_stamps[6];
		$load_time_page5 = $time_stamps[9] - $time_stamps[8];
		print ($CSV1 $user_id[0].", $load_time_page1, $load_time_page2, 
		$load_time_page3, $load_time_page4, $load_time_page5 "."\n");
	}
close $CSV1 or die "$!";
}
sub write_to_csv2
{
  my $sess_id = $_[0];
  my $start_sess = $_[1];
  my $end_sess = $_[2];
  my @user_id = split('\.',$_[3]);
  my @time_stamps = ();

#write session 2 page load time into csv2 file  

  open($CSV2,">>$csv_file_dir/sess2.csv") || die "Can't open CSV :$!";
  for($page_id=1; $page_id<=5; $page_id++)
     {
	push(@time_stamps,get_pcap_time_per_page($page_id,$start_sess,$end_sess));
     }
	if(@time_stamps)
       {
		$load_time_page1 = $time_stamps[1] - $time_stamps[0];
		$load_time_page2 = $time_stamps[3] - $time_stamps[2];
		$load_time_page3 = $time_stamps[5] - $time_stamps[4];
		$load_time_page4 = $time_stamps[7] - $time_stamps[6];
		$load_time_page5 = $time_stamps[9] - $time_stamps[8];
		print ($CSV2 $user_id[0].", $load_time_page1 
		,$load_time_page2 ,$load_time_page3,$load_time_page4 
		,$load_time_page5 "."\n");
	}
  close $CSV2 or die "$!";
}
sub write_to_csv3
{
  my $sess_id = $_[0];
  my $start_sess = $_[1];
  my $end_sess = $_[2];
  my @user_id = split('\.',$_[3]);
  my @time_stamps = ();

#write session 3 page load time into csv3 file  

 open($CSV3,">>$csv_file_dir/sess3.csv") || die "Can't open CSV :$!";
  for($page_id=1; $page_id<=5; $page_id++)
     {
	push(@time_stamps,get_pcap_time_per_page($page_id,$start_sess,$end_sess));
     }
	if(@time_stamps)
       {
		$load_time_page1 = $time_stamps[1] - $time_stamps[0];
		$load_time_page2 = $time_stamps[3] - $time_stamps[2];
		$load_time_page3 = $time_stamps[5] - $time_stamps[4];
		$load_time_page4 = $time_stamps[7] - $time_stamps[6];
		$load_time_page5 = $time_stamps[9] - $time_stamps[8];
		print ($CSV3 $user_id[0].", $load_time_page1 ,
		$load_time_page2 ,$load_time_page3,$load_time_page4 ,
		$load_time_page5 "."\n");
	}

  close $CSV3 or die "$!";
}

