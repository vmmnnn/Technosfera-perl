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
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

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

sub anagram {
    use utf8;
    use Encode qw(encode decode);
    my $words_list = shift;
    my %result;
    my @mass = @{$words_list};
    my $i = 0;
    my $j;
    #
    # Поиск анаграмм
    for my $word (@mass) {
        $word = decode("utf-8", $word);
        $mass[$i] = lc($word);
	$i++;
    }
    for my $word (@mass) {
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
		my @res_mass = @{$ref};
	        my $fl = 0;
		#for my $k (0..@res_mass) { # ???
                my $k;
		for ($k = 0; $k < @res_mass; $k++) { # Is there the same value?
		    if (decode("utf-8", $res_mass[$k]) eq $word) {
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
    for my $key (keys %result) {   # delete keys with one value
	my $ref = $result{$key};
	my @res_mass = @{$ref};
	if (@res_mass == 1) {
	    delete $result{$key};
	}
    }
    return \%result;
}

1;
