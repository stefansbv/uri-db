package URI::_odbc;
# use List::MoreUtils qw(firstidx);
use base 'URI::_db';
our $VERSION = '0.18';

sub dbi_driver   { 'ODBC' }

sub _dbi_param_map {
    my $self = shift;
    my $host = $self->host;
    my $port = $self->_port;

    # Just return the DSN if no host or port.
    return [ DSN => scalar $self->dbname ] unless $host || $port;

    # Fetch the driver from the query params.
    require URI::QueryParam;
    return (
        [ Server   => $host                        ],
        [ Port     => $port || $self->default_port ],
        [ Database => scalar $self->dbname         ],
    );
}

# sub query_params {
#     my $self = shift;
#     require URI::QueryParam;
#     my @qp = map {
#         my $f = $_;
#         map { $f => $_ } grep { defined } $self->query_param($f)
#     } $self->query_param;
#     my $index = firstidx { /Driver/ } @qp;
#     if (defined $index and $index >= 0) {

#         # Remove the Firebird driver from params
#         splice @qp, $index, 2 if $qp[$index+1] eq 'Firebird';
#     }
#     return @qp;
# }

sub dbi_dsn {
    my $self = shift;
	my $dbi_driver = $self->dbi_driver;
    my $dsn_params = $self->_dsn_params;
    if ( $dsn_params =~ m/Firebird/ ) {
        $dsn_params =~ s/;Driver=(.+)//;
        return join( ':' => 'dbi', $dbi_driver, qq(Driver={$1}) ) . ';' . $dsn_params;
    }
    return join ':' => 'dbi', $dbi_driver, $self->_dsn_params;
}


1;
