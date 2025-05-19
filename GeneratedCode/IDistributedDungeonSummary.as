package GeneratedCode
{
   import Brain.GameObject.GameObject;
   
   public interface IDistributedDungeonSummary
   {
      
      function setNetworkComponentDistributedDungeonSummary(param1:DistributedDungeonSummaryNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function set map_node_id(param1:uint) : void;
      
      function set report(param1:Vector.<DungeonReport>) : void;
      
      function set dungeon_name(param1:String) : void;
      
      function set dungeonSuccess(param1:uint) : void;
      
      function set dungeonMod1(param1:uint) : void;
      
      function set dungeonMod2(param1:uint) : void;
      
      function set dungeonMod3(param1:uint) : void;
      
      function set dungeonMod4(param1:uint) : void;
      
      function TransactionResponse(param1:uint, param2:uint, param3:uint, param4:uint) : void;
   }
}

