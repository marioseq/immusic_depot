/**
* ...
* @author Martin Legris
* @version 0.1
*/

package ca.newcommerce.youtube.events
{
	import ca.newcommerce.youtube.feeds.VideoFeed;
	//import ca.newcommerce.youtube.feeds.UserFeed;
	import flash.events.Event;

	public class YouTubeEvent extends Event
	{
		public static const VIDEO_FEED_READY:String = "videofeed_ready";
		public static const VIDEO_DATA_RECEIVED:String = "video_data_received";
		public static const PROFILE_DATA_RECEIVED:String = "profile_data_received";
		public static const RESPONSE_DATA_RECEIVED:String = "response_data_received";
		public static const STANDARD_VIDEO_DATA_RECEIVED:String = "standard_video_data_received";
		public static const RAW_URL_DATA_RECEIVED:String = "raw_url_data_received";
		
		protected var _requestId:Number = -1;
		protected var _requestWrapper:Object;
		protected var _videoFeed:VideoFeed;
		//protected var _userFeed:UserFeed;
		
		public function YouTubeEvent(type:String, requestWrapper:Object, videoFeed:VideoFeed)//, userFeed:UserFeed)
		{
			super(type);
			_requestId = requestWrapper.id;
			_requestWrapper = requestWrapper;
		}
		
		public function get requestId():Number
		{
			return _requestId;
		}
		
		public function get requestWrapper():Object
		{
			return _requestWrapper;
		}
	}
}