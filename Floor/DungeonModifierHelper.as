package Floor
{
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import GameMasterDictionary.GMDungeonModifier;
   
   public class DungeonModifierHelper
   {
      
      public var GMDungeonMod:GMDungeonModifier;
      
      public var NewThisFloor:Boolean;
      
      public function DungeonModifierHelper(param1:uint, param2:Boolean, param3:DBFacade)
      {
         super();
         GMDungeonMod = param3.gameMaster.dungeonModifierById.itemFor(param1);
         if(GMDungeonMod == null)
         {
            Logger.error("Unable to find GMDungeonModifier with ID: " + param1);
         }
         NewThisFloor = param2;
      }
   }
}

