xquery version "3.0";
element names {
for $ead in /ead
let $all_names := $ead//*[self::persname or self::corpname or self::famname]
    for $name in $all_names
	  let $collectiontitle := $ead/archdesc/did/unittitle/descendant-or-self::*/text(),
        $eadid := $ead/eadheader/eadid,
        $publisher := $ead/eadheader/filedesc/publicationstmt/publisher,
        $xpathNS := replace(fn:path($name), 'Q\{\}', ''),
				$orignationlabel := $name/parent::origination/@label,
    (: This should be updated, but for now I'm just grabbing the contents of the bioghist(s) if the "name" is a child of an origination element (i.e. it's NOT looking to see if there is a potentially related bioghist if the name occurs elsewhere).  This text is then used to assist in Google Refine's reconcilation process :)
       $bioghist := $name/parent::origination/parent::did/parent::archdesc/bioghist/descendant::*[not(name()='head')]/text()

	  where $name ne '' and not($name/parent::repository/parent::did/parent::archdesc)
	  
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
