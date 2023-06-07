helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add couchdb https://apache.github.io/couchdb-helm
helm repo add neo4j https://helm.neo4j.com/neo4j

helm dependency update databases

cd ../databases

helm dependency build --skip-refresh