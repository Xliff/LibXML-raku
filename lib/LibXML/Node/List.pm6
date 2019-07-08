class LibXML::Node::List does Iterable does Iterator {
    use LibXML::Native;
    use LibXML::Node;

    has Bool $.keep-blanks;
    has $.doc is required;
    has $.native is required handles <string-value>;
    has $!cur;
    has $.of is required;
    has LibXML::Node @!store;
    has Bool $!lazy = True;
    has LibXML::Node $!parent; # just to keep the list alive
    submethod TWEAK {
        $!parent = $!of.box: $_ with $!native;
        $!cur = $!native;
    }

    method Array handles<AT-POS elems List list pairs keys values map grep> {
        if $!lazy-- {
            $!cur = $!native;
            @!store = self;
        }
        @!store;
    }
    method push(LibXML::Node:D $node) {
        $!parent.appendChild($node);
        @!store.push($node) unless $!lazy;
        $node;
    } 
    method pop {
        do with self.Array.tail -> LibXML::Node $node {
            @!store.pop;
            $node.unbindNode;
        } // LibXML::Node;
    }
    multi method to-literal( :list($)! where .so ) { self.map(*.string-value) }
    multi method to-literal( :delimiter($_) = '' ) { self.to-literal(:list).join: $_ }
    method Str  { $.to-literal }
    method iterator {
        $!cur = $!native;
        self;
    }
    method pull-one {
        with $!cur -> $this {
            $!cur = $this.next-node($!keep-blanks);
            $!of.box: $this, :$!doc
        }
        else {
            IterationEnd;
        }
    }
    method to-node-set {
        require LibXML::Node::Set;
        my xmlNodeSet:D $native = $!native.list-to-nodeset($!keep-blanks);
        LibXML::Node::Set.new: :$native;
    }
}
