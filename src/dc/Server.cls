Class dc.Server Extends dc.rest.RestAbstract
{

ClassMethod ping() As %Status
{
    Write { "Say" : "Pong" }.%ToJSON()
    Return $$$OK
}

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/ping"                Method="GET"    Call="ping"             Cors="true"/>
</Routes>
}

}
