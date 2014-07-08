role Bio::Role::Identify;

# these are the primary data available that are similar to the BioPerl
# Bio::IdentifiableI interface. I've included the primary accession
# (accession_number) in this implementation.

has Str $.id                        is rw;
has Str $.primary_id                is rw;
has Int $.version                   is rw; 
has Str $.authority                 is rw;
has Str $.namespace                 is rw;
has Str $.accession_number          is rw;

method display_id($id?) {
    return self.id($id);
}

method lsid_string returns Str {
  return join(':', self.authority.Str, self.namespace.Str, self.id.Str);
}

method namespace_string returns Str {
  return join(':', ~self.namespace, ~self.id, ~(defined(self.version()) ?? "." ~ self.version !! ''));
}