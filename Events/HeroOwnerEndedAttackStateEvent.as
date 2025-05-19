package Events
{
   import flash.events.Event;
   
   public class HeroOwnerEndedAttackStateEvent extends Event
   {
      
      public static const EVENT_NAME:String = "PLAYER_ENDED_ATTACK_STATE";
      
      public function HeroOwnerEndedAttackStateEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

