package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class WeaponDetails
   {
      
      public var type:uint;
      
      public var power:uint;
      
      public var requiredlevel:uint;
      
      public var rarity:uint;
      
      public var modifier1:uint;
      
      public var modifier2:uint;
      
      public var legendarymodifier:uint;
      
      public function WeaponDetails()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : WeaponDetails
      {
         var _loc2_:WeaponDetails = new WeaponDetails();
         _loc2_.type = param1.readUnsignedInt();
         _loc2_.power = param1.readUnsignedShort();
         _loc2_.requiredlevel = param1.readUnsignedByte();
         _loc2_.rarity = param1.readUnsignedByte();
         _loc2_.modifier1 = param1.readUnsignedInt();
         _loc2_.modifier2 = param1.readUnsignedInt();
         _loc2_.legendarymodifier = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         param1.writeUnsignedInt(type);
         param1.writeShort(power);
         param1.writeByte(requiredlevel);
         param1.writeByte(rarity);
         param1.writeUnsignedInt(modifier1);
         param1.writeUnsignedInt(modifier2);
         param1.writeUnsignedInt(legendarymodifier);
      }
   }
}

