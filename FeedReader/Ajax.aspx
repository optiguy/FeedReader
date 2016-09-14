<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Ajax.aspx.cs" Inherits="FeedReader.Ajax" %>

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
    <form id="form1" runat="server">
        <div class="container">
            <div class="row">
                <div class="col s12">
                    <h1>Feed Reader</h1>
                    <div class="divider"></div>
                </div>
                <div id="feedResult" class="col s12 center">
                    <!-- Loading Placeholder -->
                    <div class="preloader-wrapper big active">
                        <div class="spinner-layer spinner-blue-only">
                            <div class="circle-clipper left">
                                <div class="circle"></div>
                            </div>
                            <div class="gap-patch">
                                <div class="circle"></div>
                            </div>
                            <div class="circle-clipper right">
                                <div class="circle"></div>
                            </div>
                        </div>
                    </div>
                    <h5 class="valign">Vent venligst mens dine nyheder loades ind...</h5>
                    <!-- Loading Placeholder -->
                </div>
                </div>
            </div>
        </div>

        <!--Import jQuery before materialize.js-->
        <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
        <script type="text/javascript" src="public/materialize/js/materialize.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {

                $.ajax({
                    method: "GET",
                    url: "http://localhost:6942/WebServiceFeeds.asmx/GetFeeds",
                })
                .done(function (data) {

                    $("#feedResult").html("");

                    $.each(JSON.parse(data), function (index, feed) {
                        let HTMLTitle = "<h2>" + feed.title + "</h2>";
                        let HTMLRSSlink = "<div class='chip'><a href='" + feed.link + "'>RSS adresse til " + feed.title + "</a></div>";
                        
                        $("#feedResult").append(HTMLTitle + HTMLRSSlink);

                        $.ajax({
                            method: "POST",
                            async: false,
                            data: { feedLink: feed.link },
                            url: "http://localhost:6942/WebServiceFeeds.asmx/GetItems",
                        })
                        .done(function (items) {
                            $.each(JSON.parse(items), function (index, item) {

                                let HTMLItemTitle = "<a href='" + item.link + "'><h5>" + item.title + "</h5></a>";
                                let HTMLItemDescription = "<p>" + item.description + "</p>";
                                let HTMLItemAuthor = "<p>Forfatter: " + item.author + "<p>";
                                let HTMLItemLink = "<a href='" + item.link + "'>Læs Nyheden</a>";

                                let fullHTML = "<div class='card-panel hoverable'><div class='section'>" + HTMLItemTitle + HTMLItemDescription + HTMLItemAuthor + HTMLItemLink + "</div></div>";
                                $("#feedResult").append(fullHTML);
                            });
                        })
                        .error(function () {
                            alert("Feed kan ikke hentes!");
                        })

                    });

                })
                .error(function () {
                    alert("Something went wrong. Please reload the page!");
                });

            });
        </script>
    </form>
</body>
</html>
