package Projectile
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Clock.GameClock;
   import Brain.Render.MovieClipRenderController;
   import Brain.Utils.ColorMatrix;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Facade.DBFacade;
   import Floor.FloorView;
   import GameMasterDictionary.GMWeaponAesthetic;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   
   public class ProjectileView extends FloorView
   {
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mBody:MovieClip;
      
      private var mEffect:MovieClip;
      
      private var mProjectileGameObject:ProjectileGameObject;
      
      private var mEffectRenderer:MovieClipRenderController;
      
      private var mProjectileRenderer:MovieClipRenderController;
      
      public function ProjectileView(param1:DBFacade, param2:ProjectileGameObject)
      {
         super(param1,param2);
         mProjectileGameObject = param2;
         mAssetLoadingComponent = new AssetLoadingComponent(mFacade);
         mLogicalWorkComponent = new LogicalWorkComponent(mFacade);
         if(mProjectileGameObject.effectTimeOffset > 0)
         {
            mLogicalWorkComponent.doLater(mProjectileGameObject.effectTimeOffset,createEffect);
         }
         else
         {
            this.createEffect();
         }
      }
      
      override public function init() : void
      {
         super.init();
         var _loc1_:String = DBFacade.buildFullDownloadPath(mProjectileGameObject.gmProjectile.SwfFilepath);
         mAssetLoadingComponent.getSwfAsset(_loc1_,setupArt);
      }
      
      private function createEffect(param1:GameClock = null) : void
      {
         if(mProjectileGameObject.effectName != null)
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(mProjectileGameObject.effectPath),setupEffect);
         }
      }
      
      public function setupEffect(param1:SwfAsset) : void
      {
         mEffectRenderer = mDBFacade.movieClipPool.checkout(mDBFacade,param1,mProjectileGameObject.effectName) as MovieClipRenderController;
         mEffect = mEffectRenderer.clip;
         var _loc3_:Number = mProjectileGameObject.weapon != null ? mProjectileGameObject.weapon.collisionScale() : 1;
         mEffect.scaleX;
         mEffect.scaleY;
         var _loc4_:Number = mProjectileGameObject.gmProjectile.TrailTint;
         var _loc2_:Number = mProjectileGameObject.gmProjectile.TrailSaturation;
         applyColor(_loc4_,_loc2_,mEffect);
         mEffectRenderer.play(0,true);
         mRoot.addChildAt(mEffect,0);
         mEffect.rotation = Math.atan2(mProjectileGameObject.velocity.y,mProjectileGameObject.velocity.x) * 180 / 3.141592653589793;
      }
      
      private function setupArt(param1:SwfAsset) : void
      {
         mProjectileRenderer = mDBFacade.movieClipPool.checkout(mDBFacade,param1,mProjectileGameObject.gmProjectile.ProjModel) as MovieClipRenderController;
         mBody = mProjectileRenderer.clip;
         mProjectileRenderer.play(0,true);
         mRoot.addChild(mBody);
         var _loc3_:Number = mProjectileGameObject.gmProjectile.Tint;
         var _loc2_:Number = mProjectileGameObject.gmProjectile.Saturation;
         applyColor(_loc3_,_loc2_,mBody);
         if(mProjectileGameObject.rotationSpeed == 0)
         {
            if(mProjectileGameObject.shouldRotate)
            {
               mBody.rotation = Math.atan2(mProjectileGameObject.velocity.y,mProjectileGameObject.velocity.x) * 180 / 3.141592653589793;
            }
         }
         else
         {
            mLogicalWorkComponent.doEveryFrame(updateRotation);
         }
         if(mProjectileGameObject.weapon)
         {
            applyColorAndGlow(mBody);
            mBody.scaleX *= mProjectileGameObject.weapon.collisionScale();
            mBody.scaleY *= mProjectileGameObject.weapon.collisionScale();
         }
      }
      
      protected function applyColorAndGlow(param1:DisplayObject) : void
      {
         var _loc2_:GMWeaponAesthetic = mProjectileGameObject.weapon.weaponAesthetic;
         if(_loc2_.HasColor)
         {
            param1.transform.colorTransform = new ColorTransform(_loc2_.ItemR,_loc2_.ItemG,_loc2_.ItemB,1,_loc2_.ItemRAdd,_loc2_.ItemGAdd,_loc2_.ItemBAdd,0);
         }
         if(_loc2_.HasGlow)
         {
            param1.filters = [new GlowFilter(_loc2_.GlowColor,1,_loc2_.GlowDist,_loc2_.GlowDist,_loc2_.GlowStr)];
         }
         if(mProjectileGameObject.weapon.gmRarity.HasGlow)
         {
            param1.filters = [new GlowFilter(mProjectileGameObject.weapon.gmRarity.GlowColor,0.5,mProjectileGameObject.weapon.gmRarity.GlowDist * mProjectileGameObject.weapon.collisionScale(),mProjectileGameObject.weapon.gmRarity.GlowDist * mProjectileGameObject.weapon.collisionScale(),mProjectileGameObject.weapon.gmRarity.GlowStr * mProjectileGameObject.weapon.collisionScale())];
         }
      }
      
      protected function applyColor(param1:Number, param2:Number, param3:DisplayObject) : void
      {
         var _loc4_:ColorMatrix = null;
         if(param1 != 0 || param2 != 1)
         {
            _loc4_ = new ColorMatrix();
            _loc4_.adjustHue(param1);
            _loc4_.adjustSaturation(param2);
            param3.filters = [_loc4_.filter];
         }
         else
         {
            param3.filters = [];
         }
      }
      
      private function updateRotation(param1:GameClock) : void
      {
         if(mBody)
         {
            mBody.rotation += mProjectileGameObject.rotationSpeed * mLogicalWorkComponent.gameClock.tickLength;
         }
      }
      
      public function setRotation(param1:Number) : void
      {
         if(mBody)
         {
            mBody.rotation = param1;
         }
      }
      
      override public function destroy() : void
      {
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         mAssetLoadingComponent.destroy();
         mAssetLoadingComponent = null;
         mBody = null;
         mEffect = null;
         if(mEffectRenderer)
         {
            mDBFacade.movieClipPool.checkin(mEffectRenderer);
            mEffectRenderer = null;
         }
         if(mProjectileRenderer)
         {
            mDBFacade.movieClipPool.checkin(mProjectileRenderer);
            mProjectileRenderer = null;
         }
         mProjectileGameObject = null;
         super.destroy();
      }
   }
}

