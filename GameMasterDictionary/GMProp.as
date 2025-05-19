package GameMasterDictionary
{
   public class GMProp extends GMItem
   {
      
      public var PropType:String;
      
      public var AssetClassName:String;
      
      public var SwfFilepath:String;
      
      public var DefaultLayer:String;
      
      public var ArchwayAlpha:Boolean;
      
      public var TileTheme:String;
      
      public function GMProp(param1:Object)
      {
         super(param1);
         PropType = param1.PropType;
         AssetClassName = param1.AssetClassName;
         SwfFilepath = param1.SwfFilepath;
         DefaultLayer = param1.DefaultLayer;
         ArchwayAlpha = param1.ArchwayAlpha == true;
         TileTheme = param1.TileTheme;
      }
   }
}

