use nqp;
use QAST:from<NQP>;
 
sub Bio::seq(Str $sequence) is export {
    use Bio::Grammar::Fasta;
    use Bio::Grammar::Actions::Fasta;
    Bio::Grammar::Fasta.parse($sequence, actions => Bio::Grammar::Actions::Fasta).ast;
}
 
sub EXPORT(|) {
    role Bio::Grammar {
        token quote:sym<` `> {
        '`' <bioseq> [ '`' || <.FAILGOAL: '`'> ]
        }
        token bioseq { <-[`]>* }
    }
 
    role Bio::Actions {
        method quote:sym<` `>(Mu $/) {
            my $seq := nqp::atkey(nqp::findmethod($/, 'hash')($/), 'bioseq');
            my $call := QAST::Op.new(
                                :op<call>,
                                :name<&Bio::seq>,
                                QAST::SVal.new(:value($seq.Str))
                        );
            $/.'!make'($call);
        }
    }
 
    nqp::bindkey(%*LANG, 'MAIN', %*LANG<MAIN>.HOW.mixin(%*LANG<MAIN>, Bio::Grammar));
    nqp::bindkey(%*LANG, 'MAIN-actions', %*LANG<MAIN-actions>.HOW.mixin(%*LANG<MAIN-actions>, Bio::Actions));
    {}
} 
