use strict;
use warnings;

#--------setting--------
my $ta = -1; #Taの場所を指定 ch3ならば、ta=3; -1ならば最後のch
my $diff = 0.5;
#-----------------------

my $prevdata = 0;
my @slimdata;
my $ch_count = 0;

while(<>){
  my $line;
  $line = $_;
  chomp($line);

  if($line =~ /^\d+/){
    my @recdata = split(/,/,$line);
    my $count = 0;
    
    foreach my $data(@recdata){
        $data =~ s/^\+//;
    }
    my $ch_number = 2;
    my $curr_data = 0;
    while($ch_number < $ch_count+2){
        $curr_data += $recdata[$ch_number];
        $ch_number++;
    }
    if($ta == -1){
       $curr_data -= $recdata[$ch_count+1]*$ch_count;
    }else{
        $curr_data -= $recdata[$ta+1]*$ch_count;
    }

    if(abs($curr_data - $prevdata) > $diff){#前のデータと比較し0.5℃(default)以内の差ならば追加
    my $pushdata="";
    $ch_number = 0;
    while($ch_number < $ch_count+2){#Alarmなどのデータは不要なため削除
        $pushdata = $pushdata."$recdata[$ch_number], ";
        $ch_number++;
    }
        
      $pushdata =~ s/, $//;#末尾のカンマを削除
      push(@slimdata,$pushdata);
      $prevdata = $curr_data;
    }
  }elsif($line =~ /^CH\d+/){#温度データのch数をカウント
	$ch_count++;
	push(@slimdata,$line);
  }else{#温度データ以外をそのまま追記
    push(@slimdata,$line);
  }
}

foreach my $eline(@slimdata){
  print "$eline\n";
}
