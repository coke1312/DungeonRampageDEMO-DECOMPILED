package GeneratedCode
{
   import Brain.GameObject.GameObject;
   
   public interface IDistributedDungeonFloor
   {
      
      function setNetworkComponentDistributedDungeonFloor(param1:DistributedDungeonFloorNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function set mapNodeId(param1:uint) : void;
      
      function set coliseumTierConstant(param1:String) : void;
      
      function tileLibrary(param1:String) : void;
      
      function tiles(param1:Vector.<DungeonTileUsage>) : void;
      
      function set baseLining(param1:uint) : void;
      
      function set introMovieSwfFilePath(param1:String) : void;
      
      function set introMovieAssetClassName(param1:String) : void;
      
      function set currentFloorNum(param1:uint) : void;
      
      function set activeDungeonModifiers(param1:Vector.<DungeonModifier>) : void;
      
      function show_text(param1:String) : void;
      
      function play_sound(param1:String) : void;
      
      function trigger_camera_zoom(param1:Number) : void;
      
      function trigger_camera_shake(param1:Number, param2:Number, param3:uint) : void;
   }
}

