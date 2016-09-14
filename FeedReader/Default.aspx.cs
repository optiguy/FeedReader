using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.XPath;

namespace FeedReader
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Repeater_feeds.DataBind(); //Make sure that repeater has data
            foreach (RepeaterItem feedItem in Repeater_feeds.Items)
            {
                //Get link
                HyperLink feedButton = (HyperLink)feedItem.FindControl("Linkbutton_feed");
                string feedLink = feedButton.NavigateUrl; //Get RSS link

                // Set datasource
                Repeater feedRepeater = (Repeater)feedItem.FindControl("Repeater_channel");
                XmlDataSource xds = new XmlDataSource();
                xds.DataFile = feedLink;
                xds.XPath = "rss/channel";
                feedRepeater.DataSource = xds;
                feedRepeater.DataBind();
            } 
        }

        protected void Repeater_channel_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            SetXPathOnInnerRepeater(e, "Repeater_item", "./item");
        }

        private static void SetXPathOnInnerRepeater(RepeaterItemEventArgs e, string ID, string XPath)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater Repeater_Inner = e.Item.FindControl(ID) as Repeater;
                XPathNavigator data = ((IXPathNavigable)e.Item.DataItem).CreateNavigator();
                Repeater_Inner.DataSource = data.Select(XPath);
                Repeater_Inner.DataBind();
            }
        }


    }
}