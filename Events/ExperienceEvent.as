package Events
{
   public class ExperienceEvent extends GameObjectEvent
   {
      
      public static const EXPERIENCE_UPDATE:String = "ExperienceEvent_EXPERIENCE_UPDATE";
      
      public var experience:uint;
      
      public function ExperienceEvent(param1:String, param2:uint, param3:uint, param4:Boolean = false, param5:Boolean = false)
      {
         this.experience = param3;
         super(param1,param2,param4,param5);
      }
   }
}

