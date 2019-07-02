use v6;
unit class LibXML::Enums;

enum xmlElementType is export (
   XML_ELEMENT_NODE => 1,
   XML_ATTRIBUTE_NODE => 2,
   XML_TEXT_NODE => 3,
   XML_CDATA_SECTION_NODE => 4,
   XML_ENTITY_REF_NODE => 5,
   XML_ENTITY_NODE => 6,
   XML_PI_NODE => 7,
   XML_COMMENT_NODE => 8,
   XML_DOCUMENT_NODE => 9,
   XML_DOCUMENT_TYPE_NODE => 10,
   XML_DOCUMENT_FRAG_NODE => 11,
   XML_NOTATION_NODE => 12,
   XML_HTML_DOCUMENT_NODE => 13,
   XML_DTD_NODE => 14,
   XML_ELEMENT_DECL => 15,
   XML_ATTRIBUTE_DECL => 16,
   XML_ENTITY_DECL => 17,
   XML_NAMESPACE_DECL => 18,
   XML_XINCLUDE_START => 19,
   XML_XINCLUDE_END => 20,
   XML_DOCB_DOCUMENT_NODE => 21
);

enum xmlParserOption is export (
   XML_PARSE_RECOVER => 1,
   XML_PARSE_NOENT => 2,
   XML_PARSE_DTDLOAD => 4,
   XML_PARSE_DTDATTR => 8,
   XML_PARSE_DTDVALID => 16,
   XML_PARSE_NOERROR => 32,
   XML_PARSE_NOWARNING => 64,
   XML_PARSE_PEDANTIC => 128,
   XML_PARSE_NOBLANKS => 256,
   XML_PARSE_SAX1 => 512,
   XML_PARSE_XINCLUDE => 1024,
   XML_PARSE_NONET => 2048,
   XML_PARSE_NODICT => 4096,
   XML_PARSE_NSCLEAN => 8192,
   XML_PARSE_NOCDATA => 16384,
   XML_PARSE_NOXINCNODE => 32768,
   XML_PARSE_COMPACT => 65536,
   XML_PARSE_OLD10 => 131072,
   XML_PARSE_NOBASEFIX => 262144,
   XML_PARSE_HUGE => 524288,
   XML_PARSE_OLDSAX => 1048576,
   XML_PARSE_IGNORE_ENC => 2097152,
   XML_PARSE_BIG_LINES => 4194304
);

enum htmlParserOption is export (
   HTML_PARSE_RECOVER => 1,
   HTML_PARSE_NODEFDTD => 4,
   HTML_PARSE_NOERROR => 32,
   HTML_PARSE_NOWARNING => 64,
   HTML_PARSE_PEDANTIC => 128,
   HTML_PARSE_NOBLANKS => 256,
   HTML_PARSE_NONET => 2048,
   HTML_PARSE_NOIMPLIED => 8192,
   HTML_PARSE_COMPACT => 65536,
   HTML_PARSE_IGNORE_ENC => 2097152
);

my enum xmlAttributeDefault is export (
    XML_ATTRIBUTE_NONE => 1,
    'XML_ATTRIBUTE_REQUIRED',
    'XML_ATTRIBUTE_IMPLIED',
    'XML_ATTRIBUTE_FIXED'
);

my enum xmlXPathObjectType is export (
    XPATH_UNDEFINED => 0,
    XPATH_NODESET => 1,
    XPATH_BOOLEAN => 2,
    XPATH_NUMBER => 3,
    XPATH_STRING => 4,
    XPATH_POINT => 5,
    XPATH_RANGE => 6,
    XPATH_LOCATIONSET => 7,
    XPATH_USERS => 8,
    XPATH_XSLT_TREE => 9  # An XSLT value tree, non modifiable
);

enum xmlSaveOption is export (
   XML_SAVE_FORMAT => 1,
   XML_SAVE_NO_DECL => 2,
   XML_SAVE_NO_EMPTY => 4,
   XML_SAVE_NO_XHTML => 8,
   XML_SAVE_XHTML => 16,
   XML_SAVE_AS_XML => 32,
   XML_SAVE_AS_HTML => 64,
   XML_SAVE_NO_WS => 128,
);

enum xmlParserProperties is export (
    XML_PARSER_LOADDTD => 1,
    XML_PARSER_DEFAULTATTRS => 2,
    XML_PARSER_VALIDATE => 3,
    XML_PARSER_SUBST_ENTITIES => 4
);

