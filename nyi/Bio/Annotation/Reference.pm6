use Bio::Annotation::DBLink;
class Bio::Annotation::Reference is Bio::Annotation::DBLink {
# =head2 new

#  Title   : new
#  Usage   : $ref = Bio::Annotation::Reference.new( title => 'title line',
#                            authors => 'author line',
#                            location => 'location line',
#                            medline => 9988812);
#  Function:
#  Example :
#  Returns : a new Bio::Annotation::Reference object
#  Args    : a hash with optional title, authors, location, medline, pubmed,
#            start, end, consortium, rp and rg attributes


# =cut

# method new{
#     my ($class,@args) = @_;

#     my $self = $class.SUPER::new(@args);

#     my ($start,$end,$authors,$consortium,$location,$title,$medline,
#     $pubmed,$rp,$rg,$doi) =
#     $self._rearrange([qw(START
#                   END
#                   AUTHORS
#                   CONSORTIUM
#                   LOCATION
#                   TITLE
#                   MEDLINE
#                   PUBMED
#                   RP
#                   RG
# 				  DOI
#                   )],@args);

#     defined $start    && $self.start($start);
#     defined $end      && $self.end($end);
#     defined $authors  && $self.authors($authors);
#     defined $consortium  && $self.consortium($consortium);
#     defined $location && $self.location($location);
#     defined $title    && $self.title($title);
#     defined $medline  && $self.medline($medline);
#     defined $pubmed   && $self.pubmed($pubmed);
#     defined $rp       && $self.rp($rp);
#     defined $rg       && $self.rg($rg);
# 	defined $doi      && $self.doi($doi);
#     return $self;
# }


# =head1 AnnotationI implementing functions

# =cut

# =head2 as_text

#  Title   : as_text
#  Usage   :
#  Function:
#  Example :
#  Returns :
#  Args    :


# =cut

method as_text(){
    # this could get out of hand!
    return "Reference: " ~ self.title;
}

# =head2 display_text

#  Title   : display_text
#  Usage   : my $str = $ann.display_text();
#  Function: returns a string. Unlike as_text(), this method returns a string
#            formatted as would be expected for te specific implementation.

#            One can pass a callback as an argument which allows custom text
#            generation; the callback is passed the current instance and any text
#            returned
#  Example :
#  Returns : a string
#  Args    : [optional] callback

# =cut



my $DEFAULT_CB = sub ($self) { $self.title() };

method display_text($cb? is copy) {
    $cb ||= $DEFAULT_CB;
#     $self->throw("Callback must be a code reference") if ref $cb ne 'CODE';
    return $cb.(self);
}

# =head2 hash_tree

#  Title   : hash_tree
#  Usage   :
#  Function:
#  Example :
#  Returns :
#  Args    :


# =cut

method hash_tree(){
    my %h;
    %h{'title'}   = self.title;
    %h{'authors'} = self.authors;
    %h{'location'} = self.location;
    if (defined self.start) {
        %h{'start'}   = self.start;
    }
    if (defined self.end) {
        %h{'end'} = self.end;
    }
    %h{'medline'} = self.medline;
    if (defined self.pubmed) {
        %h{'pubmed'} = self.pubmed;
    }

    return %h;
}

# =head2 tagname

#  Title   : tagname
#  Usage   : $obj.tagname($newval)
#  Function: Get/set the tagname for this annotation value.

#            Setting this is optional. If set, it obviates the need to provide
#            a tag to Bio::AnnotationCollectionI when adding this object. When
#            obtaining an AnnotationI object from the collection, the collection
#            will set the value to the tag under which it was stored unless the
#            object has a tag stored already.
#  Example :
#  Returns : value of tagname (a scalar)
#  Args    : new value (a scalar, optional)


# =cut


# =head1 Specific accessors for References

# =cut


# =head2 start

#  Title   : start
#  Usage   : $self.start($newval)
#  Function: Gives the reference start base
#  Example :
#  Returns : value of start
#  Args    : newvalue (optional)


# =cut

has $!start is rw;    
method start($value?) {
    if ( defined $value) {
        $!start = $value;
    }
    return $!start;
}

# =head2 end

#  Title   : end
#  Usage   : $self.end($newval)
#  Function: Gives the reference end base
#  Example :
#  Returns : value of end
#  Args    : newvalue (optional)


# =cut

has $!end is rw;    
method end($value?) {
    if ( defined $value) {
        $!end = $value;
    }
    return $!end;
} 

# =head2 rp

#  Title   : rp
#  Usage   : $self.rp($newval)
#  Function: Gives the RP line. No attempt is made to parse this line.
#  Example :
#  Returns : value of rp
#  Args    : newvalue (optional)


# =cut

has $!rp is rw;    
method rp($value?) {
    if ( defined $value) {
        $!rp = $value;
    }
    return $!rp;
} 

# =head2 rg

#  Title   : rg
#  Usage   : $obj.rg($newval)
#  Function: Gives the RG line. This is Swissprot/Uniprot specific, and
#            if set will usually be identical to the authors attribute,
#            but the swissprot manual does allow both RG and RA (author)
#            to be present for the same reference.

#  Example :
#  Returns : value of rg (a scalar)
#  Args    : on set, new value (a scalar or undef, optional)


# =cut


has $!rg is rw;    
method rg($value?) {
    if ( defined $value) {
        $!rg = $value;
    }
    return $!rg;
} 

# =head2 authors

#  Title   : authors
#  Usage   : $self.authors($newval)
#  Function: Gives the author line. No attempt is made to parse the author line
#  Example :
#  Returns : value of authors
#  Args    : newvalue (optional)


# =cut

has $!authors is rw;    
method authors($value?){
    if ( defined $value) {
        $!authors = $value;
    }
    return $!authors;
}

# =head2 location

#  Title   : location
#  Usage   : $self.location($newval)
#  Function: Gives the location line. No attempt is made to parse the location line
#  Example :
#  Returns : value of location
#  Args    : newvalue (optional)


# =cut

has $!location is rw;
method location($value?){
    if ( defined $value) {
        $!location = $value;
    }
    return $!location;
}

# =head2 title

#  Title   : title
#  Usage   : $self.title($newval)
#  Function: Gives the title line (if exists)
#  Example :
#  Returns : value of title
#  Args    : newvalue (optional)


# =cut

has $!title is rw;
method title($value?){
    if ( defined $value) {
        $!title = $value;
    }
    return $!title;
}

# =head2 medline

#  Title   : medline
#  Usage   : $self.medline($newval)
#  Function: Gives the medline number
#  Example :
#  Returns : value of medline
#  Args    : newvalue (optional)


# =cut

has $!medline is rw;
method medline($value?){
    if ( defined $value) {
        $!medline = $value;
    }
    return $!medline;
}

# =head2 pubmed

#  Title   : pubmed
#  Usage   : $refobj.pubmed($newval)
#  Function: Get/Set the PubMed number, if it is different from the MedLine
#            number.
#  Example :
#  Returns : value of medline
#  Args    : newvalue (optional)


# =cut

has $!pubmed is rw;
method pubmed($value?) {
    if ( defined $value) {
        $!pubmed = $value;
    }
    return $!pubmed;
}

# =head2 database

#  Title   : database
#  Usage   :
#  Function: Overrides DBLink database to be hard coded to 'MEDLINE' (or 'PUBMED'
#            if only pubmed id has been supplied), unless the database has been
#            set explicitely before.
#  Example :
#  Returns :
#  Args    :


# =cut

multi method database(*@args){
     my $default = 'MEDLINE';
     if (! defined self.medline && defined self.pubmed) {
         $default = 'PUBMED';
     }
     my $value = defined callsame;
     $value ||= $default;
     return  $value;
}

# =head2 primary_id

#  Title   : primary_id
#  Usage   :
#  Function: Overrides DBLink primary_id to provide medline number, or pubmed
#            number if only that has been defined
#  Example :
#  Returns :
#  Args    :


# =cut

# method primary_id{
#     my ($self, @args) = @_;
#     if (@args) {
#         $self.medline(@args);
#     }
#     if (! defined $self.medline && defined $self.pubmed) {
#         return $self.pubmed;
#     }
#     return $self.medline;
# }

# =head2 optional_id

#  Title   : optional_id
#  Usage   :
#  Function: Overrides DBLink optional_id to provide the PubMed number.
#  Example :
#  Returns :
#  Args    :


# =cut

# method optional_id{
#    my ($self, @args) = @_;

#    return $self.pubmed(@args);
# }

# =head2 publisher

#  Title   : publisher
#  Usage   : $self.publisher($newval)
#  Function: Gives the publisher line. No attempt is made to parse the publisher line
#  Example :
#  Returns : value of publisher
#  Args    : newvalue (optional)


# =cut

has $!publisher is rw;    
method publisher($value?) {
    if ( defined $value) {
        $!publisher = $value;
    }
    return $!publisher;
} 

# =head2 editors

#  Title   : editors
#  Usage   : $self.editors($newval)
#  Function: Gives the editors line. No attempt is made to parse the editors line
#  Example :
#  Returns : value of editors
#  Args    : newvalue (optional)


# =cut

has $!editors is rw;    
method editors($value?) {
    if ( defined $value) {
        $!editors = $value;
    }
    return $!editors;
} 


# =head2 encoded_ref

#  Title   : encoded_ref
#  Usage   : $self.encoded_ref($newval)
#  Function: Gives the encoded_ref line. No attempt is made to parse the encoded_ref line
#     (this is added for reading PDB records (REFN record), where this contains
#      ISBN/ISSN/ASTM code)
#  Example :
#  Returns : value of encoded_ref
#  Args    : newvalue (optional)


# =cut

has $!encoded_ref is rw;    
method encoded_ref($value?) {
    if ( defined $value) {
        $!encoded_ref = $value;
    }
    return $!encoded_ref;
} 

# =head2 doi

#  Title   : doi
#  Usage   : $self.doi($newval)
#  Function: Gives the DOI (Digital Object Identifier) from the International
#            DOI Foundation (http://www.doi.org/), which can be used to resolve
# 		   URL links for the full-text documents using:

# 		   http://dx.doi.org/<doi>

#  Example :
#  Returns : value of doi
#  Args    : newvalue (optional)

# =cut

has $!doi is rw;    
method doi($value?) {
    if ( defined $value) {
        $!doi = $value;
    }
    return $!doi;
} 


# =head2 consortium

#  Title   : consortium
#  Usage   : $self.consortium($newval)
#  Function: Gives the consortium line. No attempt is made to parse the consortium line
#  Example :
#  Returns : value of consortium
#  Args    : newvalue (optional)


# =cut

has $!consortium is rw;    
method consortium($value?) {
    if ( defined $value) {
        $!consortium = $value;
    }
    return $!consortium;
} 

# =head2 gb_reference

#  Title   : gb_reference
#  Usage   : $obj.gb_reference($newval)
#  Function: Gives the generic GenBank REFERENCE line. This is GenBank-specific.
#            If set, this includes everything on the reference line except
# 		   the REFERENCE tag and the reference count.  This is mainly a
# 		   fallback for the few instances when REFERENCE lines have unusual
# 		   additional information such as split sequence locations, feature
# 		   references, etc.  See Bug 2020 in Bugzilla for more information.
#  Example :
#  Returns : value of gb_reference (a scalar)
#  Args    : on set, new value (a scalar or undef, optional)


# =cut

has $!gb_reference is rw;    
method gb_reference($value?) {
    if ( defined $value) {
        $!gb_reference = $value;
    }
    return $!gb_reference;
} 

}

