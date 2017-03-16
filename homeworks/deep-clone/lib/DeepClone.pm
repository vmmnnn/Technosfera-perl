package DeepClone;

use 5.010;
use strict;
use warnings;

my %seen;

=encoding UTF8

=head1 SYNOPSIS

Клонирование сложных структур данных

=head1 clone($orig)

Функция принимает на вход ссылку на какую либо структуру данных и отдаюет, в качестве результата, ее точную независимую копию.
Это значит, что ни один элемент результирующей структуры, не может ссылаться на элементы исходной, но при этом она должна в точности повторять ее схему.

Входные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив и хеш, могут быть любые из указанных выше конструкций.
Любые отличные от указанных типы данных -- недопустимы. В этом случае результатом клонирования должен быть undef.

Выходные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив или хеш, не могут быть ссылки на массивы и хеши исходной структуры данных.

=cut

sub clone {
   my $orig = shift;
   my $cloned;
   my $ref_type = ref $orig;
   my $error_fl = 0;
   # ...
   if ($ref_type) {
      if (exists $seen{$orig}) {
         $cloned = $seen{$orig};
      } elsif ($ref_type eq 'ARRAY') {
         my @mass;
         my $i = 0;
         my @orig_mass = @{$orig};
         $seen{$orig} = \@mass;
         for my $elem (@orig_mass) {
            my $ref_elem_type = ref $elem;
            my $answ;
            if ($ref_elem_type) {
               if ($ref_elem_type eq 'ARRAY') {
                  if ($elem == $orig) {
                     $mass[$i] = \@mass;
                  } else {
                     $answ = clone($elem);
                     if (defined $answ) {
                        $mass[$i] = $answ;
                     } else {
                        $error_fl = 1;
                     }
                  }
               } elsif ($ref_elem_type eq 'HASH') { 
                  $answ = clone($elem);
                  if (defined $answ) {
                     $mass[$i] = $answ;
                  } else {
                     $error_fl = 1;
                  }
               } else {
                  $mass[$i] = undef;
                  $error_fl = 1;
               }
            } else {
               $mass[$i] = $elem;
            }
            $i++;
         }
         $cloned = \@mass;
         $seen{$orig} = $cloned;
      } elsif ($ref_type eq 'HASH') {
         my %hash;
         my %orig_hash = %{$orig};
         my $answ;
         $seen{$orig} = \%hash;
         for my $key (keys %orig_hash) {
            my $val = $orig_hash{$key};
            my $ref_val_type = ref $val;
            if ($ref_val_type) {
               if ($ref_val_type eq 'HASH') {
                  if ($val == $orig) {
                     $hash{$key} = $val;
                  } else {
                     $answ = clone($val);
                     if (defined $answ) {
                        $hash{$key} = $answ;
                     } else {
                        $error_fl = 1;
                     }
                  }
               } elsif ($ref_val_type eq 'ARRAY') {
                  $answ = clone($val);
                  if (defined $answ) {
                     $hash{$key} = $answ;
                  } else {
                     $error_fl = 1;
                  }
               } else {
                  $hash{$key} = undef;
                  $error_fl = 1;
               }
            } else {
               $hash{$key} = $val;
            }
         }
         $cloned = \%hash;
         $seen{$orig} = $cloned;
      } else {
         $cloned = undef;       
      }  
   } else {
      $cloned = $orig;
   }
   if ($error_fl == 1) {
      return undef;
   }
   # deep clone algorith here
   # ...
   return $cloned;
}

1;
