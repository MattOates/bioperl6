use v6;

use lib './lib';

use Test;
plan 2;

use Bio;
use Bio::PrimarySeq;

my @dna = `>AT4G03560.1 atTPC1 Channel
ATGGAAGACCCGTTGATTGGTAGAGATAGTCTTGGTGGTGGTGGTACGGATCGGGTTCGTCGATCAGAAGCTATCACGCATGGTACTCCGTTTCAGAAAGCAGCTGCACTCGTTGATCT
GGCTGAAGATGGTATTGGTCTTCCTGTGGAAATACTTGATCAGTCGAGTTTCGGGGAGTCTGCTAGGTATTACTTCATCTTCACACGTTTGGATCTGATCTGGTCACTCAACTATTTCG
CTCTGCTTTTCCTTAACTTCTTCGAGCAACCATTGTGGTGTGAAAAAAACCCTAAACCGTCTTGCAAAGATAGAGATTACTATTACCTGGGAGAGTTACCGTACTTGACCAATGCAGAA
TCCATTATCTATGAGGTGATTACCCTGGCTATACTCCTTGTACATACTTTCTTCCCGATATCCTATGAAGGTTCCCGAATCTTTTGGACTAGTCGCCTGAATCTAGTGAAGGTTGCTTG
CGTGGTAATTTTGTTTGTTGATGTGCTGGTTGACTTTCTGTATCTGTCTCCACTGGCTTTCGACTTTCTCCCTTTTAGAATCGCCCCATACGTGAGAGTTATCATATTCATCCTCAGCA
TAAGGGAACTTCGGGACACCCTTGTCCTTCTGTCTGGAATGCTTGGCACATACTTGAATATCTTGGCTCTATGGATGCTGTTCCTTCTATTTGCCAGTTGGATTGCTTTTGTTATGTTT
GAGGACACGCAGCAGGGCCTCACGGTCTTCACTTCATATGGTGCAACTCTTTACCAGATGTTTATTTTGTTCACAACATCCAACAATCCTGATGTCTGGATTCCTGCATACAAGTCTTC
TCGCTGGTCTTCGGTGTTCTTCGTGCTCTACGTGCTAATTGGCGTCTACTTTGTCACAAACTTGATTCTTGCCGTTGTTTATGACAGTTTCAAAGAACAGCTCGCAAAGCAAGTATCTG
GAATGGATCAAATGAAGAGAAGAATGTTGGAGAAAGCCTTTGGTCTTATAGACTCAGACAAAAACGGGGAGATTGATAAGAACCAATGCATTAAGCTCTTTGAACAGTTGACTAATTAC
AGGACGTTGCCGAAGATATCAAAAGAAGAATTCGGATTGATATTTGATGAGCTTGACGATACTCGTGACTTTAAGATAAACAAGGATGAGTTTGCTGACCTCTGCCAGGCCATTGCTTT
AAGATTCCAAAAGGAGGAAGTACCGTCTCTCTTTGAACATTTTCCGCAAATTTACCATTCCGCCTTATCACAACAACTGAGAGCCTTTGTTCGAAGCCCCAACTTTGGCTACGCTATTT
CTTTCATCCTCATTATCAATTTCATTGCTGTCGTTGTTGAAACAACGCTTGATATCGAAGAAAGCTCGGCTCAGAAGCCATGGCAGGTTGCCGAGTTTGTCTTTGGTTGGATATATGTG
TTGGAGATGGCTCTGAAGATCTATACATATGGATTTGAGAATTATTGGAGAGAGGGTGCTAACCGATTTGATTTTCTAGTCACATGGGTCATAGTTATTGGGGAAACAGCTACCTTCAT
AACTCCAGACGAGAATACTTTCTTCTCAAATGGAGAATGGATCCGGTACCTTCTCCTGGCGAGAATGTTAAGACTGATAAGGCTTCTTATGAACGTCCAGCGATACCGAGCATTTATTG
CGACGTTCATAACTCTTATTCCAAGTTTGATGCCATATTTAGGGACCATTTTCTGCGTGCTGTGTATCTACTGCTCTATTGGCGTACAGGTCTTTGGAGGGCTTGTGAATGCTGGGAAC
AAAAAGCTCTTTGAAACCGAATTGGCTGAGGATGACTACCTTTTGTTCAACTTCAATGACTACCCCAATGGAATGGTCACACTCTTCAATCTGCTAGTTATGGGTAACTGGCAAGTATG
GATGGAGAGCTACAAAGATTTGACGGGCACGTGGTGGAGCATTACATATTTCGTCAGTTTCTATGTCATCACTATTTTACTTCTGTTGAATTTGGTTGTTGCCTTTGTCTTGGAGGCGT
TCTTTACTGAGCTGGATCTTGAAGAAGAAGAAAAATGTCAAGGACAGGATTCTCAAGAAAAAAGAAACAGGCGTCGATCTGCAGGGTCGAAGTCTCGGAGTCAGAGAGTTGATACACTT
CTTCATCACATGTTGGGTGATGAACTCAGCAAACCAGAGTGTTCCACTTCTGACACATAA
`;
isa-ok @dna[0], Bio::PrimarySeq, 'Created DNA Seq successfully from Slang.';

done-testing();
