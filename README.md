# NAME

SQL::Maker::Plugin::JoinSelect - Plugin of SQL::Maker for making SQL contained \`JOIN\`

# SYNOPSIS

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

# DESCRIPTION

SQL::Maker::Plugin::JoinSelect is Plugin of SQL::Maker for making SQL contained \`JOIN\`.

# INTERFACE

## Method

### ["($sql, @binds) = $sql\_maker->join\_select($table, $join\_conds, \\@fields, \\%where, \\%opt)"](#($sql, @binds) = $sql\_maker->join\_select($table, $join\_conds, \\@fields, \\%where, \\%opt))

[$table](http://search.cpan.org/perldoc?$table), [\\@fields](http://search.cpan.org/perldoc?\\@fields), [\\%where](http://search.cpan.org/perldoc?\\%where) and [\\%opt](http://search.cpan.org/perldoc?\\%opt) are same as arguments of [$sql\_maker->select](http://search.cpan.org/perldoc?$sql\_maker->select).

[$join\_conds](http://search.cpan.org/perldoc?$join\_conds) is an ArrayRef containing sequenced pair of [$table](http://search.cpan.org/perldoc?$table) and [$join\_cond](http://search.cpan.org/perldoc?$join\_cond) as follows.

    [
        'user_item' => {'user.id' => 'user_item.user_id'},
        'item'      => 'user_item.item_id => item.id',
        ...
    ]

Each <$join\_cond> can be ArrayRef, HashRef and String same as condition argument of [SQL::Maker::Select\#add\_join](http://search.cpan.org/perldoc?SQL::Maker::Select\#add\_join).

Join type is 'inner' by default. If you want to specify join type, you can use ArrayRef like follows.

    [
        'item' => ['outer' => {'user.id' => 'item.user_id'}],
    ]

# LICENSE

Copyright (C) Masayuki Matsuki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Masayuki Matsuki <y.songmu@gmail.com>
