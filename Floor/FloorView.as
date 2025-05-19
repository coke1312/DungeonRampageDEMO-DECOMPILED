package Floor
{
   import Brain.GameObject.View;
   import Brain.Logger.Logger;
   import Dungeon.NavCollider;
   import Facade.DBFacade;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Vector3D;
   
   public class FloorView extends View
   {
      
      protected var mParentFloorObject:FloorObject;
      
      protected var mLayer:int = 0;
      
      protected var mDBFacade:DBFacade;
      
      public function FloorView(param1:DBFacade, param2:FloorObject)
      {
         mDBFacade = param1;
         super(param1);
         mParentFloorObject = param2;
      }
      
      public static function findNavCollisions(param1:DisplayObjectContainer) : Array
      {
         return findChildrenOfClass(param1,["NavCollisionCircle","NavCollisionRectangle"]);
      }
      
      public static function findCombatCollisions(param1:DisplayObjectContainer) : Array
      {
         return findChildrenOfClass(param1,["CombatCollisionCircle","CombatCollisionRectangle"]);
      }
      
      override public function set position(param1:Vector3D) : void
      {
         super.position = param1;
         for each(var _loc2_ in mParentFloorObject.navCollisions)
         {
            _loc2_.position = param1;
         }
      }
      
      public function get worldCenter() : Vector3D
      {
         return mParentFloorObject.worldCenter;
      }
      
      public function addToStage() : void
      {
         if(this.layer == 0)
         {
            Logger.error("Tried to addToStage with layer == 0");
         }
         else
         {
            mSceneGraphComponent.addChild(this.root,this.layer);
            checkoutMovieClipRenderers();
         }
      }
      
      public function removeFromStage() : void
      {
         if(this.layer && mSceneGraphComponent.contains(this.root,this.layer))
         {
            mSceneGraphComponent.removeChild(this.root);
         }
         checkinMovieClipRenderers();
      }
      
      protected function checkoutMovieClipRenderers() : void
      {
      }
      
      protected function checkinMovieClipRenderers() : void
      {
      }
      
      public function set layer(param1:int) : void
      {
         mLayer = param1;
      }
      
      override public function destroy() : void
      {
         mParentFloorObject = null;
         mDBFacade = null;
         super.destroy();
      }
      
      public function get layer() : int
      {
         return mLayer;
      }
   }
}

