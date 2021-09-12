# Strimzi Postgres-Debizium Example

This example creates strimzi cluster. Runs kafka-connect with debezium plugin for PostgresSql

## Instructions

1. Switch to namespace

    ``` bash
    kubectl config set-context --current --namespace=<insert-namespace-name-here>
    ```

1. Create a k8s secret [more info](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#registry-secret-existing-credentials)

    ``` bash
    kubectl create secret docker-registry regcred \
        --docker-server=<your-registry-server> \
        --docker-username=<your-name> \
        --docker-password=<your-pword> \
        --docker-email=<your-email>
    ```

1. Replace `*.sample.yaml` with your own file

1. Apply

    ``` bash
    kustomize build ./overlays/<overlay-name>/ \
        | kubectl apply -f -
    ```

    or

    ``` bash
    kubectl apply -k ./overlays/<overlay-name>
    ```

1. To get all topics

    ``` bash
    kubectl exec my-cluster-kafka-0 -c kafka -it -- \
        bin/kafka-topics.sh \
            --bootstrap-server localhost:9092 \
            --list
    ```

1. To consume topic

    ``` bash
    kubectl exec my-cluster-kafka-0 -c kafka -it -- \
    bin/kafka-console-consumer.sh \
        --bootstrap-server localhost:9092 \
        --topic <topic-name>
    ```

    or

    ``` bash
    docker run --rm -it quay.io/strimzi/kafka:0.22.1-kafka-2.7.0 \
        bin/kafka-console-consumer.sh \
        --bootstrap-server <ip>:9094 \
        --topic <topic-name>
    ```

## Resources

- [Debezium PostgresSQL Source Connector | Confluent Documentations](https://docs.confluent.io/debezium-connect-postgres-source/current/overview.html)
- [Build your own connector image](https://strimzi.io/blog/2021/03/29/connector-build/)
- [Azure PGSQL CONFIGURATION](https://debezium.io/documentation/reference/connectors/postgresql.html#postgresql-on-azure)
