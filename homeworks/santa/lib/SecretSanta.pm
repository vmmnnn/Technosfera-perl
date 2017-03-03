package SecretSanta;

use 5.010;
use strict;
use warnings;
use DDP;

sub calculate {
	my @members = @_;
	my @res;
	
	# ...
	my @people;     # All members
	my %hash;       # Answer
	my %married;    # Married members
	my $i = 0;
	my $cycle_fl = 1;
	for my $elem (@members) {
	   if (ref $elem) {    # Married people - put in %married
              $married{$elem->[0]} = $elem->[1];
              $married{$elem->[1]} = $elem->[0];
	      $people[$i] = $elem->[0];
	      $people[$i+1] = $elem->[1]; 
	      $i += 2;
	   } else {            # Single person
	      $people[$i] = $elem;
	      $i += 1;
	   } 
	}
#	use Data::Dumper;
#	say Dumper \@members;
#	say "         ALL PEOPLE";
#        say Dumper \@people;
#	say "         MARRIED PEOPLE";
#        say Dumper \%married;
	$i = 0;
	while ($cycle_fl == 1) {
   	   $cycle_fl = 0;
	   for my $person (@people) {   
	      my @santa_list;    # People, who can give a present to this person
              for my $santa (@people) {
	                     # Person can't give presents to himself
	         next if ($santa eq $person);
	                     # Santa is already a santa for somebody
	         next if (exists($hash{$santa}));
	                     # Santa can't give a present to his santa
	         next if (exists($hash{$person}) && $hash{$person} eq $santa);
	                     # Santa can't give a present to his wife/husband
	         next if (exists($married{$santa}) && 
		                        $married{$santa} eq $person);
	         push (@santa_list, $santa);
	      }
	      if (@santa_list == 0) {    # No variants => redo
	         $cycle_fl = 1;
		 last;
	      }
	      my $num = int(rand(@santa_list));
	      $hash{$santa_list[$num]} = $person;
           }
	}
        for my $person (@people) {
           push(@res, [$person, $hash{$person}]);
	}
#	say "           A N S W E R";
#        say Dumper \%hash;
	#	push @res,[ "fromname", "toname" ];
	# ...
	return @res;
}

1;
