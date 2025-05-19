package GeneratedCode
{
   import Facade.DBFacade;
   import NetworkCode.DcNetworkPacket;
   import NetworkCode.DcSocket;
   import NetworkCode.DcSocketGenerate;
   
   public class GeneratedDcSocket extends DcSocket implements DcSocketGenerate
   {
      
      public const CLID_Trash:uint = 0;
      
      public const CLID_DistributedDistrict:uint = 19;
      
      public const CLID_ObjectServer:uint = 23;
      
      public const CLID_StatAccumulator:uint = 25;
      
      public const CLID_AreaManager:uint = 26;
      
      public const CLID_DistributedNPCGameObject:uint = 27;
      
      public const CLID_HeroGameObject:uint = 28;
      
      public const CLID_PlayerGameObject:uint = 29;
      
      public const CLID_PresenceManager:uint = 30;
      
      public const CLID_DistributedDungeonFloor:uint = 32;
      
      public const CLID_DistributedTownFloor:uint = 33;
      
      public const CLID_DistributedDungionArea:uint = 36;
      
      public const CLID_DistributedDungeonSummary:uint = 38;
      
      public const CLID_DistributedTownArea:uint = 39;
      
      public const CLID_DistributedDooberGameObject:uint = 40;
      
      public const CLID_DistributedBuffGameObject:uint = 41;
      
      public const CLID_MatchMaker:uint = 42;
      
      public const DcHash:uint = 1338974727;
      
      public function GeneratedDcSocket(param1:DBFacade, param2:String, param3:int, param4:String, param5:String, param6:uint)
      {
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override public function getDcHash() : uint
      {
         return 1338974727;
      }
      
      public function ObjectFactoryOwner(param1:uint, param2:uint, param3:DcNetworkPacket) : void
      {
         switch(int(param1) - 28)
         {
            case 0:
               Doid_NetInterfaces[String(param2)] = HeroGameObjectOwnerNetworkComponent.ownerFactory(param3,this,param2);
               break;
            case 1:
               Doid_NetInterfaces[String(param2)] = PlayerGameObjectOwnerNetworkComponent.ownerFactory(param3,this,param2);
               break;
            default:
               trace("Received generate for object of unknown Class ID " + param1);
         }
      }
      
      public function ObjectFactoryVisible(param1:uint, param2:uint, param3:DcNetworkPacket) : void
      {
         switch(int(param1) - 27)
         {
            case 0:
               Doid_NetInterfaces[String(param2)] = DistributedNPCGameObjectNetworkComponent.netFactory(param3,this,param2);
               break;
            case 1:
               Doid_NetInterfaces[String(param2)] = HeroGameObjectNetworkComponent.netFactory(param3,this,param2);
               break;
            case 2:
               Doid_NetInterfaces[String(param2)] = PlayerGameObjectNetworkComponent.netFactory(param3,this,param2);
               break;
            case 3:
               Doid_NetInterfaces[String(param2)] = PresenceManagerNetworkComponent.netFactory(param3,this,param2);
               break;
            case 5:
               Doid_NetInterfaces[String(param2)] = DistributedDungeonFloorNetworkComponent.netFactory(param3,this,param2);
               break;
            case 6:
               Doid_NetInterfaces[String(param2)] = DistributedTownFloorNetworkComponent.netFactory(param3,this,param2);
               break;
            case 9:
               Doid_NetInterfaces[String(param2)] = DistributedDungionAreaNetworkComponent.netFactory(param3,this,param2);
               break;
            case 11:
               Doid_NetInterfaces[String(param2)] = DistributedDungeonSummaryNetworkComponent.netFactory(param3,this,param2);
               break;
            case 12:
               Doid_NetInterfaces[String(param2)] = DistributedTownAreaNetworkComponent.netFactory(param3,this,param2);
               break;
            case 13:
               Doid_NetInterfaces[String(param2)] = DistributedDooberGameObjectNetworkComponent.netFactory(param3,this,param2);
               break;
            case 14:
               Doid_NetInterfaces[String(param2)] = DistributedBuffGameObjectNetworkComponent.netFactory(param3,this,param2);
               break;
            case 15:
               Doid_NetInterfaces[String(param2)] = MatchMakerNetworkComponent.netFactory(param3,this,param2);
               break;
            default:
               trace("Received generate for object of unknown Class ID " + param1);
         }
      }
   }
}

