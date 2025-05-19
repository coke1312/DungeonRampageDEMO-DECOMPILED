package Brain.Sound
{
   import flash.events.Event;
   
   public class SoundCategoryVoumeChangedEvent extends Event
   {
      
      public static const TYPE:String = "SoundCategoryVoumeChangedEvent";
      
      public function SoundCategoryVoumeChangedEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super("SoundCategoryVoumeChangedEvent",param1,param2);
      }
   }
}

