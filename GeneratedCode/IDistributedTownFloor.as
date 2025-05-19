package GeneratedCode
{
   import Brain.GameObject.GameObject;
   
   public interface IDistributedTownFloor
   {
      
      function setNetworkComponentDistributedTownFloor(param1:DistributedTownFloorNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function tileLibrary(param1:String) : void;
      
      function tiles(param1:Vector.<DungeonTileUsage>) : void;
   }
}

