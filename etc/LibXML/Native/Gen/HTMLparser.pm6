use v6;
#  -- DO NOT EDIT --
# generated by: etc/generator.p6 

unit module LibXML::Native::Gen::HTMLparser;
# interface for an HTML 4.0 non-verifying parser:
#    this module implements an HTML 4.0 non-verifying parser with API compatible with the XML parser ones. It should be able to parse "real world" HTML, even if severely broken from a specification point of view. 
use LibXML::Native::Defs :LIB, :xmlCharP;

enum htmlParserOption is export (
    HTML_PARSE_COMPACT => 65536,
    HTML_PARSE_IGNORE_ENC => 2097152,
    HTML_PARSE_NOBLANKS => 256,
    HTML_PARSE_NODEFDTD => 4,
    HTML_PARSE_NOERROR => 32,
    HTML_PARSE_NOIMPLIED => 8192,
    HTML_PARSE_NONET => 2048,
    HTML_PARSE_NOWARNING => 64,
    HTML_PARSE_PEDANTIC => 128,
    HTML_PARSE_RECOVER => 1,
)

enum htmlStatus is export (
    HTML_DEPRECATED => 2,
    HTML_INVALID => 1,
    HTML_NA => 0,
    HTML_REQUIRED => 12,
    HTML_VALID => 4,
)

class htmlElemDesc is repr('CStruct') {
    has Str $.name; # The tag name
    has byte $.startTag; # Whether the start tag can be implied
    has byte $.endTag; # Whether the end tag can be implied
    has byte $.saveEndTag; # Whether the end tag should be saved
    has byte $.empty; # Is this an empty element ?
    has byte $.depr; # Is this a deprecated element ?
    has byte $.dtd; # 1: only in Loose DTD, 2: only Frameset one
    has byte $.isinline; # is this a block 0 or inline 1 element
    has Str $.desc; # the description NRK Jan.2003 * New fields encapsulating HTML structure * * Bugs: * This is a very limited representation.  It fails to tell us when * an element *requires* subelements (we only have whether they're * allowed or not), and it doesn't tell us where CDATA and PCDATA * are allowed.  Some element relationships are not fully represented: * these are flagged with the word MODIFIER *
    has const char ** $.subelts; # allowed sub-elements of this element
    has Str $.defaultsubelt; # subelement for suggested auto-repair if necessary or NULL
    has const char ** $.attrs_opt; # Optional Attributes
    has const char ** $.attrs_depr; # Additional deprecated attributes
    has const char ** $.attrs_req; # Required attributes
}

class htmlEntityDesc is repr('CStruct') {
    has uint32 $.value; # the UNICODE value for the character
    has Str $.name; # The entity name
    has Str $.desc; # the description
}

