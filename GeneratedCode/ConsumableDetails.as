package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class ConsumableDetails
   {
      
      public var type:uint;
      
      public var count:uint;
      
      public function ConsumableDetails()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : ConsumableDetails
      {
         var _loc2_:ConsumableDetails = new ConsumableDetails();
         _loc2_.type = param1.readUnsignedInt();
         _loc2_.count = param1.readUnsignedShort();
         return _loc2_;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         param1.writeUnsignedInt(type);
         param1.writeShort(count);
      }
   }
}