enum xmlReaderTypes is export (
    XML_READER_TYPE_NONE => 0,
    XML_READER_TYPE_ELEMENT => 1,
    XML_READER_TYPE_ATTRIBUTE => 2,
    XML_READER_TYPE_TEXT => 3,
    XML_READER_TYPE_CDATA => 4,
    XML_READER_TYPE_ENTITY_REFERENCE => 5,
    XML_READER_TYPE_ENTITY => 6,
    XML_READER_TYPE_PROCESSING_INSTRUCTION => 7,
    XML_READER_TYPE_COMMENT => 8,
    XML_READER_TYPE_DOCUMENT => 9,
    XML_READER_TYPE_DOCUMENT_TYPE => 10,
    XML_READER_TYPE_DOCUMENT_FRAGMENT => 11,
    XML_READER_TYPE_NOTATION => 12,
    XML_READER_TYPE_WHITESPACE => 13,
    XML_READER_TYPE_SIGNIFICANT_WHITESPACE => 14,
    XML_READER_TYPE_END_ELEMENT => 15,
    XML_READER_TYPE_END_ENTITY => 16,
    XML_READER_TYPE_XML_DECLARATION => 17,
);

enum xmlPatternFlags is export (
    XML_PATTERN_DEFAULT   => 0,         # simple pattern match
    XML_PATTERN_XPATH     => 1+<0,      # standard XPath pattern
    XML_PATTERN_XSSEL     => 1+<1,      # XPath subset for schema selector
    XML_PATTERN_XSFIELD   => 1+<2       # XPath subset for schema field
);

enum xmlC14NMode is export (
    XML_C14N_1_0            => 0,    # Origianal C14N 1.0 spec
    XML_C14N_EXCLUSIVE_1_0  => 1,    # Exclusive C14N 1.0 spec
    XML_C14N_1_1            => 2     # C14N 1.1 spec
);

enum xmlErrorLevel is export (
   XML_ERR_NONE => 0,
   XML_ERR_WARNING => 1,
   XML_ERR_ERROR => 2,
   XML_ERR_FATAL => 3
);

enum xmlErrorDomain is export (
    XML_FROM_NONE => 0,
    'XML_FROM_PARSER',	# The XML parser
    'XML_FROM_TREE',	# The tree module
    'XML_FROM_NAMESPACE',	# The XML Namespace module
    'XML_FROM_DTD',	# The XML DTD validation with parser context*/
    'XML_FROM_HTML',	# The HTML parser
    'XML_FROM_MEMORY',	# The memory allocator
    'XML_FROM_OUTPUT',	# The serialization code
    'XML_FROM_IO',	# The Input/Output stack
    'XML_FROM_FTP',	# The FTP module
    'XML_FROM_HTTP',	# The HTTP module
    'XML_FROM_XINCLUDE',	# The XInclude processing
    'XML_FROM_XPATH',	# The XPath module
    'XML_FROM_XPOINTER',	# The XPointer module
    'XML_FROM_REGEXP',	# The regular expressions module
    'XML_FROM_DATATYPE',	# The W3C XML Schemas Datatype module
    'XML_FROM_SCHEMASP',	# The W3C XML Schemas parser module
    'XML_FROM_SCHEMASV',	# The W3C XML Schemas validation module
    'XML_FROM_RELAXNGP',	# The Relax-NG parser module
    'XML_FROM_RELAXNGV',	# The Relax-NG validator module
    'XML_FROM_CATALOG',	# The Catalog module
    'XML_FROM_C14N',	# The Canonicalization module
    'XML_FROM_XSLT',	# The XSLT engine from libxslt
    'XML_FROM_VALID',	# The XML DTD validation with valid context
    'XML_FROM_CHECK',	# The error checking module
    'XML_FROM_WRITER',	# The xmlwriter module
    'XML_FROM_MODULE',	# The dynamically loaded module module*/
    'XML_FROM_I18N',	# The module handling character conversion
    'XML_FROM_SCHEMATRONV', # The Schematron validator module
    'XML_FROM_BUFFER',     # The buffers module
    'XML_FROM_URI'         # The URI module
);


