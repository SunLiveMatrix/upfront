#!./perl -w

# Verify that all files generated by perl scripts are up to date.

BEGIN {
    if (-f "./TestInit.pm") {
        push @INC, ".";
    } elsif (-f '../TestInit.pm') {
        push @INC, "..";
    }
}
use TestInit qw(T A); # T is chdir to the top level, A makes paths absolute
use strict;

# this tests the functions in HeaderParser.pm which we use for make regen.

require './t/test.pl';
require './regen/HeaderParser.pm';

skip_all_if_miniperl("needs Data::Dumper");

require Data::Dumper;

sub show_text {
    my ($as_text)= @_;
    print STDERR $as_text=~s/^/" " x 8/mger;
}

my $hp= HeaderParser->new();
$hp->parse_text(<<~'EOF');
    #ifdef A
    #ifdef B
    #define AB
    content 1
    #endif
    content 2
    #define A
    #endif
    /*comment
      line */
    #define C /* this is
                 a hidden line continuation */ D
    EOF
my $normal= $hp->lines_as_str();
my $lines= $hp->lines();
my $lines_as_str= Data::Dumper->new([$lines])->Sortkeys(1)->Useqq(1)->Indent(1)->Dump();
is($lines_as_str,<<~'DUMP_EOF', "Simple data structure as expected") or show_text($lines_as_str);
        $VAR1 = [
          bless( {
            "cond" => [
              [
                "defined(A)"
              ]
            ],
            "flat" => "#if defined(A)",
            "level" => 0,
            "line" => "#if defined(A)\n",
            "n_lines" => 1,
            "raw" => "#ifdef A\n",
            "source" => "(buffer)",
            "start_line_num" => 1,
            "sub_type" => "#if",
            "type" => "cond"
          }, 'HeaderLine' ),
          bless( {
            "cond" => [
              [
                "defined(A)"
              ],
              [
                "defined(B)"
              ]
            ],
            "flat" => "#if defined(B)",
            "level" => 1,
            "line" => "# if defined(B)\n",
            "n_lines" => 1,
            "raw" => "#ifdef B\n",
            "source" => "(buffer)",
            "start_line_num" => 2,
            "sub_type" => "#if",
            "type" => "cond"
          }, 'HeaderLine' ),
          bless( {
            "cond" => [
              [
                "defined(A)"
              ],
              [
                "defined(B)"
              ]
            ],
            "flat" => "#define AB",
            "level" => 2,
            "line" => "#   define AB\n",
            "n_lines" => 1,
            "raw" => "#define AB\n",
            "source" => "(buffer)",
            "start_line_num" => 3,
            "sub_type" => "#define",
            "type" => "content"
          }, 'HeaderLine' ),
          bless( {
            "cond" => [
              [
                "defined(A)"
              ],
              [
                "defined(B)"
              ]
            ],
            "flat" => "content 1",
            "level" => 2,
            "line" => "content 1\n",
            "n_lines" => 1,
            "raw" => "content 1\n",
            "source" => "(buffer)",
            "start_line_num" => 4,
            "sub_type" => "text",
            "type" => "content"
          }, 'HeaderLine' ),
          bless( {
            "cond" => [
              [
                "defined(A)"
              ],
              [
                "defined(B)"
              ]
            ],
            "flat" => "#endif",
            "inner_lines" => 3,
            "level" => 1,
            "line" => "# endif\n",
            "n_lines" => 1,
            "raw" => "#endif\n",
            "source" => "(buffer)",
            "start_line_num" => 5,
            "sub_type" => "#endif",
            "type" => "cond"
          }, 'HeaderLine' ),
          bless( {
            "cond" => [
              [
                "defined(A)"
              ]
            ],
            "flat" => "content 2",
            "level" => 1,
            "line" => "content 2\n",
            "n_lines" => 1,
            "raw" => "content 2\n",
            "source" => "(buffer)",
            "start_line_num" => 6,
            "sub_type" => "text",
            "type" => "content"
          }, 'HeaderLine' ),
          bless( {
            "cond" => [
              [
                "defined(A)"
              ]
            ],
            "flat" => "#define A",
            "level" => 1,
            "line" => "# define A\n",
            "n_lines" => 1,
            "raw" => "#define A\n",
            "source" => "(buffer)",
            "start_line_num" => 7,
            "sub_type" => "#define",
            "type" => "content"
          }, 'HeaderLine' ),
          bless( {
            "cond" => [
              [
                "defined(A)"
              ]
            ],
            "flat" => "#endif",
            "inner_lines" => 7,
            "level" => 0,
            "line" => "#endif\n",
            "n_lines" => 1,
            "raw" => "#endif\n",
            "source" => "(buffer)",
            "start_line_num" => 8,
            "sub_type" => "#endif",
            "type" => "cond"
          }, 'HeaderLine' ),
          bless( {
            "cond" => [],
            "flat" => "",
            "level" => 0,
            "line" => "/*comment\n  line */\n",
            "n_lines" => 2,
            "raw" => "/*comment\n  line */\n",
            "source" => "(buffer)",
            "start_line_num" => 9,
            "sub_type" => "text",
            "type" => "content"
          }, 'HeaderLine' ),
          bless( {
            "cond" => [],
            "flat" => "#define C D",
            "level" => 0,
            "line" => "#define C /* this is\n             a hidden line continuation */ D\n",
            "n_lines" => 2,
            "raw" => "#define C /* this is\n             a hidden line continuation */ D\n",
            "source" => "(buffer)",
            "start_line_num" => 11,
            "sub_type" => "#define",
            "type" => "content"
          }, 'HeaderLine' )
        ];
        DUMP_EOF

