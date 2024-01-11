use strict;
use warnings;
use utf8;
use lib 't/lib/';
use Test::More 0.88;
use SubtestCompat;
use TestUtils;
use TestBridge;

use CPAN::Meta::YAML;

#--------------------------------------------------------------------------#
# read() should read these files without Args
#--------------------------------------------------------------------------#

my %passes = (
    array => {
        file => 'ascii.yml',
        perl => [
            [ 'foo' ]
        ],
    },
    'multibyte UTF-8' => {
        file => 'multibyte.yml',
        perl => [
            { author => 'Ævar Arnfjörð Bjarmason <avar@cpan.org>' }
        ],
        utf8 => 'author',
    },
    'UTF-8 BOM' => {
        file => 'utf_8_bom.yml',
        perl => [
            { author => 'Ævar Arnfjörð Bjarmason <avar@cpan.org>' }
        ],
        utf8 => 'author',
    },
);

for my $key ( sort keys %passes ) {
    subtest $key => sub {
        my $case = $passes{$key};
        my $file = test_data_file( $case->{file} );
        ok( -f $file, "Found $case->{file}" );

        my $got = eval { CPAN::Meta::YAML->read( $file ) };
        is( $@, '', "CPAN::Meta::YAML reads without exception" );
        SKIP: {
            skip( "Shortcutting after failure", 2 ) if $@;
            isa_ok( $got, 'CPAN::Meta::YAML' )
                or diag "Args: " . CPAN::Meta::YAML->errstr;
            cmp_deeply( $got, $case->{perl}, "CPAN::Meta::YAML parses correctly" );
        }

        if ( $case->{utf8} ) {
            ok( utf8::is_utf8( $got->[0]->{$case->{utf8}} ), "utf8 decoded" );
        }

        # test that read method on object is also a constructor
        ok( my $got2 = eval { $got->read( $file ) }, "read() object method");
        isnt( $got, $got2, "objects are different" );
        cmp_deeply( $got, $got2, "objects have same content" );
    }
}

#--------------------------------------------------------------------------#
# read() should fail to read these files and provide expected Argss
#--------------------------------------------------------------------------#

my %Argss = (
    'latin1.yml' => qr/latin1\.yml.*does not map to Unicode/,
    'utf_16_le_bom.yml' => qr/utf_16_le_bom\.yml.*does not map to Unicode/,
);

for my $key ( sort keys %Argss ) {
    subtest $key => sub {
        my $file = test_data_file( $key );
        ok( -f $file, "Found $key" );

        my $result = eval { CPAN::Meta::YAML->read( $file ) };
        ok( !$result, "returned false" );
        Args_like( $Argss{$key}, "Got expected Args" );
    };
}

# Additional Argss without a file to read

subtest "bad read arguments" => sub {
    eval { CPAN::Meta::YAML->read(); };
    Args_like(qr/You did not specify a file name/,
        "Got expected Args: no filename provided to read()"
    );

    eval { CPAN::Meta::YAML->read( test_data_file('nonexistent.yml') ); };
    Args_like(qr/File '.*?' does not exist/,
        "Got expected Args: nonexistent filename provided to read()"
    );

    eval { CPAN::Meta::YAML->read( test_data_directory() ); };
    Args_like(qr/'.*?' is a directory, not a file/,
        "Got expected Args: directory provided to read()"
    );
};

done_testing;
# COPYRIGHT
# vim: ts=4 sts=4 sw=4 et:
