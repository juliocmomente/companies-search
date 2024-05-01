Class dc.data.GlassdoorReviews Extends %Persistent
{

Property firm As %String(MAXLEN = 255);

Property location As %String(MAXLEN = 255);

Property overallRating As %Integer;

Property headline As %String(MAXLEN = "");

Property pros As %String(MAXLEN = "");

Property prosVector As %Vector(DATATYPE = "DOUBLE", LEN = 384);

Property cons As %String(MAXLEN = "");

Property consVector As %Vector(DATATYPE = "DOUBLE", LEN = 384);

Storage Default
{
<Data name="GlassdoorReviewsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>firm</Value>
</Value>
<Value name="3">
<Value>location</Value>
</Value>
<Value name="4">
<Value>overallRating</Value>
</Value>
<Value name="5">
<Value>headline</Value>
</Value>
<Value name="6">
<Value>pros</Value>
</Value>
<Value name="7">
<Value>prosVector</Value>
</Value>
<Value name="8">
<Value>cons</Value>
</Value>
<Value name="9">
<Value>consVector</Value>
</Value>
</Data>
<DataLocation>^dc.data.GlassdoorReviewsD</DataLocation>
<DefaultData>GlassdoorReviewsDefaultData</DefaultData>
<IdLocation>^dc.data.GlassdoorReviewsD</IdLocation>
<IndexLocation>^dc.data.GlassdoorReviewsI</IndexLocation>
<StreamLocation>^dc.data.GlassdoorReviewsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
