package GameMasterDictionary
{
   public class GMFeedPosts
   {
      
      public var Id:uint;
      
      public var Constant:String;
      
      public var FeedName:String;
      
      public var IdTrigger:uint;
      
      public var LevelTrigger:uint;
      
      public var Category:String;
      
      public var FeedCaption:String;
      
      public var FeedDescriptions:String;
      
      public var FeedActionsName:String;
      
      public var FeedActionsLink:String;
      
      public var FeedActionsReward:String;
      
      public var FeedImageLink:String;
      
      public function GMFeedPosts(param1:Object)
      {
         super();
         Id = param1.Id;
         Constant = param1.Constant;
         FeedName = param1.FeedName;
         IdTrigger = param1.IdTrigger;
         Category = param1.Category;
         FeedCaption = param1.FeedCaption;
         FeedDescriptions = param1.FeedDescriptions;
         FeedActionsName = param1.FeedActionsName;
         FeedActionsLink = param1.FeedActionsLink;
         FeedActionsReward = param1.FeedActionsReward;
         FeedImageLink = param1.FeedImageLink;
         LevelTrigger = param1.LevelTrigger;
      }
   }
}

