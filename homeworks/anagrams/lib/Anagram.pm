package Anagram;

use 5.010;
use strict;
use warnings;

=encoding UTF8

=head1 SYNOPSIS

Поиск анаграмм

=head1 anagram($arrayref)

Функцию поиска всех множеств анаграмм по словарю.

Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8

Выходные данные: Ссылка на хеш множеств анаграмм.

Ключ - первое встретившееся в словаре слово из множества
Зiначение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

Множества из одного элемента не должны попасть в результат.

Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например

anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])

должен вернуть ссылку на хеш


{
    'пятак'  => ['пятак', 'пятка', 'тяпка'],
    'листок' => ['листок', 'слиток', 'столик'],
}

=cut

sub cleaning_hash {    
   my $hash_ref = shift;
   my %hash = %{$hash_ref};
   for my $key (keys %hash) {   # delete keys with one value
      my $ref = $hash{$key};
      my @res_matr = @{$ref};
      if (@res_matr == 1) {
         delete $hash{$key};
      }
   }
   for my $key (keys %hash) {       # sort
      my @words = @{$hash{$key}};
      @words = sort @words;
      $hash{$key} = \@words;
   }
   return \%hash;
}


sub anagram {
   use utf8;
   use Encode qw(encode decode);
   my $words_list = shift;
   my %result;
   my @matr = @{$words_list};
   my $i = 0;
   my $j;
    #
    # Поиск анаграмм

   @matr = map {lc decode("utf-8", $_)} @matr;

   for my $word (@matr) {
      my $found_fl = 0;   
           # 0 - make new key, 1 - push as a value, 2 - don't do anything
      my $l_word = length($word);
      for my $key (keys %result) {
         my $amm_eq = 0;
         my $l_key = length(decode("utf-8", $key));
         if ($l_word == $l_key) {
            if ($word eq $key) {
               $found_fl = 2;
               last;
            }
            for $i (0..$l_word-1) {
               my $letter = substr($word, $i, 1);
               for $j (0..$l_key-1) {
                  if ($letter eq substr(decode("utf-8", $key), $j, 1)){
                     $amm_eq++;
                  }
               }
            }
         }
         if ($amm_eq == $l_word) {    # found list in hash
            my $ref = $result{$key};
            my @res_matr = @{$ref};
            my $fl = 0;
             #for my $k (0..@res_matr) { # ???
            my $k;
            for ($k = 0; $k < @res_matr; $k++) { # Is there the same value?
               if (decode("utf-8", $res_matr[$k]) eq $word) {
                  $fl = 1;
                  last;
               }
            }
            if ($fl == 0) {
               push(@{$ref}, encode("utf-8", $word));
            }
            $found_fl = 1;
            last;
         } 
      }
      if ($found_fl == 0) {             # new key
         $result{encode("utf-8", $word)} = [encode("utf-8", $word)];
      }
   }
   return cleaning_hash(\%result);
#   return \%result;
}

1;
