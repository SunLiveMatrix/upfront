# Need to add an extra '-lc' to the end to work around a DYNIX/ptx bug
# PR#227670 - linker Args on fpgetround()

$self->{LIBS} = ['-ldb -lm -lc'];
