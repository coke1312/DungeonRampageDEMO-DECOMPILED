package Combat.Weapon
{
   import Actor.ActorRenderer;
   import Brain.Render.IRenderer;
   import Facade.DBFacade;
   
   public class WeaponRenderer extends ActorRenderer
   {
      
      protected var mWeaponGameObject:WeaponGameObject;
      
      public function WeaponRenderer(param1:DBFacade, param2:WeaponGameObject, param3:Boolean)
      {
         super(param1,param2.actorGameObject,param3);
         mWeaponGameObject = param2;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         mWeaponGameObject = null;
      }
      
      override protected function loadErrorCallback() : void
      {
      }
      
      override protected function getSpriteSheetClassName(param1:String) : String
      {
         return mActorGameObject.actorData.assetClassName + "_" + param1 + "_" + mWeaponGameObject.weaponAesthetic.ModelName + ".png";
      }
      
      override protected function get movieClipClassName() : String
      {
         return super.movieClipClassName + "_" + mWeaponGameObject.weaponAesthetic.ModelName;
      }
      
      override protected function setAnimInDictionary(param1:String, param2:IRenderer) : void
      {
         super.setAnimInDictionary(param1,param2);
         stop();
      }
      
      override protected function get swfFilePath() : String
      {
         return super.swfFilePath.slice(0,super.swfFilePath.length - 4) + "_" + mWeaponGameObject.weaponAesthetic.ModelName + ".swf";
      }
   }
}

