package GeneratedCode
{
   import Brain.GameObject.GameObject;
   
   public interface IPlayerGameObject
   {
      
      function setNetworkComponentPlayerGameObject(param1:PlayerGameObjectNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function set screenName(param1:String) : void;
      
      function Chat(param1:String) : void;
      
      function ShowPlayerIsTyping(param1:uint) : void;
   }
}

