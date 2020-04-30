NAME
====

LibXML::CDATA - LibXML Class for CDATA Sections

SYNOPSIS
========

```raku
use LibXML::CDATA;
# Only methods specific to CDATA nodes are listed here,
# see the LibXML::Node documentation for other methods

my LibXML::CDATA $cdata .= new( :$content );

$cdata.data ~~ s/xxx/yyy/; # Stringy Interface - see LibXML::Text
```

DESCRIPTION
===========

This class provides all functions of [LibXML::Text ](https://libxml-raku.github.io/LibXML-raku/Text), but for CDATA nodes.

METHODS
=======

The class inherits from [LibXML::Node ](https://libxml-raku.github.io/LibXML-raku/Node). The documentation for Inherited methods is not listed here.

Many functions listed here are extensively documented in the DOM Level 3 specification ([http://www.w3.org/TR/DOM-Level-3-Core/ ](http://www.w3.org/TR/DOM-Level-3-Core/ )). Please refer to the specification for extensive documentation.

  * new

    ```raku
    my LibXML::CDATA $node .= new( :$content );
    ```

    The constructor is the only provided function for this package. It is required, because *libxml2 * treats the different text node types slightly differently.

COPYRIGHT
=========

2001-2007, AxKit.com Ltd.

2002-2006, Christian Glahn.

2006-2009, Petr Pajas.

LICENSE
=======

This program is free software; you can redistribute it and/or modify it under the terms of the Artistic License 2.0 [http://www.perlfoundation.org/artistic_license_2_0](http://www.perlfoundation.org/artistic_license_2_0).
