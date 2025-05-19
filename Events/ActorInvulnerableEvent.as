package Events
{
   public class ActorInvulnerableEvent extends GameObjectEvent
   {
      
      public var mIsInvulnerable:Boolean;
      
      public function ActorInvulnerableEvent(param1:String, param2:uint, param3:Boolean, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param2,param4,param5);
         mIsInvulnerable = param3;
      }
   }
}

