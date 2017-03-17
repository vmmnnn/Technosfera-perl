package SecretSanta;

use 5.010;
use strict;
use warnings;
use DDP;

sub calculate {{
   my @members = @_;
   my @res;
   
        # ...
   my @people;     # All members
   my %hash;       # Answer
   my %married;    # Married members
   my $amm_married = 0;
   my $i = 0;
   my $fl = 0;
   for my $elem (@members) {
      if (ref $elem) {    # Married people - put in %married
         $married{$elem->[0]} = $elem->[1];
         $married{$elem->[1]} = $elem->[0];
         push @people, $elem->[0];
         push @people, $elem->[1];
      } else {            # Single person
         push @people, $elem;
      } 
   }
   $amm_married = keys %married;

#   use Data::Dumper;
#   warn "\n     MEMBERS\n", Dumper \@members, "\n";
#   warn "     PEOPLE\n", Dumper \@people, "\n";
#   warn "     MARRIED\n", Dumper \%married, "\n\n";

   if (!(@people <= 2 || (@people == 3 && $amm_married == 2))) {
      for my $person (@people) {   
         $fl = 1;
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
            $fl = 0;
         }
         if (@santa_list == 0 || $fl == 1) {
            $fl = 1;
            last;
         }
         my $num = int(rand(@santa_list));
         $hash{$santa_list[$num]} = $person;
      }
      for my $person (@people) {
         if (! defined $hash{$person}) {
            $fl = 1;
            last;
         }
      }
      if ($fl == 1) {
         redo;
      }
      for my $person (@people) {
         push(@res, [$person, $hash{$person}]);
      }
   }
   #   push @res,[ "fromname", "toname" ];
   # ...
   return @res;
}}

1;
