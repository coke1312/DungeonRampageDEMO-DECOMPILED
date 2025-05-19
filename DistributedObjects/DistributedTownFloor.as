package DistributedObjects
{
   import Brain.Facade.Facade;
   import Brain.GameObject.GameObject;
   import GeneratedCode.DistributedTownFloorNetworkComponent;
   import GeneratedCode.DungeonTileUsage;
   import GeneratedCode.IDistributedTownFloor;
   
   public class DistributedTownFloor extends GameObject implements IDistributedTownFloor
   {
      
      public function DistributedTownFloor(param1:Facade, param2:uint = 0)
      {
         super(param1,param2);
      }
      
      public function setNetworkComponentDistributedTownFloor(param1:DistributedTownFloorNetworkComponent) : void
      {
      }
      
      public function postGenerate() : void
      {
      }
      
      public function tileLibrary(param1:String) : void
      {
      }
      
      public function tiles(param1:Vector.<DungeonTileUsage>) : void
      {
      }
   }
}

