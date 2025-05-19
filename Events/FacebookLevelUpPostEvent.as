package Events
{
   import flash.events.Event;
   
   public class FacebookLevelUpPostEvent extends Event
   {
      
      public static const NAME:String = "FacebookLevelUpPostEvent";
      
      private var mLevel:uint;
      
      public function FacebookLevelUpPostEvent(param1:String, param2:uint, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         mLevel = param2;
      }
      
      public function get level() : uint
      {
         return mLevel;
      }
   }
}

