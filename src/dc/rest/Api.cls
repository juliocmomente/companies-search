Class dc.rest.Api Extends dc.rest.RestAbstract
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/search" Method="GET" Call="dc.rest.companies.Search:GetCompanies"/>
</Routes>
}

}