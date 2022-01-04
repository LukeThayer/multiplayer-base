extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1911


func _ready():
	ConnectToServer()
	pass 

func ConnectToServer():
	network.create_client(ip,port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed",self, "_OnConnectionFailed")
	network.connect("connection_succeeded",self, "_OnConnectionSucceeded")

func _OnConnectionFailed():
	print("connection failed")


func _OnConnectionSucceeded():
	print("connection succeeded")

func AuthenticatePlayer(username, password, player_id):
	print("sending out authentication request")
	rpc_id(1, "AuthenticatePlayer", username, password, player_id)
	pass

remote func AuthenticationResults(result,player_id,token):
	print("results recieved and replying to player login request")
	Gateway.ReturnLoginRequest(result,player_id, token)
	pass

