declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace mdc = "http://mdc.functions"; 
declare function mdc:xpath
  ($nodes as node()*) as xs:string* {

for $node in $nodes/ancestor-or-self::*
let $numPrecSiblings := count($node/preceding-sibling::*[name()=name($node)])
 for $number in $numPrecSiblings
 let $position := $number
 return
     concat('/ead:', name($node), '[', $position + 1, ']')
 };
 
 
element names {
for $ead in /ead:ead
let $all_names := $ead//*[self::ead:persname or self::ead:corpname or self::ead:famname]
    for $name in $all_names
	  let $collectiontitle := $ead/ead:archdesc/ead:did/ead:unittitle/descendant-or-self::*/text(),
        $eadid := $ead/ead:eadheader/ead:eadid,
        $publisher := $ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:publisher,
        $xpath := string-join(mdc:xpath($name), ''),
				$orignationlabel := $name/parent::ead:origination/@label,
    (: This should be updated, but for now I'm just grabbing the contents of a bioghist if the "name" is a child of an origination element (this also enables the query to excecute very quickly) :)
        $bioghist := $name/parent::ead:origination/parent::ead:did/parent::ead:archdesc/ead:bioghist/descendant::*[not(name()='head')]/text()
    
where $name ne '' and not($name/parent::ead:repository/parent::ead:did/parent::ead:archdesc)
return 
	<name>
		<namestring>{normalize-unicode(normalize-space($name))}</namestring>
		<encodinganalog>{data($name/@encodinganalog)}</encodinganalog>
		<normalattribute>{data($name/@normal)}</normalattribute>
		<altrender>{data($name/@altrender)}</altrender>
		<elementname>{name($name)}</elementname>
		<orignationlabel>{data($orignationlabel)}</orignationlabel>
		<bioghist>{data($bioghist)}</bioghist>
		<parentcollection>{data($collectiontitle)}</parentcollection>
		<parentID>{data($eadid)}</parentID>
		<mainagencycode>{data($eadid/@mainagencycode)}</mainagencycode>
		<publisher>{data($publisher)}</publisher>
		<xpath>{$xpath}</xpath>
	</name>
}