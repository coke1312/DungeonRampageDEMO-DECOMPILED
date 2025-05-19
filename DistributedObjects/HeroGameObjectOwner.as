package DistributedObjects
{
   import Account.StackableInfo;
   import Actor.ActorGameObject;
   import Actor.Player.HeroOwnerView;
   import Actor.Player.InputController;
   import Box2D.Dynamics.b2Body;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.GameObject.GameObject;
   import Brain.Logger.Logger;
   import Brain.Render.Layer;
   import Brain.WorkLoop.PreRenderWorkComponent;
   import Brain.WorkLoop.Task;
   import Camera.FollowTargetCameraStrategy;
   import Combat.Attack.PlayerOwnerAttackController;
   import Combat.Attack.TavernPlayerOwnerAttackController;
   import Combat.Weapon.WeaponController;
   import Combat.Weapon.WeaponGameObject;
   import Dungeon.NavCollider;
   import Dungeon.Tile;
   import Events.HpEvent;
   import Events.ManaEvent;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import Floor.FloorView;
   import GameMasterDictionary.GMAttack;
   import GeneratedCode.AttackChoreography;
   import GeneratedCode.CombatResult;
   import GeneratedCode.HeroGameObjectOwnerNetworkComponent;
   import GeneratedCode.IHeroGameObjectOwner;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.Set;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class HeroGameObjectOwner extends HeroGameObject implements IHeroGameObjectOwner
   {
      
      public static const BROADCAST_INTERVAL:Number = 0.2;
      
      public static const DEFAULT_CAMERA_ZOOM:Number = 0.63;
      
      public static const CAMERA_ZOOM_DELTA:Number = 0.05;
      
      public static const CAMERA_ZOOM_TWEEN_DURATION:Number = 0.5;
      
      public static const COLLISION_CIRCLE_RADIUS:Number = 20;
      
      public static var HERO_OWNER_READY:String = "HERO_OWNER_READY";
      
      public static var currentHeroOwnerId:uint = 0;
      
      protected var mBroadcastTask:Task;
      
      protected var mInputTask:Task;
      
      private var mVisibleTiles:Vector.<Tile>;
      
      protected var mFollowCamera:FollowTargetCameraStrategy;
      
      protected var mButtonsDown:Set;
      
      protected var mPlayerOwnerAttackController:PlayerOwnerAttackController;
      
      protected var mHeroGameObjectOwnerNetworkComponent:HeroGameObjectOwnerNetworkComponent;
      
      protected var mCurrentWeaponIndex:int = -1;
      
      private var mBroadcastLastPosition:Vector3D = new Vector3D();
      
      private var mBroadcastLastHeading:Number = 0;
      
      protected var mInputHeading:Number = 0;
      
      private var mInputController:InputController;
      
      public var autoAimEnabled:Boolean;
      
      public var actorClickedToAttack:ActorGameObject;
      
      private var mInputVelocity:Vector3D;
      
      public var autoMoveVelocity:Vector3D;
      
      protected var mEventComponent:EventComponent;
      
      private var mFromNetAttackChoreography:AttackChoreography;
      
      protected var mCanSuffer:Boolean;
      
      private var mSelectedTargets:Map;
      
      private var mCurrentAttemptedRevivee:HeroGameObject;
      
      public var mTeleportDestination:Vector3D;
      
      public function HeroGameObjectOwner(param1:DBFacade, param2:uint)
      {
         Logger.debug("New  HeroGameObjectOwner******************************");
         super(param1,param2);
         mWantNavCollisions = true;
         mVisibleTiles = new Vector.<Tile>();
         mButtonsDown = new Set();
         mEventComponent = new EventComponent(param1);
         mInputController = new InputController(this,param1);
         mInputVelocity = new Vector3D(0,0,0);
         autoMoveVelocity = new Vector3D(0,0,0);
         HeroGameObjectOwner.currentHeroOwnerId = this.id;
         autoAimEnabled = true;
         mCanSuffer = true;
         actorClickedToAttack = null;
      }
      
      override public function get isOwner() : Boolean
      {
         return true;
      }
      
      public function clearWeaponInput() : void
      {
         mPlayerOwnerAttackController.clearInput();
      }
      
      public function get weaponControllers() : Vector.<WeaponController>
      {
         return mPlayerOwnerAttackController.weaponControllers;
      }
      
      override protected function buildView() : void
      {
         view = new HeroOwnerView(mDBFacade,this);
      }
      
      override public function set view(param1:FloorView) : void
      {
         super.view = param1;
      }
      
      override public function addNavCollision(param1:NavCollider) : void
      {
         param1.type = b2Body.b2_dynamicBody;
         super.addNavCollision(param1);
      }
      
      public function set canSuffer(param1:Boolean) : void
      {
         mCanSuffer = param1;
      }
      
      override public function get canSuffer() : Boolean
      {
         return mCanSuffer;
      }
      
      override protected function initializeToFirstValidWeapon() : void
      {
         var _loc3_:WeaponController = null;
         var _loc1_:WeaponGameObject = null;
         var _loc2_:* = 0;
         if(weaponControllers.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < weaponControllers.length)
            {
               _loc3_ = weaponControllers[_loc2_];
               if(_loc3_ != null)
               {
                  _loc1_ = _loc3_.weapon;
                  if(_loc1_ != null)
                  {
                     mCurrentWeaponIndex = _loc2_;
                     this.currentWeapon = _loc1_;
                     return;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function startUserInput() : void
      {
         mBroadcastTask = mLogicalWorkComponent.doEverySeconds(0.2,broadcastTelemetry);
         mInputController.init();
         mInputTask = mLogicalWorkComponent.doEveryFrame(inputUpCall);
      }
      
      protected function inputUpCall(param1:GameClock) : void
      {
         mInputController.perFrameUpCall();
      }
      
      public function stopUserInput() : void
      {
         mInputController.stop();
         mInputTask.destroy();
         mInputTask = null;
      }
      
      override public function init() : void
      {
         super.init();
         mPreRenderWorkComponent = new PreRenderWorkComponent(mDBFacade);
         mDBFacade.camera.targetObject = mDBFacade.sceneGraphManager.worldTransformNode;
         mDBFacade.sceneGraphManager.worldTransformNode.parent.x = mDBFacade.viewWidth * 0.5;
         mDBFacade.sceneGraphManager.worldTransformNode.parent.y = mDBFacade.viewHeight * 0.5;
         mDBFacade.camera.defaultZoom = 0.63;
         mDBFacade.camera.zoom = mDBFacade.camera.defaultZoom;
         mDBFacade.camera.centerCameraOnPoint(position);
         mFollowCamera = new FollowTargetCameraStrategy(mDBFacade.camera,mHeroView.root);
         mFollowCamera.start(mPreRenderWorkComponent);
         autoAimEnabled = true;
         actorClickedToAttack = null;
         mPreRenderWorkComponent.doEveryFrame(this.doVisibility);
         mDBFacade.hud.initializeHud(this);
         mDBFacade.stageRef.addEventListener("keyDown",this.debugKey,false,0,true);
         Logger.debug(" Sending HERO_OWNER_READY ");
         mEventComponent.dispatchEvent(new Event(HERO_OWNER_READY));
         if(this.actorData.movment > 250)
         {
            mDBFacade.iamaCheater("test_fbcheats");
         }
      }
      
      private function debugKey(param1:KeyboardEvent) : void
      {
         var _loc7_:Layer = null;
         var _loc3_:* = false;
         var _loc2_:IMapIterator = null;
         var _loc5_:HeroGameObject = null;
         var _loc8_:String = mDBFacade.dbConfigManager.getConfigString("test_effect_swf","");
         var _loc6_:String = mDBFacade.dbConfigManager.getConfigString("test_effect_name","");
         var _loc4_:FloorObject = this;
         switch(param1.keyCode)
         {
            case 98:
               _loc7_ = mDBFacade.sceneGraphManager.getLayer(50);
               _loc3_ = !_loc7_.visible;
               _loc7_.visible = _loc3_;
               if(actorNametag)
               {
                  actorNametag.visible = _loc3_;
               }
               _loc2_ = distributedDungeonFloor.remoteHeroes.iterator() as IMapIterator;
               while(_loc2_.hasNext())
               {
                  _loc5_ = _loc2_.next();
                  _loc5_.actorNametag.visible = _loc3_;
               }
               break;
            case 69:
               if(_loc8_ && _loc6_ && distributedDungeonFloor)
               {
                  distributedDungeonFloor.effectManager.playEffect(DBFacade.buildFullDownloadPath(_loc8_),_loc6_,new Vector3D(Math.random() * 100,Math.random() * 100,0),_loc4_);
               }
         }
      }
      
      public function get visibleTiles() : Vector.<Tile>
      {
         return mVisibleTiles;
      }
      
      private function doVisibility(param1:GameClock) : void
      {
         var _loc3_:Rectangle = null;
         var _loc2_:* = undefined;
         var _loc4_:* = null;
         if(mDistributedDungeonFloor && mDistributedDungeonFloor.tileGrid)
         {
            _loc3_ = mFacade.camera.visibleRectangle;
            _loc2_ = mDistributedDungeonFloor.tileGrid.getVisibleTiles(_loc3_);
            for each(_loc4_ in mVisibleTiles)
            {
               if(_loc2_.indexOf(_loc4_) < 0)
               {
                  _loc4_.removeFromStage();
               }
            }
            for each(_loc4_ in _loc2_)
            {
               if(mVisibleTiles.indexOf(_loc4_) < 0)
               {
                  _loc4_.addToStage();
               }
            }
            mVisibleTiles = _loc2_;
         }
      }
      
      private function get canMoveXY() : Boolean
      {
         return this.mMovementController.canMoveXY && !mFacade.inputManager.check(16);
      }
      
      public function set inputVelocity(param1:Vector3D) : void
      {
         mInputVelocity = param1;
      }
      
      public function set inputHeading(param1:Number) : void
      {
         mInputHeading = param1;
      }
      
      public function get inputHeading() : Number
      {
         return mInputHeading;
      }
      
      override protected function move() : void
      {
         this.actorView.position = this.position;
         this.actorView.heading = this.heading;
      }
      
      public function broadcastTelemetry(param1:GameClock = null) : void
      {
         if(Vector3D.distance(mBroadcastLastPosition,position) > 0.5)
         {
            mHeroGameObjectOwnerNetworkComponent.send_position(position);
            mBroadcastLastPosition = position;
         }
         if(mBroadcastLastHeading != heading)
         {
            mHeroGameObjectOwnerNetworkComponent.send_heading(heading);
            mBroadcastLastHeading = heading;
         }
      }
      
      public function getNextFramePosition() : Vector3D
      {
         var _loc1_:Vector3D = this.position;
         _loc1_.x += this.actorView.velocity.x * 0.04;
         _loc1_.y += this.actorView.velocity.y * 0.04;
         return _loc1_;
      }
      
      override protected function setupWeapons() : void
      {
         if(mPlayerOwnerAttackController)
         {
            mPlayerOwnerAttackController.destroy();
         }
         super.setupWeapons();
         var _loc1_:* = mDistributedDungeonFloor.gmMapNode.NodeType == "TAVERN";
         if(_loc1_)
         {
            mPlayerOwnerAttackController = new TavernPlayerOwnerAttackController(this,mHeroView,mDBFacade);
         }
         else
         {
            mPlayerOwnerAttackController = new PlayerOwnerAttackController(this,mHeroView,mDBFacade);
         }
         initializeToFirstValidWeapon();
      }
      
      public function get currentWeaponRange() : uint
      {
         Logger.debug("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!TODO!!!!!!!!!!!!!!!!!!!!!111: Make this make sense with the new weaponControllers code!");
         return mPlayerOwnerAttackController.weaponControllers[mCurrentWeaponIndex].weaponRange;
      }
      
      public function setViewVelocity() : void
      {
         this.mHeroView.velocity = mInputVelocity.add(autoMoveVelocity);
         this.navCollisions[0].velocity = this.mHeroView.velocity;
      }
      
      override public function set movementControllerType(param1:String) : void
      {
         super.movementControllerType = param1;
         if(!canMoveXY)
         {
            mInputVelocity.scaleBy(0);
         }
      }
      
      public function forceHeading(param1:Vector3D) : void
      {
         param1.normalize();
         var _loc2_:Number = Math.atan2(param1.y,param1.x) * 180 / 3.141592653589793;
         this.heading = _loc2_;
         this.mHeroView.heading = _loc2_;
      }
      
      public function placeAt(param1:Vector3D) : void
      {
         mMovementController.stopLerp();
         position = param1;
         mInputVelocity.x = 0;
         mInputVelocity.y = 0;
         this.navCollisions[0].position = param1;
         this.navCollisions[0].velocity = mInputVelocity;
         mMovementController.move(param1,this.heading);
         mInputVelocity.x = 0;
         mInputVelocity.y = 0;
      }
      
      public function setTeleDest(param1:Vector3D) : void
      {
         mTeleportDestination = param1;
      }
      
      public function doAttackOnHit(param1:String, param2:WeaponGameObject) : void
      {
         for each(var _loc3_ in weaponControllers)
         {
            if(_loc3_ && _loc3_.weapon == param2)
            {
               _loc3_.queueAttack(param1);
               _loc3_.doQueue();
            }
         }
      }
      
      public function moveBodyTo(param1:Vector3D) : void
      {
         mMovementController.moveBody(param1,this.heading);
      }
      
      public function stopMovement() : void
      {
         mMovementController.stopLerp();
      }
      
      public function moveToTeleDest() : void
      {
         mMovementController.stopLerp();
         position = mTeleportDestination;
         this.navCollisions[0].position = mTeleportDestination;
         this.navCollisions[0].velocity = mInputVelocity;
         mMovementController.move(mTeleportDestination,this.heading);
      }
      
      override public function set position(param1:Vector3D) : void
      {
         super.position = param1;
      }
      
      public function set currentWeaponIndex(param1:int) : void
      {
         mCurrentWeaponIndex = param1;
         if(weaponControllers[mCurrentWeaponIndex] != null && weaponControllers[mCurrentWeaponIndex].weapon != null)
         {
            this.currentWeapon = weaponControllers[mCurrentWeaponIndex].weapon;
            mDBFacade.hud.setWeaponHighlight(param1);
         }
      }
      
      public function get currentWeaponIndex() : int
      {
         return mCurrentWeaponIndex;
      }
      
      public function get PlayerAttack() : PlayerOwnerAttackController
      {
         return mPlayerOwnerAttackController;
      }
      
      public function set ActorClickedToAttack(param1:ActorGameObject) : void
      {
         actorClickedToAttack = param1;
      }
      
      public function sendChat(param1:String) : void
      {
         var _loc2_:GameObject = mFacade.gameObjectManager.getReferenceFromId(mPlayerID);
         var _loc3_:PlayerGameObjectOwner = _loc2_ as PlayerGameObjectOwner;
         if(_loc3_)
         {
            _loc3_.sendChat(param1);
         }
      }
      
      public function showPlayerIsTyping(param1:Boolean) : void
      {
         var _loc2_:GameObject = mFacade.gameObjectManager.getReferenceFromId(mPlayerID);
         var _loc3_:PlayerGameObjectOwner = _loc2_ as PlayerGameObjectOwner;
         if(_loc3_)
         {
            _loc3_.sendPlayerIsTyping(param1);
         }
      }
      
      override public function destroy() : void
      {
         mDBFacade.stageRef.removeEventListener("keyDown",this.debugKey);
         if(mPlayerOwnerAttackController)
         {
            mPlayerOwnerAttackController.destroy();
         }
         mVisibleTiles = null;
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         mDBFacade.hud.detachHero();
         mFollowCamera.destroy();
         mFollowCamera = null;
         mHeroGameObjectOwnerNetworkComponent = null;
         HeroGameObjectOwner.currentHeroOwnerId = 0;
         mInputController.destroy();
         mInputController = null;
         mEventComponent.destroy();
         mEventComponent = null;
         super.destroy();
      }
      
      public function setOwnerNetworkComponentHeroGameObject(param1:HeroGameObjectOwnerNetworkComponent) : void
      {
         mHeroGameObjectOwnerNetworkComponent = param1;
      }
      
      public function sendChoreography(param1:AttackChoreography) : void
      {
         if(mFromNetAttackChoreography == null || mFromNetAttackChoreography.attack.attackType != param1.attack.attackType)
         {
            if(mHeroGameObjectOwnerNetworkComponent != null)
            {
               mHeroGameObjectOwnerNetworkComponent.send_ProposeAttackChoreography(param1);
            }
         }
      }
      
      public function sendStopChoreography() : void
      {
         StopChoreography();
         if(mHeroGameObjectOwnerNetworkComponent != null)
         {
            mHeroGameObjectOwnerNetworkComponent.send_StopChoreography();
         }
      }
      
      public function attemptRevive(param1:HeroGameObject) : void
      {
         var _loc2_:* = 0;
         mCurrentAttemptedRevivee = param1;
         if(mDBFacade.dbConfigManager.getConfigBoolean("use_long_revive",true))
         {
            _loc2_ = 910900;
         }
         else
         {
            _loc2_ = 910901;
         }
         attack(_loc2_,param1,1,mAttemptReviveScript,this.stateMachine.enterNavigationState,sendStopChoreography);
      }
      
      public function proposeCombatResults(param1:Vector.<CombatResult>) : void
      {
         if(mHeroGameObjectOwnerNetworkComponent != null)
         {
            mHeroGameObjectOwnerNetworkComponent.send_ProposeCombatResults(param1);
         }
      }
      
      public function proposeRevive() : void
      {
         if(mCurrentAttemptedRevivee != null && mCurrentAttemptedRevivee.isInReviveState())
         {
            if(mHeroGameObjectOwnerNetworkComponent != null)
            {
               mHeroGameObjectOwnerNetworkComponent.send_ProposeRevive(mCurrentAttemptedRevivee.id);
            }
         }
      }
      
      public function proposeSelfRevive(param1:uint) : void
      {
         if(mHeroGameObjectOwnerNetworkComponent != null)
         {
            mHeroGameObjectOwnerNetworkComponent.send_ProposeSelfRevive(param1);
         }
      }
      
      public function ProposeSelfRevive_Resp(param1:uint, param2:uint) : void
      {
         var _loc6_:Map = null;
         var _loc5_:Array = null;
         var _loc7_:* = 0;
         var _loc3_:StackableInfo = null;
         var _loc4_:* = 0;
         if(param1)
         {
            _loc6_ = mDBFacade.dbAccountInfo.inventoryInfo.stackables;
            _loc5_ = _loc6_.keysToArray();
            _loc7_ = 60001;
            if(param2)
            {
               _loc7_ = 60018;
            }
            for each(var _loc8_ in _loc5_)
            {
               _loc3_ = _loc6_.itemFor(_loc8_);
               if(_loc3_.gmId == _loc7_)
               {
                  _loc4_ = uint(_loc6_.itemFor(_loc8_).count);
                  _loc6_.itemFor(_loc8_).count--;
               }
            }
         }
         else
         {
            mEventComponent.dispatchEvent(new Event("purchaseReviveAll-failed"));
         }
      }
      
      public function ProposeCreateNPC(param1:uint, param2:uint, param3:int, param4:int) : void
      {
         if(mHeroGameObjectOwnerNetworkComponent != null)
         {
            mHeroGameObjectOwnerNetworkComponent.send_ProposeCreateNPC(param1,param2,param3,param4);
         }
      }
      
      public function get weaponRange() : uint
      {
         var _loc1_:GMAttack = mDBFacade.gameMaster.attackById.itemFor(30);
         return _loc1_.Range;
      }
      
      public function get inputController() : InputController
      {
         return mInputController;
      }
      
      override public function ReceiveAttackChoreography(param1:AttackChoreography) : void
      {
         super.ReceiveAttackChoreography(param1);
      }
      
      override public function set state(param1:String) : void
      {
         super.state = param1;
         if(param1 == "down")
         {
            if(this.view is HeroOwnerView)
            {
               (this.view as HeroOwnerView).stopHeartbeatSound();
            }
            this.mHeroView.velocity.scaleBy(0);
            this.navCollisions[0].velocity = this.mHeroView.velocity;
         }
      }
      
      override public function setStateAndAttackChoreography(param1:String, param2:AttackChoreography) : void
      {
         mFromNetAttackChoreography = param2;
         state = param1;
         ReceiveAttackChoreography(param2);
         mFromNetAttackChoreography = null;
      }
      
      override public function ponderBuffChanges() : void
      {
         mFacade.eventManager.dispatchEvent(new ManaEvent("ManaEvent_MANA_UPDATE",id,mMana,this.maxManaPoints));
         mFacade.eventManager.dispatchEvent(new HpEvent("HpEvent_HP_UPDATE",id,mHitPoints,this.maxHitPoints));
      }
      
      public function ReportBuffEffect(param1:uint, param2:int, param3:uint, param4:int) : void
      {
         var _loc5_:ActorGameObject = mDistributedDungeonFloor.getActor(param1);
         if(_loc5_ != null)
         {
            if(param2 < 0)
            {
               _loc5_.actorView.spawnDamageFloater(false,param2,true,true,param4,param3,"BUFF_DAMAGE_MOVEMENT_TYPE");
            }
            else
            {
               _loc5_.actorView.spawnHealFloater(param2,true,true,param4,param3,"BUFF_DAMAGE_MOVEMENT_TYPE");
            }
         }
      }
      
      public function ReceivedBuffEffect(param1:int, param2:uint, param3:int) : void
      {
         if(param1 < 0)
         {
            this.actorView.spawnDamageFloater(false,param1,true,true,param3,param2,"BUFF_DAMAGE_MOVEMENT_TYPE");
         }
         else
         {
            this.actorView.spawnHealFloater(param1,true,true,param3,param2,"BUFF_DAMAGE_MOVEMENT_TYPE");
         }
      }
      
      public function pauseMovement() : void
      {
         inputController.inputType = "lock_xy";
      }
      
      public function unPauseMovement() : void
      {
         inputController.inputType = "free";
      }
      
      public function TooFullForDoober(param1:uint) : void
      {
         if(param1 == true)
         {
            mDBFacade.hud.showHealthFullMessage();
         }
         else
         {
            mDBFacade.hud.showManaFullMessage();
         }
      }
      
      public function tryToUseConsumable(param1:uint) : void
      {
         mPlayerOwnerAttackController.tryToDoConsumableAttack(param1);
      }
      
      public function startDeathCamInput() : void
      {
         mSelectedTargets = new Map();
         mDBFacade.stageRef.addEventListener("keyDown",checkDeathCamKeyEvent);
      }
      
      protected function checkDeathCamKeyEvent(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 32)
         {
            followNextAlly();
         }
      }
      
      public function stopDeathCamInput() : void
      {
         mDBFacade.stageRef.removeEventListener("keyDown",checkDeathCamKeyEvent);
         if(mSelectedTargets)
         {
            mSelectedTargets.clear();
         }
         mSelectedTargets = null;
         resetCamera();
      }
      
      public function followNextAlly() : void
      {
         var _loc2_:ActorGameObject = null;
         if(mSelectedTargets == null || mFollowCamera == null)
         {
            return;
         }
         if(mDistributedDungeonFloor == null || mDistributedDungeonFloor.remoteHeroes == null)
         {
            return;
         }
         var _loc3_:* = null;
         var _loc1_:IMapIterator = mDistributedDungeonFloor.remoteHeroes.iterator() as IMapIterator;
         while(_loc1_.hasNext())
         {
            _loc2_ = _loc1_.next() as ActorGameObject;
            if(!(_loc2_ == null || mSelectedTargets.itemFor(_loc2_)))
            {
               _loc3_ = _loc2_;
               if(!(_loc3_.actorView == null || _loc3_.actorView.root == null))
               {
                  mFollowCamera.changeTarget(_loc3_.actorView.root);
               }
            }
         }
         if(_loc3_ == null)
         {
            mSelectedTargets.clear();
            resetCamera();
         }
         else
         {
            mSelectedTargets.add(_loc3_,true);
         }
      }
      
      public function resetCamera() : void
      {
         mFollowCamera.changeTarget(mHeroView.root);
      }
   }
}

