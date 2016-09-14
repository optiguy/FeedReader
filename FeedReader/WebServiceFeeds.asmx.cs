using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using Newtonsoft.Json;
using System.Web.UI.WebControls;
using System.Xml;

namespace FeedReader
{
    public class FeedModel
    {
        public string title;
        public string link;
    }

    public class ChannelModel : FeedModel
    {
        public string description;
    }

    public class ItemModel : ChannelModel
    {
        public string author;
    }

    /// <summary>
    /// Summary description for WebServiceFeeds
    /// </summary>
    [WebService(Namespace = "http://localhost.bjarke/")]
    [ScriptService]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class WebServiceFeeds : System.Web.Services.WebService
    {
        private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DatabaseFeedsConnectionString"].ConnectionString);

        [WebMethod]
        [ScriptMethod(UseHttpGet = true, ResponseFormat = ResponseFormat.Json)]
        public void GetFeeds()
        {
            //Query the database
            SqlDataAdapter DBfeeds = new SqlDataAdapter("SELECT * FROM Feeds", conn);
            DataTable DTfeeds = new DataTable();
            DBfeeds.Fill(DTfeeds);

            //Build up the data
            List<FeedModel> model = new List<FeedModel>();
            foreach (DataRow feedRow in DTfeeds.Rows)
            {
                FeedModel feed = new FeedModel();
                feed.title = feedRow["title"].ToString();
                feed.link = feedRow["link"].ToString();
                model.Add(feed);
            }
            Context.Response.Write(JsonConvert.SerializeObject(model));
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public void GetChannelInfo(string feedLink)
        {
            XmlDocument doc = ParseRSSasXML(feedLink);
            XmlNode channelNode = doc.DocumentElement.SelectSingleNode("channel");
            
            ChannelModel channel = new ChannelModel();
            channel.title = channelNode["title"].InnerText;
            channel.link = channelNode["link"].InnerText;
            channel.description = channelNode["description"].InnerText;

            Context.Response.Write(JsonConvert.SerializeObject(channel));
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public void GetItems(string feedLink)
        {
            XmlDocument doc = ParseRSSasXML(feedLink);

            List<ItemModel> items = new List<ItemModel>();

            XmlNodeList itemNodes = doc.DocumentElement.SelectNodes("channel/item");

            foreach (XmlNode itemNode in itemNodes)
            {
                ItemModel item = new ItemModel();
                item.title = itemNode["title"].InnerText;
                item.link = itemNode["link"].InnerText;
                item.description = itemNode["description"].InnerText;
                if (itemNode["author"] != null)
                {
                    item.author = itemNode["author"].InnerText;
                }
                items.Add(item);
            }

            Context.Response.Write(JsonConvert.SerializeObject(items));
        }

        private static XmlDocument ParseRSSasXML(string feedLink)
        {
            XmlDataSource xds = new XmlDataSource();
            xds.DataFile = feedLink;

            XmlDocument doc = xds.GetXmlDocument();
            return doc;
        }
    }
}
