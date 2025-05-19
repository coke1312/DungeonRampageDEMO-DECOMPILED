package GeneratedCode
{
   import Brain.GameObject.GameObject;
   
   public interface IPresenceManager
   {
      
      function setNetworkComponentPresenceManager(param1:PresenceManagerNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function friendState(param1:uint, param2:uint, param3:uint) : void;
   }
}

