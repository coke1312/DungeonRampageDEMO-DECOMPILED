package Actor.Player.Input
{
   import Actor.ActorGameObject;
   import Box2D.Collision.b2Distance;
   import Box2D.Collision.b2DistanceInput;
   import Box2D.Collision.b2DistanceOutput;
   import Box2D.Collision.b2DistanceProxy;
   import Box2D.Collision.b2SimplexCache;
   import Brain.Logger.Logger;
   import Brain.Utils.Tuple;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.HeroGameObjectOwner;
   import Dungeon.NavCollider;
   import Facade.DBFacade;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   
   public class GBS_ModernMouseController extends MouseController
   {
      
      private static const mLeftClickWeaponIndex:int = 0;
      
      private static const mRightClickWeaponIndex:int = 1;
      
      private static const mMiddleClickWeaponIndex:int = 2;
      
      private var mCurrentTarget:ActorGameObject;
      
      private var mClickedLocation:Vector3D;
      
      private var mIsStationaryAttack:Boolean = false;
      
      private var mHeroLocationPreviousFrame:Vector3D;
      
      private var mDistanceInputCache:b2DistanceInput;
      
      private var mDistanceOutputCache:b2DistanceOutput;
      
      private var mDistanceSimplexCache:b2SimplexCache;
      
      public function GBS_ModernMouseController(param1:DBFacade, param2:HeroGameObjectOwner)
      {
         super(param1,param2);
         mDistanceInputCache = new b2DistanceInput();
         mDistanceInputCache.proxyA = new b2DistanceProxy();
         mDistanceInputCache.proxyB = new b2DistanceProxy();
         mDistanceOutputCache = new b2DistanceOutput();
         mDistanceSimplexCache = new b2SimplexCache();
         mDistanceSimplexCache.count = 0;
         mHeroLocationPreviousFrame = mHeroGameObjectOwner.view.position;
      }
      
      override protected function handleMouseDown(param1:MouseEvent) : void
      {
         super.handleMouseDown(param1);
      }
      
      override protected function determineSelection() : void
      {
         checkStationaryKey();
         if(mMouseDownThisFrame)
         {
            faceLocation(getMouseWorldLocation());
            cancelMovementAction();
            clearCurrentTarget();
            if(mMouseDownActorThisFrame && isValidTarget(mMouseDownActorThisFrame))
            {
               mCurrentTarget = mMouseDownActorThisFrame;
            }
            else
            {
               mClickedLocation = getMouseWorldLocation();
               mHeroGameObjectOwner.distributedDungeonFloor.effectManager.playEffect(DBFacade.buildFullDownloadPath("Resources/Art2D/FX/db_fx_library.swf"),"UI_pointer_click",mClickedLocation);
            }
         }
         if(mMouseUpThisFrame)
         {
            if(mCurrentTarget != null && mActorMousedOver != mCurrentTarget)
            {
               setCurrentTargetSelection(false);
            }
         }
         if(mCurrentTarget != null && mCurrentTarget.isDead())
         {
            handleCurrentTargetDied();
         }
      }
      
      private function checkStationaryKey() : void
      {
         if(!mIsStationaryAttack && mDBFacade.inputManager.check(16))
         {
            cancelMovementAction();
            mIsStationaryAttack = true;
         }
         else if(mIsStationaryAttack && !mDBFacade.inputManager.check(16))
         {
            mHeroGameObjectOwner.PlayerAttack.stopAttacking();
            mIsStationaryAttack = false;
         }
      }
      
      private function checkForAlternateWeaponAttacks() : void
      {
         if(mRightMouseDown)
         {
            handleAlternateWeaponAttack(1);
         }
         else if(mMiddleMouseDown)
         {
            handleAlternateWeaponAttack(2);
         }
      }
      
      private function handleAlternateWeaponAttack(param1:int) : void
      {
         clearMovement();
         faceLocation(getMouseWorldLocation());
         beginAttack(param1);
      }
      
      private function handleCurrentTargetDied() : void
      {
         if(mCurrentTarget.actorView != null)
         {
            mCurrentTarget.actorView.mouseOverUnhighlight();
         }
         setCurrentTargetSelection(false);
         mCurrentTarget = null;
         mHeroGameObjectOwner.PlayerAttack.stopAttacking();
      }
      
      override protected function determineMotion() : void
      {
         var _loc1_:Vector3D = null;
         var _loc2_:Vector3D = null;
         if(mCurrentTarget != null && mCurrentTarget.actorView != null)
         {
            attackMoveToTarget(mCurrentTarget);
         }
         else if(mClickedLocation != null)
         {
            if(mDBFacade.inputManager.mouseDown)
            {
               _loc1_ = getMouseWorldLocation();
               _loc2_ = _loc1_.subtract(mHeroGameObjectOwner.view.position);
               if(_loc2_.length > 50)
               {
                  mClickedLocation = _loc1_;
               }
            }
            walkToLocation();
         }
         else if(mInputHeading == null)
         {
            mInputHeading = new Vector3D();
         }
      }
      
      override protected function determineAttacks() : void
      {
         checkForAlternateWeaponAttacks();
         if(mIsStationaryAttack)
         {
            handleStationaryAttack();
         }
      }
      
      private function handleStationaryAttack() : void
      {
         if(mDBFacade.inputManager.mouseDown)
         {
            faceLocation(getMouseWorldLocation());
            beginAttack();
         }
         else
         {
            mHeroGameObjectOwner.PlayerAttack.stopAttacking();
         }
      }
      
      private function zeroVelocity() : void
      {
         mInputVelocity.x = 0;
         mInputVelocity.y = 0;
      }
      
      private function getMouseWorldLocation() : Vector3D
      {
         return mDBFacade.camera.getWorldCoordinateFromMouse(mDBFacade.inputManager.mouseX,mDBFacade.inputManager.mouseY);
      }
      
      private function setCurrentTargetSelection(param1:Boolean) : void
      {
         if(mCurrentTarget.actorView == null)
         {
            return;
         }
         if(param1)
         {
            mCurrentTarget.actorView.mouseSelectedHighlight();
         }
         else
         {
            mCurrentTarget.actorView.mouseSelectedUnhighlight();
         }
      }
      
      private function clearCurrentTarget() : void
      {
         if(mCurrentTarget == null)
         {
            return;
         }
         setCurrentTargetSelection(false);
         mCurrentTarget = null;
      }
      
      private function cancelMovementAction() : void
      {
         mClickedLocation = null;
      }
      
      private function isPrimaryWeaponRanged() : Boolean
      {
         if(mHeroGameObjectOwner.weapons.length == 0)
         {
            return false;
         }
         var _loc1_:WeaponGameObject = mHeroGameObjectOwner.weapons[0];
         if(_loc1_ == null)
         {
            return false;
         }
         return mHeroGameObjectOwner.weapons[0].weaponData.ClassType == "SHOOTING";
      }
      
      private function isValidTarget(param1:ActorGameObject) : Boolean
      {
         return !param1.isDead();
      }
      
      private function walkToLocation() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Vector3D = null;
         var _loc1_:Number = NaN;
         if(mClickedLocation)
         {
            _loc2_ = 10;
            _loc3_ = mClickedLocation.subtract(mHeroGameObjectOwner.view.position);
            if(_loc3_.length > _loc2_)
            {
               _loc1_ = 50;
               moveTowardsLocation(mClickedLocation,_loc3_.length > _loc1_);
            }
            else
            {
               if(!mDBFacade.inputManager.mouseDown)
               {
                  mClickedLocation = null;
               }
               zeroVelocity();
            }
         }
      }
      
      private function attackMoveToTarget(param1:ActorGameObject) : void
      {
         setCurrentTargetSelection(true);
         if(isHeroInWeaponRange(param1))
         {
            beginAttack();
            zeroVelocity();
            if(!mDBFacade.inputManager.mouseDown)
            {
               clearCurrentTarget();
            }
         }
         else
         {
            moveTowardsLocation(param1.actorView.position,true);
         }
      }
      
      private function isHeroInWeaponRange(param1:ActorGameObject) : Boolean
      {
         if(isPrimaryWeaponRanged())
         {
            return true;
         }
         var _loc3_:Number = 0.25;
         var _loc2_:Number = getHeroDistanceToObject(param1);
         return _loc3_ >= _loc2_;
      }
      
      public function getHeroDistanceToObject(param1:ActorGameObject) : Number
      {
         if(mHeroGameObjectOwner.navCollisions.length == 0)
         {
            Logger.warn("getHeroDistanceToObject - Hero Game Object has no NavColliders");
            return 0;
         }
         if(param1.navCollisions.length == 0)
         {
            Logger.warn("getHeroDistanceToObject - GameObject has no NavColliders");
            return 0;
         }
         var _loc3_:NavCollider = mHeroGameObjectOwner.navCollisions[0];
         var _loc2_:NavCollider = param1.navCollisions[0];
         mDistanceInputCache.proxyA.Set(_loc3_.getShape());
         mDistanceInputCache.proxyB.Set(_loc2_.getShape());
         mDistanceInputCache.transformA = _loc3_.getBody().GetTransform();
         mDistanceInputCache.transformB = _loc2_.getBody().GetTransform();
         mDistanceInputCache.useRadii = true;
         mDistanceSimplexCache.count = 0;
         b2Distance.Distance(mDistanceOutputCache,mDistanceSimplexCache,mDistanceInputCache);
         return mDistanceOutputCache.distance;
      }
      
      public function beginAttack(param1:int = 0) : void
      {
         mPotentialAttacksThisFrame.push(new Tuple(param1,false));
      }
      
      public function moveTowardsLocation(param1:Vector3D, param2:Boolean) : void
      {
         var _loc6_:Vector3D = mHeroGameObjectOwner.view.position;
         if(mDBFacade.inputManager.mouseUp)
         {
            if(mHeroLocationPreviousFrame.equals(_loc6_))
            {
               clearMovement();
               return;
            }
         }
         if(param2)
         {
            faceLocation(param1);
         }
         var _loc4_:Number = mDBFacade.dbConfigManager.getConfigNumber("speed_hack_multiplier",1);
         var _loc3_:Number = mHeroGameObjectOwner.movementSpeed * _loc4_;
         var _loc5_:Vector3D = param1.subtract(_loc6_);
         _loc5_.normalize();
         _loc5_.scaleBy(_loc3_);
         mInputVelocity = _loc5_;
         mHeroLocationPreviousFrame = _loc6_;
      }
      
      public function faceLocation(param1:Vector3D) : void
      {
         var _loc2_:Vector3D = param1.subtract(mHeroGameObjectOwner.worldCenter);
         _loc2_.normalize();
         mInputHeading = _loc2_;
      }
      
      override public function clearMovement() : void
      {
         if(mDBFacade.inputManager.mouseUp)
         {
            clearCurrentTarget();
            cancelMovementAction();
         }
         zeroVelocity();
         if(mInputHeading == null)
         {
            mInputHeading = new Vector3D();
         }
         else
         {
            mInputHeading.setTo(0,0,0);
         }
      }
   }
}

