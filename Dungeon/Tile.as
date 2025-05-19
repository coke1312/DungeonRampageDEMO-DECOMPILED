package Dungeon
{
   import Actor.ActorGameObject;
   import Brain.Logger.Logger;
   import Brain.SceneGraph.SceneGraphComponent;
   import Collision.LocalHeroProximitySensor;
   import DistributedObjects.DistributedDungeonFloor;
   import DistributedObjects.NPCGameObject;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import Projectile.ChainProjectileGameObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import org.as3commons.collections.Set;
   import org.as3commons.collections.framework.IIterator;
   
   public class Tile extends FloorObject
   {
      
      public static const TILE_WIDTH:uint = 900;
      
      public static const TILE_HEIGHT:uint = 900;
      
      private var mNumberOfProps:uint;
      
      private var mPropsAdded:uint = 0;
      
      private var mFloorObjects:Set = new Set();
      
      private var mOwnedFloorObjects:Set = new Set();
      
      private var mActorGameObjects:Set = new Set();
      
      private var mNPCGameObjects:Set = new Set();
      
      private var mProjectileGameObjects:Set = new Set();
      
      private var mBounds:Rectangle;
      
      private var mBackground:Prop;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mOnStage:Boolean = false;
      
      private var mIsFiller:Boolean = false;
      
      private var mLocalHeroProximitySensors:Vector.<LocalHeroProximitySensor>;
      
      public function Tile(param1:DBFacade, param2:uint, param3:Boolean)
      {
         super(param1);
         mIsFiller = param3;
         mBounds = new Rectangle(0,0,900,900);
         mSceneGraphComponent = new SceneGraphComponent(param1);
         mNumberOfProps = param2 + 1;
         mLocalHeroProximitySensors = new Vector.<LocalHeroProximitySensor>();
         checkIfFinished();
         this.init();
      }
      
      public function isFiller() : Boolean
      {
         return mIsFiller;
      }
      
      public function addOwnedFloorObject(param1:FloorObject) : Boolean
      {
         return mOwnedFloorObjects.add(param1);
      }
      
      public function removeOwnedFloorObject(param1:FloorObject) : Boolean
      {
         return mOwnedFloorObjects.remove(param1);
      }
      
      public function hasOwnedFloorObject(param1:FloorObject) : Boolean
      {
         return mOwnedFloorObjects.has(param1);
      }
      
      override public function destroy() : void
      {
         var _loc2_:FloorObject = null;
         var _loc1_:IIterator = mOwnedFloorObjects.iterator();
         while(_loc1_.hasNext())
         {
            _loc2_ = _loc1_.next();
            _loc2_.destroy();
         }
         mOwnedFloorObjects.clear();
         mOwnedFloorObjects = null;
         _loc1_ = mProjectileGameObjects.iterator();
         while(_loc1_.hasNext())
         {
            _loc2_ = _loc1_.next();
            _loc2_.destroy();
         }
         mProjectileGameObjects = null;
         mFloorObjects.clear();
         mFloorObjects = null;
         mActorGameObjects.clear();
         mActorGameObjects = null;
         mNPCGameObjects.clear();
         mNPCGameObjects = null;
         mBackground = null;
         mSceneGraphComponent.destroy();
         mSceneGraphComponent = null;
         super.destroy();
      }
      
      override public function set position(param1:Vector3D) : void
      {
         super.position = param1;
         mBounds.x = this.position.x;
         mBounds.y = this.position.y;
      }
      
      public function get bounds() : Rectangle
      {
         return mBounds;
      }
      
      public function get isOnStage() : Boolean
      {
         return mOnStage;
      }
      
      public function contains(param1:Number, param2:Number) : Boolean
      {
         return mBounds.contains(param1,param2);
      }
      
      public function containsPoint(param1:Vector3D) : Boolean
      {
         return mBounds.containsPoint(new Point(param1.x,param1.y));
      }
      
      public function get floorObjects() : Set
      {
         return mFloorObjects;
      }
      
      public function get actorGameObjects() : Set
      {
         return mActorGameObjects;
      }
      
      public function get NPCGameObjects() : Set
      {
         return mNPCGameObjects;
      }
      
      protected function checkIfFinished() : void
      {
         if(mPropsAdded == mNumberOfProps)
         {
         }
      }
      
      public function expandBounds(param1:FloorObject) : void
      {
         mBounds = mBounds.union(param1.view.root.getBounds(mFacade.sceneGraphManager.worldTransformNode));
      }
      
      public function addFloorObject(param1:FloorObject) : void
      {
         mFloorObjects.add(param1);
         if(param1 is ActorGameObject)
         {
            mActorGameObjects.add(param1);
         }
         if(param1 is NPCGameObject)
         {
            mNPCGameObjects.add(param1);
         }
         if(param1 is ChainProjectileGameObject)
         {
            mProjectileGameObjects.add(param1);
         }
         mPropsAdded++;
         checkIfFinished();
         if(mOnStage)
         {
            param1.view.addToStage();
         }
         else
         {
            param1.view.removeFromStage();
         }
      }
      
      public function removeFloorObject(param1:FloorObject) : void
      {
         if(mFloorObjects)
         {
            mFloorObjects.remove(param1);
         }
         if(param1 is ActorGameObject && mActorGameObjects)
         {
            mActorGameObjects.remove(param1);
         }
         if(param1 is NPCGameObject && mNPCGameObjects)
         {
            mNPCGameObjects.remove(param1);
         }
         if(param1 is ChainProjectileGameObject && mProjectileGameObjects)
         {
            mProjectileGameObjects.remove(param1);
         }
      }
      
      public function ignoredAProp() : void
      {
         mPropsAdded++;
         checkIfFinished();
      }
      
      public function set background(param1:Prop) : void
      {
         mBackground = param1;
         if(mOnStage)
         {
            mSceneGraphComponent.addChildAt(mBackground.view.root,5,0);
         }
         mPropsAdded++;
         checkIfFinished();
      }
      
      public function get background() : Prop
      {
         return mBackground;
      }
      
      public function addToStage() : void
      {
         var _loc2_:FloorObject = null;
         if(mOnStage)
         {
            return;
         }
         var _loc1_:IIterator = mFloorObjects.iterator();
         while(_loc1_.hasNext())
         {
            _loc2_ = _loc1_.next();
            if(_loc2_.view == null)
            {
               Logger.warn("floorObject with null view attempted addToStage id: " + _loc2_.id);
            }
            else
            {
               _loc2_.view.addToStage();
            }
         }
         if(mBackground)
         {
            mBackground.view.root.parent.setChildIndex(mBackground.view.root,0);
         }
         mOnStage = true;
      }
      
      public function removeFromStage() : void
      {
         var _loc2_:FloorObject = null;
         if(!mOnStage)
         {
            return;
         }
         var _loc1_:IIterator = mFloorObjects.iterator();
         while(_loc1_.hasNext())
         {
            _loc2_ = _loc1_.next();
            if(_loc2_.view == null)
            {
               Logger.warn("floorObject with null view attempted removeFromStage id: " + _loc2_.id);
            }
            else
            {
               _loc2_.view.removeFromStage();
            }
         }
         mOnStage = false;
      }
      
      public function createLocalEventCollision(param1:DistributedDungeonFloor, param2:uint, param3:uint, param4:uint, param5:Boolean, param6:Function) : void
      {
         mLocalHeroProximitySensors.push(new LocalHeroProximitySensor(mDBFacade,param1,this.position.x + param2,this.position.y + param3,param4,param5,param6));
      }
   }
}

