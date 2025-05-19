package GeneratedCode
{
   import Brain.GameObject.GameObject;
   
   public interface IDistributedDungionArea
   {
      
      function setNetworkComponentDistributedDungionArea(param1:DistributedDungionAreaNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function tileLibrary(param1:Vector.<swrapper>) : void;
      
      function set cacheNpc(param1:Vector.<uint>) : void;
      
      function set cacheSWC(param1:Vector.<swrapper>) : void;
      
      function floorReward(param1:uint) : void;
      
      function floorEnding(param1:uint) : void;
      
      function dungeonEnding(param1:uint, param2:uint) : void;
      
      function floorfailing(param1:uint) : void;
      
      function tellClientInfiniteRewardData(param1:uint, param2:uint, param3:uint, param4:Vector.<InfiniteRewardData>) : void;
   }
}

