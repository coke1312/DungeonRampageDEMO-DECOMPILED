package GameMasterDictionary
{
   public class GMModifier extends GMItem
   {
      
      public var Type:String;
      
      public var Level:uint;
      
      public var IconName:String;
      
      public var Description:String;
      
      public var MELEE_SPD:Number;
      
      public var SHOOT_SPD:Number;
      
      public var MAGIC_SPD:Number;
      
      public var MP_COST:Number;
      
      public var CHAIN:Number;
      
      public var PIERCE:Number;
      
      public var MODIFIER_LEVEL:Number;
      
      public var MODIFIER_TYPE:String;
      
      public var COOLDOWN_REDUC:Number;
      
      public var CHARGE_REDUC:Number;
      
      public var INCREASE_COLLISION:Number;
      
      public var MAX_PROJECTILES:uint;
      
      public var INCREASED_PROJECTILE_ANGLE_PERCENT:Number;
      
      public function GMModifier(param1:Object)
      {
         super(param1);
         Type = param1.MODIFIER_TYPE;
         Level = param1.MODIFIER_LEVEL;
         IconName = param1.IconName;
         Description = param1.Description;
         MODIFIER_LEVEL = param1.MODIFIER_LEVEL;
         MODIFIER_TYPE = param1.MODIFIER_TYPE;
         MELEE_SPD = 1;
         SHOOT_SPD = 1;
         MAGIC_SPD = 1;
         MP_COST = 1;
         CHAIN = 0;
         PIERCE = 0;
         COOLDOWN_REDUC = 1;
         CHARGE_REDUC = 1;
         INCREASE_COLLISION = 1;
         MAX_PROJECTILES = 0;
         INCREASED_PROJECTILE_ANGLE_PERCENT = 0;
         if(param1.hasOwnProperty("MELEE_SPD"))
         {
            MELEE_SPD = param1.MELEE_SPD;
         }
         if(param1.hasOwnProperty("SHOOT_SPD"))
         {
            SHOOT_SPD = param1.SHOOT_SPD;
         }
         if(param1.hasOwnProperty("MAGIC_SPD"))
         {
            MAGIC_SPD = param1.MAGIC_SPD;
         }
         if(param1.hasOwnProperty("MP_COST"))
         {
            MP_COST = param1.MP_COST;
         }
         if(param1.hasOwnProperty("PIERCE"))
         {
            PIERCE = param1.PIERCE;
         }
         if(param1.hasOwnProperty("CHAIN"))
         {
            CHAIN = param1.CHAIN;
         }
         if(param1.hasOwnProperty("MAX_PROJECTILES"))
         {
            MAX_PROJECTILES = param1.MAX_PROJECTILES;
         }
         if(param1.hasOwnProperty("INCREASED_PROJECTILE_ANGLE_PERCENT"))
         {
            INCREASED_PROJECTILE_ANGLE_PERCENT = param1.INCREASED_PROJECTILE_ANGLE_PERCENT;
         }
         if(param1.hasOwnProperty("COOLDOWN_REDUC"))
         {
            COOLDOWN_REDUC = param1.COOLDOWN_REDUC;
         }
         if(param1.hasOwnProperty("CHARGE_UP_REDUC"))
         {
            CHARGE_REDUC = param1.CHARGE_UP_REDUC;
         }
         if(param1.hasOwnProperty("ATTACK_COLLISION_SCALE"))
         {
            INCREASE_COLLISION = param1.ATTACK_COLLISION_SCALE as Number;
         }
      }
   }
}

