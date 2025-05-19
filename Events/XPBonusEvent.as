package Events
{
   import Facade.Locale;
   import flash.events.Event;
   
   public class XPBonusEvent extends Event
   {
      
      public static const NAME:String = "XP_BONUS_EVENT";
      
      private var mXPMultiplier:Number;
      
      private var mIsActive:Boolean;
      
      public function XPBonusEvent(param1:String, param2:Boolean, param3:Number = 1, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         mIsActive = param2;
         mXPMultiplier = param3;
      }
      
      public function get isActive() : Boolean
      {
         return mIsActive;
      }
      
      public function get xpMultiplier() : Number
      {
         return mXPMultiplier;
      }
      
      public function get xpMultiplierBonusTextForHUD() : String
      {
         return Locale.getString("BONUS_XP_" + mXPMultiplier.toString());
      }
      
      public function get xpMultiplierBonusTextForNewsFeed() : String
      {
         return Locale.getString("NEWS_FEED_BONUS_XP_" + mXPMultiplier.toString());
      }
   }
}

