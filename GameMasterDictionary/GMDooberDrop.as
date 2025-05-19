package GameMasterDictionary
{
   public class GMDooberDrop extends GMItem
   {
      
      public var BRUTE:Boolean;
      
      public var SKELETON_WARRIOR:Boolean;
      
      public var SKELETON_ARCHER:Boolean;
      
      public var KNIGHT:Boolean;
      
      public var CASTLE_BARREL:Boolean;
      
      public var CASTLE_BOX:Boolean;
      
      public var CASTLE_SPIKES:Boolean;
      
      public var CASTLE_KINGSTATUE:Boolean;
      
      public var CASTLE_FLAG:Boolean;
      
      public var WOLF_PET:Boolean;
      
      public var WARCOW_PET:Boolean;
      
      public var DEMON_PET:Boolean;
      
      public function GMDooberDrop(param1:Object)
      {
         super(param1);
         BRUTE = param1.BRUTE;
         SKELETON_WARRIOR = param1.SKELETON_WARRIOR;
         SKELETON_ARCHER = param1.SKELETON_ARCHER;
         KNIGHT = param1.KNIGHT;
         CASTLE_BARREL = param1.CASTLE_BARREL;
         CASTLE_BOX = param1.CASTLE_BOX;
         CASTLE_SPIKES = param1.CASTLE_SPIKES;
         CASTLE_KINGSTATUE = param1.CASTLE_KINGSTATUE;
         CASTLE_FLAG = param1.CASTLE_FLAG;
         WOLF_PET = param1.WOLF_PET;
         WARCOW_PET = param1.WARCOW_PET;
         DEMON_PET = param1.DEMON_PET;
      }
   }
}

