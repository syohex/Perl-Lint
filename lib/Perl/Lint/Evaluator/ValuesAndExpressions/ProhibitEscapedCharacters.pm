package Perl::Lint::Evaluator::ValuesAndExpressions::ProhibitEscapedCharacters;
use strict;
use warnings;
use Perl::Lint::Constants::Type;
use parent "Perl::Lint::Evaluator";

# TODO msg!
use constant {
    DESC => '',
    EXPL => '',
};

sub evaluate {
    my ($class, $file, $tokens, $args) = @_;

    my @violations;
    my $is_reg_quote = 0;
    for (my $i = 0; my $token = $tokens->[$i]; $i++) {
        my $token_type = $token->{type};
        if ($token_type == REG_QUOTE) {
            $is_reg_quote = 1;
        }
        elsif ($token_type == STRING || $token_type == REG_EXP) {
            if ($is_reg_quote) {
                $is_reg_quote = 0;
                next;
            }

            my $string = $token->{data};
            if ($string =~ /\\x?[0-9a-fA-F]{2,}/) {
                push @violations, {
                    filename => $file,
                    line     => $token->{line},
                    description => DESC,
                    explanation => EXPL,
                };
            }
        }
    }

    return \@violations;
}

1;

