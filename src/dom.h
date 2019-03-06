/* dom.h
 * $Id$
 * Author: Christian Glahn (2001)
 * Ported from Perl 5 to 6 by David Warring (2019)
 *
 * This header file provides some definitions for wrapper functions.
 * These functions hide most of libxml2 code, and should make the
 * code in the XS file more readable .
 *
 * The Functions are sorted in four parts:
 * part 0 ..... general wrapper functions which do not belong
 *              to any of the other parts and not specified in DOM.
 * part A ..... wrapper functions for general nodeaccess
 * part B ..... document wrapper
 * part C ..... element wrapper
 *
 * I did not implement any Text, CDATASection or comment wrapper functions,
 * since it is pretty straightforeward to access these nodes.
 */

#ifndef __LIBXML_DOM_H__
#define __LIBXML_DOM_H__

#ifdef __cplusplus
extern "C" {
#endif

#include <libxml/tree.h>
#include <libxml/xpath.h>
#include <libxml/encoding.h>
#include <libxml/xmlerror.h>
#include <libxml/xmlmemory.h>
#include <libxml/parser.h>
#include <libxml/parserInternals.h>
#include <libxml/xmlIO.h>
#include <libxml/xpathInternals.h>
#include <libxml/globals.h>
#include <stdio.h>

#ifdef __cplusplus
}
#endif

/**
 * part 0:
 *
 * unsortet.
 **/

void
domReconcileNS(xmlNodePtr tree);

/**
 * NAME domIsParent
 * TYPE function
 *
 * tests if a node is an ancestor of another node
 *
 * SYNOPSIS
 * if ( domIsParent(cur, ref) ) ...
 *
 * this function is very useful to resolve if an operation would cause
 * circular references.
 *
 * the function returns 1 if the ref node is a parent of the cur node.
 */
int
domIsParent( xmlNodePtr cur, xmlNodePtr ref );

/**
 * NAME domTestHierarchy
 * TYPE function
 *
 * tests the general hierarchy error
 *
 * SYNOPSIS
 * if ( domTestHierarchy(cur, ref) ) ...
 *
 * this function tests the general hierarchy error.
 * it tests if the ref node would cause any hierarchical error for
 * cur node. the function evaluates domIsParent() internally.
 *
 * the function will retrun 1 if there is no hierarchical error found.
 * otherwise it returns 0.
 */
int
domTestHierarchy( xmlNodePtr cur, xmlNodePtr ref );

/**
* NAME domTestDocument
* TYPE function
* SYNOPSIS
* if ( domTestDocument(cur, ref) )...
*
* this function extends the domTestHierarchy() function. It tests if the
* cur node is a document and if so, it will check if the ref node can be
* inserted. (e.g. Attribute or Element nodes must not be appended to a
* document node)
*/
int
domTestDocument( xmlNodePtr cur, xmlNodePtr ref );

/**
* NAME domAddNodeToList
* TYPE function
* SYNOPSIS
* domAddNodeToList( cur, prevNode, nextNode )
*
* This function inserts a node between the two nodes prevNode
* and nextNode. prevNode and nextNode MUST be adjacent nodes,
* otherwise the function leads into undefined states.
* Either prevNode or nextNode can be NULL to mark, that the
* node has to be inserted to the beginning or the end of the
* nodelist. in such case the given reference node has to be
* first or the last node in the list.
*
* if prevNode is the same node as cur node (or in case of a
* Fragment its first child) only the parent information will
* get updated.
*
* The function behaves different to libxml2's list functions.
* The function is aware about document fragments.
* the function does not perform any text node normalization!
*
* NOTE: this function does not perform any highlevel
* errorhandling. use this function with caution, since it can
* lead into undefined states.
*
* the function will return 1 if the cur node is appended to
* the list. otherwise the function returns 0.
*/
static xmlNodePtr
_domAddNodeToList( xmlNodePtr cur, xmlNodePtr prev, xmlNodePtr next, xmlNodePtr *tail );

/**
 * part A:
 *
 * class Node
 **/

/* A.1 DOM specified section */

xmlChar *
domName( xmlNodePtr node );

void
domSetName( xmlNodePtr node, xmlChar* name );

xmlNodePtr
domAppendChild( xmlNodePtr self,
                xmlNodePtr newChild );
xmlNodePtr
domReplaceChild( xmlNodePtr self,
                 xmlNodePtr newChlid,
                 xmlNodePtr oldChild );
xmlNodePtr
domRemoveChild( xmlNodePtr self,
               xmlNodePtr Child );
xmlNodePtr
domInsertBefore( xmlNodePtr self,
                 xmlNodePtr newChild,
                 xmlNodePtr refChild );

xmlNodePtr
domInsertAfter( xmlNodePtr self,
                xmlNodePtr newChild,
                xmlNodePtr refChild );

/* A.3 extra functionality not specified in DOM L1/2*/
xmlChar*
domGetNodeValue( xmlNodePtr self );

void
domSetNodeValue( xmlNodePtr self, xmlChar* value );

xmlNodePtr
domReplaceNode( xmlNodePtr old, xmlNodePtr new );

void
domReleaseNode( xmlNodePtr node );

/**
 * part B:
 *
 * class Document
 **/

/**
 * NAME domImportNode
 * TYPE function
 * SYNOPSIS
 * node = domImportNode( document, node, move, reconcileNS);
 *
 * the function will import a node to the given document. it will work safe
 * with namespaces and subtrees.
 *
 * if move is set to 1, then the node will be entirely removed from its
 * original document. if move is set to 0, the node will be copied with the
 * deep option.
 *
 * if reconcileNS is 1, namespaces are reconciled.
 *
 * the function will return the imported node on success. otherwise NULL
 * is returned
 */
xmlNodePtr
domImportNode( xmlDocPtr document, xmlNodePtr node, int move, int reconcileNS );

/**
 * part C:
 *
 * class Element
 **/

xmlNodeSetPtr
domGetChildrenByLocalName( xmlNodePtr self, xmlChar* name );

xmlNodeSetPtr
domGetChildrenByTagName( xmlNodePtr self, xmlChar* name );

xmlNodeSetPtr
domGetChildrenByTagNameNS( xmlNodePtr self, xmlChar* nsURI, xmlChar* name );

xmlAttrPtr
domGetAttributeNode( xmlNodePtr node, const xmlChar *qname);

xmlChar *
domGetAttribute(xmlNodePtr node, const xmlChar *qname);

xmlAttrPtr
domSetAttributeNode( xmlNodePtr node , xmlAttrPtr attr );

int
domNodeNormalize( xmlNodePtr node );

int
domNodeNormalizeList( xmlNodePtr nodelist );

int
domRemoveNsRefs(xmlNodePtr tree, xmlNsPtr ns);

void
domAttrSerializeContent(xmlBufferPtr buffer, xmlAttrPtr attr);

void
domClearPSVI(xmlNodePtr tree);

xmlAttrPtr
domCreateAttribute( xmlDocPtr self, char *name, char *value);

xmlAttrPtr
domCreateAttributeNS( xmlDocPtr self, char *URI, char *name, char *value );


xmlAttrPtr
domSetAttributeNS(xmlNodePtr, xmlChar *URI, xmlChar *name, xmlChar *value );

#endif
