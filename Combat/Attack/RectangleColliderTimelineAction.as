package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Combat.CombatGameObject;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class RectangleColliderTimelineAction extends ColliderTimelineAction
   {
      
      public static const TYPE:String = "rectangleCollider";
      
      private var mHalfWidth:Number;
      
      private var mHalfHeight:Number;
      
      private var mRotation:Number;
      
      public function RectangleColliderTimelineAction(param1:WeaponGameObject, param2:ActorGameObject, param3:ActorView, param4:DBFacade, param5:DistributedDungeonFloor, param6:Function, param7:Vector3D, param8:Vector3D, param9:Number, param10:Number, param11:Number, param12:uint, param13:uint)
      {
         mHalfWidth = param9;
         mHalfHeight = param10;
         mRotation = param11;
         super(param1,param2,param3,param4,param5,param6,param7,param8,param12,param13);
      }
      
      public static function buildFromJson(param1:WeaponGameObject, param2:ActorGameObject, param3:ActorView, param4:DBFacade, param5:DistributedDungeonFloor, param6:Object, param7:Function) : RectangleColliderTimelineAction
      {
         var _loc17_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc14_:Vector3D = null;
         var _loc13_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc15_:Vector3D = null;
         var _loc18_:* = 0;
         var _loc19_:* = 0;
         if(param2.isOwner)
         {
            _loc17_ = param1 != null ? param1.collisionScale() : 1;
            _loc10_ = param6.halfHeight * _loc17_;
            _loc16_ = param6.halfWidth * _loc17_;
            _loc11_ = Number(param6.rotation);
            _loc9_ = 0;
            if(param6.xOffset != null)
            {
               _loc9_ = param6.xOffset * _loc17_;
            }
            _loc8_ = 0;
            if(param6.yOffset != null)
            {
               _loc8_ = param6.yOffset * _loc17_;
            }
            _loc14_ = new Vector3D(_loc9_,_loc8_);
            _loc13_ = 0;
            if(param6.xGlobalOffset != null)
            {
               _loc13_ = param6.xGlobalOffset * _loc17_;
            }
            _loc12_ = 0;
            if(param6.yGlobalOffset != null)
            {
               _loc12_ = param6.yGlobalOffset * _loc17_;
            }
            _loc15_ = new Vector3D(_loc13_,_loc12_);
            _loc18_ = 1;
            if(param6.lifeTime != null)
            {
               _loc18_ = uint(param6.timeToLive);
            }
            _loc19_ = 0;
            if(param6.hitDelayPerObject != null)
            {
               _loc19_ = uint(param6.hitDelayPerObject);
            }
            return new RectangleColliderTimelineAction(param1,param2,param3,param4,param5,param7,_loc14_,_loc15_,_loc16_,_loc10_,_loc11_,_loc18_,_loc19_);
         }
         return null;
      }
      
      override protected function buildCombatGameObject(param1:uint, param2:uint) : CombatGameObject
      {
         var _loc3_:RectangleCombatCollider = new RectangleCombatCollider(mDBFacade,mActorGameObject,mDistributedDungeonFloor.box2DWorld,mHalfWidth,mHalfHeight,mActorGameObject.heading,mRotation);
         return new CombatGameObject(mDBFacade,mActorGameObject,mAttackType,mWeapon,mDistributedDungeonFloor,_loc3_,param1,param2,mCombatResultCallback);
      }
      
      override public function destroy() : void
      {
         mWeapon = null;
         mDistributedDungeonFloor = null;
         mCombatGameObject.destroy();
         super.destroy();
      }
   }
}

