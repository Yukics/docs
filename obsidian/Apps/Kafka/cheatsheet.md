#init #tech 

## Comandos útiles
### List topics

```
/kafka/bin/kafka-topics.sh --list --zookeeper servidor:2181
```

### Show partitions
```
./kafka-topics.sh --describe --zookeeper servidor:2181 --topic topic_name
```

### Status of a topic
```
/kafka/bin/kafka-topics.sh --describe --zookeeper servidor:2181 --topic topic_name
```

### List consumer groups
```
#old
/kafka/bin/kafka-consumer-groups.sh --zookeeper servidor:2181 --list
#new
/kafka/bin/kafka-consumer-groups.sh --new-consumer --bootstrap-server servidor:9092 --list
```