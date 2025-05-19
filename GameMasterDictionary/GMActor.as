package GameMasterDictionary
{
   public class GMActor extends GMItem
   {
      
      public static const DESTRUCTION_SMASH:String = "SMASH";
      
      public static const DESTRUCTION_TIPOVER:String = "TIPOVER";
      
      public static const CHAR_TYPE_PROP:String = "PROP";
      
      public var Release:String = "D";
      
      public var CharType:String;
      
      public var ClassType:String;
      
      public var Species:String;
      
      public var Element:String;
      
      public var HP:Number;
      
      public var MP:Number;
      
      public var BaseMove:Number;
      
      public var BaseValues:StatVector;
      
      public var LevelValues:StatVector;
      
      public var AssetClassName:String;
      
      public var SwfFilepath:String;
      
      public var PortraitName:String;
      
      public var IconSwfFilepath:String;
      
      protected var mIconName:String;
      
      public var Description:String;
      
      public var AssetType:String;
      
      public var SpriteWidth:Number;
      
      public var SpriteHeight:Number;
      
      public var NametagY:Number;
      
      public var HealthbarScale:Number;
      
      public var Scale:Number;
      
      public var Hue:Number;
      
      public var Saturation:Number;
      
      public var Brightness:Number;
      
      public var Ability:uint;
      
      public var HitSound:String;
      
      public var HitVolume:Number;
      
      public var DeathSound:String;
      
      public var DeathVolume:Number;
      
      public var SpawnEffectClassName:String;
      
      public var SpawnEffectFilePath:String;
      
      public var CollisionX:Number;
      
      public var CollisionY:Number;
      
      public var CollisionSize:Number;
      
      public var CollideWithTeam:Boolean;
      
      public var TeleportInTimeline:String;
      
      public var TeleportOutTimeline:String;
      
      public var RespawnT:Number;
      
      public var ProjEmitOffset:Number;
      
      public var DefaultDestruct:String;
      
      public var Weapon1:String;
      
      public var Weapon2:String;
      
      public var Weapon3:String;
      
      public var Weapon4:String;
      
      public var Weapon5:String;
      
      public var CanShakeCamera:Boolean;
      
      public var IsMover:Boolean = true;
      
      public var HasOffscreenIndicator:Boolean = false;
      
      public var scaled_ProjEmitOffset:Number;
      
      public function GMActor(param1:Object)
      {
         super(param1);
         if(param1.hasOwnProperty("Release"))
         {
            Release = param1.Release;
         }
         Description = param1.Description;
         CharType = param1.CharType;
         ClassType = param1.ClassType;
         Species = param1.Species;
         Element = param1.Element;
         HP = param1.HP;
         MP = param1.MP;
         BaseValues = new StatVector();
         BaseValues.SetFromJSON(param1);
         LevelValues = new StatVector();
         LevelValues.SetFromJSON(param1,"LV_");
         AssetClassName = param1.AssetClassName;
         PortraitName = param1.PortraitName;
         IconSwfFilepath = param1.IconSwfFilepath;
         mIconName = param1.IconName;
         SwfFilepath = param1.SwfFilepath;
         Description = param1.Description;
         AssetType = param1.AssetType;
         SpriteWidth = param1.SpriteWidth;
         SpriteHeight = param1.SpriteHeight;
         NametagY = param1.NametagY;
         HealthbarScale = param1.HealthbarScale;
         IsMover = param1.IsMover == 1;
         HasOffscreenIndicator = param1.HasOffscreenIndicator;
         Ability = 0;
         Scale = param1.Scale;
         Hue = param1.Hue;
         Saturation = param1.Saturation > 0 ? (100 + param1.Saturation) / 100 * 2 : 0;
         Brightness = param1.Brightness;
         BaseMove = param1.BaseMove;
         HitSound = param1.HitSound;
         HitVolume = param1.HitVol;
         DeathSound = param1.DeathSound;
         DeathVolume = param1.DeathVol;
         SpawnEffectClassName = param1.SpawnEffectClassName;
         SpawnEffectFilePath = param1.SpawnEffectFilePath;
         CollisionX = param1.CollisionX;
         CollisionY = param1.CollisionY;
         CollisionSize = param1.CollisionSize;
         CollideWithTeam = param1.CollideWithTeam;
         TeleportInTimeline = param1.TeleportInTimeline;
         TeleportOutTimeline = param1.TeleportOutTimeline;
         RespawnT = param1.RespawnT;
         ProjEmitOffset = param1.ProjEmitOffset;
         scaled_ProjEmitOffset = param1.ProjEmitOffset * Scale;
         DefaultDestruct = param1.DefaultDestruct;
         CanShakeCamera = param1.CanShakeCamera;
      }
      
      public function get IconName() : String
      {
         return mIconName;
      }
   }
}

