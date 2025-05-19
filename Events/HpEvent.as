package Events
{
   public class HpEvent extends GameObjectEvent
   {
      
      public static const HP_UPDATE:String = "HpEvent_HP_UPDATE";
      
      public var hp:uint;
      
      public var maxHp:uint;
      
      public function HpEvent(param1:String, param2:uint, param3:uint, param4:uint, param5:Boolean = false, param6:Boolean = false)
      {
         this.hp = param3;
         this.maxHp = param4;
         super(param1,param2,param5,param6);
      }
   }
}

