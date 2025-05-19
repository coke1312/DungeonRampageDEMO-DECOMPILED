package Account
{
   import flash.events.Event;
   
   public class CurrencyUpdatedAccountEvent extends Event
   {
      
      public static const EVENT_NAME:String = "CurrencyUpdatedAccountEvent";
      
      private var mBasicCurrency:uint;
      
      private var mPremiumCurrency:uint;
      
      public function CurrencyUpdatedAccountEvent(param1:uint, param2:uint, param3:Boolean = false, param4:Boolean = false)
      {
         super("CurrencyUpdatedAccountEvent",param3,param4);
         mPremiumCurrency = param2;
         mBasicCurrency = param1;
      }
      
      public function get basicCurrency() : uint
      {
         return mBasicCurrency;
      }
      
      public function get premiumCurrency() : uint
      {
         return mPremiumCurrency;
      }
   }
}

