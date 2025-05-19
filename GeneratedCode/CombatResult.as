package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class CombatResult
   {
      
      public var attacker:uint;
      
      public var attackee:uint;
      
      public var damage:int;
      
      public var attack:Attack;
      
      public var when:uint;
      
      public var suffer:uint;
      
      public var knockback:uint;
      
      public var blocked:uint;
      
      public var criticalHit:uint;
      
      public var effectiveness:int;
      
      public var selfDamage:int;
      
      public var scalingMaxPowerMultiplier:Number;
      
      public var generation:uint;
      
      public function CombatResult()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : CombatResult
      {
         var _loc2_:CombatResult = new CombatResult();
         _loc2_.attacker = param1.readUnsignedInt();
         _loc2_.attackee = param1.readUnsignedInt();
         _loc2_.damage = param1.readInt();
         _loc2_.attack = Attack.readFromPacket(param1);
         _loc2_.when = param1.readUnsignedByte();
         _loc2_.suffer = param1.readUnsignedByte();
         _loc2_.knockback = param1.readUnsignedByte();
         _loc2_.blocked = param1.readUnsignedByte();
         _loc2_.criticalHit = param1.readUnsignedByte();
         _loc2_.effectiveness = param1.readByte();
         _loc2_.selfDamage = param1.readInt();
         _loc2_.scalingMaxPowerMultiplier = param1.readFloat();
         _loc2_.generation = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         param1.writeUnsignedInt(attacker);
         param1.writeUnsignedInt(attackee);
         param1.writeInt(damage);
         attack.writeToPacket(param1);
         param1.writeByte(when);
         param1.writeByte(suffer);
         param1.writeByte(knockback);
         param1.writeByte(blocked);
         param1.writeByte(criticalHit);
         param1.writeByte(effectiveness);
         param1.writeInt(selfDamage);
         param1.writeFloat(scalingMaxPowerMultiplier);
         param1.writeByte(generation);
      }
   }
}

