use v6;

# TODO: this should be immutable, as setting the codon table once allows for
# caching the codons in a faster hash lookup.
use Bio::Tools::IUPAC;

class Bio::Tools::CodonTable {
    our %codons;
    our %trcol;
    
    # not sure this is necessary
    our %iub = %Bio::Tools::IUPAC::IUB;

    constant CODONSIZE = 3 ;
    
    has $!codon-table;
    
    INIT {
        my @nucs = <t c a g>;
        my $x = 0;
        
        for @nucs -> $i {
            for @nucs -> $j {
                for @nucs -> $k {
                    my $codon = "$i$j$k";
                    %codons{$codon} = $x;
                    %trcol{$x} = $codon;
                    $x++;
                }
            }
        }
    }
    
    # first set internal values for all translation tables
    
    has Str $.gap where {$_.chars == 1};
        
    has Str $.terminator where { $_.chars == 1 };
    
    #has $.CODONGAP = $GAP x CODONSIZE;
    has $.CODONGAP = '---';
    
    has $.id;
    
    # thinking these could go into a simple basic data class
    #constant NYI    
    our @NAMES = (
        'Standard',        #1
        'Vertebrate Mitochondrial',#2
        'Yeast Mitochondrial',# 3
        'Mold, Protozoan, and CoelenterateMitochondrial and Mycoplasma/Spiroplasma',#4
        'Invertebrate Mitochondrial',#5
        'Ciliate, Dasycladacean and Hexamita Nuclear',# 6
        '', '',
        'Echinoderm Mitochondrial',#9
        'Euplotid Nuclear',#10
        '"Bacterial"',# 11
        'Alternative Yeast Nuclear',# 12
        'Ascidian Mitochondrial',# 13
        'Flatworm Mitochondrial',# 14
        'Blepharisma Nuclear',# 15
        'Chlorophycean Mitochondrial',# 16
        '', '',  '', '',
        'Trematode Mitochondrial',# 21
        'Scenedesmus obliquus Mitochondrial', #22
        'Thraustochytrium Mitochondrial'  #23
    );
    
    our @TABLES = <
        FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
        FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSS**VVVVAAAADDEEGGGG
        FFLLSSSSYY**CCWWTTTTPPPPHHQQRRRRIIMMTTTTNNKKSSRRVVVVAAAADDEEGGGG
        FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
        FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSSSVVVVAAAADDEEGGGG
        FFLLSSSSYYQQCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
        '' ''
        FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG
        FFLLSSSSYY**CCCWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
        FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
        FFLLSSSSYY**CC*WLLLSPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
        FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSGGVVVVAAAADDEEGGGG
        FFLLSSSSYYY*CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG
        FFLLSSSSYY*QCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
        FFLLSSSSYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
        '' '' '' ''
        FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNNKSSSSVVVVAAAADDEEGGGG   
        FFLLSS*SYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
        FF*LSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
    >;
    
    our @STARTS = <
        ---M---------------M---------------M----------------------------
        --------------------------------MMMM---------------M------------
        ----------------------------------MM----------------------------
        --MM---------------M------------MMMM---------------M------------
        ---M----------------------------MMMM---------------M------------
        -----------------------------------M----------------------------
        '' ''
        -----------------------------------M----------------------------
        -----------------------------------M----------------------------
        ---M---------------M------------MMMM---------------M------------
        -------------------M---------------M----------------------------
        -----------------------------------M----------------------------
        -----------------------------------M----------------------------
        -----------------------------------M----------------------------
        -----------------------------------M----------------------------
        '' ''  '' ''
        -----------------------------------M---------------M------------  
        -----------------------------------M----------------------------
        --------------------------------M--M---------------M------------
    >;
    
    submethod BUILD(:$!id = 1, 
                    :$table?,
                    :$table-name = 'Custom' ~ @NAMES.elems +1,
                    :$starts = @STARTS[1],
                    :$!gap = '-',
                    :$!terminator = '*'
                    )
    {
        if $table {
            push @TABLES, $table;
            push @NAMES, $table-name;
            push @STARTS, $starts;
            # overrides id for custom tables
            $!id = @NAMES.elems;
        }
        for %codons.kv -> $codon, $aa {
            $!codon-table{ $codon } = @TABLES[self.id-1].substr(%codons{$codon}, 1)
        }
    }
    
    method name() {
        return @NAMES[self.id - 1];
    }
    
    method tables() {
        my %tables;
        for  1 .. @NAMES ->  $id {
          my $name = @NAMES[$id-1];
          %tables{$id} = $name if $name;
        }
        return %tables;
    }
    
