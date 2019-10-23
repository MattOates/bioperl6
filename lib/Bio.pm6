use nqp;
use QAST:from<NQP>;
 
sub Bio::seq(Str $sequence) is export {
    use Bio::Grammar::Fasta;
    use Bio::Grammar::Actions::Fasta;
    return Bio::Grammar::Fasta.parse($sequence, actions => Bio::Grammar::Actions::Fasta).ast;
}
 
sub EXPORT(|) {
    role Bio::Slang::Grammar {
        token quote:sym<` `> {
        '`' <bioseq> [ '`' || <.FAILGOAL: '`'> ]
        }
        token bioseq { <-[`]>* }
    }
 
    role Bio::Slang::Actions {
        method quote:sym<` `>(Mu $/) {
            my $seq := nqp::atkey(nqp::findmethod($/, 'hash')($/), 'bioseq');
            my $call := QAST::Op.new(
                                :op<call>,
                                :name<&Bio::seq>,
                                QAST::SVal.new(:value($seq.Str))
                        );
            $/.make($call);
        }
    }

    # Register our grammar and actions as a Slang extending the MAIN language handling
    if $*PERL.compiler.version before v2017.03 {
        nqp::bindkey(%*LANG, 'MAIN', %*LANG<MAIN>.HOW.mixin(%*LANG<MAIN>, Bio::Slang::Grammar));
        nqp::bindkey(%*LANG, 'MAIN-actions', %*LANG<MAIN-actions>.HOW.mixin(%*LANG<MAIN-actions>, Bio::Slang::Actions));
    }
    else {
        $ = $*LANG.define_slang(
            'MAIN',
            $*LANG.slang_grammar('MAIN').^mixin(Bio::Slang::Grammar),
            $*LANG.actions.^mixin(Bio::Slang::Actions)
        )
    }

    {}
} 
