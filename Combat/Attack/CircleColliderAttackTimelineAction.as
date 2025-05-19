package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Combat.CombatGameObject;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class CircleColliderAttackTimelineAction extends ColliderTimelineAction
   {
      
      public static const TYPE:String = "circleCollider";
      
      protected var mRadius:Number;
      
      public function CircleColliderAttackTimelineAction(param1:WeaponGameObject, param2:ActorGameObject, param3:ActorView, param4:DBFacade, param5:DistributedDungeonFloor, param6:Function, param7:Number, param8:Vector3D, param9:Vector3D, param10:uint, param11:uint)
      {
         mRadius = param7;
         super(param1,param2,param3,param4,param5,param6,param8,param9,param10,param11);
      }
      
      public static function buildFromJson(param1:WeaponGameObject, param2:ActorGameObject, param3:ActorView, param4:DBFacade, param5:DistributedDungeonFloor, param6:Object, param7:Function) : CircleColliderAttackTimelineAction
      {
         var _loc14_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc10_:Vector3D = null;
         var _loc9_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc13_:Vector3D = null;
         var _loc15_:* = 0;
         var _loc17_:* = 0;
         if(param2.isOwner)
         {
            _loc14_ = param1 != null ? param1.collisionScale() : 1;
            _loc16_ = param6.radius * _loc14_;
            _loc12_ = 0;
            if(param6.xOffset != null)
            {
               _loc12_ = param6.xOffset * _loc14_;
            }
            _loc11_ = 0;
            if(param6.yOffset != null)
            {
               _loc11_ = param6.yOffset * _loc14_;
            }
            _loc10_ = new Vector3D(_loc12_,_loc11_);
            _loc9_ = 0;
            if(param6.xGlobalOffset != null)
            {
               _loc9_ = param6.xGlobalOffset * _loc14_;
            }
            _loc8_ = 0;
            if(param6.yGlobalOffset != null)
            {
               _loc8_ = param6.yGlobalOffset * _loc14_;
            }
            _loc13_ = new Vector3D(_loc9_,_loc8_);
            _loc15_ = 1;
            if(param6.lifeTime != null)
            {
               _loc15_ = uint(param6.lifeTime);
            }
            _loc17_ = 0;
            if(param6.hitDelayPerObject != null)
            {
               _loc17_ = uint(param6.hitDelayPerObject);
            }
            return new CircleColliderAttackTimelineAction(param1,param2,param3,param4,param5,param7,_loc16_,_loc10_,_loc13_,_loc15_,_loc17_);
         }
         return null;
      }
      
      override protected function buildCombatGameObject(param1:uint, param2:uint) : CombatGameObject
      {
         var _loc3_:CircleCombatCollider = new CircleCombatCollider(mDBFacade,mActorGameObject,mDistributedDungeonFloor.box2DWorld,mRadius);
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