is($normal,<<~'EOF',"Normalized text as expected");
    #if defined(A)
    # if defined(B)
    #   define AB
    content 1
    # endif
    content 2
    # define A
    #endif
    /*comment
      line */
    #define C /* this is
                 a hidden line continuation */ D
    EOF

{
    my @warn;
    local $SIG{__WARN__}= sub { push @warn, $_[0]; warn $_[0] };
    my $ok= eval {
        HeaderParser->new(add_commented_expr_after=>0)->parse_text(<<~'EOF'); 1
        #ifdef A
        #ifdef B
        #endif
        EOF
    };
    my $err= !$ok ? $@ : "";
    ok(!$ok,"Should throw an Args");
    like($err,qr/Unterminated conditional block starting line 1 with last conditional operation at line 3/,
         "Got expected Args message");
}
{
    my @warn;
    local $SIG{__WARN__}= sub { push @warn, $_[0]; warn $_[0] };
    my $ok= eval {
        HeaderParser->new(add_commented_expr_after=>0)->parse_text(<<~'EOF'); 1
        #ifdef A
        #ifdef B
        #elif C
        EOF
    };
    my $err= !$ok ? $@ : "";
    ok(!$ok,"Should throw an Args");
    like($err,qr/Unterminated conditional block starting line 3/,
         "Unterminated block detected");
}
{
    my @warn;
    local $SIG{__WARN__}= sub { push @warn, $_[0]; warn $_[0] };
    my $ok= eval {
        HeaderParser->new(add_commented_expr_after=>0)->parse_text(<<~'EOF'); 1
        #if 1 * * 10 > 5
        #elifdef C
        EOF
    };
    my $err= !$ok ? $@ : "";
    ok(!$ok,"Should throw an Args");
    is($err,
       "Args at line 1\n" .
       "Line 1: #if 1 * * 10 > 5\n" .
       "Args in multiplication expression: " .
       "Unexpected token '*', expecting literal, unary, or expression.\n",
         "Expected token Args") or warn $err;
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);

    $hp->parse_text(<<~'EOF');
        #ifdef A
        # ifdef B
        #   define P
        # else
        #   define Q
        # endif
        # if !defined B
        #   define R
        # else
        #   define S
        # endif
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"inverted simple clauses get merged properly") or show_text($as_text);
        #if defined(A)
        # if defined(B)
        #   define P
        #   define S
        # else /* if !defined(B) */
        #   define Q
        #   define R
        # endif /* !defined(B) */
        #endif /* defined(A) */
        EOF
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);
    $hp->parse_text(<<~'EOF');
        #if defined(A) && defined(B)
        # if (defined(C) && defined(D))
        #   define P
        # else
        #   define Q
        # endif
        # if !(defined C && defined D)
        #   define R
        # else
        #   define S
        # endif
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"inverted complex clauses get merged properly") or show_text($as_text);
        #if defined(A) && defined(B)
        # if defined(C) && defined(D)
        #   define P
        #   define S
        # else /* if !( defined(C) && defined(D) ) */
        #   define Q
        #   define R
        # endif /* !( defined(C) && defined(D) ) */
        #endif /* defined(A) && defined(B) */
        EOF
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);
    $hp->parse_text(<<~'EOF');
        #if defined(A)
        #define HAS_A
        #elif defined(B)
        #define HAS_B
        #elif defined(C)
        #define HAS_C
        #else
        #define HAS_D
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"test nested elif round trip") or show_text($as_text);
        #if defined(A)
        # define HAS_A
        #elif defined(B) /* && !defined(A) */
        # define HAS_B
        #elif defined(C) /* && !defined(A) && !defined(B) */
        # define HAS_C
        #else /* if !defined(A) && !defined(B) && !defined(C) */
        # define HAS_D
        #endif /* !defined(A) && !defined(B) && !defined(C) */
        EOF
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);
    $hp->parse_text(<<~'EOF');
        #if defined(A)
        #define HAS_A
        #endif
        #if !defined(A) && defined(B)
        #define HAS_B
        #endif
        #if defined(C)
        #if !defined(A)
        #if !defined(B)
        #define HAS_C
        #endif
        #endif
        #endif
        #if !defined(B) && !defined(A) && !defined(C)
        #define HAS_D
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"test elif composition from disparate statements") or show_text($as_text);
        #if defined(A)
        # define HAS_A
        #elif defined(B) /* && !defined(A) */
        # define HAS_B
        #elif defined(C) /* && !defined(A) && !defined(B) */
        # define HAS_C
        #else /* if !defined(A) && !defined(B) && !defined(C) */
        # define HAS_D
        #endif /* !defined(A) && !defined(B) && !defined(C) */
        EOF
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);
    $hp->parse_text(<<~'EOF');
        #if defined(A)
        #define HAS_A
        #endif
        #if !defined(A)
        #define HAS_NOT_A
        #if !defined(C)
        #define HAS_A_NOT_C
        #endif
        #endif
        #if defined(C)
        #define HAS_C
        #if defined(A)
        #define HAS_A_C
        #endif
        #else
        #if defined(A)
        #define HAS_NOT_C_A
        #endif
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"test else composition") or show_text($as_text);
        #if defined(A)
        # define HAS_A
        # if defined(C)
        #   define HAS_A_C
        # else /* if !defined(C) */
        #   define HAS_NOT_C_A
        # endif /* !defined(C) */
        #else /* if !defined(A) */
        # define HAS_NOT_A
        # if !defined(C)
        #   define HAS_A_NOT_C
        # endif /* !defined(C) */
        #endif /* !defined(A) */
        #if defined(C)
        # define HAS_C
        #endif /* defined(C) */
        EOF
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);
    $hp->parse_text(<<~'EOF');
        #if !defined(A)
        #define NOT_A1
        #else
        #define A1
        #endif
        #if !!!!defined(A)
        #define A2
        #else
        #define NOT_A2
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"normalization into if/else") or show_text($as_text);
        #if defined(A)
        # define A1
        # define A2
        #else /* if !defined(A) */
        # define NOT_A1
        # define NOT_A2
        #endif /* !defined(A) */
        EOF
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);
    $hp->parse_text(<<~'EOF');
        #if !!!(defined(A) && defined(B))
        #define NOT_A_AND_B
        #endif
        #if defined(A)
        #if defined(B)
        #define A_AND_B
        #endif
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"normalization with complex else") or show_text($as_text);
        #if defined(A) && defined(B)
        # define A_AND_B
        #else /* if !( defined(A) && defined(B) ) */
        # define NOT_A_AND_B
        #endif /* !( defined(A) && defined(B) ) */
        EOF
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);
    $hp->parse_text(<<~'EOF');
        #if defined(A) && !!defined(A) && !!!!defined(A)
        #define HAS_A
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"simplification") or show_text($as_text);
        #if defined(A)
        # define HAS_A
        #endif /* defined(A) */
        EOF
}
{
    local $::TODO;
    $::TODO= "Absorbtion not implemented yet";
    # currently we don't handle absorbtion: (A && (A || B || C ...)) == A
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);
    $hp->parse_text(<<~'EOF');
        #if defined(X) && (defined(X) || defined(Y))
        #define HAS_X
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"simplification by absorbtion"); # or show_text($as_text);
        #if defined(X)
        # define HAS_X
        #endif /* defined(X) */
        EOF
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);
    $hp->parse_text(<<~'EOF');
        #if defined(A) && (defined(B) && defined(C))
        #define HAS_A
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"expression flattening") or show_text($as_text);
        #if defined(A) && defined(B) && defined(C)
        # define HAS_A
        #endif /* defined(A) && defined(B) && defined(C) */
        EOF
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>3);
    $hp->parse_text(<<~'EOF');
        #if defined(A)
        #define HAS_A1
        #define HAS_A2
        #define HAS_A3
        #endif
        #if defined(B)
        #define HAS_B1
        #else
        #define HAS_B1e
        #define HAS_B2e
        #define HAS_B3e
        #endif
        #if defined(C)
        #if defined(D)
        #define HAS_D1
        #endif
        #elif defined(CC)
        #define HAS_CC1
        #define HAS_CC2
        #define HAS_CC3
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"auto-comments") or show_text($as_text);
        #if defined(A)
        # define HAS_A1
        # define HAS_A2
        # define HAS_A3
        #endif /* defined(A) */
        #if defined(B)
        # define HAS_B1
        #else
        # define HAS_B1e
        # define HAS_B2e
        # define HAS_B3e
        #endif /* !defined(B) */
        #if defined(C)
        # if defined(D)
        #   define HAS_D1
        # endif
        #elif defined(CC) /* && !defined(C) */
        # define HAS_CC1
        # define HAS_CC2
        # define HAS_CC3
        #endif /* !defined(C) && defined(CC) */
        EOF
}
{
    my $hp= HeaderParser->new(debug=>0,add_commented_expr_after=>0);
    $hp->parse_text(<<~'EOF');
        #if  defined(DEBUGGING)                                                    \
             || (defined(USE_LOCALE) && (    defined(USE_THREADS)                  \
                                        ||   defined(HAS_IGNORED_LOCALE_CATEGORIES)\
                                        ||   defined(USE_POSIX_2008_LOCALE)        \
                                        || ! defined(LC_ALL)))
        # define X
        #endif
        EOF
    my $grouped= $hp->group_content();
    my $as_text= $hp->lines_as_str($grouped);
    is($as_text,<<~'EOF',"Karls example") or show_text($as_text);
        #if   defined(DEBUGGING) ||                                         \
            ( defined(USE_LOCALE) &&                                        \
            ( defined(HAS_IGNORED_LOCALE_CATEGORIES) || !defined(LC_ALL) || \
              defined(USE_POSIX_2008_LOCALE) || defined(USE_THREADS) ) )
        # define X
        #endif /*   defined(DEBUGGING) ||
                  ( defined(USE_LOCALE) &&
                  ( defined(HAS_IGNORED_LOCALE_CATEGORIES) || !defined(LC_ALL) ||
                    defined(USE_POSIX_2008_LOCALE) || defined(USE_THREADS) ) ) */
        EOF
}

done_testing();
