use LibXML::Attr;
use LibXML::Enums;
use LibXML::Node;
use LibXML::Native;
use LibXML::Types :NCName;
use NativeCall;

class LibXML::Attr::Map {...}

# namespace aware version of LibXML::Attr::Map
class LibXML::Attr::MapNs does Associative {
    trusts LibXML::Attr::Map;
    has LibXML::Node $.node;
    has Str:D $.uri is required;
    has LibXML::Attr:D %!store handles<EXISTS-KEY Numeric keys pairs kv elems list values List>;
    method TWEAK { $!node.requireNamespace($!uri) } # vivify namespace

    method !unlink(Str:D $key) {
        $!node.removeChild($_)
            with %!store{$key}:delete;
    }
    method !store(Str:D $name, LibXML::Attr:D $att) {
        self!unlink($name);
        %!store{$name} = $att;
    }

    method AT-KEY($key) is rw {
        %!store{$key};
    }

    multi method ASSIGN-KEY(Str() $name, Str() $val) {
        self!store($name, $!node.setAttributeNS($!uri, $name, $val));
    }

    method BIND-KEY(Str() $name, Str() $val) {
        self!unlink($name);
        %!store{$name} := $!node.setAttributeNS($!uri, $name, $val);
    }

    method DELETE-KEY(Str() $name) {
        self!unlink($name);
    }
}

class LibXML::Attr::Map does Associative {
    has LibXML::Node $.node;
    has xmlNs %!ns;
    my subset MapNode where LibXML::Attr:D|LibXML::Attr::MapNs:D;
    has MapNode %!store handles <EXISTS-KEY Numeric keys pairs kv elems>;

    submethod TWEAK() {
        with $!node.native.properties -> domNode $prop is copy {
            my LibXML::Node $doc = $!node.doc;
            require LibXML::Attr;
            while $prop.defined {
                if $prop.type == XML_ATTRIBUTE_NODE {
                    my xmlAttr $native := nativecast(xmlAttr, $prop);
                    my $att := LibXML::Attr.new: :$native, :$doc;
                    self!tie-att($att);
                }

                $prop = $prop.next;
            }
        }
    }

    method !unlink(Str:D $key) {
        with %!store{$key}:delete {
             when LibXML::Attr::MapNs {
                 for .keys -> $key {
                     .DELETE-KEY($key);
                 }
             }
             when LibXML::Node {
                 $!node.removeAttribute($key)
             }
        }
    }
    method !store(Str:D $name, MapNode:D $att) {
        self!unlink($name);
        %!store{$name} = $att;
    }

    method AT-KEY($key) is rw {
        Proxy.new(
            FETCH => sub ($) {
                %!store{$key};
            },
            STORE => sub ($, Hash $ns) {
                # for autovivication
                self.ASSIGN-KEY($key, $ns);
            },
        );
    }

    # merge in new attributes;
    multi method ASSIGN-KEY(Str() $uri, LibXML::Attr::MapNs $ns-atts) {
        self!store($ns-atts.uri, $ns-atts);
    }

    multi method ASSIGN-KEY(Str() $uri, Hash $atts) {
        # plain hash; need to coerce
        my LibXML::Attr::MapNs $ns-map .= new: :$!node, :$uri;
        for $atts.pairs {
            $ns-map{.key} = .value;
        }
        # redispatch
        self.ASSIGN-KEY($uri, $ns-map);
    }

    multi method ASSIGN-KEY(Str() $name, Str:D $val) is default {
        $!node.setAttribute($name, $val);
        self!store($name, $!node.getAttributeNode($name));
    }

    method DELETE-KEY(Str() $key) {
        self!unlink($key);
    }

    method !tie-att(LibXML::Attr:D $att) {
        my Str:D $name = $att.native.getNodeName;
        my Str $uri;
        my ($prefix, $local-name) = $name.split(':', 2);

        if $local-name {
            with $!node.doc {
                %!ns{$prefix} = .native.SearchNs($!node.native, $prefix)
                    unless %!ns{$prefix}:exists;

                with %!ns{$prefix} -> $ns {
                    $uri = $ns.href;
                }
            }
        }

        with $uri {
            self{$_} = %()
                unless self{$_} ~~ LibXML::Attr::MapNs;

            $_!LibXML::Attr::MapNs::store($local-name, $att)
                given %!store{$_};
        }
        else {
            self!store($name, $att);
        }

    }

