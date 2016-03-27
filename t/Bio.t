use v6;

use lib './lib';

use Test;
plan 2;

use Bio;

my @seq = `>id comment
CCCGAACGGCTT
`;
say @seq;
isa-ok(@seq[0], Bio::PrimarySeq, 'PrimarySeq produced by quote constructor');
ok(@seq[0].seq eq 'CCCGAACGGCTT', 'Parsed the sequence all ok');

done-testing();
