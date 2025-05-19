package GameMasterDictionary
{
   public class GMRarity
   {
      
      public var Id:uint;
      
      public var Constant:String;
      
      public var Type:String;
      
      public var NumberOfModifiers:uint;
      
      public var MaxModifierLevel:uint;
      
      public var MinModifierLevel:uint;
      
      public var HasColoredBackground:Boolean;
      
      public var BackgroundIcon:String;
      
      public var BackgroundIconBorder:String;
      
      public var BackgroundSwf:String;
      
      public var KeyOfferId:Number;
      
      public var MinSellPercent:Number;
      
      public var MaxSellPercent:Number;
      
      public var LevelWeight:Number;
      
      public var ModifierWeight:Number;
      
      public var BasePowerScale:Number;
      
      public var BasePowerConstant:Number;
      
      public var HasGlow:Boolean;
      
      public var GlowColor:uint;
      
      public var GlowStr:uint;
      
      public var GlowDist:uint;
      
      public var TextColor:uint;
      
      public function GMRarity(param1:Object)
      {
         super();
         Id = param1.Id;
         KeyOfferId = param1.KeyOfferId;
         Constant = Type = param1.Type;
         NumberOfModifiers = param1.NumberOfModifiers;
         HasColoredBackground = param1.HasColoredBackground;
         MaxModifierLevel = param1.MaxModifierLevel;
         MinModifierLevel = param1.MinModifierLevel;
         MinSellPercent = param1.MinSellPercent;
         MaxSellPercent = param1.MaxSellPercent;
         LevelWeight = param1.LevelWeight;
         ModifierWeight = param1.ModifierWeight;
         HasGlow = param1.HasGlow;
         GlowColor = param1.GlowColor;
         TextColor = param1.TextColor;
         GlowDist = param1.GlowDist;
         GlowStr = param1.GlowStr;
         BasePowerScale = param1.BasePowerScale;
         BasePowerConstant = param1.BasePowerConstant;
         if(HasColoredBackground)
         {
            BackgroundIcon = param1.BackgroundIcon;
            BackgroundIconBorder = param1.BackgroundIconBorder != null ? param1.BackgroundIconBorder : "";
            BackgroundSwf = param1.BackgroundSwf;
         }
      }
   }
}

