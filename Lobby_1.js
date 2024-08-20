	var socket;
	var UnityObject;
	
	function ConnectLobby(UnityObjectName) {
	
		if (typeof io === 'undefined' || io === null) {
		
			unityInstance.SendMessage(UnityObject, "ServerDown");
			return;
		
		}
		
		if (typeof socket != 'undefined' || socket != null) {
		
			if(socket.connected){
			
				console.log('Disconnect.....');
				socket.disconnect();
				
				
			}
			
		}
		
		console.log('Connecting...');
		
		socket = io.connect('wss://www.gaming-style.com:25007');
		
		UnityObject = UnityObjectName;
		
		socket.on( 'connect', function() {
			//console.log('Connected');
		});
		
		socket.on( 'error', function() {
			
			unityInstance.SendMessage(UnityObject, "ServerError");
			console.log('ServerError');
			//socket.disconnect();
			
		});
		
		socket.on('connect_error', () => {
			
			unityInstance.SendMessage(UnityObject, "ServerConnectError");
			console.log('ServerConnectError');
			//socket.disconnect();
			
		});
		
		socket.on('disconnect', () => {
			
			unityInstance.SendMessage(UnityObject, "Disconnected");
			console.log('Disconnected');
			//socket.disconnect();
			
		});
		
		socket.on('news',function (data){
			console.log(data);
			socket.emit('Other Event', { my: ':) data :)'});
			unityInstance.SendMessage(UnityObject, "SetFullUrl", 'From Unity');
			console.log(socket.connected);
		});
		
		socket.on('GetInfo',function (){

			unityInstance.SendMessage(UnityObject, "GetInfo");

		});
		
		socket.on('AlreadyConnected',function (){
		
			unityInstance.SendMessage(UnityObject, "AlreadyConnected");
			console.log('AlreadyConnected');
			socket.disconnect();

		});
		
		socket.on('ConnectionSucess',function (){
		
			console.log('Connected');
			unityInstance.SendMessage(UnityObject, "ConnectionSucess");

		});
		
		socket.on('OldPlayer',function (Data){

			//console.log(Data);
			unityInstance.SendMessage(UnityObject, "PlayerJoin", Data);
			

		});
		
		socket.on('OldPlayerClan',function (Data){

			unityInstance.SendMessage(UnityObject, "PlayerClanJoin", Data);

		});
		
		socket.on('NewPlayer',function (Data){

			unityInstance.SendMessage(UnityObject, "PlayerJoin", Data);

		});
		
		socket.on('NewPlayerClan',function (Data){

			unityInstance.SendMessage(UnityObject, "PlayerClanJoin", Data);

		});
		
		socket.on('PlayerInGame',function (Player){

			unityInstance.SendMessage(UnityObject, "PlayerLeave", Player);

		});
		
		socket.on('NewMessage',function (Message){
		
			unityInstance.SendMessage(UnityObject, "NewMessage", Message);

		});
		
		socket.on('NewClanMessage',function (Message){
		
			unityInstance.SendMessage(UnityObject, "NewClanMessage", Message);

		});
		
		socket.on('NewPrivateMessage',function (Message){
		
			unityInstance.SendMessage(UnityObject, "NewPrivateMessage", Message);

		});
		
		socket.on('NewEventMessage',function (Message){
		
			unityInstance.SendMessage(UnityObject, "NewEventMessage", Message);

		});
		
		socket.on('PlayerDisconnect',function (Player){

			unityInstance.SendMessage(UnityObject, "PlayerLeave", Player);

		});
		
		

	}
	
	function DisconnectLobby(UnityObjectName) {
	
		socket.disconnect();
	
	}
	
	function Login(gameObjectName,LoginName,Nickname,Admin,VIP,Level,Clan,Server,Room,MapName) {
	
		if (typeof socket === 'undefined' || socket === null) {
		
			console.log('Error loading socket');
			return;
		
		}
		
		socket.emit('Login', { 
			PlayerLoginName :LoginName,
			PlayerNickname  :Nickname,
			PlayerAdmin	true,
			PlayerVIP 	true,
			PlayerLevel     :Level,
			PlayerClan      :Clan,
			PlayerServer	:Server,
			PlayerRoom	:Room,
			PlayerMapName	:MapName
		});

	}
	
	function SendChatMessage(gameObjectName,Message) {

		if (typeof socket === 'undefined' || socket === null) {
		
			console.log('Error loading socket');
			return;
		
		}
		
		socket.emit('Message', { MSG : Message});

	}
	
	function SendClanMessage(gameObjectName,Message) {

		if (typeof socket === 'undefined' || socket === null) {
		
			console.log('Error loading socket');
			return;
		
		}
		
		socket.emit('ClanMessage', { MSG : Message});

	}
	
	function SendPrivateMessage(gameObjectName,Message,PlayerName) {

		if (typeof socket === 'undefined' || socket === null) {
		
			console.log('Error loading socket');
			return;
		
		}
		
		socket.emit('PrivateMessage', { MSG : Message , Player : PlayerName});

	}
	
	function SendEventMessage(gameObjectName,Message) {

		if (typeof socket === 'undefined' || socket === null) {
		
			console.log('Error loading socket');
			return;
		
		}
		
		socket.emit('EventMessage', { MSG : Message});

	}
	
	
	function SendInGame(gameObjectName,InGame) {

		if (typeof socket === 'undefined' || socket === null) {
		
			console.log('Error loading socket');
			return;
		
		}

		socket.emit('SetInGame', { InGameType : InGame});

	}
	
	function SendInGamePM(gameObjectName,InGame) {

		if (typeof socket === 'undefined' || socket === null) {
		
			console.log('Error loading socket');
			return;
		
		}

		socket.emit('SetInGamePM', { InGamePM : InGame});

	}
	
