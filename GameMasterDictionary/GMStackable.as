package GameMasterDictionary
{
   public class GMStackable extends GMInventoryBase
   {
      
      public var StackLimit:uint;
      
      public var EquipLimit:uint;
      
      public var LevelReq:uint;
      
      public var ExpMult:Number;
      
      public var GoldMult:Number;
      
      public var AccountBooster:Boolean;
      
      public var Buff:String;
      
      public var UsageAttack:String;
      
      public function GMStackable(param1:Object)
      {
         super(param1);
         StackLimit = param1.StackLimit;
         EquipLimit = param1.EquipLimit;
         LevelReq = param1.LevelReq;
         ExpMult = param1.ExpMult;
         GoldMult = param1.GoldMult;
         Buff = param1.BuffGiven;
         UsageAttack = param1.UsageAttack;
         AccountBooster = param1.AccountBooster;
      }
   }
}

