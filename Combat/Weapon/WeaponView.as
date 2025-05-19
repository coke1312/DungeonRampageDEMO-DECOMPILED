package Combat.Weapon
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.GameObject.View;
   import Brain.Render.ActorSpriteSheetRenderer;
   import Brain.WorkLoop.PreRenderWorkComponent;
   import Facade.DBFacade;
   import GameMasterDictionary.GMWeaponAesthetic;
   import flash.display.DisplayObject;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   
   public class WeaponView extends View
   {
      
      protected var mWeaponGameObject:WeaponGameObject;
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      protected var mPreRenderWorkComponent:PreRenderWorkComponent;
      
      protected var mWeaponAnimRenderer:ActorSpriteSheetRenderer;
      
      protected var mWeaponRenderer:WeaponRenderer;
      
      protected var mDBFacade:DBFacade;
      
      public function WeaponView(param1:DBFacade, param2:WeaponGameObject)
      {
         mDBFacade = param1;
         super(param1);
         mWeaponGameObject = param2;
         mAssetLoadingComponent = new AssetLoadingComponent(mFacade);
         mPreRenderWorkComponent = new PreRenderWorkComponent(mFacade);
         if(mWeaponGameObject.weaponAesthetic.ModelName)
         {
            mWeaponRenderer = new WeaponRenderer(mDBFacade,mWeaponGameObject,true);
            mWeaponRenderer.loadAssets();
            mWeaponGameObject.actorGameObject.actorView.body.addChild(mWeaponRenderer);
            applyColorAndGlow(mWeaponRenderer);
         }
      }
      
      protected function applyColorAndGlow(param1:DisplayObject) : void
      {
         var _loc2_:GMWeaponAesthetic = mWeaponGameObject.weaponAesthetic;
         if(_loc2_.HasColor)
         {
            param1.transform.colorTransform = new ColorTransform(_loc2_.ItemR,_loc2_.ItemG,_loc2_.ItemB,1,_loc2_.ItemRAdd,_loc2_.ItemGAdd,_loc2_.ItemBAdd,0);
         }
         if(_loc2_.HasGlow)
         {
            param1.filters = [new GlowFilter(_loc2_.GlowColor,1,_loc2_.GlowDist,_loc2_.GlowDist,_loc2_.GlowStr)];
         }
         if(mWeaponGameObject.gmRarity.HasGlow)
         {
            param1.filters = [new GlowFilter(mWeaponGameObject.gmRarity.GlowColor,1,mWeaponGameObject.gmRarity.GlowDist,mWeaponGameObject.gmRarity.GlowDist,mWeaponGameObject.gmRarity.GlowStr)];
         }
      }
      
      protected function removeColorAndGlow(param1:DisplayObject) : void
      {
         var _loc2_:GMWeaponAesthetic = mWeaponGameObject.weaponAesthetic;
         if(_loc2_.HasColor)
         {
            param1.transform.colorTransform = new ColorTransform();
         }
         if(_loc2_.HasGlow)
         {
            param1.filters = [];
         }
      }
      
      public function get weaponRenderer() : WeaponRenderer
      {
         return mWeaponRenderer;
      }
      
      override public function destroy() : void
      {
         if(mWeaponRenderer)
         {
            mWeaponRenderer.destroy();
            mWeaponRenderer = null;
         }
         mAssetLoadingComponent.destroy();
         mAssetLoadingComponent = null;
         mPreRenderWorkComponent.destroy();
         mPreRenderWorkComponent = null;
         mWeaponGameObject = null;
         mDBFacade = null;
         super.destroy();
      }
   }
}

