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
            //Make sure that jQuery has loaded the document and it is ready
            $(document).ready(function () {

                //Standard jQuery function for making AJAX request
                //{} is an json object containing the options for the AJAX call
                //See more here : http://api.jquery.com/jquery.ajax/
                $.ajax({
                    method: "GET",
                    url: "http://localhost:6942/WebServiceFeeds.asmx/GetFeeds",
                })
                //The done() function is executed when the query is successful
                //The anonymous function is injected into the done function, which returns the data variable from the query.
                .done(function (data) {

                    //Remove all content from id="feedResult" (the load animation and text.)
                    $("#feedResult").html("");

                    //1. jQuery's version of a foreach loop
                    //2. We're parsing the data varible (string) into JSON
                    //3. The anonymous function is injected into the each function and will be run for each item in the collection
                    $.each(JSON.parse(data), function (index, feed) {

                        //Extract the data from each item and build up the html for our page.
                        let HTMLTitle = "<h2>" + feed.title + "</h2>";
                        let HTMLRSSlink = "<div class='chip'><a href='" + feed.link + "'>RSS adresse til " + feed.title + "</a></div>";

                        //Append the html we just builded into the div with id="feedResult"
                        $("#feedResult").append(HTMLTitle + HTMLRSSlink);

                        //In the current foreach loop with each single item, we're making another ajax call.
                        //This time we're making a POST request, as we need to post the link to the RSSDocument on the internet
                        //The Data option is simulating our form inputs, with name = feedLink and the value ex. http://nyheder.tv2.dk/rss
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
                //The error() function is executed when the query throws an error
                .error(function () {
                    alert("Something went wrong. Please reload the page!");
                });
            });
        </script>
    </form>
</body>
</html>
