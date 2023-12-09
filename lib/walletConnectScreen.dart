import 'package:chase_map/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class WallectConnectScreen extends StatefulWidget {
  const WallectConnectScreen({super.key});

  @override
  State<WallectConnectScreen> createState() => _WallectConnectScreenState();
}

class _WallectConnectScreenState extends State<WallectConnectScreen> {
  late W3MService _w3mService;
  bool isConnected = false;
  late SupabaseClient supabaseClient;

  @override
  void initState() {
    super.initState();
    _initializeW3MService();
    print("web3 ${!_w3mService.isConnected}");
    print("web3 ${_w3mService.connectResponse}");
  }

  void _initializeW3MService() async {
    // Add your own custom chain to chains presets list to show when using W3MNetworkSelectButton
    // See https://docs.walletconnect.com/web3modal/flutter/custom-chains
    // W3MChainPresets.chains.putIfAbsent('<chainID>', () => <Your W3MChainInfo>);

    _w3mService = W3MService(
      projectId: '5d52a713ebc43de2f8f7834ae785f575',
      metadata: const PairingMetadata(
        name: 'Web3Modal Flutter Example',
        description: 'Web3Modal Flutter Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );

    await _w3mService.init().then((value) => setState(() {
          isConnected = _w3mService.isConnected;
        }));
        initSupabase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: !isConnected
          ? [
              W3MNetworkSelectButton(service: _w3mService),
              W3MConnectWalletButton(service: _w3mService),
            ]
          : [
              W3MAccountButton(service: _w3mService),
              ElevatedButton(onPressed: () => {
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapWidget(supabaseClient: supabaseClient,w3mService: _w3mService,))
              )
              }, child: Text('Start'))
            ],
    ));
  }

  void initSupabase() async{
    await Supabase.initialize(
      url: 'https://ehwrhfywdqhjweqtytuy.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVod3JoZnl3ZHFoandlcXR5dHV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk5MDA5NDMsImV4cCI6MjAxNTQ3Njk0M30.pkQkYz1LQQhLLqOUv4Wf9JySZj9iBRt1_l2pK0vsFPA',
    );

    final supabase = Supabase.instance.client;
    setState(() {
      supabaseClient = supabase;
    });

    print("supabase $supabase");
  }
}
