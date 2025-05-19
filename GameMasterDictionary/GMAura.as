package GameMasterDictionary
{
   public class GMAura extends GMItem
   {
      
      public var Duration:Number;
      
      public var DrainsMana:Number;
      
      public var AreaRadius:Number;
      
      public var FriendlyBuffGiven:String;
      
      public var HostileBuffGiven:String;
      
      public var AuraEffect:String;
      
      public var Description:String;
      
      public function GMAura(param1:Object)
      {
         super(param1);
         AuraEffect = param1.AuraEffect;
         Description = param1.Description;
      }
   }
}

