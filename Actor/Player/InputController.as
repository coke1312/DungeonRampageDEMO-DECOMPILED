package Actor.Player
{
   import Actor.Player.Input.GBS_ModernMouseController;
   import Actor.Player.Input.IMouseController;
   import Actor.Player.Input.KeyboardController;
   import Brain.Utils.Tuple;
   import Brain.WorkLoop.LogicalWorkComponent;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class InputController
   {
      
      public static const FREE:String = "free";
      
      private static const LOCK_XY:String = "lock_xy";
      
      private static const LOCK_R:String = "lock_r";
      
      private static const LOCK_XY_R:String = "lock_xy_r";
      
      private var mDBFacade:DBFacade;
      
      private var mHeroGameObject:HeroGameObjectOwner;
      
      private var mDirectionVector:Vector3D = new Vector3D();
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mAbortAstarPathWalk:Boolean;
      
      private var mWantCameraZoom:Boolean;
      
      private var mKeyboardController:KeyboardController;
      
      private var mMouseController:IMouseController;
      
      private var mInputType:String = "free";
      
      private var mCombatDisabled:Boolean;
      
      public function InputController(param1:HeroGameObjectOwner, param2:DBFacade)
      {
         super();
         mDBFacade = param2;
         mHeroGameObject = param1;
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         mWantCameraZoom = mDBFacade.dbConfigManager.getConfigBoolean("camera_zoom",false);
         mKeyboardController = new KeyboardController(mDBFacade,mHeroGameObject);
         mMouseController = new GBS_ModernMouseController(mDBFacade,mHeroGameObject);
         mCombatDisabled = false;
      }
      
      public function destroy() : void
      {
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         mKeyboardController.destroy();
         mKeyboardController = null;
         mMouseController.destroy();
         mMouseController = null;
         mDBFacade = null;
         mHeroGameObject = null;
      }
      
      public function init() : void
      {
         mMouseController.init();
      }
      
      public function stop() : void
      {
         mMouseController.stop();
      }
      
      public function perFrameUpCall() : void
      {
         var _loc5_:* = false;
         mHeroGameObject.position = mHeroGameObject.navCollisions[0].position;
         var _loc3_:Number = mDBFacade.inputManager.mouseWheelDelta;
         if(_loc3_ != 0)
         {
            _loc5_ = _loc3_ > 0;
            mHeroGameObject.PlayerAttack.scrollWeapons(_loc5_);
         }
         mKeyboardController.perFrameUpCall();
         mMouseController.perFrameUpCall();
         var _loc4_:Vector3D = determineInputHeading();
         var _loc1_:Vector3D = determineInputVelocity();
         var _loc2_:Number = Math.atan2(_loc4_.y,_loc4_.x) * 180 / 3.141592653589793;
         if(_loc4_.x != 0 || _loc4_.y != 0)
         {
            mHeroGameObject.inputHeading = _loc2_;
         }
         if(!mCombatDisabled)
         {
            translateInputIntoAttacks();
            mHeroGameObject.PlayerAttack.weaponCommandQueueUpCall();
         }
         translateInputIntoConsumableUse();
         if(!canMoveXY(mInputType))
         {
            _loc1_.scaleBy(0);
            mMouseController.clearMovement();
         }
         mHeroGameObject.inputVelocity = _loc1_;
         mHeroGameObject.setViewVelocity();
         if(canMoveR(mInputType) && (_loc4_.x != 0 || _loc4_.y != 0))
         {
            mHeroGameObject.heading = _loc2_;
         }
      }
      
      public function disableCombat() : void
      {
         mCombatDisabled = true;
         inputType = "lock_xy";
         mKeyboardController.combatDisabled = true;
         mMouseController.combatDisabled = true;
         mHeroGameObject.PlayerAttack.resetWeapons();
      }
      
      public function enableCombat() : void
      {
         mCombatDisabled = false;
         inputType = "free";
         mKeyboardController.combatDisabled = false;
         mMouseController.combatDisabled = false;
      }
      
      private function translateInputIntoAttacks() : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:Array = null;
         var _loc3_:Tuple = null;
         var _loc2_:Boolean = false;
         var _loc1_:Vector.<int> = mKeyboardController.pressedCombatKeysThisFrame;
         var _loc7_:Vector.<int> = mKeyboardController.releasedCombatKeysThisFrame;
         _loc5_ = 0;
         while(_loc5_ < _loc1_.length)
         {
            _loc4_ = uint(mKeyboardController.KeyIndexToAttack(_loc5_));
            if(_loc1_[_loc5_])
            {
               mHeroGameObject.PlayerAttack.addToPotentialWeaponInputQueue(_loc4_,true,true);
               _loc2_ = true;
            }
            if(_loc7_[_loc5_])
            {
               mHeroGameObject.PlayerAttack.addToPotentialWeaponInputQueue(_loc4_,false,true);
               _loc2_ = true;
            }
            _loc5_++;
         }
         if(!_loc2_)
         {
            _loc6_ = mMouseController.potentialAttacksThisFrame;
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               _loc3_ = _loc6_[_loc5_];
               mHeroGameObject.PlayerAttack.addToPotentialWeaponInputQueue(_loc3_.first,_loc3_.second,false);
               _loc5_++;
            }
         }
      }
      
      private function translateInputIntoConsumableUse() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc1_:Boolean = false;
         var _loc4_:Vector.<int> = mKeyboardController.releasedConsumableKeysThisFrame;
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            _loc2_ = uint(mKeyboardController.KeyIndexToConsumable(_loc3_));
            if(_loc4_[_loc3_])
            {
               mHeroGameObject.tryToUseConsumable(_loc2_);
               _loc1_ = true;
            }
            _loc3_++;
         }
      }
      
      private function determineInputVelocity() : Vector3D
      {
         var _loc1_:Vector3D = mKeyboardController.inputVelocity;
         if(_loc1_.x == 0 && _loc1_.y == 0)
         {
            _loc1_ = mMouseController.inputVelocity;
         }
         else
         {
            mMouseController.clearMovement();
         }
         return _loc1_;
      }
      
      private function determineInputHeading() : Vector3D
      {
         var _loc1_:Vector3D = mKeyboardController.inputHeading;
         if(_loc1_.x == 0 && _loc1_.y == 0)
         {
            _loc1_ = mMouseController.inputHeading;
         }
         return _loc1_;
      }
      
      public function canMoveR(param1:String) : Boolean
      {
         return param1 != "lock_r" && param1 != "lock_xy_r";
      }
      
      public function canMoveXY(param1:String) : Boolean
      {
         return param1 != "lock_xy" && param1 != "lock_xy_r" && !mDBFacade.inputManager.check(16);
      }
      
      public function get directionVector() : Vector3D
      {
         return mDirectionVector;
      }
      
      public function set inputType(param1:String) : void
      {
         mInputType = param1;
      }
      
      public function getInputType() : String
      {
         return mInputType;
      }
   }
}

