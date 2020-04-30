unit class LibXML::RegExp;

use LibXML::Enums;
use LibXML::Native;
use LibXML::Node;
use NativeCall;
use LibXML::ErrorHandling;

enum Flags (
    PAT_FROM_ROOT => 1 +< 8,
    PAT_FROM_CUR  => 1 +< 9
);

has xmlRegexp $!native;
method native { $!native }
has UInt $.flags;

submethod TWEAK(Str:D :$regexp!) {
    $!native .= new(:$regexp)
       // die X::LibXML::OpFail.new(:what<RegExp>, :op<Compile>);
}

submethod DESTROY {
    .Free with $!native;
}

method compile(Str:D $regexp, |c) {
    self.new: :$regexp, |c;
}

method !try-bool(Str:D $op, |c) {
    my $rv := $!native."$op"(|c);
    fail X::LibXML::OpFail.new(:what<RegExp>, :$op)
        if $rv < 0;
    $rv > 0;
}

method matches(Str:D() $content) {
    self!try-bool('Match', $content);
}

method isDeterministic {
    self!try-bool('IsDeterministic');
}

multi method ACCEPTS(LibXML::RegExp:D: Str:D $content) {
    self.matches($content);
}

=begin pod

=head1 NAME

LibXML::RegExp - LibXML::RegExp - interface to libxml2 regular expressions

=head1 SYNOPSIS

  =begin code :lang<raku>
  use LibXML::RegExp;
  my LibXML::RegExp $compiled-re .= compile('[0-9]{5}(-[0-9]{4})?');
  my LibXML::RegExp $compiled-re .= new(rexexp => '[0-9]{5}(-[0-9]{4})?');
  if $compiled-re.isDeterministic() { ... }
  if $compiled-re.matches($string) { ... }
  if $string ~~ $compiled-re { ... }

  my LibXML::RegExp $compiled-re .= new( :$regexp );
  my Bool $matched = $compiled-re.matches($string);
  my Bool $det     = $compiled-re.isDeterministic();
  =end code

=head1 DESCRIPTION

This is a Raku interface to libxml2's implementation of regular expressions,
which are used e.g. for validation of XML Schema simple types (pattern facet).

=begin item
new / compile
  =begin code :lang<raku>
  my LibXML::RegExp $compiled-re .= compile( $regexp );
  my LibXML::RegExp $compiled-re .= new( :$regexp );
  =end code
The constructors takes a string containing a regular expression and return an object that contains a compiled regexp.
=end item

=begin item
matches / ACCEPTS
  =begin code :lang<raku>
  my Bool $matched = $compiled-re.matches($string);
  $matched = $string ~~ $compiled-re;
  =end code
Given a string value, returns True if the value is matched by the
compiled regular expression.
=end item

=begin item
isDeterministic()
  =begin code :lang<raku>
  my Bool $det = $compiled-re.isDeterministic();
  =end code
Returns True if the regular expression is deterministic; returns False
otherwise. (See the definition of determinism in the XML spec (L<<<<<< http://www.w3.org/TR/REC-xml/#determinism >>>>>>))

=end item

=head1 COPYRIGHT

2001-2007, AxKit.com Ltd.

2002-2006, Christian Glahn.

2006-2009, Petr Pajas.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under
the terms of the Artistic License 2.0 L<http://www.perlfoundation.org/artistic_license_2_0>.

=end pod