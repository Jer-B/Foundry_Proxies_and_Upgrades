-include ~/.env

#ignore below folders
.PHONY: all test clean deploy fund help install snapshot format anvil 

deploy-anvil:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(RPC_URL_ANVIL) --private-key $(PRIVATE_KEY_TESTNET_ANVIL) -vvvvv

deploy-testnet:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(alchemy_RPC_sepolia) --private-key $(PRIVATE_KEY_TESTNET_TESTNET) --broadcast -vvvvv

deploy-testnet-verify:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(alchemy_RPC_sepolia) --private-key $(PRIVATE_KEY_TESTNET_TESTNET) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvvv




DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

#install modules
install :; forge install Cyfrin/foundry-devops@0.0.11 --no-commit && forge install foundry-rs/forge-std@v1.5.3 --no-commit && forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit && forge install transmissions11/solmate@v6 --no-commit && forge install openzeppelin/openzeppelin-contracts-upgradeable --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(alchemy_RPC_sepolia) --private-key $(PRIVATE_KEY_TESTNET) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy Proxy:
	@forge script script/DeployBox.s.sol:DeployBox $(NETWORK_ARGS)

Upgrade Proxy:
	@forge script script/UpgradeBox.s.sol:UpgradeBox $(NETWORK_ARGS)
