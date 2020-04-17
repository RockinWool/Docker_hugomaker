export PWD=$(pwd)
export EXISTDOCKER=$(sudo docker ps -a -f "name=HugoC" --format {{.Names}})
for X in "RockinWool"
do
    sudo docker build -t hugoc .
    if [ "$EXISTDOCKER" = HugoC ]; then
        read -p " すでにコンテナは存在しますが作り直しますか? (y/N):" BUILD
        case "$BUILD" in 
            [yY]*) sudo docker rm HugoC \
            && sudo docker run -itd --name HugoC -v $PWD/RFV:/home/RockinWool/RFV -p 8888:8888 --rm --mount type=bind,src=`pwd`,dst=./ hugoc\
            && sudo docker exec -it HugoC bash;;
            *) echo "skipped." ;;
        esac
    else
        sudo docker run -itd --name HugoC -v $PWD/RFV:/home/RockinWool/RFV -p 8888:8888 --rm --mount type=bind,src=`pwd`,dst=./ hugoc
    fi
    sudo docker start HugoC
    sudo docker exec -it HugoC bash
    sudo docker stop HugoC
    read -p "${X} : コンテナを破棄しますか? (y/N):" VAR
    case "$VAR" in 
        [yY]*) sudo docker rm HugoC ;;
        *) echo "skipped." ; continue ;;
    esac
    
done