enum xmlParserError is export (
    XML_ERR_OK => 0,
    XML_ERR_INTERNAL_ERROR => 1,
    XML_ERR_NO_MEMORY => 2,
    XML_ERR_DOCUMENT_START => 3,
    XML_ERR_DOCUMENT_EMPTY => 4,
    XML_ERR_DOCUMENT_END => 5,
    XML_ERR_INVALID_HEX_CHARREF => 6,
    XML_ERR_INVALID_DEC_CHARREF => 7,
    XML_ERR_INVALID_CHARREF => 8,
    XML_ERR_INVALID_CHAR => 9,
    XML_ERR_CHARREF_AT_EOF => 10,
    XML_ERR_CHARREF_IN_PROLOG => 11,
    XML_ERR_CHARREF_IN_EPILOG => 12,
    XML_ERR_CHARREF_IN_DTD => 13,
    XML_ERR_ENTITYREF_AT_EOF => 14,
    XML_ERR_ENTITYREF_IN_PROLOG => 15,
    XML_ERR_ENTITYREF_IN_EPILOG => 16,
    XML_ERR_ENTITYREF_IN_DTD => 17,
    XML_ERR_PEREF_AT_EOF => 18,
    XML_ERR_PEREF_IN_PROLOG => 19,
    XML_ERR_PEREF_IN_EPILOG => 20,
    XML_ERR_PEREF_IN_INT_SUBSET => 21,
    XML_ERR_ENTITYREF_NO_NAME => 22,
    XML_ERR_ENTITYREF_SEMICOL_MISSING => 23,
    XML_ERR_PEREF_NO_NAME => 24,
    XML_ERR_PEREF_SEMICOL_MISSING => 25,
    XML_ERR_UNDECLARED_ENTITY => 26,
    XML_WAR_UNDECLARED_ENTITY => 27,
    XML_ERR_UNPARSED_ENTITY => 28,
    XML_ERR_ENTITY_IS_EXTERNAL => 29,
    XML_ERR_ENTITY_IS_PARAMETER => 30,
    XML_ERR_UNKNOWN_ENCODING => 31,
    XML_ERR_UNSUPPORTED_ENCODING => 32,
    XML_ERR_STRING_NOT_STARTED => 33,
    XML_ERR_STRING_NOT_CLOSED => 34,
    XML_ERR_NS_DECL_ERROR => 35,
    XML_ERR_ENTITY_NOT_STARTED => 36,
    XML_ERR_ENTITY_NOT_FINISHED => 37,
    XML_ERR_LT_IN_ATTRIBUTE => 38,
    XML_ERR_ATTRIBUTE_NOT_STARTED => 39,
    XML_ERR_ATTRIBUTE_NOT_FINISHED => 40,
    XML_ERR_ATTRIBUTE_WITHOUT_VALUE => 41,
    XML_ERR_ATTRIBUTE_REDEFINED => 42,
    XML_ERR_LITERAL_NOT_STARTED => 43,
    XML_ERR_LITERAL_NOT_FINISHED => 44,
    XML_ERR_COMMENT_NOT_FINISHED => 45,
    XML_ERR_PI_NOT_STARTED => 46,
    XML_ERR_PI_NOT_FINISHED => 47,
    XML_ERR_NOTATION_NOT_STARTED => 48,
    XML_ERR_NOTATION_NOT_FINISHED => 49,
    XML_ERR_ATTLIST_NOT_STARTED => 50,
    XML_ERR_ATTLIST_NOT_FINISHED => 51,
    XML_ERR_MIXED_NOT_STARTED => 52,
    XML_ERR_MIXED_NOT_FINISHED => 53,
    XML_ERR_ELEMCONTENT_NOT_STARTED => 54,
    XML_ERR_ELEMCONTENT_NOT_FINISHED => 55,
    XML_ERR_XMLDECL_NOT_STARTED => 56,
    XML_ERR_XMLDECL_NOT_FINISHED => 57,
    XML_ERR_CONDSEC_NOT_STARTED => 58,
    XML_ERR_CONDSEC_NOT_FINISHED => 59,
    XML_ERR_EXT_SUBSET_NOT_FINISHED => 60,
    XML_ERR_DOCTYPE_NOT_FINISHED => 61,
    XML_ERR_MISPLACED_CDATA_END => 62,
    XML_ERR_CDATA_NOT_FINISHED => 63,
    XML_ERR_RESERVED_XML_NAME => 64,
    XML_ERR_SPACE_REQUIRED => 65,
    XML_ERR_SEPARATOR_REQUIRED => 66,
    XML_ERR_NMTOKEN_REQUIRED => 67,
    XML_ERR_NAME_REQUIRED => 68,
    XML_ERR_PCDATA_REQUIRED => 69,
    XML_ERR_URI_REQUIRED => 70,
    XML_ERR_PUBID_REQUIRED => 71,
    XML_ERR_LT_REQUIRED => 72,
    XML_ERR_GT_REQUIRED => 73,
    XML_ERR_LTSLASH_REQUIRED => 74,
    XML_ERR_EQUAL_REQUIRED => 75,
    XML_ERR_TAG_NAME_MISMATCH => 76,
    XML_ERR_TAG_NOT_FINISHED => 77,
    XML_ERR_STANDALONE_VALUE => 78,
    XML_ERR_ENCODING_NAME => 79,
    XML_ERR_HYPHEN_IN_COMMENT => 80,
    XML_ERR_INVALID_ENCODING => 81,
    XML_ERR_EXT_ENTITY_STANDALONE => 82,
    XML_ERR_CONDSEC_INVALID => 83,
    XML_ERR_VALUE_REQUIRED => 84,
    XML_ERR_NOT_WELL_BALANCED => 85,
    XML_ERR_EXTRA_CONTENT => 86,
    XML_ERR_ENTITY_CHAR_ERROR => 87,
    XML_ERR_ENTITY_PE_INTERNAL => 88,
    XML_ERR_ENTITY_LOOP => 89,
    XML_ERR_ENTITY_BOUNDARY => 90,
    XML_ERR_INVALID_URI => 91,
    XML_ERR_URI_FRAGMENT => 92,
    XML_WAR_CATALOG_PI => 93,
    XML_ERR_NO_DTD => 94,
    XML_ERR_CONDSEC_INVALID_KEYWORD => 95,
    XML_ERR_VERSION_MISSING => 96,
    XML_WAR_UNKNOWN_VERSION => 97,
    XML_WAR_LANG_VALUE => 98,
    XML_WAR_NS_URI => 99,
    XML_WAR_NS_URI_RELATIVE => 100,
    XML_ERR_MISSING_ENCODING => 101,
    XML_WAR_SPACE_VALUE => 102,
    XML_ERR_NOT_STANDALONE => 103,
    XML_ERR_ENTITY_PROCESSING => 104,
    XML_ERR_NOTATION_PROCESSING => 105,
    XML_WAR_NS_COLUMN => 106,
    XML_WAR_ENTITY_REDEFINED => 107,
    XML_ERR_UNKNOWN_VERSION => 108,
    XML_ERR_VERSION_MISMATCH => 109,
    XML_ERR_NAME_TOO_LONG => 110,
    XML_ERR_USER_STOP => 111,
    XML_NS_ERR_XML_NAMESPACE => 200,
    XML_NS_ERR_UNDEFINED_NAMESPACE => 201,
    XML_NS_ERR_QNAME => 202,
    XML_NS_ERR_ATTRIBUTE_REDEFINED => 203,
    XML_NS_ERR_EMPTY => 204,
    XML_NS_ERR_COLON => 205,
    XML_DTD_ATTRIBUTE_DEFAULT => 500,
    XML_DTD_ATTRIBUTE_REDEFINED => 501,
    XML_DTD_ATTRIBUTE_VALUE => 502,
    XML_DTD_CONTENT_ERROR => 503,
    XML_DTD_CONTENT_MODEL => 504,
    XML_DTD_CONTENT_NOT_DETERMINIST => 505,
    XML_DTD_DIFFERENT_PREFIX => 506,
    XML_DTD_ELEM_DEFAULT_NAMESPACE => 507,
    XML_DTD_ELEM_NAMESPACE => 508,
    XML_DTD_ELEM_REDEFINED => 509,
    XML_DTD_EMPTY_NOTATION => 510,
    XML_DTD_ENTITY_TYPE => 511,
    XML_DTD_ID_FIXED => 512,
    XML_DTD_ID_REDEFINED => 513,
    XML_DTD_ID_SUBSET => 514,
    XML_DTD_INVALID_CHILD => 515,
    XML_DTD_INVALID_DEFAULT => 516,
    XML_DTD_LOAD_ERROR => 517,
    XML_DTD_MISSING_ATTRIBUTE => 518,
    XML_DTD_MIXED_CORRUPT => 519,
    XML_DTD_MULTIPLE_ID => 520,
    XML_DTD_NO_DOC => 521,
    XML_DTD_NO_DTD => 522,
    XML_DTD_NO_ELEM_NAME => 523,
    XML_DTD_NO_PREFIX => 524,
    XML_DTD_NO_ROOT => 525,
    XML_DTD_NOTATION_REDEFINED => 526,
    XML_DTD_NOTATION_VALUE => 527,
    XML_DTD_NOT_EMPTY => 528,
    XML_DTD_NOT_PCDATA => 529,
    XML_DTD_NOT_STANDALONE => 530,
    XML_DTD_ROOT_NAME => 531,
    XML_DTD_STANDALONE_WHITE_SPACE => 532,
    XML_DTD_UNKNOWN_ATTRIBUTE => 533,
    XML_DTD_UNKNOWN_ELEM => 534,
    XML_DTD_UNKNOWN_ENTITY => 535,
    XML_DTD_UNKNOWN_ID => 536,
    XML_DTD_UNKNOWN_NOTATION => 537,
    XML_DTD_STANDALONE_DEFAULTED => 538,
    XML_DTD_XMLID_VALUE => 539,
    XML_DTD_XMLID_TYPE => 540,
    XML_DTD_DUP_TOKEN => 541,
    XML_HTML_STRUCURE_ERROR => 800,
    XML_HTML_UNKNOWN_TAG => 801,
    # + many more error codes. see libxml/xmlerror.h
);
