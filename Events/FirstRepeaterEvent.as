package Events
{
   import flash.events.Event;
   
   public class FirstRepeaterEvent extends Event
   {
      
      public static const EVENT_NAME:String = "FirstRepeater";
      
      public function FirstRepeaterEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super("FirstRepeater",param1,param2);
      }
   }
}

