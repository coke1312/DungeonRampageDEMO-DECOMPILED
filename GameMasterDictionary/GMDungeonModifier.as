package GameMasterDictionary
{
   public class GMDungeonModifier
   {
      
      public var Id:uint;
      
      public var Constant:String;
      
      public var Name:String;
      
      public var Description:String;
      
      public var BuffId:uint;
      
      public var IsPlayerBuff:Boolean;
      
      public var NPCSpawnId:uint;
      
      public var NPCDeathSpawnId:uint;
      
      public var NPCDeathSpawnCharType:String;
      
      public var NPCDeathSpawnMaxGeneration:uint;
      
      public var NPCDeathSpawnChance:Number;
      
      public var NPCDeathSpawnMinCount:uint;
      
      public var NPCDeathSpawnMaxCount:uint;
      
      public var IconFilepath:String;
      
      public var IconName:String;
      
      public function GMDungeonModifier(param1:Object)
      {
         super();
         Id = param1.Id;
         Constant = param1.Constant;
         Name = param1.Name;
         Description = param1.Description;
         BuffId = param1.BuffId;
         IsPlayerBuff = param1.IsPlayerBuff;
         NPCSpawnId = param1.NPCSpawnId;
         NPCDeathSpawnId = param1.NPCDeathSpawnId;
         NPCDeathSpawnCharType = param1.NPCDeathSpawnCharType;
         NPCDeathSpawnMaxGeneration = param1.NPCDeathSpawnMaxGeneration;
         NPCDeathSpawnChance = param1.NPCDeathSpawnChance;
         NPCDeathSpawnMinCount = param1.NPCDeathSpawnMinCount;
         NPCDeathSpawnMaxCount = param1.NPCDeathSpawnMaxCount;
         IconFilepath = param1.IconFilepath;
         IconName = param1.IconName;
      }
   }
}

