package UR::Store::AbilityMap;

use strict;
use warnings;
use utf8;

use lib 'lib';
use Utils;

my @_PREFIX = (
	{ 
		desc => 'Отвага',
		value => ['Отвага', 'Кураж']
	},
	{ 
		desc => 'Отдача',
		value => 'Отдача'
	},
	{ 
		desc => 'Поддержка',
		value => 'Поддержка'
	},
	{ 
		desc => 'При поражении',
		value => ['При поражении', 'Поражение']
	},
	{ 
		desc => 'Команда',
		value => 'Команда'
	},
	{ 
		desc => 'Контрудар',
		value => 'Контрудар'
	},
	{ 
		desc => 'Месть',
		value => 'Месть'
	},
	{ 
		desc => 'Доверие',
		value => 'Доверие'
	},
	{ 
		desc => 'Блок',
		value => 'Блок'
	}
);

my @_RULES = (
	{
		desc => '+X Pillz',
		regex => '\+\s*(\d+) Pillz'
	},
	{
		desc => '+X Pillz в раунде',
		regex => '\+(\d+) Pillz в раунде'
	},
	{	
		desc => '+X Pillz за Урон',
		regex => '\+(\d+) Pillz за Урон'
	},
	{
		desc => '+X Атаки за оставшиеся Pillz',
		regex => '\+(\d+) Атаки за оставшиеся Pillz',
	},
	{
		desc => '+X Атаки за оставшиеся Жизни',
		regex => '\+(\d+) Атаки за оставшиеся Жизни',
	},
	{
		desc => '+X Жизней за Урон',
		regex => '\+(\d+) Жизн\w+ за Урон',
	},
	{
		desc => '+X Жизни за раунд',
		regex => '\+(\d+) Жизни за раунд',
	},
	{
		desc => '+X Pillz',
		regex => '\+(\d+) Pillz',
	},
	{
		desc => '+X Жизни',
		regex => '\+(\d+) Жизн\w+',
	},
	{
		desc =>'-X Pillz до мин. Y',
		regex =>'-\s*(\d+) Pillz\D+(\d+)\D*',
	},
	{
		desc => '-X Pillz за раунд до мин. Y',
		regex => '-(\d+) Pillz за раунд до мин. (\d+)',
	},
	{
		desc => '-X Жизни до мин. Y', 
		regex => '-\s*(\d+) Жизн\D+(\d+)\D*', 
	},
	{
		desc => 'Атака +X',
		regex => [
			'Атака \+(\d+)',
			'\+(\d+) Атака'
		]
	},
	{
		desc => 'Атака -X до мин. Y',
		regex => 'Атака -(\d+) до мин. (\d+)',
	},
	{
		desc => 'Зашита: Сила',
		regex => 'Зашита: Сила'
	},
	{
		desc => 'Защита Бонуса',
		regex => 'Защита Бонуса'
	},
	{
		desc => 'Защита: Сила и Урон',
		regex => 'Защита: Сила и Урон'
	},
	{
		desc => 'Защита: Урон',
		regex => 'Защита: Урон'
	},
	{
		desc => 'Опыт +X%',
		regex => 'Опыт \+(\d+)%',
		ignore => 1
	},
	{
		desc => 'Отвага (Сила +X)',
		regex => 'Отвага \(Сила \+(\d+)\)',
		ignore => 1
	},
	{
		desc => 'Контратака',
		regex => 'Контратака',
		ignore => 1
	},
	{
		desc => 'Копия: Бонус противн.',
		regex => [
			'Копия: Бонус противн.',
			'Копия Бонус противн.'
		]
	},
	{
		desc => 'Копия: Сила и Урон противника',
		regex => 'Копия: Сила и Урон противника'
	},
	{
		desc => 'Лечение X до Max в Y',
		regex => 'Лечение (\d+) до Max в (\d+)',
	},
	{
		desc => 'Блок Бонуса',
		regex => 'Блок Бонуса\s*(?:противн\S+)?' 
	},
	{
		desc => 'Блок Умения',
		regex => 'Блок Умения\s*(?:проти\S+)?'
	},
	{
		desc => 'Защита Сила и Урон',
		regex => 'Защита Сила и Урон'
	},
	{
		desc => 'Нет умений',
		regex => 'Нет умений'
	},
	{
		desc => 'Защита Бонуса',
		regex => 'Защита Бонуса'
	},
	{
		desc => 'Восст. X Pillz из Y',
		regex => 'восст. (\d+) Pillz из (\d+)'
	},
	{
		desc => 'Сила +X',
		regex => [
			'Сила\s+\+\s*(\d+)',
			'\+(\d+) Сила'
		]
	},
	{
		# Сила -1 до мин. 1
		# -3 Силы прот., до Min 1
		desc => 'Сила -X до мин. Y',
		regex => [
			'Сила -(\d+) до мин. (\d+)',
			'-(\d+) Силы прот., до Min (\d+)'
		]
	},
	{
		desc => 'Сила = Силе противника',
		regex => 'Сила = Силе противника',
	},
	{
		desc => 'Сила и Урон + X',
		regex => 'Сила и Урон \+ (\d+)',
	},
	{
		desc => 'Сила и Урон -X до мин. Y',
		regex => 'Сила и Урон -(\d+) до мин. (\d+)',
	},
	{
		desc => 'Урон +X',
		regex => [
			'Урон \+(\d+)',
			'\+(\d+) Урона'
		]
	},
	{
		desc => 'Урон -X до мин. Y',
		regex => [
			'Урон -(\d+) до\D+(\d+)',
			'-(\d+) Урона? до\D+(\d+)',
		]
	},
	{
		desc => 'Урон = Урону противника',
		regex => 'Урон = Урону противника',
	},
	{
		# Яд -1 до мин. 0
		# При поражении: Яд 1, при 4 мин.                                |
		desc => 'Яд X до мин. Y',
		regex => 'Яд -?(\d+)\D+(\d+)\D*'
	}
);

