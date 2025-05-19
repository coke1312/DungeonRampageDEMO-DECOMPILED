package Actor
{
   import Facade.DBFacade;
   import GameMasterDictionary.GMActor;
   import GameMasterDictionary.StatVector;
   import org.as3commons.collections.Map;
   
   public class ActorData
   {
      
      protected var mFacade:DBFacade;
      
      protected var mActorGameObject:ActorGameObject;
      
      protected var mData:GMActor;
      
      public function ActorData(param1:DBFacade, param2:ActorGameObject)
      {
         super();
         mFacade = param1;
         mActorGameObject = param2;
         var _loc3_:Map = mFacade.gameMaster.getActorMap(mActorGameObject.type);
         mData = _loc3_.itemFor(mActorGameObject.type);
         if(mData == null)
         {
            throw new Error("type not found in GameMaster");
         }
      }
      
      public function destroy() : void
      {
         mFacade = null;
         mActorGameObject = null;
         mData = null;
      }
      
      public function get gMActor() : GMActor
      {
         return mData;
      }
      
      public function getSwfFilePath() : String
      {
         return DBFacade.buildFullDownloadPath(mData.SwfFilepath);
      }
      
      public function getSpriteSheetClassName(param1:String) : String
      {
         return mData.AssetClassName + "_" + param1 + ".png";
      }
      
      public function getMovieClipClassName() : String
      {
         return mData.AssetClassName;
      }
      
      public function getOffSpriteSheetClassName(param1:String) : String
      {
         return mData.AssetClassName + "_off_" + param1 + ".png";
      }
      
      public function getOffMovieClipClassName() : String
      {
         return mData.AssetClassName ? mData.AssetClassName + "_off" : "";
      }
      
      public function get constant() : String
      {
         return mData.Constant;
      }
      
      public function get hp() : Number
      {
         return mData.HP;
      }
      
      public function get mp() : Number
      {
         return mData.MP;
      }
      
      public function get movment() : Number
      {
         return mData.BaseMove;
      }
      
      public function get baseValues() : StatVector
      {
         return mData.BaseValues;
      }
      
      public function get levelValues() : StatVector
      {
         return mData.LevelValues;
      }
      
      public function get isMover() : Boolean
      {
         return mData.IsMover;
      }
      
      public function get assetType() : String
      {
         return mData.AssetType;
      }
      
      public function get spriteWidth() : Number
      {
         return mData.SpriteWidth;
      }
      
      public function get spriteHeight() : Number
      {
         return mData.SpriteHeight;
      }
      
      public function get assetClassName() : String
      {
         return mData.AssetClassName;
      }
      
      public function get hue() : Number
      {
         return mData.Hue;
      }
      
      public function get saturation() : Number
      {
         return mData.Saturation;
      }
      
      public function get brightness() : Number
      {
         return mData.Brightness;
      }
      
      public function get scale() : Number
      {
         return mData.Scale;
      }
      
      public function get hitSound() : String
      {
         return mData.HitSound;
      }
      
      public function get hitVolume() : Number
      {
         return mData.HitVolume;
      }
      
      public function get deathSound() : String
      {
         return mData.DeathSound;
      }
      
      public function get deathVolume() : Number
      {
         return mData.DeathVolume;
      }
   }
}

