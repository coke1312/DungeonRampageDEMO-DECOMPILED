package Actor
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.Sound.SoundAsset;
   import Brain.Utils.ColorMatrix;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.PreRenderWorkComponent;
   import Combat.Weapon.WeaponView;
   import DistributedObjects.HeroGameObject;
   import DistributedObjects.NPCGameObject;
   import Effects.EffectGameObject;
   import Effects.EffectView;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import Floor.FloorView;
   import GameMasterDictionary.GMAttack;
   import GeneratedCode.CombatResult;
   import Sound.DBSoundComponent;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Vector3D;
   
   public class ActorView extends FloorView
   {
      
      public static var BODY_Y_OFFSET:Number = -45;
      
      protected static var mMouseOverEffect:GlowFilter = new GlowFilter(16633879,1,16,16,5);
      
      protected static var mMouseSelectedEffect:GlowFilter = new GlowFilter(16711680,1,16,16,5);
      
      protected var mBody:Sprite;
      
      protected var mEffect:Sprite;
      
      protected var mParentActorObject:ActorGameObject;
      
      protected var mEventComponent:EventComponent;
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      protected var mPreRenderWorkComponent:PreRenderWorkComponent;
      
      protected var mLogicalWorkComponent:LogicalWorkComponent;
      
      protected var mSoundComponent:DBSoundComponent;
      
      protected var mVelocity:Vector3D;
      
      protected var mBodyAnimRenderer:ActorRenderer;
      
      protected var mAnimName:String = "idle";
      
      protected var mHeading:Number = 0;
      
      protected var mWantNametag:Boolean = false;
      
      protected var mNametag:ActorNametag;
      
      protected var mCurrentWeaponView:WeaponView;
      
      protected var mCurrentWeaponAnimRenderer:ActorRenderer;
      
      protected var mBodyFilters:Array;
      
      protected var mDeathSoundEffect:SoundAsset;
      
      protected var mDeathSoundVolume:Number;
      
      private var specialVFXObject_Back:EffectGameObject;
      
      private var specialVFXObject_Front:EffectGameObject;
      
      public function ActorView(param1:DBFacade, param2:ActorGameObject)
      {
         super(param1,param2);
         mParentActorObject = param2;
         mBodyFilters = [];
         mVelocity = new Vector3D(0,0,0);
         mEventComponent = new EventComponent(mFacade);
         mPreRenderWorkComponent = new PreRenderWorkComponent(mFacade);
         mLogicalWorkComponent = new LogicalWorkComponent(mFacade);
         mSoundComponent = new DBSoundComponent(param1);
         mRoot.name = "ActorView.mRoot_" + param2.id;
         mAssetLoadingComponent = new AssetLoadingComponent(mFacade);
         mBody = new Sprite();
         mBody.name = "ActorView.mBody";
         mRoot.addChild(mBody);
         mEffect = new Sprite();
         mEffect.name = "ActorView.mEffect";
         mRoot.addChild(mEffect);
      }
      
      protected function applyColor(param1:DisplayObject) : void
      {
         var _loc3_:Number = mParentActorObject.actorData.brightness;
         var _loc5_:Number = mParentActorObject.actorData.hue;
         var _loc2_:Number = mParentActorObject.actorData.saturation;
         var _loc4_:ColorMatrix = new ColorMatrix();
         if(_loc3_ != 0)
         {
            _loc4_.adjustBrightness(_loc3_);
         }
         if(_loc5_ != 0)
         {
            _loc4_.adjustHue(_loc5_);
         }
         if(_loc2_ != 0)
         {
            _loc4_.adjustSaturation(_loc2_);
         }
         param1.filters = [_loc4_.filter];
      }
      
      public function get bodyAnimRenderer() : ActorRenderer
      {
         return mBodyAnimRenderer;
      }
      
      public function get currentWeapon() : WeaponView
      {
         return mCurrentWeaponView;
      }
      
      public function set currentWeapon(param1:WeaponView) : void
      {
         if(mCurrentWeaponView == param1)
         {
            return;
         }
         mCurrentWeaponView = param1;
         if(mCurrentWeaponAnimRenderer)
         {
            mCurrentWeaponAnimRenderer.stop();
         }
         mCurrentWeaponAnimRenderer = mCurrentWeaponView.weaponRenderer;
         if(mCurrentWeaponAnimRenderer)
         {
            if(mCurrentWeaponAnimRenderer.hasAnim(mAnimName))
            {
               this.bodyAnimRenderer.forceFrame(0);
               mCurrentWeaponAnimRenderer.heading = this.heading;
               mCurrentWeaponAnimRenderer.play(mAnimName,this.bodyAnimRenderer.currentFrame,this.bodyAnimRenderer.loop);
               mBody.addChild(mCurrentWeaponAnimRenderer);
            }
            else
            {
               mCurrentWeaponAnimRenderer.stop();
            }
         }
      }
      
      public function get nametag() : ActorNametag
      {
         return mNametag;
      }
      
      public function disableMouse() : void
      {
         mRoot.mouseChildren = false;
         mRoot.mouseEnabled = false;
      }
      
      public function enableMouse() : void
      {
         mRoot.mouseChildren = true;
         mRoot.mouseEnabled = true;
      }
      
      public function actionsForDeadState() : void
      {
         this.mouseOverUnhighlight();
         this.mouseSelectedUnhighlight();
         disableMouse();
         if(mDeathSoundEffect)
         {
            mSoundComponent.playSfxOneShot(mDeathSoundEffect,worldCenter,0,mDeathSoundVolume);
         }
         velocity = new Vector3D(0,0);
         hideSpecialEffect();
      }
      
      public function actionsForExitDeadState() : void
      {
         enableMouse();
         showSpecialEffect();
      }
      
      protected function buildNametag() : void
      {
         if(mWantNametag)
         {
            mNametag = new ActorNametag(mFacade,mAssetLoadingComponent,mLogicalWorkComponent,mParentActorObject.actorData.gMActor.NametagY);
            mNametag.cacheAsBitmap = true;
            mNametag.hpBar.scaleX = mParentActorObject.actorData.gMActor.HealthbarScale / root.scaleX;
            mNametag.hpBar.scaleY = mParentActorObject.actorData.gMActor.HealthbarScale / root.scaleY;
            mRoot.addChild(mNametag);
            mNametag.AFK = this.mParentActorObject.AFK;
            mNametag.screenName = this.mParentActorObject.screenName;
            mNametag.setHp(mParentActorObject.hitPoints,mParentActorObject.maxHitPoints);
         }
      }
      
      public function get body() : Sprite
      {
         return mBody;
      }
      
      public function buildBuff(param1:MovieClip, param2:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(mRoot.contains(param1))
         {
            Logger.warn("buff already is a child of mRoot");
            return;
         }
         if(param2 == "foreground")
         {
            mRoot.addChild(param1);
         }
         else
         {
            mRoot.addChildAt(param1,0);
         }
      }
      
      public function destroyBuff(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(mRoot.contains(param1))
         {
            mRoot.removeChild(param1);
         }
      }
      
      override public function init() : void
      {
         super.init();
         mBodyAnimRenderer = new ActorRenderer(mDBFacade,mParentActorObject,true);
         mBodyAnimRenderer.loadAssets();
         mBody.addChild(mBodyAnimRenderer);
         applyColor(mBodyAnimRenderer);
         buildNametag();
         if(mParentActorObject.actorData.deathSound)
         {
            mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),mParentActorObject.actorData.deathSound,function(param1:SoundAsset):void
            {
               mDeathSoundEffect = param1;
               mDeathSoundVolume = mParentActorObject.actorData.deathVolume;
            });
         }
         if(mParentActorObject.gmSkin && mParentActorObject.gmSkin.doesSpecialFXBackExist())
         {
            addSpecialBackEffect(mParentActorObject.gmSkin.specialFXSwfPath_Back,mParentActorObject.gmSkin.specialFXName_Back);
         }
         if(mParentActorObject.gmSkin && mParentActorObject.gmSkin.doesSpecialFXFrontExist())
         {
            addSpecialFrontEffect(mParentActorObject.gmSkin.specialFXSwfPath_Front,mParentActorObject.gmSkin.specialFXName_Front);
         }
      }
      
      public function addSpecialBackEffect(param1:String, param2:String) : void
      {
         var swfPath:String = param1;
         var className:String = param2;
         specialVFXObject_Back = new EffectGameObject(mDBFacade,DBFacade.buildFullDownloadPath(swfPath),className,1);
         root.addChildAt(specialVFXObject_Back.view.root,0);
         EffectView(specialVFXObject_Back.view).play(true,function():void
         {
         });
      }
      
      public function addSpecialFrontEffect(param1:String, param2:String) : void
      {
         var swfPath:String = param1;
         var className:String = param2;
         specialVFXObject_Front = new EffectGameObject(mDBFacade,DBFacade.buildFullDownloadPath(swfPath),className,1);
         root.addChild(specialVFXObject_Front.view.root);
         EffectView(specialVFXObject_Front.view).play(true,function():void
         {
         });
      }
      
      public function showSpecialEffect() : void
      {
         if(specialVFXObject_Back)
         {
            specialVFXObject_Back.view.root.visible = true;
         }
         if(specialVFXObject_Front)
         {
            specialVFXObject_Front.view.root.visible = true;
         }
      }
      
      public function hideSpecialEffect() : void
      {
         if(specialVFXObject_Back)
         {
            specialVFXObject_Back.view.root.visible = false;
         }
         if(specialVFXObject_Front)
         {
            specialVFXObject_Front.view.root.visible = false;
         }
      }
      
      public function hasAnim(param1:String) : Boolean
      {
         return this.bodyAnimRenderer.hasAnim(param1);
      }
      
      public function getAnimDurationInSeconds(param1:String) : Number
      {
         return this.bodyAnimRenderer.getAnimDurationInSeconds(param1);
      }
      
      public function playAnim(param1:String, param2:int = 0, param3:Boolean = false, param4:Boolean = true, param5:Number = 1) : Boolean
      {
         mAnimName = param1;
         if(this.bodyAnimRenderer)
         {
            this.bodyAnimRenderer.heading = this.heading;
            this.bodyAnimRenderer.play(param1,param2,param3,param4,param5);
         }
         if(mCurrentWeaponAnimRenderer)
         {
            if(mCurrentWeaponAnimRenderer.hasAnim(param1))
            {
               mCurrentWeaponAnimRenderer.heading = this.heading;
               mCurrentWeaponAnimRenderer.play(param1,param2,param3,param4,param5);
            }
            else
            {
               mCurrentWeaponAnimRenderer.stop();
            }
         }
         return true;
      }
      
      public function get currentAnim() : String
      {
         return mAnimName;
      }
      
      public function setAnimAt(param1:String, param2:uint) : Boolean
      {
         this.bodyAnimRenderer.heading = this.heading;
         this.bodyAnimRenderer.setFrame(param1,param2);
         if(mCurrentWeaponAnimRenderer)
         {
            if(mCurrentWeaponAnimRenderer.hasAnim(param1))
            {
               mCurrentWeaponAnimRenderer.heading = this.heading;
               mCurrentWeaponAnimRenderer.setFrame(param1,param2);
            }
            else
            {
               mCurrentWeaponAnimRenderer.stop();
            }
         }
         return true;
      }
      
      public function stopAnim() : void
      {
         this.bodyAnimRenderer.stop();
         if(mCurrentWeaponAnimRenderer)
         {
            mCurrentWeaponAnimRenderer.stop();
         }
      }
      
      public function setHp(param1:uint, param2:uint) : void
      {
         if(mNametag)
         {
            mNametag.setHp(param1,param2);
         }
      }
      
      public function set screenName(param1:String) : void
      {
         if(mNametag)
         {
            mNametag.screenName = param1;
         }
      }
      
      public function setChat(param1:String) : void
      {
         if(mNametag)
         {
            mNametag.setChat(param1);
         }
      }
      
      public function get velocity() : Vector3D
      {
         return mVelocity;
      }
      
      public function set velocity(param1:Vector3D) : void
      {
         mVelocity = param1;
      }
      
      public function set heading(param1:Number) : void
      {
         mHeading = param1;
         if(this.bodyAnimRenderer)
         {
            this.bodyAnimRenderer.heading = param1;
         }
         if(mCurrentWeaponAnimRenderer)
         {
            mCurrentWeaponAnimRenderer.heading = param1;
         }
      }
      
      public function get heading() : Number
      {
         return mHeading;
      }
      
      override public function destroy() : void
      {
         if(mNametag)
         {
            mNametag.destroy();
            mNametag = null;
         }
         if(mDeathSoundEffect)
         {
            mDeathSoundEffect = null;
         }
         mEventComponent.destroy();
         mEventComponent = null;
         mAssetLoadingComponent.destroy();
         mAssetLoadingComponent = null;
         mPreRenderWorkComponent.destroy();
         mPreRenderWorkComponent = null;
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         mSoundComponent.destroy();
         mSoundComponent = null;
         if(mBodyAnimRenderer)
         {
            mBodyAnimRenderer.destroy();
            mBodyAnimRenderer = null;
         }
         mCurrentWeaponView = null;
         mCurrentWeaponAnimRenderer = null;
         mBodyFilters = null;
         mBody = null;
         mEffect = null;
         mParentActorObject = null;
         super.destroy();
      }
      
      public function set body(param1:Sprite) : void
      {
         if(mBody != null && mBody.parent)
         {
            mBody.parent.removeChild(mBody);
         }
         mBody = param1;
         mRoot.addChild(mBody);
      }
      
      public function mouseOverHighlight() : void
      {
         addEffect(mMouseOverEffect);
      }
      
      public function mouseOverUnhighlight() : void
      {
         removeEffect(mMouseOverEffect);
      }
      
      public function mouseSelectedHighlight() : void
      {
         addEffect(mMouseSelectedEffect);
      }
      
      public function mouseSelectedUnhighlight() : void
      {
         removeEffect(mMouseSelectedEffect);
      }
      
      public function reviveHighlight() : void
      {
         var _loc1_:ColorTransform = new ColorTransform();
         _loc1_.color = 16777215;
         mBody.transform.colorTransform = _loc1_;
      }
      
      public function reviveUnhighlight() : void
      {
         mBody.transform.colorTransform = new ColorTransform();
      }
      
      private function addEffect(param1:GlowFilter) : void
      {
         if(mBodyFilters.indexOf(param1) < 0)
         {
            mBodyFilters.push(param1);
            mBody.filters = mBodyFilters;
         }
      }
      
      private function removeEffect(param1:GlowFilter) : void
      {
         var _loc2_:int = int(mBodyFilters.indexOf(param1));
         if(_loc2_ >= 0)
         {
            mBodyFilters.splice(_loc2_,1);
            mBody.filters = mBodyFilters;
         }
      }
      
      protected function playHitEffect(param1:GMAttack, param2:Boolean) : void
      {
         var _loc5_:String = DBFacade.buildFullDownloadPath(param1.HitEffectFilepath);
         var _loc3_:String = mParentActorObject is HeroGameObject ? "db_fx_hitRed" : param1.HitEffect;
         if(param2)
         {
            _loc3_ = param1.HitEffect;
         }
         var _loc4_:Vector3D = new Vector3D(0,mParentActorObject.actorData.gMActor.ProjEmitOffset);
         var _loc6_:Number = 1 / mRoot.scaleX;
         var _loc7_:Number = param1.HitEffectStopRotation ? 0 : Math.random() * 360;
         if(_loc3_)
         {
            mParentActorObject.distributedDungeonFloor.effectManager.playEffect(_loc5_,_loc3_,_loc4_,mParentActorObject,param1.HitEffectBehindAvatar,_loc6_,_loc7_);
         }
      }
      
      protected function playHitEffectToLerpToAttacker(param1:GMAttack, param2:ActorGameObject) : void
      {
         var swfPath:String;
         var hitEffectName:String;
         var lerpedFunc:Function;
         var i:int;
         var gmAttack:GMAttack = param1;
         var lerpActor:ActorGameObject = param2;
         if(gmAttack.HitEffectToLerpToAttacker)
         {
            swfPath = DBFacade.buildFullDownloadPath(gmAttack.HitEffectLerpFilepath);
            hitEffectName = gmAttack.HitEffectToLerpToAttacker;
            if(hitEffectName)
            {
               lerpedFunc = function():void
               {
                  playLerpedEffect(swfPath,hitEffectName,mParentActorObject,lerpActor,gmAttack.HitEffectToLerpSpeed,gmAttack.HitEffectToLerpGlowColor);
               };
               i = 0;
               while(i < 5)
               {
                  mLogicalWorkComponent.doLater(Math.random() / 100 * i,lerpedFunc);
                  ++i;
               }
            }
         }
      }
      
      protected function playHitEffectToLerpFromAttacker(param1:GMAttack, param2:ActorGameObject) : void
      {
         var swfPath:String;
         var hitEffectName:String;
         var lerpedFunc:Function;
         var i:int;
         var gmAttack:GMAttack = param1;
         var lerpActor:ActorGameObject = param2;
         if(gmAttack.HitEffectToLerpFromAttacker)
         {
            swfPath = DBFacade.buildFullDownloadPath(gmAttack.HitEffectLerpFilepath);
            hitEffectName = gmAttack.HitEffectToLerpFromAttacker;
            if(hitEffectName)
            {
               lerpedFunc = function():void
               {
                  playLerpedEffect(swfPath,hitEffectName,lerpActor,mParentActorObject,gmAttack.HitEffectToLerpSpeed,gmAttack.HitEffectToLerpGlowColor);
               };
               i = 0;
               while(i < 5)
               {
                  mLogicalWorkComponent.doLater(Math.random() / 100 * i,lerpedFunc);
                  ++i;
               }
            }
         }
      }
      
      private function playLerpedEffect(param1:String, param2:String, param3:FloorObject = null, param4:ActorGameObject = null, param5:Number = 1, param6:uint = 13369344) : void
      {
         var _loc7_:Vector3D = new Vector3D(0,0);
         var _loc8_:Number = 0.5 + Math.random();
         mParentActorObject.distributedDungeonFloor.effectManager.playLerpedEffect(param1,param2,_loc7_,param3,param4,param5,param6,false,_loc8_);
      }
      
      protected function playHealEffect() : void
      {
         var _loc2_:String = DBFacade.buildFullDownloadPath("Resources/Art2D/FX/db_fx_library.swf");
         var _loc5_:String = "db_fx_heal";
         var _loc1_:Vector3D = mParentActorObject.projectileLaunchOffset;
         var _loc3_:Number = 1 / mRoot.scaleX;
         var _loc4_:Number = 0;
         mParentActorObject.distributedDungeonFloor.effectManager.playEffect(_loc2_,_loc5_,_loc1_,mParentActorObject,false,_loc3_,_loc4_);
      }
      
      private function isThisIdTheOwner(param1:uint) : Boolean
      {
         var _loc2_:ActorGameObject = mDBFacade.gameObjectManager.getReferenceFromId(param1) as ActorGameObject;
         return _loc2_.isOwner;
      }
      
      private function isThisIdAnOwnersPet(param1:uint) : Boolean
      {
         var _loc3_:NPCGameObject = null;
         var _loc2_:ActorGameObject = mDBFacade.gameObjectManager.getReferenceFromId(param1) as ActorGameObject;
         if(_loc2_)
         {
            _loc3_ = _loc2_ as NPCGameObject;
            if(_loc3_ == null)
            {
               return false;
            }
            if(_loc3_.masterIsUser())
            {
               return true;
            }
         }
         return false;
      }
      
      private function isThisAProp(param1:uint) : Boolean
      {
         var _loc2_:ActorGameObject = mDBFacade.gameObjectManager.getReferenceFromId(param1) as ActorGameObject;
         if(_loc2_ && _loc2_.actorData.gMActor.CharType == "PROP")
         {
            return true;
         }
         return false;
      }
      
      private function doesCombatResultInvolveUserOrPetOfUser(param1:CombatResult) : Boolean
      {
         if(isThisIdUserOrPetOfUser(param1.attacker) || isThisIdUserOrPetOfUser(param1.attackee))
         {
            return true;
         }
         return false;
      }
      
      private function doesCombatResultHaveShowHealFlag(param1:CombatResult) : Boolean
      {
         var _loc2_:ActorGameObject = mDBFacade.gameObjectManager.getReferenceFromId(param1.attackee) as ActorGameObject;
         if(_loc2_.hasShowHealNumbers)
         {
            return true;
         }
         return false;
      }
      
      private function isThisIdUserOrPetOfUser(param1:uint) : Boolean
      {
         if(isThisIdTheOwner(param1))
         {
            return true;
         }
         return isThisIdAnOwnersPet(param1);
      }
      
      public function localCombatHit(param1:CombatResult) : void
      {
         var _loc2_:GMAttack = null;
         var _loc3_:ActorGameObject = mDBFacade.gameObjectManager.getReferenceFromId(param1.attacker) as ActorGameObject;
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.isOwner)
         {
            _loc2_ = mDBFacade.gameMaster.attackById.itemFor(param1.attack.attackType);
            playHitEffect(_loc2_,_loc3_.isHeroType);
            playHitEffectToLerpToAttacker(_loc2_,_loc3_);
            playHitEffectToLerpFromAttacker(_loc2_,_loc3_);
         }
      }
      
      public function receiveDamage(param1:CombatResult, param2:GMAttack) : void
      {
         var impactSound:String;
         var combatResult:CombatResult = param1;
         var gmAttack:GMAttack = param2;
         var attackerGameObject:ActorGameObject = mDBFacade.gameObjectManager.getReferenceFromId(combatResult.attacker) as ActorGameObject;
         if(attackerGameObject != null)
         {
            if(!attackerGameObject.isOwner)
            {
               playHitEffect(gmAttack,attackerGameObject.isHeroType);
            }
            if(combatResult.damage != 0)
            {
               if(doesCombatResultInvolveUserOrPetOfUser(combatResult) && !isThisAProp(combatResult.attackee))
               {
                  spawnDamageFloater(Boolean(combatResult.criticalHit),combatResult.damage,isThisIdTheOwner(combatResult.attacker),isThisIdTheOwner(combatResult.attackee),combatResult.effectiveness);
               }
            }
            if(mParentActorObject.actorData.hitSound)
            {
               this.mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),mParentActorObject.actorData.hitSound,function(param1:SoundAsset):void
               {
                  mSoundComponent.playSfxOneShot(param1,worldCenter,0,mParentActorObject.actorData.hitVolume);
               });
            }
         }
         if(gmAttack && gmAttack.ImpactSound)
         {
            impactSound = gmAttack.ImpactSound;
            if(combatResult.effectiveness < 0)
            {
               impactSound = "WeakAttack";
            }
            else if(combatResult.effectiveness > 0)
            {
               impactSound = "StrongHit";
            }
            this.mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),impactSound,function(param1:SoundAsset):void
            {
               mSoundComponent.playSfxOneShot(param1,worldCenter,0,gmAttack.ImpactVolume);
            });
         }
      }
      
      public function receiveHeal(param1:CombatResult, param2:GMAttack) : void
      {
         var _loc3_:Boolean = false;
         if(param1.damage != 0)
         {
            if(doesCombatResultInvolveUserOrPetOfUser(param1) || doesCombatResultHaveShowHealFlag(param1))
            {
               _loc3_ = isThisIdTheOwner(param1.attacker) || isThisIdTheOwner(param1.attackee);
               spawnHealFloater(param1.damage,isThisIdTheOwner(param1.attacker),isThisIdTheOwner(param1.attackee),param1.effectiveness);
            }
         }
      }
      
      public function spawnDamageFloater(param1:Boolean, param2:int, param3:Boolean, param4:Boolean, param5:int, param6:uint = 0, param7:String = "DAMAGE_MOVEMENT_TYPE") : void
      {
         var _loc8_:DamageFloater = new DamageFloater(mDBFacade,param2,mParentActorObject,0,24,0.9,90,null,param3,param4,true,param1,param5,param6,param7);
      }
      
      public function spawnHealFloater(param1:int, param2:Boolean, param3:Boolean, param4:int, param5:uint = 0, param6:String = "DAMAGE_MOVEMENT_TYPE") : void
      {
         var _loc7_:DamageFloater = new DamageFloater(mDBFacade,param1,mParentActorObject,4,24,0.9,90,null,param2,param3,true,false,param4,param5,param6);
      }
      
      public function hasAnimationRenderer() : Boolean
      {
         if(bodyAnimRenderer)
         {
            return true;
         }
         return false;
      }
      
      public function set AFK(param1:Boolean) : void
      {
         if(mNametag)
         {
            mNametag.AFK = param1;
         }
      }
   }
}

