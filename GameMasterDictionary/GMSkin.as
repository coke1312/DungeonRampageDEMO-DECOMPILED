package GameMasterDictionary
{
   public class GMSkin extends GMItem
   {
      
      public var ForHero:String;
      
      public var AssetType:String;
      
      public var SpriteWidth:uint;
      
      public var SpriteHeight:uint;
      
      public var AssetClassName:String;
      
      public var PortraitName:String;
      
      public var IconSwfFilepath:String;
      
      public var IconName:String;
      
      public var CardName:String;
      
      public var SwfFilepath:String;
      
      public var UISwfFilepath:String;
      
      public var FeedPostPicture:String;
      
      public var Scale:Number;
      
      public var NametagY:Number;
      
      public var HealthbarScale:Number;
      
      public var ProjEmitOffset:Number;
      
      public var Hue:Number;
      
      public var Saturation:Number;
      
      public var Brightness:Number;
      
      public var HitVol:Number;
      
      public var HitSound:String;
      
      public var DeathVol:Number;
      
      public var DeathSound:String;
      
      public var CharNickname:String;
      
      public var CharLikes:String;
      
      public var CharDislikes:String;
      
      public var CharUnlockLocation:String;
      
      public var Description:String;
      
      public var StoreDescription:String;
      
      public var specialFXSwfPath_Back:String;
      
      public var specialFXName_Back:String;
      
      public var specialFXSwfPath_Front:String;
      
      public var specialFXName_Front:String;
      
      public function GMSkin(param1:Object)
      {
         super(param1);
         ForHero = param1.ForHero as String;
         AssetType = param1.AssetType as String;
         SpriteWidth = param1.SpriteWidth as uint;
         SpriteHeight = param1.SpriteHeight as uint;
         AssetClassName = param1.AssetClassName as String;
         PortraitName = param1.PortraitName as String;
         IconSwfFilepath = param1.IconSwfFilepath as String;
         IconName = param1.IconName as String;
         CardName = param1.CardName as String;
         SwfFilepath = param1.SwfFilepath as String;
         UISwfFilepath = param1.UISwfFilepath as String;
         FeedPostPicture = param1.FeedPostPicture;
         Scale = param1.Scale as Number;
         NametagY = param1.NametagY as Number;
         HealthbarScale = param1.HealthbarScale as Number;
         ProjEmitOffset = param1.ProjEmitOffset as Number;
         Hue = param1.Hue;
         Saturation = param1.Saturation ? (100 + param1.Saturation) / 100 * 2 : 0;
         Brightness = param1.Brightness;
         HitVol = param1.HitVol as Number;
         HitSound = param1.HitSound as String;
         DeathVol = param1.DeathVol as Number;
         DeathSound = param1.DeathSound as String;
         CharNickname = param1.CharNickname as String;
         CharLikes = param1.CharLikes as String;
         CharDislikes = param1.CharDislikes as String;
         CharUnlockLocation = param1.CharUnlockLocation as String;
         Description = param1.Description as String;
         StoreDescription = param1.StoreDescription as String;
         specialFXSwfPath_Back = param1.SpecialFXSwfPath_Back;
         specialFXName_Back = param1.SpecialFXName_Back;
         specialFXSwfPath_Front = param1.SpecialFXSwfPath_Front;
         specialFXName_Front = param1.SpecialFXName_Front;
      }
      
      public function doesSpecialFXBackExist() : Boolean
      {
         if(specialFXSwfPath_Back == null || specialFXSwfPath_Back == "")
         {
            return false;
         }
         if(specialFXName_Back == null || specialFXName_Back == "")
         {
            return false;
         }
         return true;
      }
      
      public function doesSpecialFXFrontExist() : Boolean
      {
         if(specialFXSwfPath_Front == null || specialFXSwfPath_Front == "")
         {
            return false;
         }
         if(specialFXName_Front == null || specialFXName_Front == "")
         {
            return false;
         }
         return true;
      }
   }
}

