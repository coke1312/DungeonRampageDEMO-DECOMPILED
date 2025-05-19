package Projectile
{
   import Actor.ActorGameObject;
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2FixtureDef;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import Collision.IContactResolver;
   import Combat.CombatGameObject;
   import Combat.Weapon.WeaponGameObject;
   import DBGlobals.DBGlobal;
   import DistributedObjects.DistributedDungeonFloor;
   import DistributedObjects.HeroGameObjectOwner;
   import Dungeon.NavCollider;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import Floor.FloorView;
   import GameMasterDictionary.GMAttack;
   import GameMasterDictionary.GMNpc;
   import GameMasterDictionary.GMProjectile;
   import flash.geom.Vector3D;
   
   public class ProjectileGameObject extends FloorObject implements IContactResolver
   {
      
      protected var mProjectileView:ProjectileView;
      
      protected var mNumCollisions:uint = 0;
      
      private var mStartPosition:Vector3D;
      
      private var mVelocity:Vector3D = new Vector3D();
      
      private var mAngularVelocity:Number;
      
      private var mDontRotate:Boolean = false;
      
      protected var mFlightComponent:FlightComponent;
      
      protected var mCollisionComponent:CollisionComponent;
      
      protected var mUseRange:Boolean;
      
      protected var mGMAttack:GMAttack;
      
      protected var mGMProjectile:GMProjectile;
      
      protected var mParentActorId:uint;
      
      protected var mParentActorTeam:uint;
      
      protected var mLogicalWorkComponent:LogicalWorkComponent;
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      protected var mFinishedCallback:Function;
      
      protected var mEffectName:String;
      
      protected var mEffectPath:String;
      
      protected var mEffectTimeOffset:Number;
      
      protected var mB2Body:b2Body;
      
      protected var mB2Fixture:b2Fixture;
      
      protected var mAttackType:uint;
      
      protected var mVisualOffset:Vector3D;
      
      protected var mCollisionScale:Number;
      
      private var mIsAlive:Boolean = true;
      
      protected var mWeaponGameObject:WeaponGameObject;
      
      protected var mCombatResultCallback:Function;
      
      protected var mEffectObject:Object;
      
      protected var mUpdateTask:Task;
      
      private var mLastHitActor:Boolean = false;
      
      private var mLastHitWall:Boolean = false;
      
      protected var mRange:Number = 0;
      
      public function ProjectileGameObject(param1:DBFacade, param2:uint, param3:uint, param4:uint, param5:WeaponGameObject, param6:DistributedDungeonFloor, param7:Vector3D, param8:Vector3D, param9:Vector3D, param10:Number = 0, param11:Object = null, param12:Function = null, param13:Boolean = true, param14:Boolean = false, param15:uint = 0)
      {
         mCombatResultCallback = param12;
         mAttackType = param4;
         mGMAttack = param1.gameMaster.attackById.itemFor(param4);
         if(mGMAttack == null)
         {
            Logger.error("Unable to find GMAttack record for attack type: " + param4);
         }
         mGMProjectile = param1.gameMaster.projectileByConstant.itemFor(mGMAttack.Projectile);
         if(mGMProjectile == null)
         {
            Logger.error("No projectile defined for attack type: " + param4);
         }
         mEffectObject = param11;
         if(mEffectObject != null)
         {
            mEffectName = mEffectObject.attackEffectName;
            mEffectPath = mEffectObject.attackEffectPath;
            mEffectTimeOffset = mEffectObject.attackEffectTimeOffset;
            if(!mEffectTimeOffset)
            {
               mEffectTimeOffset = 0;
            }
         }
         mDontRotate = param14;
         mCollisionScale = param5 != null ? param5.collisionScale() : 1;
         mRange = param10 == 0 ? mGMProjectile.Range : param10;
         super(param1);
         this.layer = mGMProjectile.NoFade == true ? 46 : 20;
         if(mEffectObject.layer == "foreground")
         {
            this.layer = 30;
         }
         else if(mEffectObject.layer == "background")
         {
            this.layer = 10;
         }
         else if(mEffectObject.layer == "sorted")
         {
            this.layer = 20;
         }
         distributedDungeonFloor = param6;
         mWeaponGameObject = param5;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         if(param5 != null)
         {
            _loc22_ = param5.power;
            _loc23_ = param5.type;
         }
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mParentActorId = param2;
         mParentActorTeam = param3;
         mVisualOffset = param9;
         var _loc16_:Vector3D = new Vector3D();
         mUpdateTask = mLogicalWorkComponent.doEveryFrame(update);
         var _loc19_:b2FixtureDef = new b2FixtureDef();
         _loc19_.isSensor = true;
         var _loc17_:b2CircleShape = new b2CircleShape(mGMProjectile.CollisionSize * mCollisionScale / 50);
         _loc19_.shape = _loc17_;
         var _loc20_:b2FilterData = new b2FilterData();
         _loc20_.categoryBits = 2;
         _loc20_.maskBits = 0;
         _loc20_.groupIndex = -1;
         if(mGMProjectile.CollisionSize > 0)
         {
            switch(mGMAttack.Team)
            {
               case "FRIENDLY":
                  _loc20_.maskBits |= DBGlobal.b2dMaskForTeam(mParentActorTeam);
                  break;
               case "HOSTILE":
                  _loc20_.maskBits |= DBGlobal.b2dMaskForAllTeamsBut(mParentActorTeam);
            }
         }
         _loc20_.maskBits |= 1;
         _loc19_.filter = _loc20_;
         _loc19_.isSensor = true;
         _loc19_.userData = this.id;
         var _loc18_:b2BodyDef = new b2BodyDef();
         _loc18_.userData = this.id;
         _loc18_.type = b2Body.b2_dynamicBody;
         mB2Body = mDistributedDungeonFloor.box2DWorld.CreateBody(_loc18_);
         mB2Fixture = mB2Body.CreateFixture(_loc19_);
         this.position = param7.add(param9);
         var _loc21_:ActorGameObject = mDistributedDungeonFloor.getActor(mParentActorId);
         mUseRange = true;
         mVelocity = param8;
         switch(mGMProjectile.FlightPattern)
         {
            case "HOMING":
               mFlightComponent = new HomingFlightComponent(param7,param8,this,mParentActorId,param1,mDistributedDungeonFloor,mGMAttack.Team == "FRIENDLY",applySteeringVector);
               if(param5 == null)
               {
                  mCollisionComponent = new CollisionComponent(mDBFacade,this,mParentActorId,mDistributedDungeonFloor,_loc23_,_loc22_,mGMAttack,mCombatResultCallback,0,0,true,param15);
               }
               else
               {
                  mCollisionComponent = new CollisionComponent(mDBFacade,this,mParentActorId,mDistributedDungeonFloor,_loc23_,_loc22_,mGMAttack,mCombatResultCallback,param5.slot,param5.pierces(),true,param15);
               }
               break;
            case "BOOMERANG":
               mUseRange = false;
               mFlightComponent = new BoomerangFlightComponent(param7,param8,this,mParentActorId,param1,mDistributedDungeonFloor,mGMAttack.Team == "FRIENDLY",applySteeringVector);
               if(param5 == null)
               {
                  mCollisionComponent = new BounceBackCollisionComponent(mDBFacade,this,mParentActorId,mDistributedDungeonFloor,_loc23_,_loc22_,mGMAttack,mCombatResultCallback,0,0);
               }
               else
               {
                  mCollisionComponent = new BounceBackCollisionComponent(mDBFacade,this,mParentActorId,mDistributedDungeonFloor,_loc23_,_loc22_,mGMAttack,mCombatResultCallback,param5.slot,param5.pierces());
               }
               break;
            case "ORBITER":
               mUseRange = false;
               mFlightComponent = new OrbiterFlightComponent(param7,param8,this,mParentActorId,param1,mDistributedDungeonFloor,mGMAttack.Team == "FRIENDLY",applySteeringVector);
               if(param5 == null)
               {
                  mCollisionComponent = new BounceBackCollisionComponent(mDBFacade,this,mParentActorId,mDistributedDungeonFloor,_loc23_,_loc22_,mGMAttack,mCombatResultCallback,0,0);
               }
               else
               {
                  mCollisionComponent = new BounceBackCollisionComponent(mDBFacade,this,mParentActorId,mDistributedDungeonFloor,_loc23_,_loc22_,mGMAttack,mCombatResultCallback,param5.slot,param5.pierces());
               }
               break;
            default:
               if(param5 == null)
               {
                  mCollisionComponent = new CollisionComponent(mDBFacade,this,mParentActorId,mDistributedDungeonFloor,_loc23_,_loc22_,mGMAttack,mCombatResultCallback,0,0,true);
               }
               else
               {
                  mCollisionComponent = new CollisionComponent(mDBFacade,this,mParentActorId,mDistributedDungeonFloor,_loc23_,_loc22_,mGMAttack,mCombatResultCallback,param5.slot,param5.pierces(),true,param15);
               }
               if(_loc21_ is HeroGameObjectOwner && param13 && mGMAttack.UseAutoAim)
               {
                  mFlightComponent = new AutoAimFlightComponent(param7,param8,this,mParentActorId,param1,mDistributedDungeonFloor,mGMAttack.Team == "FRIENDLY",applySteeringVector);
               }
               else
               {
                  mFlightComponent = new FlightComponent(param7,param8,this,mParentActorId,param1,mDistributedDungeonFloor,mGMAttack.Team == "FRIENDLY",applySteeringVector);
                  mVelocity = param8;
               }
         }
         mVelocity.scaleBy(mGMProjectile.ProjSpeedF);
         mStartPosition = mPosition.clone();
         mAngularVelocity = mGMProjectile.RotationSpeedF;
         mB2Body.SetPosition(NavCollider.convertToB2Vec2(param7.clone()));
         mB2Body.SetLinearVelocity(NavCollider.convertToB2Vec2(mVelocity));
         this.init();
      }
      
      public function get weapon() : WeaponGameObject
      {
         return mWeaponGameObject;
      }
      
      public function get team() : uint
      {
         return mParentActorTeam;
      }
      
      public function get effectName() : String
      {
         return mEffectName;
      }
      
      public function get effectPath() : String
      {
         return mEffectPath;
      }
      
      public function get effectTimeOffset() : Number
      {
         return mEffectTimeOffset;
      }
      
      public function get velocity() : Vector3D
      {
         return mVelocity;
      }
      
      public function set velocity(param1:Vector3D) : void
      {
         mVelocity = param1;
      }
      
      public function get rotationSpeed() : Number
      {
         return mAngularVelocity;
      }
      
      public function set rotationSpeed(param1:Number) : void
      {
         mAngularVelocity = param1;
      }
      
      public function get gmProjectile() : GMProjectile
      {
         return mGMProjectile;
      }
      
      public function get gmAttack() : GMAttack
      {
         return mGMAttack;
      }
      
      public function get shouldRotate() : Boolean
      {
         return !mDontRotate;
      }
      
      private function update(param1:GameClock) : void
      {
         if(!distributedDungeonFloor.isAlive())
         {
            destroy();
            return;
         }
         var _loc2_:Vector3D = NavCollider.convertToVector3D(mB2Body.GetPosition());
         _loc2_ = _loc2_.add(mVisualOffset);
         this.position = _loc2_;
         mProjectileView.position = _loc2_;
         if(!checkIfDone())
         {
            applyFlightPattern(_loc2_);
         }
      }
      
      private function applyFlightPattern(param1:Vector3D) : void
      {
         if(mGMProjectile != null && mFlightComponent != null)
         {
            mFlightComponent.update();
         }
         else if(!mGMProjectile)
         {
            Logger.error("!mGMProjectile");
         }
         else if(!mFlightComponent)
         {
            Logger.error("!mFlightComponent");
         }
      }
      
      private function applySteeringVector(param1:Vector3D) : void
      {
         mVelocity = mVelocity.add(param1);
         var _loc2_:Number = mVelocity.length;
         var _loc3_:Number = Math.min(_loc2_,mGMProjectile.ProjSpeedF);
         mVelocity.scaleBy(_loc3_ / _loc2_);
         mB2Body.SetLinearVelocity(NavCollider.convertToB2Vec2(mVelocity));
      }
      
      protected function checkIfDone() : Boolean
      {
         if(mCollisionComponent.markedForDeletion() || mUseRange && Vector3D.distance(this.position,mStartPosition) >= mRange)
         {
            this.destroy();
            return true;
         }
         return false;
      }
      
      override protected function buildView() : void
      {
         mProjectileView = new ProjectileView(mDBFacade,this);
         this.view = mProjectileView as FloorView;
      }
      
      public function set rotation(param1:Number) : void
      {
         mProjectileView.setRotation(param1);
      }
      
      public function enterContact(param1:uint) : void
      {
         if(!mIsAlive)
         {
            return;
         }
         var _loc2_:ActorGameObject = mDBFacade.gameObjectManager.getReferenceFromId(param1) as ActorGameObject;
         if(_loc2_ == null)
         {
            if(!gmProjectile.IgnoreWalls)
            {
               mCollisionComponent.hitWall();
            }
         }
         else if(_loc2_.id != mParentActorId)
         {
            if(!_loc2_.isAttackable)
            {
               if(!gmProjectile.IgnoreWalls)
               {
                  mCollisionComponent.hitWall();
               }
            }
            else if(CombatGameObject.determineIfHitBasedOnTeam(mParentActorTeam,_loc2_.team,mGMAttack.Team))
            {
               hitActor(_loc2_);
            }
         }
         if(mIsAlive && mCollisionComponent.updatedVelocity)
         {
            mB2Body.SetLinearVelocity(NavCollider.convertToB2Vec2(mVelocity));
         }
      }
      
      protected function hitActor(param1:ActorGameObject) : Boolean
      {
         return mCollisionComponent.hitActor(param1);
      }
      
      public function exitContact(param1:uint) : void
      {
         if(mCollisionComponent)
         {
            mCollisionComponent.exitContact(param1);
         }
      }
      
      public function onHitWall() : void
      {
         mLastHitActor = false;
         mLastHitWall = true;
      }
      
      public function onHitActor(param1:ActorGameObject) : void
      {
         var _loc2_:HeroGameObjectOwner = null;
         mLastHitActor = false;
         if(mDBFacade.gameObjectManager.getReferenceFromId(mParentActorId) is HeroGameObjectOwner)
         {
            _loc2_ = mDBFacade.gameObjectManager.getReferenceFromId(mParentActorId) as HeroGameObjectOwner;
            if(param1.team != _loc2_.team)
            {
               mLastHitActor = true;
            }
         }
         mFlightComponent.informOfHit(param1);
         mLastHitWall = false;
      }
      
      private function setTeleDest() : void
      {
         var _loc1_:HeroGameObjectOwner = null;
         if(mDBFacade.gameObjectManager.getReferenceFromId(mParentActorId) is HeroGameObjectOwner)
         {
            if(mLastHitActor && mDBFacade.gameObjectManager.getReferenceFromId(mParentActorId) is HeroGameObjectOwner)
            {
               _loc1_ = mDBFacade.gameObjectManager.getReferenceFromId(mParentActorId) as HeroGameObjectOwner;
               _loc1_.setTeleDest(position);
            }
         }
      }
      
      private function doAttackOnHit() : void
      {
         var _loc1_:HeroGameObjectOwner = null;
         if(mLastHitActor && mDBFacade.gameObjectManager.getReferenceFromId(mParentActorId) is HeroGameObjectOwner)
         {
            _loc1_ = mDBFacade.gameObjectManager.getReferenceFromId(mParentActorId) as HeroGameObjectOwner;
            _loc1_.doAttackOnHit(mGMAttack.AttackOnHit,mWeaponGameObject);
         }
      }
      
      override public function destroy() : void
      {
         var _loc2_:GMNpc = null;
         var _loc3_:HeroGameObjectOwner = null;
         if(mGMAttack.SetTeleport)
         {
            setTeleDest();
         }
         if(mGMAttack.AttackOnHit)
         {
            doAttackOnHit();
         }
         var _loc1_:ActorGameObject = mDistributedDungeonFloor.getActor(mParentActorId);
         if(_loc1_ && _loc1_.isOwner && mGMProjectile && mGMProjectile.OnDeathNPC)
         {
            _loc2_ = mDBFacade.gameMaster.npcByConstant.itemFor(mGMProjectile.OnDeathNPC);
            _loc3_ = _loc1_ as HeroGameObjectOwner;
            _loc3_.ProposeCreateNPC(_loc2_.Id,this.weapon.slot,position.x,position.y);
         }
         mIsAlive = false;
         mWeaponGameObject = null;
         mFinishedCallback = null;
         mCombatResultCallback = null;
         mEffectObject = null;
         mStartPosition = null;
         mProjectileView = null;
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         mAssetLoadingComponent.destroy();
         mAssetLoadingComponent = null;
         if(mFlightComponent)
         {
            mFlightComponent.destroy();
            mFlightComponent = null;
         }
         mDistributedDungeonFloor.box2DWorld.DestroyBody(mB2Body);
         mB2Body.SetUserData(null);
         mB2Body.GetDefinition().userData = null;
         mB2Fixture.SetUserData(null);
         mB2Body.DestroyFixture(mB2Fixture);
         mB2Fixture = null;
         mB2Body = null;
         if(mUpdateTask)
         {
            mUpdateTask.destroy();
            mUpdateTask = null;
         }
         if(mCollisionComponent)
         {
            mCollisionComponent.destroy();
            mCollisionComponent = null;
         }
         super.destroy();
      }
   }
}