    method translate($seq is copy,
                    :$terminator?,
                    :$unknown) {
        return '' unless $seq;
        
        $seq .= trans('uU' => 'tt');
    
        my $tbl = @TABLES[self.id - 1];
        
        my $aa = (0..^($seq.chars / 3).floor)>>.map(
            {
                my $codon = substr($seq, $_ * 3, CODONSIZE);
                my $res;
                given $codon.lc {
                    when $.CODONGAP {
                        $res = '-';
                    }
                    when /<-[ATUGCatugc]>/ {
                        # TODO: rewrite this to be more consistent?
                        $res = self!translate_ambiguous_codon($_);
                    }
                    default {
                        $res = $!codon-table{ $_ };
                    }
                }
                $res;
            }
            );
        
        my $protein = $aa.join('');
        
        # any leftover?  TODO: this doesn't account for possible gaps
        if $seq.chars % CODONSIZE == 2 {
            my $aa = self!translate_ambiguous_codon( $seq.substr(*-2, 2).lc ~ 'n' );
            $protein ~= $aa if $aa ne 'X';
        }
    
        return $protein;
    }
    
    method revtranslate($value is copy,$coding?){
        my ($id) = self.id;
        my (@aas,  $p);
        my (@codons) = ();
    
        if ($value.chars == 3 ) {
            $value = lc $value;
            $value = $value.tc;
            #hash comes from SeqUtil.pm crap!
    #         $value = %THREELETTERSYMBOLS{$value};
         }
       # if ( defined $value and $value ~~ /$VALID_PROTEIN/ 
       #        and $value.chars == 1 ) {
       #      $value = uc $value;
       #      @aas = @{$IUPAC_AA{$value}};    
       #      foreach my $aa (@aas) {
       #          #print $aa, " -2\n";
       #          $aa = '\*' if $aa eq '*';
       #        while ($TABLES[$id-1] =~ m/$aa/g) {
       #            $p = pos $TABLES[$id-1];
       #            push (@codons, $TRCOL->{--$p});
       #        }
       #      }
       #  }
    
       # if ($coding and uc ($coding) eq 'RNA') {
       #     for my $i (0..$#codons)  {
       #        $codons[$i] =~ tr/t/u/;
       #     }
       # }
        
       return @codons;    
    }
    
    method is_start_codon($value is copy) {
       my $id = self.id;
    
       $value  = lc $value;
       $value =$value.trans('u'=>'t');
    
       if ( $value.chars != 3  )  {
           return 0;
       }
       else {
           my $result = 1;
           my @ms = map { substr(@STARTS[$id-1],%codons{$_},1) }, self!unambiquous_codons($value);
           for @ms -> $c {
               $result = 0 if $c ne 'M';
           }
           return $result;
       }    
    }
    
    method is_ter_codon($value is copy) {
        my $id = self.id;
    
        $value  = lc $value;
        $value  =$value.trans('u' =>'t');
    
        if ( $value.chars != 3  )  {
            return 0;
        }
        else {
            my $result = 1;
            my @ms = map { substr(@TABLES[$id-1],%codons{$_},1) }, self!unambiquous_codons($value);
            for @ms -> $c {
                $result = 0 if $c ne $.terminator;
            }
            return $result;
        }    
    }
    
    
    method is_unknown_codon($value is copy) {
       my $id = self.id;
    
       $value  = lc $value;
       $value  = $value.trans('u' => 't');
    
       if ( $value.chars != 3  )  {
           return 1;
       }
       else {
           my $result = 0;
           my @cs = map { substr(@TABLES[$id-1],%codons{$_},1) }, self!unambiquous_codons($value);
           $result = 1 if @cs.elems == 0;
           return $result;
       }    
    }
    
    method translate_strict($value is copy) {
       my ($id) = self.id;
    
       $value  = lc $value;
       $value  = $value.trans('u' => 't');
    
       if ($value.chars != 3 ) {
           return '';
       }
       elsif (!(defined %codons{$value}))  {
           return 'X';
       }
       else {
           return substr(@TABLES[$id-1],%codons{$value},1);
       }    
    }
    
    method reverse_translate_all(*@params) {
        return 'NYI';
    }
    
    method !translate_ambiguous_codon($triplet, $partial? = 0) {
        my $id = self.id;
        my $aa='';
        my @codons = self!unambiquous_codons($triplet);
        my %aas;
        
        for @codons -> $codon {
            %aas{substr(@TABLES[$id-1],%codons{$codon},1)} = 1;
        }
        my $count =  %aas.keys.elems;
        if $count == 1  {
            $aa = @(%aas.keys)[0];
        }
        elsif $count == 2 {
            if (%aas{'D'} and %aas{'N'}) {
                $aa = 'B';
             }
            elsif (%aas{'E'} and %aas{'Q'}) {
                $aa = 'Z';
            } else {
                $partial ?? ($aa = '') !! ($aa = 'X');
            }
        } else {
            $partial ?? ($aa = '') !!  ($aa = 'X');
        }
        return $aa;
    }
    
    
    method !unambiquous_codons($value) {
        my @nts;
        my @codons;
        my ($i, $j, $k);
        @nts = map { %iub{uc $_}} , $value.comb();
            for @(@nts[0]) ->  $i {
                #hack for now, since @nts has Any() values. Normally in p5 code you would have undef which would not loop at all
                last if !defined $i;
                for @(@nts[1]) -> $j {
                    for @(@nts[2]) -> $k {
                        @codons.push(lc "$i$j$k");
                    }
                }
            }
        return @codons;
    }
}
