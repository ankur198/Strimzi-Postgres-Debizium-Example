# Strimzi Postgres-Debizium Example

Example to create strimzi cluster. Run kafka-connect with debezium plugin for PostgresSql and sink to ElasticSearch

## Get Started

1. Clone repo and move inside that directory

    ``` bash
    git clone https://github.com/ankur198/Strimzi-Postgres-Debizium-Example
    cd Strimzi-Postgres-Debizium-Example
    ```

1. Create Namespace

    ``` bash
    kubectl create ns <insert-namespace-name-here>
    ```

    eg

    ``` bash
    kubectl create ns kafka
    ```

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

    where `docker-server` will be `https://index.docker.io/v1/` in case of docker hub

1. Replace `*.sample.yaml` with your own file

1. Apply

    > :warning: This sample is maintained for **docker-desktop** overlay only.

    ``` bash
    kustomize build ./overlays/<overlay-name>/ | kubectl apply -f -
    ```

    or

    ``` bash
    kubectl apply -k ./overlays/<overlay-name>
    ```

    eg

    ``` bash
    kubectl apply -k ./overlays/docker-desktop
    ```

## Validate

1. To get all topics

    ``` bash
    kubectl exec my-cluster-kafka-0 -c kafka -it -- \
        bin/kafka-topics.sh \
            --bootstrap-server localhost:9092 \
            --list
    ```

1. To consume topic (via CLI)

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

1. Create data in DB

    ``` bash
    kubectl exec postgres -n db -it -- \
        psql -U postgres strimzi -c \
            "INSERT INTO public.users (name) VALUES ('new user');"
    ```

1. Update data in DB

    ``` bash
    kubectl exec postgres -n db -it -- \
        psql -U postgres strimzi -c \
            "UPDATE public.users SET name='update user' WHERE name='new user';"
    ```

1. See data in DB

    ``` bash
    kubectl exec postgres -n db -it -- \
        psql -U postgres strimzi -c \
            "SELECT * FROM public.users;"
    ```

### See in Kibana 

1. Goto [https://localhost:5601](https://localhost:5601) to open Kibana dashboard
1. Login with username=**kibana** and password=**foo**
1. Open [discover](https://localhost:5601/app/discover) and add index.

Logs should be available in [discover](https://localhost:5601/app/discover) tab

## Resources

- [Debezium PostgresSQL Source Connector | Confluent Documentations](https://docs.confluent.io/debezium-connect-postgres-source/current/overview.html)
- [Build your own connector image](https://strimzi.io/blog/2021/03/29/connector-build/)
- [Azure PGSQL CONFIGURATION](https://debezium.io/documentation/reference/connectors/postgresql.html#postgresql-on-azure)
