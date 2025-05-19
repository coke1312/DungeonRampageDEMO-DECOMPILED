package Actor
{
   import DistributedObjects.HeroGameObject;
   import Facade.DBFacade;
   import GameMasterDictionary.GMSkin;
   
   public class HeroData extends ActorData
   {
      
      protected var mHeroGameObject:HeroGameObject;
      
      protected var mGMSkin:GMSkin;
      
      public function HeroData(param1:DBFacade, param2:HeroGameObject, param3:GMSkin)
      {
         super(param1,param2);
         mHeroGameObject = param2;
         mGMSkin = param3;
      }
      
      override public function getSwfFilePath() : String
      {
         return DBFacade.buildFullDownloadPath(mGMSkin.SwfFilepath);
      }
      
      override public function getSpriteSheetClassName(param1:String) : String
      {
         return mGMSkin.AssetClassName + "_" + param1 + ".png";
      }
      
      override public function getMovieClipClassName() : String
      {
         return mGMSkin.AssetClassName;
      }
      
      override public function getOffSpriteSheetClassName(param1:String) : String
      {
         return mGMSkin.AssetClassName + "_off_" + param1 + ".png";
      }
      
      override public function getOffMovieClipClassName() : String
      {
         return mGMSkin.AssetClassName ? mGMSkin.AssetClassName + "_off" : "";
      }
      
      override public function get assetClassName() : String
      {
         return mGMSkin.AssetClassName;
      }
      
      override public function get hue() : Number
      {
         return mGMSkin.Hue;
      }
      
      override public function get saturation() : Number
      {
         return mGMSkin.Saturation;
      }
      
      override public function get brightness() : Number
      {
         return mGMSkin.Brightness;
      }
      
      override public function get scale() : Number
      {
         return mGMSkin.Scale;
      }
      
      override public function get hitSound() : String
      {
         return mGMSkin.HitSound;
      }
      
      override public function get hitVolume() : Number
      {
         return mGMSkin.HitVol;
      }
      
      override public function get deathSound() : String
      {
         return mGMSkin.DeathSound;
      }
      
      override public function get deathVolume() : Number
      {
         return mGMSkin.DeathVol;
      }
   }
}

