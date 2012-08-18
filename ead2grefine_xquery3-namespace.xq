xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
element names {
for $ead in /ead:ead
let $all_names := $ead//*[self::ead:persname or self::ead:corpname or self::ead:famname]
    for $name in $all_names
	  let $collectiontitle := $ead/ead:archdesc/ead:did/ead:unittitle/descendant-or-self::*/text(),
        $eadid := $ead/ead:eadheader/ead:eadid,
        $publisher := $ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:publisher,
        $xpathNS := replace(fn:path($name), 'Q\{urn:isbn:1-931666-22-9\}', 'ead:'),
				$orignationlabel := $name/parent::ead:origination/@label,
    (: This should be updated, but for now I'm just grabbing the contents of the bioghist(s) if the "name" is a child of an origination element (i.e. it's NOT looking to see if there is a potentially related bioghist if the name occurs elsewhere).  This text is then used to assist in Google Refine's reconcilation process :)
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
		<xpath>{$xpathNS}</xpath>
	</name>
}
