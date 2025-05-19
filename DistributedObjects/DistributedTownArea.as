package DistributedObjects
{
   import Brain.Facade.Facade;
   import Brain.GameObject.GameObject;
   import GeneratedCode.DistributedTownAreaNetworkComponent;
   import GeneratedCode.IDistributedTownArea;
   
   public class DistributedTownArea extends GameObject implements IDistributedTownArea
   {
      
      public function DistributedTownArea(param1:Facade, param2:uint = 0)
      {
         super(param1,param2);
      }
      
      public function setNetworkComponentDistributedTownArea(param1:DistributedTownAreaNetworkComponent) : void
      {
      }
      
      public function postGenerate() : void
      {
      }
      
      public function tileLibrary(param1:String) : void
      {
      }
   }
}

