package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Logger.Logger;
   import Combat.CombatGameObject;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class ColliderTimelineAction extends AttackTimelineAction
   {
      
      protected var mHeadingOffset:Vector3D;
      
      protected var mGlobalOffset:Vector3D;
      
      protected var mWeapon:WeaponGameObject;
      
      protected var mDistributedDungeonFloor:DistributedDungeonFloor;
      
      protected var mCombatGameObject:CombatGameObject;
      
      protected var mCombatResultCallback:Function;
      
      protected var mLifeTime:uint;
      
      protected var mHitDelayPerObject:uint;
      
      public function ColliderTimelineAction(param1:WeaponGameObject, param2:ActorGameObject, param3:ActorView, param4:DBFacade, param5:DistributedDungeonFloor, param6:Function, param7:Vector3D, param8:Vector3D, param9:uint = 0, param10:uint = 0)
      {
         mLifeTime = param9;
         mWeapon = param1;
         mCombatResultCallback = param6;
         mHeadingOffset = param7;
         mGlobalOffset = param8;
         mDistributedDungeonFloor = param5;
         mHitDelayPerObject = param10;
         super(param2,param3,param4);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mCombatGameObject = buildCombatGameObject(mLifeTime,mHitDelayPerObject);
         perFrameUpCall(param1);
         if(mLifeTime > 0)
         {
            param1.addContinuousCollision(this);
         }
      }
      
      protected function buildCombatGameObject(param1:uint, param2:uint) : CombatGameObject
      {
         Logger.error("Build Combat Game Object should be overriden.  Implement it in the sub class.");
         return null;
      }
      
      private function returnPositionForCollision() : Vector3D
      {
         var _loc4_:Vector3D = mActorGameObject.getHeadingAsVector();
         var _loc3_:Number = mActorGameObject.heading;
         var _loc1_:Vector3D = new Vector3D(0,0);
         _loc1_.x += mHeadingOffset.x * _loc4_.x * mActorGameObject.actorData.scale;
         _loc1_.y += mHeadingOffset.x * _loc4_.y * mActorGameObject.actorData.scale;
         var _loc2_:Vector3D = mActorView.worldCenter.add(_loc1_);
         return _loc2_.add(mGlobalOffset);
      }
      
      public function perFrameUpCall(param1:ScriptTimeline) : Boolean
      {
         if(mCombatGameObject != null)
         {
            mCombatGameObject.position = returnPositionForCollision();
            mCombatGameObject.perFrameUpCall(param1.currentFrame);
            if(!mCombatGameObject.isAlive())
            {
               mCombatGameObject.destroy();
               mCombatGameObject = null;
               return false;
            }
            return true;
         }
         return false;
      }
   }
}

