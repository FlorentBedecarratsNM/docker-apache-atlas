FROM scratch
FROM ubuntu:18.04
LABEL maintainer="vadim@clusterside.com"
ARG VERSION=2.1.0

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install apt-utils \
    && apt-get -y install \
        maven \
        wget \
        git \
        python \
        openjdk-8-jdk-headless \
        patch \
	unzip \
    && cd /tmp \
    && wget http://mirror.linux-ia64.org/apache/atlas/${VERSION}/apache-atlas-${VERSION}-sources.tar.gz \
    && mkdir -p /opt/gremlin \
    && mkdir -p /tmp/atlas-src \
    && tar --strip 1 -xzvf apache-atlas-${VERSION}-sources.tar.gz -C /tmp/atlas-src \
    && rm apache-atlas-${VERSION}-sources.tar.gz \
    && cd /tmp/atlas-src \
    && sed -i 's/http:\/\/repo1.maven.org\/maven2/https:\/\/repo1.maven.org\/maven2/g' pom.xml \
    && export MAVEN_OPTS="-Xms2g -Xmx2g" \
    && export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    && mvn clean -Dmaven.repo.local=/tmp/.mvn-repo -Dhttps.protocols=TLSv1.2 -DskipTests package -Pdist,embedded-hbase-solr \
    && tar -xzvf /tmp/atlas-src/distro/target/apache-atlas-${VERSION}-server.tar.gz -C /opt \
    && rm -Rf /tmp/atlas-src \
    && rm -Rf /tmp/.mvn-repo \
    && apt-get -y --purge remove \
        maven \
        git \
    && apt-get -y remove openjdk-11-jre-headless \
    && apt-get -y autoremove \
    && apt-get -y clean

VOLUME ["/opt/apache-atlas-${VERSION}/conf", "/opt/apache-atlas-${VERSION}/logs"]

COPY atlas_start.py.patch atlas_config.py.patch /opt/apache-atlas-${VERSION}/bin/

RUN cd /opt/apache-atlas-${VERSION}/bin \
    && patch -b -f < atlas_start.py.patch \
    && patch -b -f < atlas_config.py.patch

COPY conf/hbase/hbase-site.xml.template /opt/apache-atlas-${VERSION}/conf/hbase/hbase-site.xml.template
COPY conf/atlas-env.sh /opt/apache-atlas-${VERSION}/conf/atlas-env.sh

COPY conf/gremlin /opt/gremlin/

RUN cd /opt/apache-atlas-${VERSION} \
    && ./bin/atlas_start.py -setup || true

RUN cd /opt/apache-atlas-${VERSION} \
    && ./bin/atlas_start.py & \
    touch /opt/apache-atlas-${VERSION}/logs/application.log \
    && tail -f /opt/apache-atlas-${VERSION}/logs/application.log | sed '/AtlasAuthenticationFilter.init(filterConfig=null)/ q' \
    && sleep 10 \
    && /opt/apache-atlas-${VERSION}/bin/atlas_stop.py

# Start edits from sburn code base to provide an UI in French
# Translate SearchLayoutView_tmpl.html (left search panel on the "legacy" UI)
RUN sed -i -e 's/>Basic</>Simple</' \
        -e 's/>Advanced</>Avancée</' \
        -e 's/title="Refresh"/title="Rafraichir"/' \
        -e 's/>Search By Type</>Recherche par type</' \
        -e 's/title="Entity Attribute Filter"/title="Type d'\''entité à filtrer"/' \
        -e 's/>Search By Classification</>Recherche par tag</' \
        -e 's/title="Tag Attribute Filter"/title="Tag à filtrer"/' \
        -e 's/>Search By Term</>Recherche par mot-clé</' \
        -e 's/>Search By Text</>Recherche en texte intégral</' \
        -e 's/placeholder="Search by text"/placeholder="Search by text"/' \
        -e 's/>Clear</>Effacer</' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/search/SearchLayoutView_tmpl.html   

# Translate SearchLayoutView.js (ie. JS prompts in the left search panel on the "legacy" UI)
RUN sed -i -e 's/>placeholder: "Search Term"</>placeholder: "Mot-clé à rechercher"</' \
        -e 's/title: '\''Advanced Search Queries'\''/title: '\''Requêtes avancées'\''/' \
        -e 's/text('\''Search By Query'\'')/text('\''Recherche par requête'\'')/' \
        -e 's/Search By Query eg./Search By Query ex./' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/views/search/SearchLayoutView.js

