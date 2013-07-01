package SQL::Maker::Plugin::JoinSelect;
use 5.008001;
use strict;
use warnings;
our $VERSION = "0.01";

use Carp;

our @EXPORT = qw/join_select/;

sub join_select {
    my ($self, $base_table, $join_conditoins, $fields, $where, $opt) = @_;
    my @join_conditions = @$join_conditoins;

    my @joins;
    while ( my ($table, $join_cond) = splice @join_conditions, 0, 2) {
        my ($type, $cond) = ('inner',);
        my $ref = ref $join_cond;
        if (!$ref || $ref eq 'HASH') {
            $cond = $join_cond;
        }
        elsif ($ref eq 'ARRAY') {
            if (uc($join_cond->[0]) =~ /^(?:(?:(?:LEFT|RIGHT|FULL)(?: OUTER)?)|INNER|CROSS)$/) {
                $type = $join_cond->[0];
                $cond = $join_cond->[1];
            }
            else {
                $cond = $join_cond;
            }
        }
        else {
            Carp::croak 'join condition is not valid';
        }

        push @joins, [$base_table => {
            type      => $type,
            table     => $table,
            condition => $cond,
        }];
    }

    my %opt = %{ $opt || {} };
    push @{ $opt{joins} }, @joins;

    $self->select(undef, $fields, $where, \%opt);
}

1;
__END__

=encoding utf-8

=head1 NAME

SQL::Maker::Plugin::JoinSelect - Plugin of SQL::Maker for making SQL contained `JOIN`

=head1 SYNOPSIS

    use SQL::Maker;
    SQL::Maker->load_plugin('JoinSelect');

    my $builder = SQL::Maker->new(driver => 'SQLite', new_line => ' ');
    my ($sql, @binds) = $builder->join_select(
        user => [
            item => 'user.id = item.user_id',
        ],
        ['*'],
        {
            'user.id' => 1,
        },
    );
    print $sql; #=> 'SELECT * FROM "user" INNER JOIN "item" ON user.id = item.user_id WHERE ("user"."id" = ?)';

=head1 DESCRIPTION

SQL::Maker::Plugin::JoinSelect is Plugin of SQL::Maker for making SQL contained `JOIN`.

=head1 LICENSE

Copyright (C) Masayuki Matsuki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Masayuki Matsuki E<lt>y.songmu@gmail.comE<gt>

=cut
