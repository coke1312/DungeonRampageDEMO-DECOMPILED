package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class Attack
   {
      
      public var weaponSlot:int;
      
      public var isConsumableWeapon:uint;
      
      public var attackType:uint;
      
      public var targetActorDoid:uint;
      
      public function Attack()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : Attack
      {
         var _loc2_:Attack = new Attack();
         _loc2_.weaponSlot = param1.readByte();
         _loc2_.isConsumableWeapon = param1.readUnsignedByte();
         _loc2_.attackType = param1.readUnsignedInt();
         _loc2_.targetActorDoid = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         param1.writeByte(weaponSlot);
         param1.writeByte(isConsumableWeapon);
         param1.writeUnsignedInt(attackType);
         param1.writeUnsignedInt(targetActorDoid);
      }
   }
}

