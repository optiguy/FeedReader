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
                    $.each(JSON.parse(data), function (index, feed) {
                        console.log(feed.title);
                        console.log(feed.link);
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
