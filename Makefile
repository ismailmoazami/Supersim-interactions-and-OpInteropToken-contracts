include .env 

run-script :; forge script script/Interactions.s.sol --broadcast --rpc-url ${OP1_RPC} -vvvvv
deploy-token :; forge script script/DeployToken.s.sol --broadcast --rpc-url ${OP1_RPC} -vvvvv
