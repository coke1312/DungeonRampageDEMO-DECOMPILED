package Account
{
   import Brain.Event.EventComponent;
   import Events.GenericNewsFeedEvent;
   import Events.XPBonusEvent;
   import Facade.DBFacade;
   import flash.events.Event;
   
   public class AccountBonus
   {
      
      public static const BONUS_XP_CHANGED_EVENT:String = "BONUS_XP_CHANGED_EVENT";
      
      public static const BONUS_COIN_CHANGED_EVENT:String = "BONUS_COIN_CHANGED_EVENT";
      
      private var mDBFacade:DBFacade;
      
      private var mXPBonusMultiplier:Number = 1;
      
      private var mXPBonusActive:Boolean = false;
      
      private var mXPBonusText:String = "";
      
      private var mCoinBonusActive:Boolean = false;
      
      private var mCoinBonusText:String = "";
      
      private var mCoinBonusMultiplier:Number = 1;
      
      private var mUINewsFeedXPBonusText:String = "";
      
      private var mEventComponent:EventComponent;
      
      public function AccountBonus(param1:DBFacade)
      {
         super();
         mDBFacade = param1;
         mEventComponent = new EventComponent(mDBFacade);
         mEventComponent.addListener("XP_BONUS_EVENT",setXPBonusStuff);
      }
      
      public function destroy() : void
      {
         if(mEventComponent)
         {
            mEventComponent.destroy();
         }
         mEventComponent = null;
         mDBFacade = null;
      }
      
      public function setXPBonusStuff(param1:XPBonusEvent) : void
      {
         mXPBonusActive = param1.isActive;
         mXPBonusMultiplier = param1.xpMultiplier;
         mXPBonusText = param1.xpMultiplierBonusTextForHUD;
         mUINewsFeedXPBonusText = param1.xpMultiplierBonusTextForNewsFeed;
         mEventComponent.dispatchEvent(new Event("BONUS_XP_CHANGED_EVENT"));
         if(mXPBonusMultiplier > 1)
         {
            mEventComponent.dispatchEvent(new GenericNewsFeedEvent("GENERIC_NEWS_FEED_MESSAGE_EVENT",mUINewsFeedXPBonusText,DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),"UI_alert_doublexp"));
         }
      }
      
      public function get xpBonusMultiplier() : Number
      {
         return mXPBonusMultiplier;
      }
      
      public function get isXPBonusActive() : Boolean
      {
         return mXPBonusActive;
      }
      
      public function get isCoinBonusActive() : Boolean
      {
         return mCoinBonusActive;
      }
      
      public function get xpBonusText() : String
      {
         return mXPBonusText;
      }
      
      public function get coinBonusText() : String
      {
         return mCoinBonusText;
      }
   }
}

