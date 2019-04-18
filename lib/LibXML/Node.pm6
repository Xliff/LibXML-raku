class LibXML::Node {
    use LibXML::Native;
    use LibXML::Native::DOM::Node;
    use LibXML::Enums;
    use LibXML::Namespace;
    use LibXML::XPathExpression;
    use LibXML::Types :NCName, :QName;
    use NativeCall;

    my subset NameVal of Pair where .key ~~ QName:D && .value ~~ Str:D;
    enum <SkipBlanks KeepBlanks>;

    has LibXML::Node $.doc;

    has domNode $.struct handles <
        domCheck
        Str string-value content
        getAttribute getAttributeNS getNamespaceDeclURI
        hasChildNodes hasAttributes hasAttribute hasAttributeNS
        lookupNamespacePrefix lookupNamespaceURI
        removeAttribute removeAttributeNS
        setNamespaceDeclURI setNamespaceDeclPrefix
        URI baseURI nodeName nodeValue
    >;

    BEGIN {
        # wrap methods that return raw nodes
        # simple navigation; no arguments
        for <
             firstChild firstNonBlankChild
             last lastChild
             next nextSibling nextNonBlankSibling
             parent parentNode
             prev previousSibling previousNonBlankSibling
        > {
            $?CLASS.^add_method($_, method { LibXML::Node.box: $.unbox."$_"() });
        }
        # single node argument constructor
        for <appendChild> {
            $?CLASS.^add_method($_, method (LibXML::Node:D $node) { $node.keep( $.unbox."$_"($node.unbox)); });
        }
        for <replaceNode addSibling> {
            $?CLASS.^add_method($_, method (LibXML::Node:D $new) { LibXML::Node.box( $.unbox."$_"($new.unbox)); });
        }
        # single node argument unconstructed
        for <isSameNode> {
            $?CLASS.^add_method($_, method (LibXML::Node:D $n1) { $.unbox."$_"($n1.unbox) });
        }
        # two node arguments
        for <insertBefore insertAfter> {
            $?CLASS.^add_method(
                $_, method (LibXML::Node:D $node, LibXML::Node $ref) {
                    $node.keep: $.unbox."$_"($node.unbox, do with $ref {.unbox} else {domNode});
                });
        }
    }

    method ownerElement { $.parentNode }
    method replaceChild(LibXML::Node $new, LibXML::Node $node) {
        $node.keep: $.unbox.replaceChild($new.unbox, $node.unbox),
    }
    method appendText(Str:D $text) {
        $.unbox.appendText($text);
    }

    method struct is rw {
        Proxy.new(
            FETCH => sub ($) { $!struct },
            STORE => sub ($, domNode:D $new-struct) {
                given box-class($new-struct.type) -> $class {
                    die "mismatch between DOM node of type {$new-struct.type} ({$class.perl}) and container object of class {self.WHAT.perl}"
                        unless $class ~~ self.WHAT|LibXML::Namespace;
                }
                .remove-reference with $!struct;
                .add-reference with $new-struct;
                $!struct = cast-struct($new-struct);
            },
        );
    }

    submethod TWEAK {
        .add-reference with $!struct;
    }

    method doc is rw {
        Proxy.new(
            FETCH => sub ($) {
                with self {
                    with .unbox.doc -> xmlDoc $struct {
                        $!doc = box-class(XML_DOCUMENT_NODE).box($struct)
                            if ! ($!doc && !$!doc.unbox.isSameNode($struct));
                    }
                    else {
                        $!doc = Nil;
                    }
                    $!doc;
                }
                else {
                    LibXML::Node;
                }
            },
            STORE => sub ($, LibXML::Node $doc) {
                with $doc {
                    unless ($!doc && $doc.isSameNode($!doc)) || $doc.isSameNode(self) {
                        $doc.adoptNode(self);
                    }
                }
                $!doc = $doc;
            },
        );
    }

    method nodeType    { $.unbox.type }
    method tagName     { $.nodeName }
    method name        { $.nodeName }
    method getName     { $.nodeName }
    method localname   { $.unbox.name }
    method line-number { $.unbox.GetLineNo }
    method prefix      { with $.unbox.ns {.prefix} else { Str } }

    sub box-class(UInt $_) {
        when XML_ATTRIBUTE_NODE     { require LibXML::Attr }
        when XML_ATTRIBUTE_DECL     { require LibXML::AttrDecl }
        when XML_CDATA_SECTION_NODE { require LibXML::CDATASection }
        when XML_COMMENT_NODE       { require LibXML::Comment }
        when XML_DTD_NODE           { require LibXML::Dtd }
        when XML_DOCUMENT_FRAG_NODE { require LibXML::DocumentFragment }
        when XML_DOCUMENT_NODE
           | XML_HTML_DOCUMENT_NODE { require LibXML::Document }
        when XML_ELEMENT_NODE       { require LibXML::Element }
        when XML_ELEMENT_DECL       { require LibXML::ElementDecl }
        when XML_ENTITY_DECL        { require LibXML::EntityDecl }
        when XML_ENTITY_REF_NODE    { require LibXML::EntityRef }
        when XML_NAMESPACE_DECL     { require LibXML::Namespace }
        when XML_PI_NODE            { require LibXML::PI }
        when XML_TEXT_NODE          { require LibXML::Text }

        default {
            warn "node content-type not yet handled: $_";
            LibXML::Node;
        }
    }

    sub struct-class(UInt $_) {
        when XML_ATTRIBUTE_NODE     { xmlAttr }
        when XML_ATTRIBUTE_DECL     { xmlAttrDecl }
        when XML_CDATA_SECTION_NODE { xmlCDataNode }
        when XML_COMMENT_NODE       { xmlCommentNode }
        when XML_DOCUMENT_FRAG_NODE { xmlDocFrag }
        when XML_DTD_NODE           { xmlDtd }
        when XML_DOCUMENT_NODE      { xmlDoc }
        when XML_HTML_DOCUMENT_NODE { htmlDoc }
        when XML_ELEMENT_NODE       { xmlNode }
        when XML_ELEMENT_DECL       { xmlElementDecl }
        when XML_ENTITY_DECL        { xmlEntityDecl }
        when XML_ENTITY_REF_NODE    { xmlEntityRefNode }
        when XML_NAMESPACE_DECL     { xmlNs }
        when XML_PI_NODE            { xmlPINode }
        when XML_TEXT_NODE          { xmlTextNode }
        default {
            warn "node content-type not yet handled: $_";
            domNode;
        }
    }

    proto sub unbox($) is export(:unbox) {*}
    multi sub unbox(LibXML::XPathExpression:D $_) { .unbox }
    multi sub unbox(LibXML::Node:D $_) { .unbox }
    multi sub unbox(LibXML::Namespace:D $_) { .unbox }
    multi sub unbox($_) is default  { $_ }

    our sub cast-struct(domNode:D $struct is raw) {
        my $delegate := struct-class($struct.type);
        nativecast( $delegate, $struct);
    }

    sub cast-elem(xmlNodeSetElem:D $elem is raw) {
        $elem.type == XML_NAMESPACE_DECL
            ?? nativecast(xmlNs, $elem)
            !! cast-struct( nativecast(domNode, $elem) );
    }

    method unbox {$!struct}

    method box(LibXML::Native::DOM::Node $struct,
               LibXML::Node :$doc is copy = $.doc, # reusable document object
              ) {
        with $struct {
            my $class := box-class(.type);
            die "mismatch between DOM node of type {.type} ({$class.perl}) and container object of class {self.WHAT.perl}"
                    unless $class ~~ self.WHAT|LibXML::Namespace;
            $class.new: :struct(cast-struct($_)), :$doc;
        }
        else {
            self.WHAT
        }
    }

    method keep(LibXML::Native::DOM::Node $raw,
                LibXML::Node :$doc is copy = $.doc, # reusable document object
                --> LibXML::Node) {
        with $raw {
            if self.defined && unbox(self).isSameNode($_) {
                self;
            }
            else {
                # create a new box object. reuse document object, if possible
                die "returned unexpected node: {$.Str}"
                    with self;
                self.box: $_, :$doc;
            }
        }
        else {
            self.WHAT;
        }
    }

    my class List does Iterable does Iterator {
        has Bool $.keep-blanks;
        has $.doc is required;
        has $.cur is required;
        has $.type = LibXML::Node;
        method iterator { self }
        method pull-one {
            my $this = $!cur;
            $_ = .next-node($!keep-blanks) with $!cur;
            with $this {
                $!type.box: $_, :$!doc
            }
            else {
                IterationEnd;
            }
        }
    }
    proto sub iterate(|) is export(:iterate) {*}
    multi sub iterate($obj, domNode $start, :$doc = $obj.doc, Bool :$keep-blanks = True) {
        # follow a chain of .next links.
        List.new: :type($obj), :cur($start), :$doc, :$keep-blanks;
    }

    my class Set does Iterable does Iterator {
        has $.range is required;
        has xmlNodeSet $.set is required;
        has UInt $!idx = 0;
        submethod TWEAK {
            .Reference with $!set;
        }
        submethod DESTROY {
            # xmlNodeSet is managed by us
            .Release with $!set;
        }
        multi method AT-POS(UInt:D $pos where $_ >= $!set.nodeNr) { Nil }
        multi method AT-POS(UInt:D $pos) {
            given $!set.nodeTab[$pos].deref {
                my $class = box-class(.type);
                die "unexpected node of type {$class.perl} in node-set"
                    unless $class ~~ $!range;

                $class.box: cast-elem($_);
            }
        }
        method size { $!set.nodeNr }
        method iterator { self }
        method pull-one {
            if $!set.defined && $!idx < $!set.nodeNr {
                self.AT-POS($!idx++);
            }
            else {
                IterationEnd;
            }
        }
    }

    multi sub iterate($range, xmlNodeSet $set) {
        # iterate through a set of nodes
        Set.new( :$set, :$range )
    }

    method ownerDocument is rw { $.doc }
    method setOwnerDocument(LibXML::Node:D $_) { self.doc = $_ }
    my subset AttrNode of LibXML::Node where { !.defined || .nodeType == XML_ATTRIBUTE_NODE };
    multi method addChild(AttrNode:D $a) { $.setAttributeNode($a) };
    multi method addChild(LibXML::Node $c) is default { $.appendChild($c) };
    method textContent { $.string-value }
    method to-literal { $.string-value }
    method unbindNode {
        $.unbox.Unlink;
        $!doc = LibXML::Node;
        self;
    }
    method childNodes {
        iterate(LibXML::Node, $.unbox.first-child(KeepBlanks));
    }
    method nonBlankChildNodes {
        iterate(LibXML::Node, $.unbox.first-child(SkipBlanks), :!keep-blanks);
    }
    method getElementsByTagName(Str:D $name) {
        iterate(LibXML::Node, $.unbox.getElementsByTagName($name));
    }
    method getElementsByLocalName(Str:D $name) {
        iterate(LibXML::Node, $.unbox.getElementsByLocalName($name));
    }
    method getElementsByTagNameNS(Str $uri, Str $name) {
        iterate(LibXML::Node, $.unbox.getElementsByTagNameNS($uri, $name));
    }
    method getChildrenByLocalName(Str:D $name) {
        iterate(LibXML::Node, $.unbox.getChildrenByLocalName($name));
    }
    method getChildrenByTagName(Str:D $name) {
        iterate(LibXML::Node, $.unbox.getChildrenByTagName($name));
    }
    method getChildrenByTagNameNS(Str:D $uri, Str:D $name) {
        iterate(LibXML::Node, $.unbox.getChildrenByTagNameNS($uri, $name));
    }
    my subset XPathDomain is export(:XPathDomain) where LibXML::XPathExpression|Str;
    my subset XPathRange is export(:XPathRange) where LibXML::Node|LibXML::Namespace;
    method findnodes(XPathDomain:D $xpath-expr) {
        my xmlNodeSet:D $node-set := $.unbox.findnodes: unbox($xpath-expr);
        iterate(XPathRange, $node-set);
    }
    method find(XPathDomain:D $xpath-expr, Bool:D $to-bool = False) {
        given $.unbox.find( unbox($xpath-expr), $to-bool) {
            when xmlNodeSet:D { iterate(XPathRange, $_) }
            default { $_ }
        }
    }
    method findvalue(XPathDomain:D $xpath-expr) {
        given $.unbox.find( unbox($xpath-expr), False) {
            with iterate(XPathRange, $_).pull-one {
                .string-value;
            }
            else {
                Str;
            }
        }
    }
    method exists(XPathDomain:D $xpath-expr --> Bool:D) {
        $.find($xpath-expr, True);
    }
    multi method setAttribute(NameVal:D $_) {
        $.unbox.setAttribute(.key, .value);
    }
    multi method setAttribute(QName $name, Str:D $value) {
        $.unbox.setAttribute($name, $value);
    }
    method setAttributeNode(AttrNode:D $att) {
        $att.keep: $.unbox.setAttributeNode($att.unbox);
    }
    method setAttributeNodeNS(AttrNode:D $att) {
        $att.keep: $.unbox.setAttributeNodeNS($att.unbox);
    }
    multi method setAttributeNS(Str $uri, NameVal:D $_) {
        $.unbox.setAttributeNS($uri, .key, .value);
    }
    multi method setAttributeNS(Str $uri, QName $name, Str $value) {
        box-class(XML_ATTRIBUTE_NODE).box: $.unbox.setAttributeNS($uri, $name, $value);
    }
    method getAttributeNode(Str $att-name --> LibXML::Node) {
        box-class(XML_ATTRIBUTE_NODE).box: $.unbox.getAttributeNode($att-name);
    }
    method getAttributeNodeNS(Str $uri, Str $att-name --> LibXML::Node) {
        box-class(XML_ATTRIBUTE_NODE).box: $.unbox.getAttributeNodeNS($uri, $att-name);
    }
    method setNamespace(Str $uri, NCName $prefix?, Bool:D() $flag = True) {
        $.unbox.setNamespace($uri, $prefix, $flag);
    }
    method localNS {
        LibXML::Namespace.box: $.unbox.localNS;
    }
    method getNamespaces {
        $.unbox.getNamespaces.map: { LibXML::Namespace.box($_) }
    }
    method namespaces { $.getNamespaces }
    method namespaceURI(--> Str) { with $.unbox.ns {.href} else {Str} }
    method getNamespaceURI { $.namespaceURI }
    method removeChild(LibXML::Node:D $node --> LibXML::Node) {
        $node.keep: $.unbox.removeChild($node.unbox);
    }
    method removeAttributeNode(AttrNode $att) {
        $att.keep: $.unbox.removeAttributeNode($att.unbox);
    }
    method removeChildNodes(--> LibXML::Node) {
        LibXML::Node.box: $.unbox.removeChildNodes;
    }
    multi method appendTextChild(NameVal:D $_) {
        $.unbox.appendTextChild(.key, .value);
    }
    multi method appendTextChild(QName:D $name, Str $value?) {
        $.unbox.appendTextChild($name, $value);
    }
    method addNewChild(Str $uri, QName $name) {
        LibXML::Node.box: $.unbox.domAddNewChild($uri, $name);
    }
    method normalise { self.unbox.normalize }
    method normalize { self.unbox.normalize }
    method cloneNode(LibXML::Node:D: Bool() $deep) {
        my domNode:D $struct = $.unbox.cloneNode($deep);
        self.new: :$struct, :$.doc;
    }

    multi method write(IO::Handle :$io!, Bool :$format = False) {
        $io.write: self.Blob(:$format);
    }

    multi method write(IO() :io($path)!, |c) {
        my IO::Handle $io = $path.open(:bin, :w);
        $.write(:$io, |c);
        $io;
    }

    multi method write(IO() :file($io)!, |c) {
        $.write(:$io, |c).close;
    }

    submethod DESTROY {
        with $!struct {
            if .remove-reference {
                # this particular node is no longer referenced directly
                given .root {
                    # release or keep the tree, in it's entirety
                    .Free unless .is-referenced;
                }
            }
        }
    }
}
