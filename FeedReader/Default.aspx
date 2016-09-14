<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="FeedReader.Default" %>

<!DOCTYPE html>
<html>
<head>
    <!--Import Google Icon Font-->
    <link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!--Import materialize.css-->
    <link type="text/css" rel="stylesheet" href="public/materialize/css/materialize.min.css" media="screen,projection" />
    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        img {
            max-width: 100%;
        }
    </style>
</head>

<body>
    <form id="myForm" runat="server">

        <div class="container">
            <div class="row">
                <div class="col s12">
                    <h1>Feed Reader</h1>
                    <div class="divider"></div>
                </div>
                <div class="col s12">
                    <asp:SqlDataSource runat="server" ID="SqlDataSource_feeds" ConnectionString='<%$ ConnectionStrings:DatabaseFeedsConnectionString %>' SelectCommand="SELECT * FROM [Feeds]"></asp:SqlDataSource>
                    <asp:Repeater ID="Repeater_feeds" runat="server" DataSourceID="SqlDataSource_feeds">
                        <ItemTemplate>
                            <h2><%# Eval("title") %></h2>
                            <div class="chip">
                                <asp:HyperLink ID="Linkbutton_feed" runat="server" NavigateUrl='<%# Eval("link") %>'><%# "RSS adresse til " + Eval("title") %></asp:HyperLink>
                            </div>
                            <asp:Repeater ID="Repeater_channel" OnItemDataBound="Repeater_channel_ItemDataBound" runat="server">
                                <ItemTemplate> 
                                    <!-- Channel 
                                    <a href="<%# XPath("link")%>" title="<%# "Gå til kategorien " + XPath("title")%>">
                                        <h3><%# XPath("title")%></h3>
                                    </a> -->
                                    <p><%# XPath("description")%></p>

                                    <asp:Repeater ID="Repeater_item" runat="server">
                                        <ItemTemplate>
                                            <!-- Item -->
                                            <div class="card-panel hoverable">
                                                <div class="section">
                                                    <a href="<%# XPath("link")%>" title="Gå til nyheden <%# XPath("title")%>">
                                                        <h5><%# XPath("title")%></h5>
                                                    </a>
                                                    <p><%# XPath("description")%></p>
                                                    <a href="<%# XPath("link")%>" title="Gå til nyheden <%# XPath("title")%>">Læs nyheden</a>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>

        <!--Import jQuery before materialize.js-->
        <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
        <script type="text/javascript" src="public/materialize/js/materialize.min.js"></script>
    </form>
</body>
</html>
