package GeneratedCode
{
   import Brain.GameObject.GameObject;
   import flash.geom.Vector3D;
   
   public interface IDistributedDooberGameObject
   {
      
      function setNetworkComponentDistributedDooberGameObject(param1:DistributedDooberGameObjectNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function set type(param1:uint) : void;
      
      function set position(param1:Vector3D) : void;
      
      function set layer(param1:int) : void;
      
      function spawnFrom(param1:Vector3D) : void;
      
      function collectedBy(param1:uint) : void;
   }
}

