package NetworkCode
{
   public interface DcNetworkInterface
   {
      
      function recvById(param1:DcNetworkPacket, param2:uint) : void;
      
      function generate(param1:DcNetworkPacket) : void;
      
      function destroy() : void;
   }
}

