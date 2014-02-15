package Cache;

use Data::Dumper;

use constant FRESH_TIME_MINUTE => 60;
use constant FRESH_TIME_HOUR => 60*60;
use constant FRESH_TIME_DAY => 60*60*24;

sub constructor {
	my ($class, %p) = @_;
	my $self = {
		storage => $p{storage},
		default_fresh_time => $p{fresh_time} || 5 * FRESH_TIME_MINUTE
	};

	return bless $self, $class;
}


sub _file_name {
	my ($self, $id) = @_;
	return $self->{storage}. '/'. $id. '.pd'
}

sub _update {
	my ($self, $id, $value) = @_;
	
	my $file_name = $self->_file_name($id);
	
	open F, '> '. $file_name or die("Can't write cache '$file_name' [ $! ]");
	
	$Data::Dumper::Indent = 0;
	print F Dumper($value);
	$Data::Dumper::Indent = 2;
	
	close F;
	
	return $value;
}

sub _fresh {
	my ($self, $id, $fresh_time) = @_;
	
	my $file_name = $self->_file_name($id);
	my $last_modification_delta = time - (stat $file_name)[9];
	return (-e $file_name and $last_modification_delta < ($fresh_time || $self->{default_fresh_time}));
}

sub _get {
	my ($self, $id) = @_;

	my $data = undef;
	my $file_name = $self->_file_name($id);
	if (-e $file_name) {
		open F, '< '. $file_name or die("Can't read cache '$file_name' [ $! ]");
		my $cache_data = '';
		$cache_data .= $_ while (<F>);
		close F;
		
		eval $cache_data;
		$data = eval $cache_data;
	}

	return $data;
}

sub get {
	my ($self, $id, $get_value_sub, $fresh_time) = @_;
	
	return $self->_fresh($id, $fresh_time) 
		? $self->_get($id) 
		: $self->_update($id, &$get_value_sub);
}	

sub _clear {
	my ($self, $id) = @_;
	
	my $file_name = $self->_file_name($id);
	if (-e $file_name) {
		unlink $file_name;
	}
}

sub total_size {
	my ($self, %p) = @_;
	my @files = glob $self->{storage}. "/*.pd";
	my $total = 0;
	my $max = -1;
	for my $file (@files) {
		my $size = -s $file;
		$total += $size;
		$max = $size if $size > $max;
	}
	return {
		cache_elements_count => scalar @files,
		cache_total_size => $total,
		cache_max_size => $max
	}


}

1;
