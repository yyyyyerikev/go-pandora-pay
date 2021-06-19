if [ $# -eq 0 ]; then
  echo "argument missing"
  exit 1
fi

nodes=4
str="./genesis.data,"

go build main.go

for (( i=0; i <= $nodes; ++i ))
do
    echo "running $i"
    rm -r ./_build/devnet_$i
    xterm -e go run main.go --instance="devnet_$i" --network="devnet" --wallet-derive-delegated-stake="0,0,delegated" --exit
    mv ./_build/devnet_$i/DEV/delegated.delegatedStake ./_build/devnet_0/DEV/$i.delegatedStake
    echo "runned"

    str+="$i.delegatedStake"

    if [ $i != $nodes ]; then
      str+=","
    fi

done

echo "creating genesis $str"
xterm -e go run main.go --instance="devnet_0" --network="devnet" --create-new-genesis="$str" --exit

for (( i=0; i <= $nodes; ++i ))
do
  echo "copying genesis $i"
  cp ./_build/devnet_0/DEV/genesis.data ./_build/devnet_$i/DEV/genesis.data
done

for (( i=0; i <= $nodes; ++i ))
do
  echo "opening $i"
  xterm -hold -e go run main.go --instance="devnet_$i" --network="devnet" --tcp-server-port="523$i" --set-genesis="file"  --staking &
done

exit 1
echo "finished"