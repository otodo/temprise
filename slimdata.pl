use strict;
use warnings;

#--------setting--------
our $ta = -1; #Taの場所を指定 ch3ならば、ta=3; -1ならば最後のch, 0ならばTaなし
our $diff = 0.5; #Ch1 - Chn までの合計温度差
# my $ind_diff = 0.5; #個々の温度差
our $convert = 40; #温度換算, 0ならば温度換算を行わない
#-----------------------

our $prevdata = 0;
our @slimdata;
my $ch_count = 0;

my $err_message = "Error!!\nta is 0 but convert is not 0";
die "$err_message" if(($ta == 0) and ($convert != 0));

while(<>){
  my $line;
  $line = $_;
  chomp($line);

  if($line =~ /^CH\d+/){#温度データのch数をカウント
    $ch_count++;
	push(@slimdata,$line);
  }elsif($line =~ /^\d+/){
    my @recdata = split(/,/,$line);
    my $count = 0;

    #TaのCHを決定
    $ta = $ch_count if($ta == -1);

    foreach my $data(@recdata){
        $data =~ s/^\+//;
    }

    
    if($convert == 0){#生データでの処理
      &add_data(\@recdata);
    }else{#convert値でTaを換算
      my $roomtemp = $recdata[$ta+1];
      my $col = 2;
      while($col <= $ch_count+1){
        $recdata[$col] = $recdata[$col] + $convert - $roomtemp;
        $col++;
      }
      &add_data(\@recdata);
    }
  }else{#温度データ以外をそのまま追記
    push(@slimdata,$line);
  }
}

foreach my $eline(@slimdata){
  print "$eline\n";
}

sub total_temp{
  my $recdata = shift;
  my $ch_number = 2;
  my $curr_data = 0;
  while($ch_number < $ch_count+2){#Alarm 列を計算対象から外す
      $curr_data += $$recdata[$ch_number];
      $ch_number++;
  }
  if($ta == 0){
    $curr_data = $curr_data;
  }else{
      $curr_data -= $$recdata[$ta+1]*$ch_count;
  }
return($curr_data);
}

sub add_data{
  my $recdata = shift;
  my $curr_data = &total_temp($recdata);
  if(abs($curr_data - $prevdata) >= $diff){#前のデータと比較しdiff以内の差ならば追加
    my $pushdata="";
    my $ch_number = 0;
    while($ch_number < $ch_count+2){#Alarmなどのデータは不要なため削除
      $pushdata = $pushdata."$$recdata[$ch_number], ";
      $ch_number++;
    }
    $pushdata =~ s/, $//;#末尾のカンマを削除
    push(@slimdata,$pushdata);
    $prevdata = $curr_data;
  }
  # print "$curr_data\n";
}