    # DOM Support
    method setNamedItem(LibXML::Attr:D $att) {
        $!node.addChild($att);
        self!tie-att($att);
    }
    method setNamedItemNS(Str $uri, LibXML::Attr:D $att) {
        my $cur-uri = $att.getNamespaceURI;
        # todo: allow namespace update on attributes?
        fail "changing attribute namespace is not supported"
            unless (!$uri && !$cur-uri) || $cur-uri ~~ $uri;
        $.setNamedItem($att);
    }
    method getNamedItemNS(Str $uri, LibXML::Attr:D $att) {
        .<att> with self{$uri};
    }


    method removeNamedItem(Str:D $name) {
        self{$name}:delete;
    }
    method removeNamedItemNS(Str $uri, Str:D $name) {
        $uri ?? (.{$name}:delete with self{$uri}) !! (self{$name}:delete);
    }
}

=begin pod
=head1 NAME

LibXML::Attr::Map - LibXML Class for Mapped Attributes

=head1 SYNOPSIS

  use LibXML::Attr::Map;
  use LibXML::Document;
  use LibXML::Element;
  my LibXML::Document $doc .= parse('<foo att1="AAA" att2="BBB">');
  my LibXML::Element $node = $doc.root;
  my LibXML::Attr::Map $atts = $node.attributes;

  say $atts.keys.sort;  # att1 att2
  say $atts<att1>.Str ; # AAA
  say $atts<att1>.gist; # att1="AAA"
  $atts<att2>:delete;
  $atts<att3> = "CCC";
  say $node.Str; # <foo att1="AAA" att3="CCC">


=head1 DESCRIPTION

This class is roughly equivalent to the W3C DOM NamedNodeMap and (Perl 5's XML::LibXML::NamedNodeMap). This implementation currently limits their use to manipulation
of an element's attributes.

It presents a tied hash-like mapping of attributes to attribute names.

=head2 Updating Attributes

Attributes can be created, updated or deleted associatively:

  my LibXML::Attr::Map $atts = $node.attributes;

  $atts<style> = 'fontweight: bold';
  my LibXML::Attr $style = $atts<style>;
  $atts<style>:delete; # remove the style

There are also some DOM (NamedNodeMap) compatible methods:

   $atts.setNamedItem('style', 'fontweight: bold');
   my LibXML::Attr $style = $attr.getNamedItem('style');
   $atts.removeNamedItem('style');

=head2 Namespaces

Attributes with namespaces are stored in a nested, map under the namespace's URL.

  <foo
    att1="AAA" att2="BBB"
    xmlns:x="http://myns.org" x:att3="CCC"
  />
  EOF

  my LibXML::Element $node = $doc.root;
  my LibXML::Attr::Map $atts = $node.attributes;

  say $atts.keys.sort;  # att1 att2 http://myns.org
  say $atts<http://myns.org>.keys; # att3
  my LibXML::Attr $att3 = $atts<http://myns.org><att3>;
  # assign to a new namespace
  my $foo-bar = $attrs<http://www.foo.com/><bar> = 'baz';

The C<:!ns> option filters out any attributes with qaulified namedspaces:
  
  my LibXML::Attr::Map $atts = $node.attributes: :!ns;
  say $atts.keys.sort;  # att1 att2


=head1 METHODS

=begin item1
keys, pairs, kv, elems, values, list

Similar to the equivalent L<Hash|https://docs.perl6.org/type/Hash> methods.

=end item1

=begin item1
setNamedItem

  $map.setNamedItem($new_node)

Sets the node with the same name as C<<<<<< $new_node >>>>>> to C<<<<<< $new_node >>>>>>.

=end item1

=begin item1
removeNamedItem

  $map.removeNamedItem($name)

Remove the item with the name C<<<<<< $name >>>>>>.

=end item1

=begin item1
getNamedItemNS

   my LibXML::Attr $att = $map.getNamedItemNS($uri, $name);

C<$map.getNamedItemNS($uri,$name)> is similar to C<$map{$uri}{$name}>.

=end item1

=begin item1
setNamedItemNS

I<<<<<< Not implemented yet. >>>>>>. 

=end item1

=begin item1
removeNamedItemNS

  $map.removeNamedItemNS($uri, $name);

C<$map.removedNamedItemNS($uri,$name)> is similar to C<$map{$uri}{$name}:delete>.

=end item1

=end pod



