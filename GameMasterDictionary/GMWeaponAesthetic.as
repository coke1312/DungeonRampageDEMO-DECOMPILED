package GameMasterDictionary
{
   public class GMWeaponAesthetic
   {
      
      public var Release:String;
      
      public var WeaponItemConstant:String;
      
      public var Constant:String;
      
      public var Name:String;
      
      public var MinLevel:uint;
      
      public var MaxLevel:uint;
      
      public var ModelName:String;
      
      public var IconName:String;
      
      public var IconSwf:String;
      
      public var SwordTrailOverride:String;
      
      public var ItemR:Number;
      
      public var ItemG:Number;
      
      public var ItemB:Number;
      
      public var ItemRAdd:Number;
      
      public var ItemGAdd:Number;
      
      public var ItemBAdd:Number;
      
      public var HasColor:Boolean;
      
      public var GlowDist:Number;
      
      public var GlowStr:Number;
      
      public var GlowColor:uint;
      
      public var HasGlow:Boolean;
      
      public var TrailR:Number;
      
      public var TrailG:Number;
      
      public var TrailB:Number;
      
      public var TrailRAdd:Number;
      
      public var TrailGAdd:Number;
      
      public var TrailBAdd:Number;
      
      public var HasTrailColor:Boolean;
      
      public var Description:String;
      
      public var IsLegendary:Boolean;
      
      public function GMWeaponAesthetic(param1:Object)
      {
         super();
         Release = param1.Release;
         WeaponItemConstant = param1.WeaponItemConstant;
         Constant = param1.Constant;
         Name = param1.Name;
         MinLevel = param1.MinLvl as uint;
         MaxLevel = param1.MaxLvl as uint;
         ModelName = param1.ModelName;
         IconName = param1.IconName;
         IconSwf = param1.UISwfFilepath;
         SwordTrailOverride = param1.SwordTrailOverride;
         HasColor = param1.ItemR != null && param1.ItemG != null && param1.ItemB != null && param1.ItemRAdd != null && param1.ItemGAdd != null && param1.ItemBAdd != null;
         if(HasColor)
         {
            ItemR = param1.ItemR;
            ItemG = param1.ItemG;
            ItemB = param1.ItemB;
            ItemRAdd = param1.ItemRAdd;
            ItemGAdd = param1.ItemGAdd;
            ItemBAdd = param1.ItemBAdd;
         }
         HasGlow = param1.GlowDist != null && param1.GlowStr != null && param1.GlowColor != null;
         if(HasGlow)
         {
            GlowDist = param1.GlowDist;
            GlowStr = param1.GlowStr;
            GlowColor = uint(param1.GlowColor);
         }
         HasTrailColor = param1.TrailR != null && param1.TrailG != null && param1.TrailB != null && param1.TrailRAdd != null && param1.TrailGAdd != null && param1.TrailBAdd != null;
         if(HasTrailColor)
         {
            TrailR = param1.TrailR;
            TrailG = param1.TrailG;
            TrailB = param1.TrailB;
            TrailRAdd = param1.TrailRAdd;
            TrailGAdd = param1.TrailGAdd;
            TrailBAdd = param1.TrailBAdd;
         }
         Description = param1.Description;
         IsLegendary = param1.IsLegendary;
      }
   }
}

