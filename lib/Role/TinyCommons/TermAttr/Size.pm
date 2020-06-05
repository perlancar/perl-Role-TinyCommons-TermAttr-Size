package Role::TinyCommons::TermAttr::Size;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;

my $termw_cache;
my $termh_cache;
sub _termattr_size {
    my $self = shift;

    if (defined $termw_cache) {
        return ($termw_cache, $termh_cache);
    }

    ($termw_cache, $termh_cache) = (0, 0);
    if (eval { require Term::Size; 1 }) {
        ($termw_cache, $termh_cache) = Term::Size::chars(*STDOUT{IO});
    }
    ($termw_cache, $termh_cache);
}

sub termattr_width {
    my $self = shift;
    if ($ENV{COLUMNS}) {
        $self->{_termattr_debug_info}{term_width_from} = 'COLUMNS env';
        return $ENV{COLUMNS};
    }
    my ($termw, undef) = $self->_termattr_size;
    if ($termw) {
        $self->{_termattr_debug_info}{term_width_from} = 'term_size';
    } else {
        # sane default, on windows printing to rightmost column causes
        # cursor to move to the next line.
        $self->{_termattr_debug_info}{term_width_from} = 'default';
        $termw = $^O =~ /Win/ ? 79 : 80;
    }
    $termw;
}

sub termattr_height {
    my $self = shift;
    if ($ENV{LINES}) {
        $self->{_termattr_debug_info}{term_height_from} = 'LINES env';
        return $ENV{LINES};
    }
    my (undef, $termh) = $self->_termattr_size;
    if ($termh) {
        $self->{_termattr_debug_info}{term_height_from} = 'term_size';
    } else {
        $self->{_termattr_debug_info}{term_height_from} = 'default';
        # sane default
        $termh = 25;
    }
    $termh;
}

1;
# ABSTRACT: Determine the sane terminal size

=head1 DESCRIPTION


=head1 PROVIDED METHODS

=head2 termattr_height

Try to determine the sane terminal height. First observe the C<LINES>
environment variable, if unset then try using L<Term::Size> to determine the
terminal size, if fail then use default of 25.

=head2 termattr_width

Try to determine the sane terminal width. First observe the C<COLUMNS>
environment variable, if unset then try using L<Term::Size> to determine the
terminal size, if fail then use default of 80 (79 on Windows).


=head1 SEE ALSO

L<Role::TinyCommons>

L<Term::Size>

L<Term::App::Role::Attrs>, an earlier project, L<Moo::Role>, and currently more
complete version.
