#!/bin/sh
PUBLIC_KEY=$(cast w a $PRIVATE_KEY)
echo "PUBLIC_KEY: $PUBLIC_KEY"
echo $(forge --version)
echo "Deploying factory"
FACTORY_OUT=$(forge create --legacy \
--rpc-url $RPC_URL \
--private-key $PRIVATE_KEY \
--verify \
--verifier blockscout \
--verifier-url $EXPLORER_API_URL \
contracts/v2-core/contracts/UniswapV2Factory.sol:UniswapV2Factory \
--constructor-args $PUBLIC_KEY)

FACTORY_ADDRESS=$(echo "$FACTORY_OUT" | sed -n 's/^Deployed to: //p')
echo "FACTORY_ADDRESS: $FACTORY_ADDRESS"

# obtain init hash
INIT_HASH_OUTPUT=$(cast call --rpc-url $RPC_URL $FACTORY_ADDRESS "INIT_CODE_HASH()")
INIT_HASH_VALUE=$(echo "$INIT_HASH_OUTPUT" | sed 's/^0x//')

echo "INIT_HASH_OUTPUT: $INIT_HASH_OUTPUT"

# replace init hash in library
sed -i "s/hex'70bcf9e2fa6f691fe59a2714d8ff7c6987ed70844ce18b7a15093b03c70a7514'/hex'$INIT_HASH_VALUE'/" contracts/v2-periphery/contracts/libraries/UniswapV2Library.sol 

echo "Deploying Router"
echo "Factory: $FACTORY_ADDRESS"
echo "WETH: $WETH"

forge create --legacy \
--rpc-url $RPC_URL \
--private-key $PRIVATE_KEY \
--verify \
--verifier blockscout \
--verifier-url $EXPLORER_API_URL \
contracts/v2-periphery/contracts/UniswapV2Router02.sol:UniswapV2Router02 \
--constructor-args $FACTORY_ADDRESS $WETH
if [ "$ENV" = "dev" ]; then
    echo "Deploying TokenFactory"

    forge create --legacy \
    --rpc-url $RPC_URL \
    --private-key $PRIVATE_KEY \
    --verify \
    --verifier blockscout \
    --verifier-url $EXPLORER_API_URL \
    contracts/tokens/TokenFactory.sol:TokenFactory
fi
