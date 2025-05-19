package Events
{
   public class ManaEvent extends GameObjectEvent
   {
      
      public static const MANA_UPDATE:String = "ManaEvent_MANA_UPDATE";
      
      public var mana:uint;
      
      public var maxMana:uint;
      
      public function ManaEvent(param1:String, param2:uint, param3:uint, param4:uint, param5:Boolean = false, param6:Boolean = false)
      {
         this.mana = param3;
         this.maxMana = param4;
         super(param1,param2,param5,param6);
      }
   }
}

