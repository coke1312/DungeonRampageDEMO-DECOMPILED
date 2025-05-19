package GameMasterDictionary
{
   public class GMAchievement
   {
      
      public var Id:String;
      
      public var Name:String;
      
      public var Descriptions:String;
      
      public var ImageLink:String;
      
      public var Points:uint;
      
      public function GMAchievement(param1:Object)
      {
         super();
         Id = param1.Id;
         Name = param1.Name;
         Descriptions = param1.Descriptions;
         ImageLink = param1.ImageLink;
         Points = param1.Points;
      }
   }
}

