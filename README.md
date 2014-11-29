## About:

[Docker](http://www.docker.com/) image based on [digitalwonderland/oracle-jre-8](https://registry.hub.docker.com/u/digitalwonderland/oracle-jre-8/)

## Additional Software:

* [Apache Cassandra](http://cassandra.apache.org/)

## Usage:

The container can be configured via environment variables:

| Environment Variable | Cassandra Property | Default |
| -------------------- | ------------------ | --------|
| ```CASSANDRA_CONFIG_BROADCAST_ADDRESS``` | ```broadcast_address``` | N/A |
| ```CASSANDRA_CONFIG_LISTEN_INTERFACE``` | ```listen_interface``` | ```eth0``` |
| ```CASSANDRA_CONFIG_RPC_ADDRESS``` | ```rpc_address``` | ```0.0.0.0``` |
| ```CASSANDRA_CONFIG_BROADCAST_RPC_ADDRESS``` | ```broadcast_rpc_address``` | ```$CASSANDRA_CONFIG_BROADCAST_ADDRESS``` |
| ```CASSANDRA_CONFIG_SEEDS``` | ```seeds``` | ```$CASSANDRA_CONFIG_BROADCAST_ADDRESS``` |

### Stand-alone Mode:

As a minimum one must run the container with ```-e CASSANDRA_CONFIG_BROADCAST_ADDRESS=$YOUR_DOCKER_HOST_IP``` to get a standalone instance.

### Cluster Mode:

For a cluster instance one has to additionally provide _seeds_ via ```CASSANDRA_CONFIG_SEEDS```.

### Further Customization:

Additional configuration can be provided via environment variables starting with ```CASSANDRA_CONFIG_```. Any matching variables will get inserted  into Cassandras ```cassandra.yaml``` by

1. removing the ```CASSANDRA_CONFIG_``` prefix
2. transformation to lower case
