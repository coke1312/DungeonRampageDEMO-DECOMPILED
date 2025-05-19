package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class DungeonReport
   {
      
      public var name:String;
      
      public var trophyCount:uint;
      
      public var id:uint;
      
      public var type:uint;
      
      public var skin_type:uint;
      
      public var kills:uint;
      
      public var xp:uint;
      
      public var xp_earned:uint;
      
      public var xp_bonus:uint;
      
      public var team_xp_bonus:uint;
      
      public var gold_earned:uint;
      
      public var boost_xp:Number;
      
      public var boost_gold:Number;
      
      public var receivedTrophy:uint;
      
      public var dungeonModifier1:uint;
      
      public var dungeonModifier2:uint;
      
      public var dungeonModifier3:uint;
      
      public var dungeonModifier4:uint;
      
      public var loot_type_1:uint;
      
      public var loot_type_2:uint;
      
      public var loot_type_3:uint;
      
      public var loot_type_4:uint;
      
      public var weapon_level_1:uint;
      
      public var weapon_level_2:uint;
      
      public var weapon_level_3:uint;
      
      public var weapon_type_1:uint;
      
      public var weapon_type_2:uint;
      
      public var weapon_type_3:uint;
      
      public var modifier_type_1a:uint;
      
      public var modifier_type_1b:uint;
      
      public var legendary_modifier_type_1:uint;
      
      public var modifier_type_2a:uint;
      
      public var modifier_type_2b:uint;
      
      public var legendary_modifier_type_2:uint;
      
      public var modifier_type_3a:uint;
      
      public var modifier_type_3b:uint;
      
      public var legendary_modifier_type_3:uint;
      
      public var weapon_power_1:uint;
      
      public var weapon_power_2:uint;
      
      public var weapon_power_3:uint;
      
      public var weapon_rarity_1:uint;
      
      public var weapon_rarity_2:uint;
      
      public var weapon_rarity_3:uint;
      
      public var chest_type_1:uint;
      
      public var chest_type_2:uint;
      
      public var chest_type_3:uint;
      
      public var chest_type_4:uint;
      
      public var valid:uint;
      
      public var account_flags:uint;
      
      public var totalAvatarsOwned:uint;
      
      public var consumable1_id:uint;
      
      public var consumable1_count:uint;
      
      public var consumable2_id:uint;
      
      public var consumable2_count:uint;
      
      public function DungeonReport()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : DungeonReport
      {
         var _loc2_:DungeonReport = new DungeonReport();
         _loc2_.name = param1.readUTF();
         _loc2_.trophyCount = param1.readUnsignedInt();
         _loc2_.id = param1.readUnsignedInt();
         _loc2_.type = param1.readUnsignedInt();
         _loc2_.skin_type = param1.readUnsignedInt();
         _loc2_.kills = param1.readUnsignedInt();
         _loc2_.xp = param1.readUnsignedInt();
         _loc2_.xp_earned = param1.readUnsignedInt();
         _loc2_.xp_bonus = param1.readUnsignedInt();
         _loc2_.team_xp_bonus = param1.readUnsignedInt();
         _loc2_.gold_earned = param1.readUnsignedInt();
         _loc2_.boost_xp = param1.readFloat();
         _loc2_.boost_gold = param1.readFloat();
         _loc2_.receivedTrophy = param1.readUnsignedByte();
         _loc2_.dungeonModifier1 = param1.readUnsignedInt();
         _loc2_.dungeonModifier2 = param1.readUnsignedInt();
         _loc2_.dungeonModifier3 = param1.readUnsignedInt();
         _loc2_.dungeonModifier4 = param1.readUnsignedInt();
         _loc2_.loot_type_1 = param1.readUnsignedInt();
         _loc2_.loot_type_2 = param1.readUnsignedInt();
         _loc2_.loot_type_3 = param1.readUnsignedInt();
         _loc2_.loot_type_4 = param1.readUnsignedInt();
         _loc2_.weapon_level_1 = param1.readUnsignedInt();
         _loc2_.weapon_level_2 = param1.readUnsignedInt();
         _loc2_.weapon_level_3 = param1.readUnsignedInt();
         _loc2_.weapon_type_1 = param1.readUnsignedInt();
         _loc2_.weapon_type_2 = param1.readUnsignedInt();
         _loc2_.weapon_type_3 = param1.readUnsignedInt();
         _loc2_.modifier_type_1a = param1.readUnsignedInt();
         _loc2_.modifier_type_1b = param1.readUnsignedInt();
         _loc2_.legendary_modifier_type_1 = param1.readUnsignedInt();
         _loc2_.modifier_type_2a = param1.readUnsignedInt();
         _loc2_.modifier_type_2b = param1.readUnsignedInt();
         _loc2_.legendary_modifier_type_2 = param1.readUnsignedInt();
         _loc2_.modifier_type_3a = param1.readUnsignedInt();
         _loc2_.modifier_type_3b = param1.readUnsignedInt();
         _loc2_.legendary_modifier_type_3 = param1.readUnsignedInt();
         _loc2_.weapon_power_1 = param1.readUnsignedInt();
         _loc2_.weapon_power_2 = param1.readUnsignedInt();
         _loc2_.weapon_power_3 = param1.readUnsignedInt();
         _loc2_.weapon_rarity_1 = param1.readUnsignedInt();
         _loc2_.weapon_rarity_2 = param1.readUnsignedInt();
         _loc2_.weapon_rarity_3 = param1.readUnsignedInt();
         _loc2_.chest_type_1 = param1.readUnsignedInt();
         _loc2_.chest_type_2 = param1.readUnsignedInt();
         _loc2_.chest_type_3 = param1.readUnsignedInt();
         _loc2_.chest_type_4 = param1.readUnsignedInt();
         _loc2_.valid = param1.readUnsignedByte();
         _loc2_.account_flags = param1.readUnsignedInt();
         _loc2_.totalAvatarsOwned = param1.readUnsignedInt();
         _loc2_.consumable1_id = param1.readUnsignedInt();
         _loc2_.consumable1_count = param1.readUnsignedInt();
         _loc2_.consumable2_id = param1.readUnsignedInt();
         _loc2_.consumable2_count = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         param1.writeUTF(name);
         param1.writeUnsignedInt(trophyCount);
         param1.writeUnsignedInt(id);
         param1.writeUnsignedInt(type);
         param1.writeUnsignedInt(skin_type);
         param1.writeUnsignedInt(kills);
         param1.writeUnsignedInt(xp);
         param1.writeUnsignedInt(xp_earned);
         param1.writeUnsignedInt(xp_bonus);
         param1.writeUnsignedInt(team_xp_bonus);
         param1.writeUnsignedInt(gold_earned);
         param1.writeFloat(boost_xp);
         param1.writeFloat(boost_gold);
         param1.writeByte(receivedTrophy);
         param1.writeUnsignedInt(dungeonModifier1);
         param1.writeUnsignedInt(dungeonModifier2);
         param1.writeUnsignedInt(dungeonModifier3);
         param1.writeUnsignedInt(dungeonModifier4);
         param1.writeUnsignedInt(loot_type_1);
         param1.writeUnsignedInt(loot_type_2);
         param1.writeUnsignedInt(loot_type_3);
         param1.writeUnsignedInt(loot_type_4);
         param1.writeUnsignedInt(weapon_level_1);
         param1.writeUnsignedInt(weapon_level_2);
         param1.writeUnsignedInt(weapon_level_3);
         param1.writeUnsignedInt(weapon_type_1);
         param1.writeUnsignedInt(weapon_type_2);
         param1.writeUnsignedInt(weapon_type_3);
         param1.writeUnsignedInt(modifier_type_1a);
         param1.writeUnsignedInt(modifier_type_1b);
         param1.writeUnsignedInt(legendary_modifier_type_1);
         param1.writeUnsignedInt(modifier_type_2a);
         param1.writeUnsignedInt(modifier_type_2b);
         param1.writeUnsignedInt(legendary_modifier_type_2);
         param1.writeUnsignedInt(modifier_type_3a);
         param1.writeUnsignedInt(modifier_type_3b);
         param1.writeUnsignedInt(legendary_modifier_type_3);
         param1.writeUnsignedInt(weapon_power_1);
         param1.writeUnsignedInt(weapon_power_2);
         param1.writeUnsignedInt(weapon_power_3);
         param1.writeUnsignedInt(weapon_rarity_1);
         param1.writeUnsignedInt(weapon_rarity_2);
         param1.writeUnsignedInt(weapon_rarity_3);
         param1.writeUnsignedInt(chest_type_1);
         param1.writeUnsignedInt(chest_type_2);
         param1.writeUnsignedInt(chest_type_3);
         param1.writeUnsignedInt(chest_type_4);
         param1.writeByte(valid);
         param1.writeUnsignedInt(account_flags);
         param1.writeUnsignedInt(totalAvatarsOwned);
         param1.writeUnsignedInt(consumable1_id);
         param1.writeUnsignedInt(consumable1_count);
         param1.writeUnsignedInt(consumable2_id);
         param1.writeUnsignedInt(consumable2_count);
      }
   }
}

