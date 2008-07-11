package autoflash.rpc;

/**
 * ClientProxy
 * 	�������Ice�Կͻ��˵Ľӿڣ�������Ҫrpc�Ŀͻ��˲��������������Ľӿڡ�
 * 	����������һ��singleton�����еĲ������ͨ��service()��á�
 */
public class ClientProxy {
	private autoflash.rpc.slice.ClientServicePrx service_;
	private Ice.Communicator ic_;
	static private ClientProxy cp_;
	
	public static autoflash.rpc.slice.ClientServicePrx service() {
		if (cp_ == null)
			cp_ = new ClientProxy();
		return cp_.service_;
	}

	/**
	 * @param args
	 */
	private ClientProxy() {
		System.out.println("Construct ClientProxy");
		ic_ = null;
        try {
            ic_ = Ice.Util.initialize();
            Ice.ObjectPrx base = ic_.stringToProxy(
                    "ClientService:default -p 16000");

            service_ = autoflash.rpc.slice.ClientServicePrxHelper.checkedCast(base);
            //service_.registerStation(new autoflash.rpc.slice.StationInfo());

            if (service_ == null)
                throw new Error("Invalid proxy");
            else
            	System.out.println("Service inited.");
                       
        } catch (Ice.LocalException e) {
            e.printStackTrace();
            System.exit(0);
        } catch (Exception e) {
            System.err.println(e.getMessage());
            System.exit(0);
        }
	}
	
	public void destroy() {
        if (ic_ != null) {
            // Clean up
            //
            try {
                ic_.destroy();
            } catch (Exception e) {
                System.err.println(e.getMessage());
            }
        }
        System.exit(0);
	}

}