sub UTF8ToHtml(unsigned char * $out, Pointer[int32] $outlen, const unsigned char * $in, Pointer[int32] $inlen --> int32) is native(LIB) is export {*};
sub htmlAttrAllowed(const htmlElemDesc * $elt, xmlCharP $attr, int32 $legacy --> htmlStatus) is native(LIB) is export {*};
sub htmlAutoCloseTag(htmlDoc $doc, xmlCharP $name, htmlNode $elem --> int32) is native(LIB) is export {*};
sub htmlCreateMemoryParserCtxt(Str $buffer, int32 $size --> htmlParserCtxt) is native(LIB) is export {*};
sub htmlCreatePushParserCtxt(htmlSAXHandler $sax, Pointer $user_data, Str $chunk, int32 $size, Str $filename, xmlCharEncoding $enc --> htmlParserCtxt) is native(LIB) is export {*};
sub htmlCtxtReadDoc(htmlParserCtxt $ctxt, xmlCharP $cur, Str $URL, Str $encoding, int32 $options --> htmlDoc) is native(LIB) is export {*};
sub htmlCtxtReadFd(htmlParserCtxt $ctxt, int32 $fd, Str $URL, Str $encoding, int32 $options --> htmlDoc) is native(LIB) is export {*};
sub htmlCtxtReadFile(htmlParserCtxt $ctxt, Str $filename, Str $encoding, int32 $options --> htmlDoc) is native(LIB) is export {*};
sub htmlCtxtReadIO(htmlParserCtxt $ctxt, xmlInputReadCallback $ioread, xmlInputCloseCallback $ioclose, Pointer $ioctx, Str $URL, Str $encoding, int32 $options --> htmlDoc) is native(LIB) is export {*};
sub htmlCtxtReadMemory(htmlParserCtxt $ctxt, Str $buffer, int32 $size, Str $URL, Str $encoding, int32 $options --> htmlDoc) is native(LIB) is export {*};
sub htmlCtxtReset(htmlParserCtxt $ctxt) is native(LIB) is export {*};
sub htmlCtxtUseOptions(htmlParserCtxt $ctxt, int32 $options --> int32) is native(LIB) is export {*};
sub htmlElementAllowedHere(const htmlElemDesc * $parent, xmlCharP $elt --> int32) is native(LIB) is export {*};
sub htmlElementStatusHere(const htmlElemDesc * $parent, const htmlElemDesc * $elt --> htmlStatus) is native(LIB) is export {*};
sub htmlEncodeEntities(unsigned char * $out, Pointer[int32] $outlen, const unsigned char * $in, Pointer[int32] $inlen, int32 $quoteChar --> int32) is native(LIB) is export {*};
sub htmlEntityLookup(xmlCharP $name --> const htmlEntityDesc *) is native(LIB) is export {*};
sub htmlEntityValueLookup(uint32 $value --> const htmlEntityDesc *) is native(LIB) is export {*};
sub htmlFreeParserCtxt(htmlParserCtxt $ctxt) is native(LIB) is export {*};
sub htmlHandleOmittedElem(int32 $val --> int32) is native(LIB) is export {*};
sub htmlIsAutoClosed(htmlDoc $doc, htmlNode $elem --> int32) is native(LIB) is export {*};
sub htmlIsScriptAttribute(xmlCharP $name --> int32) is native(LIB) is export {*};
sub htmlNewParserCtxt( --> htmlParserCtxt) is native(LIB) is export {*};
sub htmlNodeStatus(const htmlNode $node, int32 $legacy --> htmlStatus) is native(LIB) is export {*};
sub htmlParseCharRef(htmlParserCtxt $ctxt --> int32) is native(LIB) is export {*};
sub htmlParseChunk(htmlParserCtxt $ctxt, Str $chunk, int32 $size, int32 $terminate --> int32) is native(LIB) is export {*};
sub htmlParseDoc(xmlCharP $cur, Str $encoding --> htmlDoc) is native(LIB) is export {*};
sub htmlParseDocument(htmlParserCtxt $ctxt --> int32) is native(LIB) is export {*};
sub htmlParseElement(htmlParserCtxt $ctxt) is native(LIB) is export {*};
sub htmlParseEntityRef(htmlParserCtxt $ctxt, const xmlChar ** $str --> const htmlEntityDesc *) is native(LIB) is export {*};
sub htmlParseFile(Str $filename, Str $encoding --> htmlDoc) is native(LIB) is export {*};
sub htmlReadDoc(xmlCharP $cur, Str $URL, Str $encoding, int32 $options --> htmlDoc) is native(LIB) is export {*};
sub htmlReadFd(int32 $fd, Str $URL, Str $encoding, int32 $options --> htmlDoc) is native(LIB) is export {*};
sub htmlReadFile(Str $filename, Str $encoding, int32 $options --> htmlDoc) is native(LIB) is export {*};
sub htmlReadIO(xmlInputReadCallback $ioread, xmlInputCloseCallback $ioclose, Pointer $ioctx, Str $URL, Str $encoding, int32 $options --> htmlDoc) is native(LIB) is export {*};
sub htmlReadMemory(Str $buffer, int32 $size, Str $URL, Str $encoding, int32 $options --> htmlDoc) is native(LIB) is export {*};
sub htmlSAXParseDoc(xmlCharP $cur, Str $encoding, htmlSAXHandler $sax, Pointer $userData --> htmlDoc) is native(LIB) is export {*};
sub htmlSAXParseFile(Str $filename, Str $encoding, htmlSAXHandler $sax, Pointer $userData --> htmlDoc) is native(LIB) is export {*};
sub htmlTagLookup(xmlCharP $tag --> const htmlElemDesc *) is native(LIB) is export {*};