use base 'UR::Store';

sub constructor {
	my ($class, %p) = @_;

	return UR::Store::connect($class);
}

sub _table_name {
	my ($self) = @_;
	return 'ability_map';
}

sub _map_prefix {
	my ($self, $ability) = @_;
	for (my $i = 0; $i < scalar @_PREFIX; $i++) {
		my $p = $_PREFIX[$i];

		for my $value (@{to_list($p->{value})}) {
			if ($ability =~ /^($value)\s*:\s*(.*)$/) {
				return { index => $i, ability => $2 };
			}
		}
	}

	return undef;
}

sub _map {
	my ($self, $orig_ability) = @_;

	my $prefix = $self->_map_prefix($orig_ability);
	my $ability = $prefix ? $prefix->{ability} : $orig_ability;

	for (my $i = 0; $i < scalar @_RULES; $i++) {
		my $r = $_RULES[$i];

		for my $regex (@{to_list($r->{regex})}) {
			if ($ability =~ /^$regex$/i) {
				return {
					x => $1,
					y => $2,
					prefix_id => $prefix ? $prefix->{index} : undef,
					rule_id => $i,
					prefix => $prefix ? $_PREFIX[$prefix->{index}]->{desc} : undef,
					rule => $_RULES[$i]->{desc}
				};
			}
		}
	}
	webug { prefix => $prefix, ability => $orig_ability };
	return 0;
}

sub update {
	my ($self, $chars) = @_;

	my @map;
	for my $c (@$chars) {
		my $map_result = $self->_map($c->{ability});
		if ($map_result) {
			$map_result->{char_id} = $c->{id};
			push @map, $map_result;
		}
	}

	$self->_clear;
	$self->SUPER::update(\@map);
}

sub load {
	my ($self) = @_;

	return $self->query(
		sprintf("SELECT * FROM %s", $self->_table_name),
	);
}

1
