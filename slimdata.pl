use strict;
use warnings;

my $prevdata = 0;
my @slimdata;

while(<>){
  my $line;
  $line = $_;
  chomp($line);

  if($line =~ /^\d+/){
    my @recdata = split(/,/,$line);
    foreach my $data(@recdata){
      $data =~ s/^\+//;
    }
    my $curr_data = $recdata[2] + $recdata[3] + $recdata[4] + $recdata[5] + $recdata[6] - 5*$recdata[7];
#    my $curr_data = $recdata[2];
    if(abs($curr_data - $prevdata) > 0.5){#前のデータと比較し0.5℃以内の差ならば追加
     
      my $pushdata="";
      foreach my $data (@recdata){
        $pushdata = $pushdata."$data,";
      }
      $pushdata =~ s/,$//;
      push(@slimdata,$pushdata);
      $prevdata = $curr_data;
    }

  }else{
    push(@slimdata,$line);
  }
}

foreach my $eline(@slimdata){
  print "$eline\n";
}
