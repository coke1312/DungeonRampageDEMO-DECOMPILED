package GeneratedCode
{
   import Brain.GameObject.GameObject;
   
   public interface IMatchMaker
   {
      
      function setNetworkComponentMatchMaker(param1:MatchMakerNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function InfiniteDetails(param1:Vector.<InfiniteMapNodeDetail>) : void;
      
      function ClientRequestEntryResponce(param1:uint, param2:uint) : void;
      
      function ClientExitComplete(param1:uint) : void;
      
      function ClientInformPartyComposition(param1:Vector.<GameServerPartyMember>) : void;
   }
}

