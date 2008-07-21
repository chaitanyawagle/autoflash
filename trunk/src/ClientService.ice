module autoflash {
module rpc {
module slice{

    struct Point {
        int latitude;
        int longitude;
    };
    
    struct Area {
    	Point topLeftCorner;
    	int latitudeSpan;
    	int longitudeSpan;
    };

	// ����ͺ�
    struct BatteryModel {
        string name;
        int maxChargeRounds;	// ��������
        double capacity;		// ����
        int maxLifeTime;		// ��������ڣ����ռ���
        string factory;
    };

    struct BatteryInfo {	
        string ID;
        BatteryModel model;
        int shippedDate;		// ��������
        int chargeRounds;		// �ѳ�����
    };
    sequence<BatteryInfo> BatteriesInfo;

    struct StationInfo {
        string ID;
        string address;
        Point position; 
        int capacity;			// �ɴ洢�ĵ����
        string owner;
        double chargePrice;		// ���۸���ʱ�����ڼƼ�
        double rentPrice;		// �������
    };
    sequence<StationInfo> StationsInfo;

    struct DepotInfo {
        string ID;
        string address;
		Point position;
        double chargePrice;		// ���۸�
        int storageCapacity;	// �ɴ洢�ĵ����
        int chargeCapacity;		// ��ͬʱ���ĵ����
        string owner;
        double rentPrice;		// �������
    };
    sequence<DepotInfo> DepotsInfo;

    struct VehicleInfo {
        string ID;				// ���ǵ�ĳЩ��������û�г��ƣ����³��������ʹ��IDͳһ��ʾ����
		string licence;			// ���ƺ�
        string owner;
        string model;
    };
    sequence<VehicleInfo> VehiclesInfo;

    enum BatteryState {Empty, 		// λ�ڼӵ�վ����վ��������Ҫ����״̬
    					Charging, 	// ���ڳ��
    					Charged, 	// �ѳ�����
    					Onboard, 	// �ѱ������λ�ڳ�����
    					Discarded, 	//	�Ѿ�����
    					Arbitrary 
    					};
    					
    enum OpenStatus { Open, Closed, OpenOrClosed };

	// �����µĳ�������У�һЩ�����ɺ��ԣ�������ڴ���ID��string���մ��������Դ�������
    struct BatteryQueryCondition {
        BatteryModel model;		// ��ѯ�ض��ͺŵĵ��
        BatteryState state;		// ��ѯ�ض�״̬�ĵ��
        int minShippedDate;		// ��ѯ�����ض����ڹ���ĵ��
        int maxShippedDate;		// ��ѯ�����ض����ڹ���ĵ��
        int minChargeRounds;	// ��ѯ�����������ض�ֵ�ĵ��
        int maxChargeRounds;	// ��ѯ������С���ض�ֵ�ĵ��
        string stationID;  		// ��ѯĿǰλ��ĳ�ӵ�վ�ڵĵ��
        string depotID;    		// ��ѯĿǰλ��ĳ���վ�ڵĵ��
        string vehicleID;  		// ��ѯĿǰλ��ĳ�������ϵĵ��
    };

    struct StationQueryCondition {
        Area region;			// ��ѯλ��ĳ�������ڵ�վ��
        string stationID;  		// ��ѯ�����ض�ID��վ��
        OpenStatus status;		// ��ѯĿǰ���Ż�رյ�վ��
        string owner;			// ��ѯ�ض�ӵ���˵�վ��
        int minCapacity;		// ��ѯ���������ض�ֵ��վ��
        int maxCapacity;		// ��ѯ����С���ض�ֵ��վ��
    };
    struct DepotQueryCondition {
        Area region;			// ��ѯλ��ĳ�������ڵ�վ��
        string depotID;    		// ��ѯ�����ض�ID��վ��
        OpenStatus status;		// ��ѯĿǰ���Ż�رյ�վ��
        string owner;			// ��ѯ�ض�ӵ���˵�վ��
        int minStorageCapacity;	// ��ѯ�洢���������ض�ֵ��վ��
        int maxStorageCapacity;	// ��ѯ�洢����С���ض�ֵ��վ��
        int minChargeCapacity;	// ��ѯ������������ض�ֵ��վ��
        int maxChargeCapacity;	// ��ѯ�������С���ض�ֵ��վ��
    };
    struct VehicleQueryCondition {
        string model;			// ��ѯĳ���ͺŵĳ���
        int minChargeDate;		// ��ѯ�ϴμӵ粻�����ض����ڵĳ���
        int maxChargeDate;		// ��ѯ�ϴμӵ粻�����ض����ڵĳ���
        int batteryNum;			// ��ѯĿǰ�����ض���Ŀ��صĳ���
        string batteryID;		// ��ѯĿǰĳ�������λ�ڵĳ���
    };
    
    enum ActivityType { Rent, Return, MoveFromStation, MoveToStation, MoveFromDepot, MoveInDepot, Purchase, Discard, OpenStation, CloseStation, OpenDepot, CloseDepot, Register, Unregister, Set, Charge };
    struct Activity {
        ActivityType type;
        string batteryID;
        string stationOrDepotID;
        int money;
    };
    sequence<Activity> Activities;

    interface ClientService {
        /** For Power Station */
        // �󲿷������Ӧ�������ȹ黹һ���ù��ĵ�ز����һ���µ�أ���Ҳ����һ������黹����أ���˰����������ֿ���
        // Ŀǰ������еļƼ۲��������ڷ������˽��У���˿ͻ���ֻ��Ҫ�ṩ�����Ϣ���ӷ������˵õ������۸�
        double rentBattery(string stationID, string vehicleID, string batteryID, double amount);
        double returnBattery(string stationID, string vechildID, string batteryID, double amount);

        // ���������˳��ӵ�վ��
        // ������ʱ�����ǵ������İ��ŵĹ�����ֻ�ǽ��м�¼��
        void moveBatteryToStation(string stationID, string batteryID);
        void moveBatteryFromStation(string stationID, string batteryID);

        // ����ʧЧ�ĵ�ء�
        // TODO: �����û��𻵵��⳥���⡣
        void reportDamagedBattery(string stationID, string batteryID);

        // ���ڲ������ݿ���ڵĳ�����Ӧ������ע�ᡣע��ʱ����������복����Ϣ�����������ɳ���ID�����ء�
        string registerVehicle(string stationID, VehicleInfo info);

		// ���Ż�ر�һ���ӵ�վ��
        void openStation(string stationID);
        void closeStation(string stationID);

        /** For Depot */
        // ���������˳����վ��
        // ������ʱ�����ǵ������İ��ŵĹ�����ֻ�ǽ��м�¼��
        void moveBatteryToDepot(string depotID, string batteryID);
        void moveBatteryFromDepot(string depotID, string batteryID);

 		// Ϊ��س�磬�������������Ŀǰ�ĵ������Լ���ǰһ�α������ĵ�����
        void charge(string depotID, string batteryID, double currentAmount, double useAmount);

        // ������أ��������ϵ��Լ��𻵵ĵ�ء�
        void discard(string depotID, string batteryID);

        void openDepot(string depotID);
        void closeDepot(string depotID);

        /** For battery supplier */
        // �ɹ��µ�أ������µ�ص�ID
        string purchase(BatteryInfo info);

        /** For administrator */
        // ��ѯ���ض�ʱ����ڵĻ��¼
        Activities queryActivities(int start, int end);
        Activities queryBatteryActivities(string batteryID, int start, int end);
        Activities queryStationActivities(string staionID, int start, int end);
        Activities queryDepotActivities(string staionID, int start, int end);

		// ���ݲ�ѯ������ѯ�ض���վ����������
        StationsInfo queryStations(StationQueryCondition c);
        DepotsInfo queryDepots(DepotQueryCondition c);
        BatteriesInfo queryBatteries(BatteryQueryCondition c);
        VehiclesInfo queryVehicles(VehicleQueryCondition c);

        // ע��ӵ�վ����վ��ע��ʱ������վ����Ϣ�󣬷���������վ��ID
        string registerStation(StationInfo info);
        string registerDepot(DepotInfo info);
        void unregisterStation(string stationID);
        void setStation(string stationID, StationInfo info);
        void unregisterDepot(string depotID);
        void setDepot(string stationID, DepotInfo info);
    };  // interface ClientService
};	// module slice
};  // module rpc
};	// module autoflash
