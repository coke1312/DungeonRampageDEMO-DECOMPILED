package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class swrapper
   {
      
      public var fileName:String;
      
      public function swrapper()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : swrapper
      {
         var _loc2_:swrapper = new swrapper();
         _loc2_.fileName = param1.readUTF();
         return _loc2_;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         param1.writeUTF(fileName);
      }
   }
}

