package Floor
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2FilterData;
   import Brain.GameObject.GameObject;
   import Brain.Logger.Logger;
   import DistributedObjects.DistributedDungeonFloor;
   import Dungeon.NavCollider;
   import Dungeon.Tile;
   import Facade.DBFacade;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   public class FloorObject extends GameObject
   {
      
      protected var mPosition:Vector3D = new Vector3D();
      
      protected var mFloorView:FloorView;
      
      protected var mTile:Tile;
      
      protected var mArchwayAlpha:Boolean = false;
      
      protected var mDistributedDungeonFloor:DistributedDungeonFloor;
      
      protected var mWantNavCollisions:Boolean = true;
      
      protected var mNavCollisions:Vector.<NavCollider>;
      
      protected var mLayer:int = 0;
      
      protected var mDBFacade:DBFacade;
      
      protected var mFilter:b2FilterData;
      
      public function FloorObject(param1:DBFacade, param2:uint = 0)
      {
         super(param1,param2);
         mNavCollisions = new Vector.<NavCollider>();
         mDBFacade = param1;
         buildView();
      }
      
      override public function init() : void
      {
         super.init();
         mFloorView.init();
      }
      
      public function get wantNavCollision() : Boolean
      {
         return mWantNavCollisions;
      }
      
      public function get archwayAlpha() : Boolean
      {
         return mArchwayAlpha;
      }
      
      public function get distributedDungeonFloor() : DistributedDungeonFloor
      {
         return mDistributedDungeonFloor;
      }
      
      public function set distributedDungeonFloor(param1:DistributedDungeonFloor) : void
      {
         mDistributedDungeonFloor = param1;
         this.updateTile();
      }
      
      protected function updateTile() : void
      {
         if(mDistributedDungeonFloor)
         {
            this.tile = mDistributedDungeonFloor.tileGrid.getTileAtPosition(this.position);
         }
      }
      
      public function get navCollisions() : Vector.<NavCollider>
      {
         return mNavCollisions;
      }
      
      public function get worldCenter() : Vector3D
      {
         if(mNavCollisions == null || mNavCollisions.length == 0)
         {
            return mPosition;
         }
         if(mNavCollisions[0] == null)
         {
            Logger.warn("navCollision is null during get world center call on id: " + mId);
            return mPosition;
         }
         return mNavCollisions[0].worldCenter;
      }
      
      public function get worldCenterAsb2Vec2() : b2Vec2
      {
         if(mNavCollisions.length == 0)
         {
            return NavCollider.convertToB2Vec2(mPosition);
         }
         return NavCollider.convertToB2Vec2(mNavCollisions[0].worldCenter);
      }
      
      public function addNavCollision(param1:NavCollider) : void
      {
         if(!mWantNavCollisions)
         {
            Logger.warn("adding nav collision but wantNavCollision == false. Ignoring.");
            return;
         }
         mNavCollisions.push(param1);
      }
      
      public function removeNavColliders() : void
      {
         for each(var _loc1_ in mNavCollisions)
         {
            _loc1_.destroy();
         }
         mNavCollisions = new Vector.<NavCollider>();
      }
      
      public function set navCollidersActive(param1:Boolean) : void
      {
         for each(var _loc2_ in mNavCollisions)
         {
            _loc2_.active = param1;
         }
      }
      
      public function set tile(param1:Tile) : void
      {
         if(param1 == mTile)
         {
            return;
         }
         if(mTile)
         {
            mTile.removeFloorObject(this);
         }
         mTile = param1;
         if(mTile)
         {
            mTile.addFloorObject(this);
         }
      }
      
      public function get tile() : Tile
      {
         return mTile;
      }
      
      public function get position() : Vector3D
      {
         if(mPosition)
         {
            return mPosition.clone();
         }
         return null;
      }
      
      public function set position(param1:Vector3D) : void
      {
         mPosition = param1;
         this.updateTile();
      }
      
      public function set layer(param1:int) : void
      {
         mLayer = param1;
         mFloorView.layer = mLayer;
      }
      
      public function get layer() : int
      {
         return mLayer;
      }
      
      public function set view(param1:FloorView) : void
      {
         mFloorView = param1;
      }
      
      public function get view() : FloorView
      {
         return mFloorView;
      }
      
      protected function buildView() : void
      {
         view = new FloorView(mDBFacade,this);
      }
      
      protected function createNavCollisions(param1:String) : void
      {
         var _loc2_:Array = mDistributedDungeonFloor.dungeonFloorFactory.tileFactory.propFactory.getNavCollisionJson(param1);
         this.processJsonNavCollisions(_loc2_,this.addNavCollision);
      }
      
      protected function processJsonNavCollisions(param1:Array, param2:Function) : void
      {
         var _loc7_:* = null;
         var _loc3_:Vector3D = null;
         var _loc9_:Vector3D = null;
         var _loc8_:Vector3D = null;
         var _loc5_:NavCollider = null;
         var _loc4_:* = undefined;
         var _loc6_:Matrix3D = new Matrix3D();
         var _loc10_:Matrix3D = new Matrix3D();
         _loc10_.identity();
         _loc10_.appendScale(this.view.root.scaleX,this.view.root.scaleY,1);
         _loc10_.appendRotation(this.view.root.rotation,Vector3D.Z_AXIS);
         mFilter = buildFilter();
         for each(_loc7_ in param1)
         {
            _loc6_.identity();
            if(_loc7_.rotation)
            {
               _loc6_.appendRotation(_loc7_.rotation,Vector3D.Z_AXIS);
            }
            _loc6_.appendTranslation(_loc7_.x,_loc7_.y,0);
            _loc6_.append(_loc10_);
            _loc4_ = _loc6_.decompose();
            _loc3_ = _loc4_[0];
            _loc9_ = _loc4_[1];
            _loc8_ = _loc4_[2];
            _loc5_ = NavCollider.buildNavColliderFromJson(mDBFacade,_loc7_,this,_loc3_,_loc9_.z,_loc8_,this.mDistributedDungeonFloor.box2DWorld,mFilter);
            if(_loc5_)
            {
               _loc5_.position = this.position;
               param2(_loc5_);
            }
         }
      }
      
      protected function buildFilter() : b2FilterData
      {
         var _loc1_:b2FilterData = new b2FilterData();
         _loc1_.categoryBits = 1;
         return _loc1_;
      }
      
      override public function destroy() : void
      {
         if(mTile)
         {
            mTile.removeFloorObject(this);
         }
         mTile = null;
         mDistributedDungeonFloor = null;
         for each(var _loc1_ in mNavCollisions)
         {
            _loc1_.destroy();
         }
         mNavCollisions = null;
         if(mFloorView != null)
         {
            mFloorView.destroy();
            mFloorView = null;
         }
         mDBFacade = null;
         super.destroy();
      }
   }
}

