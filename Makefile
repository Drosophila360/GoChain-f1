-include .env

.PHONY: deploy-sepolia

deploy-sepolia:
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--account devAccount \
		--sender 0x802602c50f220BAc74354ee3Cf9A1e1C94c91803 \
		--broadcast \
		--verify \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		-vvvv