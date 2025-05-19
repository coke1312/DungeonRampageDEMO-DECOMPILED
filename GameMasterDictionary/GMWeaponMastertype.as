package GameMasterDictionary
{
   public class GMWeaponMastertype
   {
      
      public var Id:uint;
      
      public var Constant:String;
      
      public var Name:String;
      
      public var Icon:String;
      
      public var UISwfFilepath:String;
      
      public var Description:String;
      
      public var DontShowInTavern:Boolean;
      
      public function GMWeaponMastertype(param1:Object)
      {
         super();
         Id = param1.Id;
         Constant = param1.Constant;
         Name = param1.Name;
         Icon = param1.Icon;
         UISwfFilepath = param1.UISwfFilepath;
         Description = param1.Description;
         DontShowInTavern = param1.DontShowInTavern != null ? param1.DontShowInTavern : false;
      }
   }
}

