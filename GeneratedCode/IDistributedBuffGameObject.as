package GeneratedCode
{
   import Brain.GameObject.GameObject;
   
   public interface IDistributedBuffGameObject
   {
      
      function setNetworkComponentDistributedBuffGameObject(param1:DistributedBuffGameObjectNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function set type(param1:uint) : void;
      
      function set effectedActor(param1:uint) : void;
   }
}