# $Id: Reference.pm 15635 2009-04-14 19:11:13Z cjfields $
#
# BioPerl module for Bio::Annotation::Reference
#
# Please direct questions and support issues to <bioperl-l@bioperl.org> 
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>
#
# Copyright Ewan Birney
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

# =head1 NAME

# Bio::Annotation::Reference - Specialised DBLink object for Literature References

# =head1 SYNOPSIS

#     $reg = Bio::Annotation::Reference.new( title    => 'title line',
#                                             location => 'location line',
#                                             authors  => 'author line',
#                                             medline  => 998122 );

# =head1 DESCRIPTION

# Object which presents a literature reference. This is considered to be
# a specialised form of database link. The additional methods provided
# are all set/get methods to store strings commonly associated with
# references, in particular title, location (ie, journal page) and
# authors line.

# There is no attempt to do anything more than store these things as
# strings for processing elsewhere. This is mainly because parsing these
# things suck and generally are specific to the specific format one is
# using. To provide an easy route to go format --E<gt> object --E<gt> format
# without losing data, we keep them as strings. Feel free to post the
# list for a better solution, but in general this gets very messy very
# fast...

# =head1 AUTHOR - Ewan Birney 

# Email birney@ebi.ac.uk

# =head1 APPENDIX

# The rest of the documentation details each of the object
# methods. Internal methods are usually preceded with a _

# =cut


